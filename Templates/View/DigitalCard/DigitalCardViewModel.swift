/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import D1


/// Digital Card ViewModel.
class DigitalCardViewModel: BaseViewModel {
    var listOfCards: [TabItem] = [TabItem(cardId: D1Configuration.CARD_ID, tag: 0),
                                  TabItem(cardId: D1Configuration.CARD_ID, tag: 1)]
    @Published var disableDigitizationButton: Bool = true;
    @Published var pushAvailable: Bool = D1Core.shared().isModuleEnabled(.d1Push)
    @Published var digitalCardList: [TabItem] = []
    @Published var noDigitalCard: Bool = true
    
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
    
    /// Retrieves the virtual card detail
    /// - Parameter cardId: Card ID.
    /// - Returns: Virtual card detail.
    func getDigitalCardDetailView(_ cardId: String, _ digitalCardId: String, _ deleteCallback: @escaping () -> Void) -> DigitalCardDetailView {
        return D1Push.shared().getDigitalCardDetailView(cardId, digitalCardId, deleteCallback)
    }
    
    
    /// Retrieves the digital card list.
    /// - Parameter cardId: Card ID.
    func getDigitalCardList(_ cardId: String) {
        D1Push.shared().getDigitalCardList(cardId: cardId) { (cardList: [DigitalCard]?, error: D1Error?) in
            if let error = error {
                self.bannerShow(caption: "Error during get digital card list.", description: error.localizedDescription, type: .error)
            } else {
                if let cardList = cardList {
                    var digitalCardListLocal: [TabItem] = []
                    for (index, digitalCard) in cardList.enumerated() {
                        digitalCardListLocal.append(TabItem(cardId: digitalCard.cardID, tag: index))
                    }
                    
                    self.digitalCardList = digitalCardListLocal
                    self.noDigitalCard = self.digitalCardList.isEmpty
                }
            }
        }
    }
}
