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
