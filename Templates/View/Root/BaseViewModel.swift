/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

/// Base ViewModel.
class BaseViewModel: ObservableObject {
    @Published var bannerData: BannerData? = nil
    @Published var bannerShow: Bool = false
    
    @Published var progressData: ProgressData? = nil
    @Published var progressShow: Bool = false

    @Published var openLoginPage: Bool = false
    @Published var openLoginError: String?

    /// Unified way how to display toast like banner with custom message.
    /// - Parameter data: Banner data.
    public func bannerShow(caption: String, description: String, type: BannerType = .info) {
        CoreUtils.runInMainThreadAsync {
            self.bannerData = BannerData(caption: caption, description: description, type: type)
            self.bannerShow = true
        }
    }
    
    /// Hides all currently visible banners.
    public func bannerHide() {
        CoreUtils.runInMainThreadAsync {
            self.bannerShow = false
        }
    }
    
    /// Unified way how to display toast like banner with custom message.
    /// - Parameter data: Banner data.
    public func progressShow(caption: String, description: String? = nil) {
        progressData = ProgressData(caption: caption, description: description)
        progressShow = true
    }
    
    /// Hides all currently visible banners.
    public func progressHide() {
        CoreUtils.runInMainThreadAsync {
            self.progressShow = false
        }
    }
    
    
    /// Generic error handler for majority of the SDK callbacks, which will handle case where we are not logged in and return us to the login screen.
    /// - Parameter error: Possible error from the SDK.
    /// - Returns: Return error if it was not nil and is different from not logged in.
    public func handleError(_ error: D1Error?) -> D1Error? {
        if let error = error, error.code == .notLoggedIn {
            openLoginPage = true
            openLoginError = error.localizedDescription
            return nil
        } else {
            return error
        }
    }
    
}
