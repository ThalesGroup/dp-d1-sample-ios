/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1
import SwiftUI

/// ViewModel for virtual card detail.
class CardDetailViewModel: BaseViewModel {
    @Published var pan: String?
    @Published var expr: String?
    @Published var name: String?
    @Published var cvv: String?
    @Published var cardState: CardState?
    @Published var cardScheme: CardScheme?
    @Published var digitizationState: CardDigitizationState? = .digitized
    @Published var cardIcon: UIImage?
    @Published var cardBackground: UIImage = UIImage()
    var panMasked: String?
    
    /// Retrieves the virtual card details.
    /// - Parameter cardId: Card ID.
    public func getCardMetaData(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().getCardMetadata(cardId: cardId) { (cardMetadata: CardMetadata?, error: D1Error?) in
            
            DispatchQueue.main.async {
            if self.isError(error: error) {
                return
            }
            
            if let cardMetadata = cardMetadata {
                self.pan = "**** **** **** " + cardMetadata.cardLast4
                self.panMasked = self.pan
                self.expr = cardMetadata.cardExpiry
                self.name = "****"
                self.cvv = "****"
                self.cardState = cardMetadata.cardState
                
                self.extractImageResources(cardMetaData: cardMetadata)
            }
            }
        }
    }
    
    /// Retrieves the protected card details.
    /// - Parameter cardId: Card ID.
    public func showCardDetails(cardId: String) {
        self.showProgress = true

        D1Helper.shared().getCardDetails(cardId: cardId) { (cardDetails: CardDetails?, error: D1Error?) in
            DispatchQueue.main.async {
                if self.isError(error: error) {
                    return
                }
                
                if let pan = cardDetails?.pan, let expr = cardDetails?.expiryDate, let cvv = cardDetails?.cvv, let name = cardDetails?.cardHolderName {
                    self.pan = String(data: pan, encoding: .utf8)
                    self.expr = String(data: expr, encoding: .utf8)
                    self.cvv = String(data: cvv, encoding: .utf8)
                    self.name = String(data: name, encoding: .utf8)
                }
                
                // TODO: not mutating variable
                // cardDetails?.wipe()
            }
        }
    }
    
    /// Clears the card details.
    public func hideCardDetails() {
        self.pan = self.panMasked
        self.name = "****"
        self.cvv = "****"
    }
    
    /// Suspends the card.
    /// - Parameter cardId: Card ID.
    public func suspendCard(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().suspedCard(cardId: cardId) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.getCardMetaData(cardId: cardId)
        }
    }
    
    /// Resumes the card.
    /// - Parameter cardId: Card ID.
    public func resumeCard(cardId: String) {
        self.showProgress = true

        D1Helper.shared().resumeCard(cardId: cardId) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.getCardMetaData(cardId: cardId)
        }
    }
    
    /// Deletes the card.
    /// - Parameter cardId: Card ID.
    public func deleteCard(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().deleteCard(cardId: cardId) { (error: D1Error?) in
            
                if self.isError(error: error) {
                    return
                }
                
                self.cardState = .deleted
        }
    }
    
    /// Checks if card is digitized.
    /// - Parameter cardId: Card ID.
    public func isCardDigitized(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().getDigitizationState(cardId: cardId) { (result: CardDigitizationResult?, error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.digitizationState = result?.state
        }
    }
    
    /// Digitizes the card.
    /// - Parameter cardId: Card ID.
    public func digitizeCard(cardId: String) {
        self.showProgress = true

        D1Helper.shared().digitizeCard(cardid: cardId) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            // get updated card state
            self.isCardDigitized(cardId: cardId)
        }
    }
    
    /// Extracts the image resources.
    /// - Parameter cardMetaData: Card meta data.
    private func extractImageResources(cardMetaData: CardMetadata?) {
        if let cardAssets: [CardAsset] = cardMetaData?.cardAssetArray {
            for cardAsset in cardAssets {
                if let cardAssetContent = cardAsset.contentArray.first?.encodedData {
                    if let cardImageData: Data = Data(base64Encoded: cardAssetContent) {
                        if cardAsset.assetContentType == .background {
                            if let backgroundImage = UIImage.init(data: cardImageData) {
                                self.cardBackground = backgroundImage
                            }
                        } else {
                            self.cardIcon = UIImage.init(data: cardImageData)
                        }
                    }
                }
            }
        }
    }
}
