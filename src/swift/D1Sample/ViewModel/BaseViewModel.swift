/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// Base ViewModel.
class BaseViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isNotifcationVisible: Bool = false
    @Published var showProgress: Bool = false
    
    public func isError(error: D1Error?) -> Bool {
        showProgress = false
        
        if let error = error {
            errorMessage = error.errorDescription
            isNotifcationVisible = true
            
            return true
        }
        
        return false
    }
    
    /// Shows the error message
    /// - Parameter message: Error message.
    public func showErrorMesssage(message: String) {
        errorMessage = message
        isNotifcationVisible = true
    }
}
