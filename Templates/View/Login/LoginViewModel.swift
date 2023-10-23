/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

/// Login ViewModel.
class LoginViewModel: BaseViewModel {
    
    // MARK: - Defines
    
    @Published var isInitializationSuccess: Bool = false
    @Published var isLoginSucces: Bool = false

    // MARK: - Lifecycle
    
    override init() {
        super.init()
        
        // Trigger configuration and update ui state.
        configureIfNeeded()
    }
    
    // MARK: - Public API
    
    
    /// Logs in to D1.
    func login() {
        progressShow(caption: "Login in progress")
        
        var request = URLRequest(url: URL(string: D1Configuration.SANDBOX_JWT_URL + D1Configuration.CONSUMER_ID)!)
        request.setBasicAuth(username: D1Configuration.SANDBOX_JWT_USER,
                             password: D1Configuration.SANDBOX_JWT_PASSWORD)
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if var token = data {
                D1Core.shared().login(issuerToken: &token) { [self] error in
                    progressHide()
                    
                    if let error = error {
                        bannerShow(caption: "SDK Login failed.", description: error.localizedDescription, type: .error)
                    } else {
                        // This will switch to the home View.
                        isLoginSucces = true
                    }
                }
            } else {
                progressHide()

                bannerShow(caption: "Failed to get token from the backend.",
                           description: error?.localizedDescription ?? "Unknown error",
                           type: .error)
            }
            
        }.resume()
    }
    
    // MARK: - Private Helpers
    
    
    /// Check SDK state, update UI according to the current situation and trigger configuration in case that sdk init did not started yet.
    private func configureIfNeeded() {
        let state = D1Core.shared().sdkInitState()
        isInitializationSuccess = state == .Initialized
        if state == .OngoingInit || state == .NotInitialized {
            progressShow(caption: "Initializing")
            if state == .NotInitialized {
                D1Core.shared().configure(eventListener: D1CoreEventHandler.shared(),
                                          completion: { [self] errors in
                    // In all cases we can hide the progress now.
                    progressHide()
                    
                    if let error = errors?[0] {
                        bannerShow(caption: "SDK Init failed.", description: error.localizedDescription, type: .error)
                    } else {
                        // This will enable the login button.
                        isInitializationSuccess = true
                    }
                }, modules: D1Core.shared().createModuleConnector(D1Configuration.CONSUMER_ID), D1VirtualCard.shared().createModuleConnector(), D1Push.shared().createModuleConnector())
            }
        }
    }
}
