/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// ViewModel for the digital card list.
class DigitalCardListViewModel: BaseViewModel {
    @Published var cardIds: [CardId] = []
    
    /// Retrieves the digital card list from D1.
    /// - Parameter virtualCardId: Card ID.
    public func retrieveDigitalCards(virtualCardId: String) {
        self.showProgress = true
        
        D1Helper.shared().getDigitalCardList(cardId: virtualCardId) { (digitalCardList: [DigitalCard]?, error: D1Error?) in
            if self.isError(error: error) {
                return
            }
            
            if let digitalCardList = digitalCardList {
                self.extractDigitalCardIds(digitalCardList: digitalCardList)
            } else {
                self.showErrorMesssage(message: "No Digital Cards Present")
            }
        }
    }

    /// Extracts the digital card ids.
    /// - Parameter digitalCardList:List of digital cards.
    private func extractDigitalCardIds(digitalCardList:[DigitalCard]) {
        var digitalCardIdLocal: [CardId] = []
        for digitalCard in digitalCardList {
            digitalCardIdLocal.append(CardId(name: digitalCard.cardID))
        }
        
        self.cardIds = digitalCardIdLocal
    }
}
