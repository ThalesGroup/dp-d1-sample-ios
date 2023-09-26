/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

/// Home ViewModel.
class HomeViewModel: BaseViewModel {
    /// Logs out.
    public func logout() {
        progressShow(caption: "Logout in progress")

        D1Core.shared().logout { [self] error in
            progressHide()
            
            if let error = error {
                bannerShow(caption: "SDK Logout failed.", description: error.localizedDescription, type: .error)
            } else {
                openLoginPage = true
            }
        }
    }
}
