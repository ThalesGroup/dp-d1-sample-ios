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
        
        fetchSandboxJWT { result in
            switch result {
            case .success(let jwt):
                guard var jwtData = jwt.data(using: .utf8) else {
                    self.progressHide()
                    
                    self.bannerShow(caption: "Failed to get token from the backend.",
                               description: "Unknown error",
                               type: .error)
                    
                    return
                }
                
                D1Core.shared().login(issuerToken: &jwtData) { [self] error in
                    progressHide()
                    
                    if let error = error {
                        bannerShow(caption: "SDK Login failed.", description: error.localizedDescription, type: .error)
                    } else {
                        // This will switch to the home View.
                        isLoginSucces = true
                    }
                }
            case .failure(let error):
                self.progressHide()

                self.bannerShow(caption: "Failed to get token from the backend.",
                           description: error.localizedDescription,
                           type: .error)
            }
        }
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
