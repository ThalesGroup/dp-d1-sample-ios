/*
 MIT License
 
 Copyright (c) 2021 Thales DIS
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
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
