/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

/// ViewModel for the virtual card list.
class PhysicalCardListViewModel: BaseViewModel {
    @Published var cardIds: [CardId] = []
    
    /// Retrieves the virtual card list from D1.
    public func retrieveCardIds() {
        var cardIdsLocal: [CardId] = []
        cardIdsLocal.append(CardId(name: Configuration.CARD_ID))
        self.cardIds = cardIdsLocal
    }
}
