/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import UIKit
import SwiftUI
import D1
import LocalAuthentication

class VirtualCardDetailViewModel: BaseViewModel {
    
    // MARK: - Defines
    private let virtualCardId: String?
    private var authenticationRequired = D1Configuration.VIRTUAL_CARD_DETAIL_AUTHENTICATION_REQUIRED

    // Card metadata
    @Published var cardLast4Pan: String?
    @Published var cardHolderName: String?
    @Published var cardExp: String?
    @Published var cardCvv: String?
    @Published var cardPan: String?
    @Published var cardBackground: Image? = nil

    
    @Published var cardFontColor: Color = .black
    @Published var showFullPan: Bool = false
    @Published var loadingValues: Bool = true
    @Published var pushAvailable: Bool = D1Core.shared().isModuleEnabled(.d1Push)

    // MARK: - Life Cycle
    
    init(_ cardId: String?) {
        virtualCardId = cardId
    }
    
    // MARK: - Public API
    
    func toggleCardDetails() {
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
    
    func loadCardMetadata() {
        // Prevent crash of swift preview. We can't trigger actual load without app running.
        guard let virtualCardId = virtualCardId else {
            return
        }
        
        D1VirtualCard.shared().getCardMetadata(virtualCardId) { [self] metaData, error in
            if let metaData = metaData {
                cardLast4Pan = metaData.cardLast4
                cardExp = metaData.cardExpiry
                extractImageResources(metaData)
                
                loadingValues = false
                cardFontColor = .white
            } else if let unHandled = handleError(error) {
                bannerShow(caption: "Load Card Metadada failed.", description: unHandled.localizedDescription, type: .error)
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func loadCardDetails() {
        D1VirtualCard.shared().getCardDetails(virtualCardId!) { [self] cardDetails, error in
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
    
    private func extractImageResources(_ metaData: CardMetadata) {
        metaData.cardAssetArray { [self] assetArray, error in
            if let assetArray = assetArray {
                extractImageResourcesLoop(assetArray: assetArray)
            } else if let unHandled = handleError(error) {
                bannerShow(caption: "Extract card image resources failed.", description: unHandled.localizedDescription, type: .error)
            }
        }
    }
    
    private func extractImageResourcesLoop(assetArray: [D1.CardAsset]) {
        for loopAsset in assetArray {
            for loopContent in loopAsset.contentArray {
                guard let image = extractImage(loopContent) else {
                    continue
                }
                
                if loopAsset.assetContentType == .background {
                    cardBackground = image
                } else if loopAsset.assetContentType == .icon {
                    print("logo")
                }
            }
        }
    }
    
    private func extractImage(_ content: CardAssetContent) -> Image? {
        if content.mimeType == .png, let data = Data(base64Encoded: content.encodedData), let image = UIImage(data: data) {
            return Image(uiImage: image)
        } else {
            // Other assets like svg or pdf is not supported.
            return nil
        }
    }
    
    
}
