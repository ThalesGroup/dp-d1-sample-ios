/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1
import UIKit

/// D1 Push related API.
protocol D1PushApi {
    
    /// Checks if card is digitized in D1 Push.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - completion: Listener.
    func isDigitizedAsDigitalPayCard(_ cardId: String,
                                     completion: @escaping (D1.CardDigitizationResult?, D1.D1Error?) -> Void)
    
    /**
     * Digitizes card for D1Pay.
     *
     * @param cardId   Card ID.
     * @param listener Listener.
     */
    
    /// Digitizes card for D1Push.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - viewController: ViewController
    ///   - completion: Listener.
    func digitizeToDigitalPayCard(_ cardId: String,
                                  viewController: UIViewController,
                                  completion: @escaping (D1Error?) -> Void)
    
    
    /// Retrieves the list of digital cards.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - completion: Listener.
    func getDigitalCardList(cardId: String, completion: @escaping ([DigitalCard]?, D1Error?) -> Void)
    
    
    /// Suspends the digital card.
    /// - Parameters:
    ///   - cardId:  Card ID.
    ///   - digitalCard: Digital card.
    ///   - completion: Listener.
    func suspendDigitalCard(cardId: String, digitalCard: DigitalCard, completion: @escaping (Bool?, D1Error?) -> Void)
    
    
    /// Resumes the digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - digitalCard: Digital card.
    ///   - completion: Listener.
    func resumedDigitalCard(cardId: String, digitalCard: DigitalCard, completion: @escaping (Bool?, D1Error?) -> Void)
    
    
    /// Deletes the digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - digitalCard: Digital card.
    ///   - completion: Listener.
    func deleteDigitalCard(cardId: String, digitalCard: DigitalCard, completion: @escaping (Bool?, D1Error?) -> Void)
    
    
    /// Activates digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - completion: Listener.
    func activateDigitalCard(cardId: String, completion: @escaping (D1.D1Error?) -> Void);
    
    /// Retrieves the digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - digitalCardId: Digital Card ID.
    ///   - completion: Listener.
    func getDigitalCard(cardId: String, digitaCardId: String, completion: @escaping (DigitalCard?, D1.D1Error?) -> Void);
    
    
    /// Retrieves the DigitalCardDetailView.
    /// - Parameters:
    ///   - cardId: Card ID
    ///   - digitalCardId: Digital card ID.
    ///   - deleteCallback: Delete callback - triggered when card is deleted, used to reload the card list.
    /// - Returns: DigitalCardDetailView
    func getDigitalCardDetailView(_ cardId: String, _ digitalCardId: String, _ deleteCallback: @escaping () -> Void) -> DigitalCardDetailView;

    
    /// Creates the D1Push related D1ModuleConnector.
    /// - Returns: D1Push related D1ModuleConnector.
    func createModuleConnector() -> D1ModuleConnector;

}
