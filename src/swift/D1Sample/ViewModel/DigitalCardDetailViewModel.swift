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

/**
 * ViewModel for digital card detail.
 */
class DigitalCardDetailViewModel: BaseViewModel {
    @Published var state: String?
    @Published var scheme: String?
    @Published var last4: String?
    @Published var expr: String?
    @Published var deviceId: String?
    @Published var deviceName: String?
    @Published var deviceType: String?
    @Published var walletID: String?
    @Published var walletName: String
    
    private var digitalCard: DigitalCard?
    
    /**
     * Retrieves the digital card details.
     *
     * @param cardId Card ID.
     * @param digitalCardId Digital Card ID.
     */
    public func getDigitalCardDetails(cardId: String, digitalCardId: String) {
        DispatchQueue.main.async {
            self.showProgress = true
        }
        
        D1Helper.shared().getCardDetails(cardId: <#T##String#>, callback: <#T##(CardDetails?, D1Error?) -> Void#>)
        
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
                self.cardFormFactor = cardMetadata.cardFormFactor
                
                self.extractImageResources(cardMetaData: cardMetadata)
            }
            }
        }
    }
    
    /**
     * Retrieves the protected card details.
     *
     * @param cardId Card ID.
     */
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
    
    /**
     * Clears the card details.
     */
    public func hideCardDetails() {
        self.pan = self.panMasked
        self.name = "****"
        self.cvv = "****"
    }
    
    /**
     * Suspends the card.
     *
     * @param cardId Card ID.
     */
    public func suspendCard(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().suspedCard(cardId: cardId) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.getCardMetaData(cardId: cardId)
        }
    }
    
    /**
     * Resumes the card.
     *
     * @param cardId Card ID.
     */
    public func resumeCard(cardId: String) {
        self.showProgress = true

        D1Helper.shared().resumeCard(cardId: cardId) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.getCardMetaData(cardId: cardId)
        }
    }
    
    /**
     * Deletes the card.
     *
     * @param cardId Card ID.
     */
    public func deleteCard(cardId: String) {
        self.showProgress = true
        
        D1Helper.shared().deleteCard(cardId: cardId) { (error: D1Error?) in
            
                if self.isError(error: error) {
                    return
                }
                
                self.cardState = .deleted
        }
    }
    
    /**
     * Checks if card is digitized.
     *
     * @param cardId Card ID.
     */
    public func isCardDigitized(cardId: String) {
        self.showProgress = true

        D1Helper.shared().getDigitizationState(cardId: cardId) { (result: CardDigitizationResult?, error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            self.digitizationState = result?.state
        }
    }
    
    /**
     * Digitizes the card.
     *
     * @param cardId            Card ID.
     * @param cardHolderName Card holder name.
     */
    public func digitizeCard(cardId: String, cardHolderName: String) {
        self.showProgress = true

        D1Helper.shared().digitizeCard(cardid: cardId, cardHolderName: cardHolderName) { (error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            // get updated card state
            self.isCardDigitized(cardId: cardId)
        }
    }
    
    /**
     * Extracts the image resources.
     *
     * @param cardMetadata Card meta data.
     */
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
