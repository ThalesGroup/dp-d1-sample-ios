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
