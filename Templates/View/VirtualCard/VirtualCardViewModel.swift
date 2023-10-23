/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import D1

struct TabItem: Identifiable {
    var id = UUID()
    var cardId: String
    var tag: Int
}

/// Virtual Card ViewModel.
class VirtualCardViewModel: BaseViewModel {
    var listOfCards: [TabItem] = [TabItem(cardId: D1Configuration.CARD_ID, tag: 0),
                                  TabItem(cardId: D1Configuration.CARD_ID, tag: 1)]
    @Published var disableDigitizationButton: Bool = true;
    @Published var pushAvailable: Bool = D1Core.shared().isModuleEnabled(.d1Push)
    
    
    /// Retrieves the virtual card detail
    /// - Parameter cardId: Card ID.
    /// - Returns: Virtual card detail.
    func getVirtualCardDetailView(_ cardId: String) -> VirtualCardDetailView {
        return D1VirtualCard.shared().getVirtualCardDetailView(cardId)
    }

    
    /// Checks if card is digitized.
    /// - Parameter cardId: Card ID.
    func cardDigitizationState(_ cardId: String) {
        self.disableDigitizationButton = true
        
        D1Push.shared().isDigitizedAsDigitalPayCard(cardId) { (result: CardDigitizationResult?, error: D1Error?) in
            if let error = error {
                self.bannerShow(caption: "Error during get card digitization state.", description: error.localizedDescription, type: .error)
            } else {
                if let result = result {
                    self.disableDigitizationButton = result.state != .notDigitized
                }
            }
        }
    }
    
    
    /// Digitizes the card.
    /// - Parameter cardId: Card ID.
    /// - Returns: D1PushView.
    func digitizeCard(_ cardId: String) -> D1PushView {
        return D1PushView(viewModel: self, cardId: cardId)
    }
}
