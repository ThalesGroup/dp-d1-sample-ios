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
import SwiftUI

/// Helper class for D1 SDK.
public class D1Helper {
    
    private var d1Task: D1Task?
    
    private static var sharedD1Helper: D1Helper = {
        return D1Helper()
    }()
    
    private init() {
        
    }

    /// Retrieves the singleton instance of  D1Helper}.
    /// - Returns: Singleton instance of D1Helper.
    public class func shared() -> D1Helper {
        return sharedD1Helper
    }

    /// Configures the D1 SDK.
    /// - Parameters:
    ///   - consumerId: Consumer ID.
    ///   - callback: Callback.
    public func configure(consumerId: String, callback: @escaping ([D1Error]?) -> Void) {
        var components = D1Task.Components()
        components.d1ServiceURLString = Configuration.D1_SERVICE_URL
        components.issuerID = Configuration.ISSUER_ID
        components.d1ServiceRSAExponent = Data(bytes: Configuration.D1_SERVICE_RSA_EXPONENT, count: Configuration.D1_SERVICE_RSA_EXPONENT.count)
        components.d1ServiceRSAModulus = Data(bytes: Configuration.D1_SERVICE_MODULUS, count: Configuration.D1_SERVICE_MODULUS.count)
        components.digitalCardURLString = Configuration.DIGITAL_CARD_URL

        d1Task = components.task()

        let coreConfig: ConfigParams = ConfigParams.coreConfig(consumerID: consumerId)
        let cardConfig: ConfigParams = ConfigParams.cardConfig()
        
        getD1Task().configure([coreConfig, cardConfig], completion: callback)
    }
    
    /// Logs in.
    /// - Parameters:
    ///   - accessToken: Issuer token.
    ///   - callback: Callback.
    public func login(accessToken: String, callback: @escaping (D1Error?) -> Void) {
        if var accessTokenData: Data = accessToken.data(using: .utf8) {
            self.getD1Task().login(&accessTokenData, completion: callback)
        }
    }
    
    /// Logs out.
    /// - Parameter callback: Callback.
    public func logout(callback: @escaping (D1Error?) -> Void) {
        getD1Task().logout(callback)
    }

    /// Retrieves the card meta data.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func getCardMetadata(cardId: String, callback: @escaping (CardMetadata?, D1Error?) -> Void) {
        self.getD1Task().cardMetadata(cardId, completion: callback)
    }
    
    /**
     * Retrieves the protected card details.
     *
     * @param cardId   Card ID.
     * @param callback Callback.
     */
    
    /// Retrieves the protected card details.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func getCardDetails(cardId: String, callback: @escaping (CardDetails?, D1Error?) -> Void) -> Void {
        self.getD1Task().cardDetails(cardId, completion: callback)
    }
    
    /// Suspends the card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func suspedCard(cardId: String, callback: @escaping (D1Error?) -> Void) {
        self.getD1Task().updateCard(cardId, cardAction: CardAction.suspend, reason: "Suspend", completion: callback)
    }
    
    /// Resumes the card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func resumeCard(cardId: String, callback: @escaping (D1Error?) -> Void) {
        self.getD1Task().updateCard(cardId, cardAction: CardAction.resume, reason: "Resume", completion: callback)
    }
    
    /// Deletes the card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func deleteCard(cardId: String, callback: @escaping (D1Error?) -> Void) {
        self.getD1Task().updateCard(cardId, cardAction: CardAction.delete, reason: "Delete", completion: callback)
    }
    
    /// Checks if card is digitized.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func getDigitizationState(cardId: String, callback: @escaping (CardDigitizationResult?, D1Error?) -> Void) {
        self.getD1Task().cardDigitizationState(cardId, completion: callback)
    }
    
    /// Digitizes the card.
    /// - Parameters:
    ///   - cardid: Card ID.
    ///   - callback: Callback.
    public func digitizeCard(cardid: String, callback: @escaping (D1Error?) -> Void) {
        let viewController: UIViewController = UIViewController()
        getD1Task().addDigitalCardToOEM(cardid, viewController: viewController, completion: callback)
    }
    
    /// Checks if the D1 SDK is configured.
    /// - Returns: True if configured, else false
    public func isConfigured() -> Bool {
        return self.d1Task != nil
    }
    
    /// Retrieves the list of digital cards.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func getDigitalCardList(cardId: String, callback: @escaping ([DigitalCard]?, D1Error?) -> Void) {
        self.getD1Task().digitalCardList(cardId, completion: callback)
    }
    
    /// Suspends the digital card.
    /// - Parameters:
    ///   - cardId:  Card ID.
    ///   - digitalCard: Digital card.
    ///   - callback: Callback.
    public func suspendDigitalCard(cardId: String, digitalCard: DigitalCard, callback: @escaping (Bool, D1Error?) -> Void) {
        self.getD1Task().updateDigitalCard(cardId, digitalCard: digitalCard, action: .suspend, completion: callback)
    }
    
    /// Resumes the digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - digitalCard: Digital card.
    ///   - callback: Callback.
    public func resumedDigitalCard(cardId: String, digitalCard: DigitalCard, callback: @escaping (Bool, D1Error?) -> Void) {
        self.getD1Task().updateDigitalCard(cardId, digitalCard: digitalCard, action: .resume, completion: callback)
    }
    
    /// Deletes the digital card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - digitalCard: Digital card.
    ///   - callback: Callback.
    public func deleteDigitalCard(cardId: String, digitalCard: DigitalCard, callback: @escaping (Bool, D1Error?) -> Void) {
        self.getD1Task().updateDigitalCard(cardId, digitalCard: digitalCard, action: .delete, completion: callback)
    }
    
    /// Activates the physical card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - secureTextField: Secure Text Field for code entry.
    ///   - callback: Callback.
    public func activatePhysicalCard(cardId: String, secureTextField: D1SecureTextField, callback: @escaping (D1Error?) -> Void) {
        let entryUi: EntryUI = EntryUI(entryTextField: secureTextField)
        self.getD1Task().activatePhysicalCard(cardId, entryUI: entryUi, completion: callback)
    }

    /// Gets the physical card activation method.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - callback: Callback.
    public func getActivationMehod(cardId: String, callback: @escaping (CardActivationMethod?, D1Error?) -> Void) {
        self.getD1Task().cardActivationMethod(cardId, completion: callback)
    }
    
    
    /// Retrieves the physical card PIN.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - textField: Text Field to dispaly the PIN.
    ///   - callback: Callback
    public func getPin(cardId: String, textField: D1PINDisplayTextField, callback: @escaping (D1Error?) -> Void ) {
        let cardPinUI: CardPINUI = CardPINUI(pinTextField: textField)
        self.getD1Task().displayPhysicalCardPIN(cardId, cardPINUI: cardPinUI, completion: callback)
    }
    
    
    /// Retrieves the SDK versions.
    /// - Returns: SDK versions
    func getLibVersions() -> String {
        return D1Task.getSDKVersions().description
    }

    /// Dispatch to main thread with delay - used for development.
    /// - Parameter block: Code block to dispatch.
    private func mockDispatch(block: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    /// Retrieves the D1Task instance.
    /// - Returns: D1Task instance.
    private func getD1Task() -> D1Task {
        if let d1Task = d1Task {
            return d1Task
        } else {
            fatalError("Need to configure D1 SDK first.")
        }
    }
     
    /// Configures RASP.
    private func configureRasp() {
        // removed
    }
}
