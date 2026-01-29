/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

/// D1 Click To Pay related API.
protocol ClickToPayApi {
    
    
    /// Enrolls Click To Pay.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - consumerInfo: Consumer info.
    ///   - billingAddress: Billing address.
    ///   - name: Name.
    ///   - completion: Callback.
    func enrolClickToPay(_ cardId: String,
                         _ consumerInfo: ConsumerInfo,
                         _ billingAddress: BillingAddress,
                         _ name: String,
                         _ completion: @escaping (D1ClickToPay.Status?, D1Error?) -> Void);
    
    
    /// Checks if the specific card is enrolled to Click To Pay.
    /// - Parameter cardId: Card ID.
    ///   - completion: Callback.
    func isClickToPayEnrolled(_ cardId: String,
                              _ completion: @escaping (Bool, D1Error?) -> Void);
}

