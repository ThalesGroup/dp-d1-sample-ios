/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import D1

struct CardId: Identifiable {
    let id = UUID()
    let name: String
}

/// ViewModel for the virtual card list.
class VirtualCardListViewModel: BaseViewModel {
    @Published var cardIds: [CardId] = []
    @Published var isLogoutSuccesfull: Bool = false
    
    /// Retrieves the virtual card list from D1.
    public func retrieveCardIds() {
        var cardIdsLocal: [CardId] = []
        cardIdsLocal.append(CardId(name: Configuration.CARD_ID))
        self.cardIds = cardIdsLocal
    }
}
