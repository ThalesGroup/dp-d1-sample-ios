/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// Splash ViewModel.
class SplashViewModel: BaseViewModel {
    @Published var isInitializationSuccess: Bool = false

    /// Configures D1 SDK.
    /// - Parameter consumerId: Consumer ID.
    public func configure(consumerId: String) {
        self.showProgress = true
        
        D1Helper.shared().configure(consumerId: consumerId) { (error: [D1Error]?) in
            if let error = error {
                if self.isError(error: error[0]) {
                    return
                }
            }
                        
            self.isInitializationSuccess = true
        }
    }
}
