/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// Home ViewModel.
class HomeViewModel: BaseViewModel {
    @Published var isLogoutSuccess: Bool = false
    @Published var sdkVersions: String = ""
    @Published var appVersion: String = ""
    
    /// Logs out.
    public func logout() {
        self.showProgress = true
        
        D1Helper.shared().logout { (error: D1Error?) in
            if self.isError(error: error) {
                // ignore error as session can be expired, but show error message
            }
            
            self.isLogoutSuccess = true
        }
    }
    
    
    /// Retrieves the SDK versions.
    public func getLibVersions() {
        self.sdkVersions = D1Helper.shared().getLibVersions()
    }
    
    /// Retrieves the app version.
    public func getAppVersions() {
        let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let versionCode: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"

        self.appVersion = version + "-" + versionCode
    }
}
