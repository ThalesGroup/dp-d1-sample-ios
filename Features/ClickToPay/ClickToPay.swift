/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1
import UIKit

private func d1Task() -> D1Task {
    return D1Core.shared().getD1Task()
}

class ClickToPay {
    // MARK: - Defines
    
    private static let VISA_REQUESTOR_ID = "40010075338"
    private static let MASTERCARD_REQUESTOR_ID = "50123197928"
    
    static private let sharedInstance = ClickToPay()
        
    
    /// Retrieves the singleton instance of D1Push.
    /// - Returns: Singleton instance of D1Push.
    public class func shared() -> ClickToPayApi {
        return sharedInstance
    }
    
    
    // MARK: - Life cycle
    
    private init() {
        // private constructor
    }
}

// MARK: - ClickToPayApi

extension ClickToPay: ClickToPayApi {
    func enrolClickToPay(_ cardId: String,
                         _ consumerInfo: D1.ConsumerInfo,
                         _ billingAddress: D1.BillingAddress,
                         _ name: String,
                         _ completion: @escaping (D1ClickToPay.Status?, D1Error?) -> Void) {
        d1Task().d1ClickToPay().enrol(cardId, consumerInfo: consumerInfo, name: name, billingAddress: billingAddress, completion: completion)
    }
    
    func isClickToPayEnrolled(_ cardId: String,
                              _ completion: @escaping (Bool, D1Error?) -> Void) {
        d1Task().digitalCardList(cardId) { cardList, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            for card in cardList ?? [] {
                if (card.tokenRequestorID == ClickToPay.VISA_REQUESTOR_ID ||
                    card.tokenRequestorID == ClickToPay.MASTERCARD_REQUESTOR_ID) {
                    completion(true , nil)
                    return
                }
            }
            
            completion(false, nil);
        }
    }
    
}

extension D1ClickToPay.Status {
    var stringValue: String {
        switch self {
        case .pending(let operationID):
            return "pending(\(operationID))"
        case .successful(let operationID):
            return "successful(\(operationID))"
        @unknown default:
            fatalError()
        }
    }
}

