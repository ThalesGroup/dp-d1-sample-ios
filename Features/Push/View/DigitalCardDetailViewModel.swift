/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import UIKit
import SwiftUI
import D1
import LocalAuthentication


/// Digital card detail ViewModel.
class DigitalCardDetailViewModel: CardViewModel {
    @Published public var digitalCard: D1.DigitalCard?
    
    private var digitalCardId: String
    private var deleteCallback: () -> Void
        
    // MARK: - Life Cycle
    
    
    /// Creates a new CardViewModel instance.
    /// - Parameter cardId: Card ID.
    init(_ cardId: String, _ digitalCardId: String, _ deleteCallback: @escaping () -> Void) {
        self.digitalCardId = digitalCardId
        self.deleteCallback = deleteCallback
        
        super.init(cardId)
    }
    
    // MARK: - Public API
    
    
    /// Retrieves the digital card.
    public func getDigitalCard() {
        D1Push.shared().getDigitalCard(cardId: self.virtualCardId, digitaCardId: self.digitalCardId) { (digitalCard: DigitalCard?, error: D1Error?) in
            if let error = error {
                self.bannerShow(caption: "Error during get digital card.", description: error.localizedDescription, type: .error)
                
                return
            }
            
            if let digitalCard = digitalCard {
                self.digitalCard = digitalCard
                self.cardState = digitalCard.state.rawValue
                self.displayCardId = self.showCardId()
            }
        }
    }
    
    
    /// Suspends the digital card.
    public func suspendDigitalCard() {
        if let digitalCard = self.digitalCard {
            progressShow(caption: "Operation in progress")
            
            D1Push.shared().suspendDigitalCard(cardId: self.virtualCardId, digitalCard: digitalCard) { (isSuccess: Bool?, error: D1Error?) in
                self.progressHide()
                
                if let error = error {
                    self.bannerShow(caption: "Error during suspend digital card.", description: error.localizedDescription, type: .error)
                }
                
                // reload card
                self.getDigitalCard()
            }
        }
    }
    
    
    /// Resumes the digital card.
    public func resumeDigitalCard() {
        if let digitalCard = self.digitalCard {
            progressShow(caption: "Operation in progress")
            
            D1Push.shared().suspendDigitalCard(cardId: self.virtualCardId, digitalCard: digitalCard) { (isSuccess: Bool?, error: D1Error?) in
                self.progressHide()
                
                if let error = error {
                    self.bannerShow(caption: "Error during resume digital card.", description: error.localizedDescription, type: .error)
                }
                
                // reload card
                self.getDigitalCard()
            }
        }
    }
    
    
    /// Deletes the digital card.
    public func deleteDigitalCard() {
        if let digitalCard = self.digitalCard {
            progressShow(caption: "Operation in progress")
            
            D1Push.shared().deleteDigitalCard(cardId: self.virtualCardId, digitalCard: digitalCard) { (isSuccess: Bool?, error: D1Error?) in
                self.progressHide()
                
                if let error = error {
                    self.bannerShow(caption: "Error during delete digital card.", description: error.localizedDescription, type: .error)
                }
                
                if let isSuccess = isSuccess {
                    if (isSuccess) {
                        // reload digital card list
                        self.deleteCallback()
                    }
                }
            }
        }
    }
    
    
    /// Activates the digital card.
    public func activateCard() {
        progressShow(caption: "Operation in progress")
        
        D1Push.shared().activateDigitalCard(cardId: digitalCardId) { (error:D1Error?) in
            self.progressHide()
            
            if let error = error {
                self.bannerShow(caption: "Error during activate digital card.", description: error.localizedDescription, type: .error)
                
                return
            }
            
            self.bannerShow(caption: "Card activated.", description: "", type: .info)
        }
    }
    
    // MARK: - Override
    
    override func showCardId() -> String {
        return self.digitalCard?.cardID ?? ""
    }
}
