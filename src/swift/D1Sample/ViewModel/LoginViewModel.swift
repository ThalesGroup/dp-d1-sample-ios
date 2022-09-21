/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// Login ViewModel.
class LoginViewModel: BaseViewModel {
    @Published var isLoginSuccess: Bool = false
    
    /// Logs in.
    public func login() {
        self.showProgress = true
        let accessToken: String = String(decoding: JWTEncoder.generateCustomBAn(consumerID: Configuration.CONSUMER_ID, tenant: Configuration.SANDBOX),
                                         as: UTF8.self)
        
        D1Helper.shared().login(accessToken: accessToken) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
                        
            self.isLoginSuccess = true
        }
    }
}
