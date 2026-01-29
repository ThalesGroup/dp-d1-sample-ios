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
    @Published var isClickToPayEnrolled: Bool = true;
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
    
    
    /// Enrolls Click To Pay.
    /// - Parameter cardId: Card ID.
    func enrollClickToPay(_ cardId: String) {
        progressShow(caption: "Click To Pay enrollment in progress")
        
        // TODO: use dummy data for now
        let consumerInfo = ConsumerInfo(firstName: "Bella", middleName: nil, lastName: "Lin", language: "en-US", phoneNumberCountryCode: "+65", phoneNumber: "99998888", email: "email@thalesgroup.com")
        let billingAddress = BillingAddress(line1: "1230 Rue de Rivoli", line2: nil, line3: nil, city: "Paris", state: "75", zipCode: "75000", countryCode: "FR")
        let name = "Bella Lin"
        
        ClickToPay.shared().enrolClickToPay(cardId, consumerInfo, billingAddress, name) { status, error in
            self.progressHide()
            
            if let error = error {
                self.bannerShow(caption: "Enroll Click To Pay failed.", description: error.localizedDescription, type: .error)
            } else {
                self.bannerShow(caption: "Click To Pay status: \(String(describing: status?.stringValue))", description: "", type: .info)
                self.isClickToPayEnrolled = true
            }
        }
    }
    
    
    /// Checks if Click To Pay is enrolled.
    /// - Parameter cardId: Card ID.
    func isClickToPayEnrolled(_ cardId: String) {
        ClickToPay.shared().isClickToPayEnrolled(cardId) { isClickToPayEnrolled, error in
            if let error = error {
                self.bannerShow(caption: "Error checking Click To Pay enrollment.", description: error.localizedDescription, type: .error)
            } else {
                self.isClickToPayEnrolled = isClickToPayEnrolled
            }
        }
    }
}
