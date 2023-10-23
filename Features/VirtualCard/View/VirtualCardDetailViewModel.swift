/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import UIKit
import SwiftUI
import D1
import LocalAuthentication

class VirtualCardDetailViewModel: CardViewModel {
    private var authenticationRequired = D1Configuration.VIRTUAL_CARD_DETAIL_AUTHENTICATION_REQUIRED
    
    override init(_ cardId: String) {
        super.init(cardId)
        
        self.showCvv = true
    }

    override func toggleCardDetails() {
        if !showFullPan && authenticationRequired {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to display full card data."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [self] success, authenticationError in
                    
                    CoreUtils.runInMainThreadAsync {
                        if success {
                            self.showFullPan = true
                            self.authenticationRequired = false
                            self.loadCardDetails()
                        } else {
                            var displayError = "Unknown failure."
                            if let authenticationError = authenticationError {
                                displayError = authenticationError.localizedDescription
                            }
                            self.bannerShow(caption: "Authentication error.", description: displayError, type: .error)
                        }
                    }
                }
            } else {
                var displayError = "Biometric not configured."
                if let error = error {
                    displayError = error.localizedDescription
                }
                bannerShow(caption: "Authentication error.", description: displayError, type: .error)
            }
        } else {
            showFullPan = !showFullPan
            
            if showFullPan {
                loadCardDetails()
            } else {
                cardCvv = nil
                cardPan = nil
                cardHolderName = nil
            }
        }
    }
    
    override func showCardId() -> String {
        return "**** **** **** \(valOrReucted(self.cardLast4Pan))"
    }
    
    // MARK: - Private Helpers
    
    
    /// Loads the card details.
    private func loadCardDetails() {
        D1VirtualCard.shared().getCardDetails(virtualCardId) { [self] cardDetails, error in
            if let cardDetails = cardDetails {
                cardPan = String(data: cardDetails.pan, encoding: .utf8)
                cardCvv = String(data: cardDetails.cvv, encoding: .utf8)
                if let data = cardDetails.cardHolderName {
                    cardHolderName = String(data: data, encoding: .utf8)
                }
            } else if let unHandled = handleError(error) {
                bannerShow(caption: "Load Card Metadada failed.", description: unHandled.localizedDescription, type: .error)
                showFullPan = false
            }
        }
    }
}
