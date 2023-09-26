/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1
import UIKit

private func d1Task() -> D1Task {
    return D1Core.shared().getD1Task()
}


/// D1PushApi implementation.
class D1Push {
    // MARK: - Defines
    
    static private let sharedInstance = D1Push()
        
    
    /// Retrieves the singleton instance of D1Push.
    /// - Returns: Singleton instance of D1Push.
    public class func shared() -> D1Push {
        return sharedInstance
    }
    
    
    // MARK: - Life cycle
    
    private init() {
        // private constructor
    }
}

// MARK: - D1VirtualCardApi

extension D1Push: D1PushApi {

    func isDigitizedAsDigitalPayCard(_ cardId: String,
                                     completion: @escaping (D1.CardDigitizationResult?, D1.D1Error?) -> Void) {
        // TODO
    }

    func digitizeToDigitalPayCard(_ cardId: String, viewController: UIViewController, completion: @escaping (D1Error?) -> Void) {
        // TODO
    }
    
    func createModuleConnector() -> D1ModuleConnector {
        return D1PushModuleConnector()
    }
    
    func getDigitalCardList(cardId: String, completion: @escaping ([D1.DigitalCard]?, D1.D1Error?) -> Void) {
        // TODO
    }
    
    func suspendDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        // TODO
    }
    
    func resumedDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        // TODO
    }
    
    func deleteDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        // TODO
    }
}

// MARK: - D1ModuleConnector

/// D1Push related D1ModuleConnector.
private class D1PushModuleConnector: D1ModuleConnector {
    func getConfiguration() -> D1.ConfigParams? {
        // There is no extra configuration needed for this module.
        return ConfigParams.cardConfig()
    }
    
    func getModuleId() -> Module {
        .d1Push
    }
}
