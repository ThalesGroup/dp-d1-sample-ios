/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1


/// Physical card detail ViewModel
class PhysicalCardDetailViewModel: BaseViewModel {
    @Published var activationMethod: String = "nothing"
    @Published var pin: String = ""
    var code: String = ""
    
    
    /// Activates card.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - textField: D1SecureTextField, wich will be used to enter the code.
    public func activateCard(cardId: String, textField: D1.D1SecureTextField) {
        self.showProgress = true

        D1Helper.shared().activatePhysicalCard(cardId: cardId, secureTextField: textField) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
        }
    }
    
    
    /// Retrieves the activation method
    /// - Parameter cardId: Card ID.
    public func getActivationMethod(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().getActivationMehod(cardId: cardId) { (cardActivationMethod: CardActivationMethod?, error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            if let cardActivationMethod = cardActivationMethod {
                self.activationMethod = self.getActivationMethodString(cardActivationMethod: cardActivationMethod)
            }
        }
    }
    
    /// Retrieves the activation method
    /// - Parameter cardId: Card ID.
    /// - Parameter textField: Text Field to dispaly the PIN.
    public func getPin(cardId: String, textField: D1PINDisplayTextField) {
        self.showProgress = true
                
        D1Helper.shared().getPin(cardId: cardId, textField: textField) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
        }
    }
    
    
    /// Converts the CardActivationMethod enum to String.
    /// - Parameter cardActivationMethod: CardActivationMethod enum.
    /// - Returns: Converted String.
    private func getActivationMethodString(cardActivationMethod: CardActivationMethod) -> String {
        switch cardActivationMethod {
            case .nothing: return "nothing"
            case .cvv: return "cvv"
            case .last4: return "last4"
            default: return "undef"
        }
    }
}
