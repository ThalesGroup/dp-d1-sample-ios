/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var cardId: String?
    var tag: Int
}

/// Virtual Card ViewModel.
class VirtualCardViewModel: BaseViewModel {
    var listOfCards: [TabItem] = [TabItem(cardId: D1Configuration.CARD_ID, tag: 0),
                                  TabItem(cardId: D1Configuration.CARD_ID, tag: 1)]
    
    func getVirtualCardDetailView(_ cardId: String?) -> VirtualCardDetailView {
        return D1VirtualCard.shared().getVirtualCardDetailView(cardId)
    }

}
