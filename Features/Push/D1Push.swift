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
    public class func shared() -> D1PushApi {
        return sharedInstance
    }
    
    
    // MARK: - Life cycle
    
    private init() {
        // private constructor
    }
}

// MARK: - D1PushApi

extension D1Push: D1PushApi {
    func isDigitizedAsDigitalPayCard(_ cardId: String,
                                     completion: @escaping (D1.CardDigitizationResult?, D1.D1Error?) -> Void) {
        d1Task().cardDigitizationState(cardId, completion: lambda(VCEventCardDigitizationState, completion: completion))
    }

    func digitizeToDigitalPayCard(_ cardId: String, viewController: UIViewController, completion: @escaping (D1Error?) -> Void) {
        d1Task().addDigitalCardToOEM(cardId, viewController: viewController, completion: completion)
    }
    
    func createModuleConnector() -> D1ModuleConnector {
        return D1PushModuleConnector()
    }
    
    func getDigitalCardList(cardId: String, completion: @escaping ([D1.DigitalCard]?, D1.D1Error?) -> Void) {
        d1Task().digitalCardList(cardId, completion: lambda(VCEventDigitalCardList, completion: completion))
    }
    
    func suspendDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        d1Task().updateDigitalCard(cardId,
                                   digitalCard: digitalCard,
                                   action: CardAction.suspend,
                                   completion: lambda(VCEventCardDigitizationLifeCycle, completion: completion))
    }
    
    func resumedDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        d1Task().updateDigitalCard(cardId,
                                   digitalCard: digitalCard,
                                   action: CardAction.resume,
                                   completion: lambda(VCEventCardDigitizationLifeCycle, completion: completion))
    }
    
    func deleteDigitalCard(cardId: String, digitalCard: D1.DigitalCard, completion: @escaping (Bool?, D1.D1Error?) -> Void) {
        d1Task().updateDigitalCard(cardId,
                                   digitalCard: digitalCard,
                                   action: CardAction.delete,
                                   completion: lambda(VCEventCardDigitizationLifeCycle, completion: completion))
    }
    
    func getDigitalCardDetailView(_ cardId: String, _ digitalCardId: String, _ deleteCallback: @escaping () -> Void) -> DigitalCardDetailView {
        return DigitalCardDetailView(cardId, digitalCardId, deleteCallback)
    }
    
    func activateDigitalCard(cardId: String, completion: @escaping (D1.D1Error?) -> Void) {
        d1Task().activateDigitalCard(cardId, completion: lambda(VCEventCardActivation, completion: completion))
    }
    
    func getDigitalCard(cardId: String, digitaCardId: String, completion: @escaping (D1.DigitalCard?, D1.D1Error?) -> Void) {
        self.getDigitalCardList(cardId: cardId) { (cardList: [DigitalCard]?, error: D1Error?) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let cardList = cardList {
                for digitalCard in cardList {
                    if digitalCard.cardID == digitaCardId {
                        completion(digitalCard, nil)
                        
                        return
                    }
                }
            }
            
            completion(nil, nil)
        }
    }
}

// MARK: - D1ModuleConnector

/// D1Push related D1ModuleConnector.
private class D1PushModuleConnector: D1ModuleConnector {
    func getConfiguration() -> [D1.ConfigParams] {
        // There is no extra configuration needed for this module.
        let card = ConfigParams.CardParams(cardID: D1Configuration.CARD_ID, cardArt: UIImage(named: "card_art")!, productTitle: "Product Title")
        return [ConfigParams.cardConfig(), ConfigParams.walletExtensionConfig(cardParamsList: [card], appGroupID: "group.com.thalesgroup.d1.Templates")]
    }
    
    func getModuleId() -> Module {
        .d1Push
    }
}
