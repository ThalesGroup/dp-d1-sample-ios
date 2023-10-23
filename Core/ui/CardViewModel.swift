/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import UIKit
import SwiftUI
import D1


/// Card ViewModel used in VirtualCard and D1Push feature to display card image and details.
class CardViewModel: BaseViewModel {
    
    // MARK: - Defines
    internal let virtualCardId: String
    private var authenticationRequired = D1Configuration.VIRTUAL_CARD_DETAIL_AUTHENTICATION_REQUIRED

    // Card metadata
    @Published var cardLast4Pan: String?
    @Published var cardHolderName: String?
    @Published var cardExp: String?
    @Published var cardCvv: String?
    @Published var cardPan: String?
    @Published var cardBackground: Image? = nil
    @Published var displayCardId: String = ""
    @Published var cardFontColor: Color = .black
    @Published var showFullPan: Bool = false
    @Published var loadingValues: Bool = true
    @Published var pushAvailable: Bool = D1Core.shared().isModuleEnabled(.d1Push)
    @Published var showCvv:Bool = false
    @Published var cardState: String = ""

    // MARK: - Life Cycle
    
    
    /// Creates a new CardViewModel instance.
    /// - Parameter cardId: Card ID.
    init(_ cardId: String) {
        virtualCardId = cardId
    }
    
    // MARK: - Public API
    
    
    /// Formats the PAN
    /// - Parameter value: PAN to format.
    /// - Returns: Formatted PAN.
    public func formatPan(_ value: String) -> String {
        return String(value.enumerated().map { $0 > 0 && $0 % 4 == 0 ? [" ", $1] : [$1]}.joined())
    }
    
    
    /// Returns value if present, else string of "*" based on reductedLength.
    /// - Parameters:
    ///   - value: Value
    ///   - reductedLength: number of "*".
    /// - Returns: Returns value if present, else string of "*" based on reductedLength.
    public func valOrReucted(_ value: String?, _ reductedLength: Int = 4) -> String {
        if let value = value, !self.loadingValues {
            return value
        } else {
            return String((0..<reductedLength).map{ _ in "*" })
        }
    }
    
    
    /// Loads the card meta data.
    func loadCardMetadata() {        
        D1Core.shared().getCardMetadata(virtualCardId) { [self] metaData, error in
            if let metaData = metaData {
                cardLast4Pan = metaData.cardLast4
                cardExp = metaData.cardExpiry
                extractImageResources(metaData)
                
                loadingValues = false
                cardFontColor = .white
                
                displayCardId = showCardId()
            } else if let unHandled = handleError(error) {
                bannerShow(caption: "Load Card Metadada failed.", description: unHandled.localizedDescription, type: .error)
            }
        }
    }
    
    // MARK: - Internal
    
    
    /// Loads card details.
    internal func toggleCardDetails() {
        // implement in VirtualCard
    }
    
    internal func showCardId() -> String{
        // implement in VirtualCard and D1Push
        return ""
    }
    
    // MARK: - Private Helpers
    
    
    /// Extracts image resources.
    /// - Parameter metaData: Card meta data.
    private func extractImageResources(_ metaData: CardMetadata) {
        metaData.cardAssetArray { [self] assetArray, error in
            if let assetArray = assetArray {
                extractImageResourcesLoop(assetArray: assetArray)
            } else if let unHandled = handleError(error) {
                bannerShow(caption: "Extract card image resources failed.", description: unHandled.localizedDescription, type: .error)
            }
        }
    }
    
    
    /// Extracts the image resources.
    /// - Parameter assetArray: Card assets.
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
    
    
    /// Extracts the image
    /// - Parameter content: Card asset content.
    /// - Returns: Card image.
    private func extractImage(_ content: CardAssetContent) -> Image? {
        if content.mimeType == .png, let data = Data(base64Encoded: content.encodedData), let image = UIImage(data: data) {
            return Image(uiImage: image)
        } else {
            // Other assets like svg or pdf is not supported.
            return nil
        }
    }
    
    
}
