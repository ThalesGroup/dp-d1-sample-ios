/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI
import D1


/// Virtual card detail screen.
struct CardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var cardDetailViewModel: CardDetailViewModel = CardDetailViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Spacer()
                        Text(self.cardDetailViewModel.pan ?? "")
                        Text(self.cardDetailViewModel.name ?? "")
                        Text(self.cardDetailViewModel.cvv ?? "")
                        Text(self.cardDetailViewModel.expr ?? "")

                        Spacer()
                        HStack {
                            Spacer()
                            if let scheme = self.cardDetailViewModel.cardScheme {
                                Text(scheme.rawValue)
                            }
                        }
                    }.frame(width: 330, height: 200)
                        .padding()
                        .background(Image(uiImage: self.cardDetailViewModel.cardBackground))
                        .cornerRadius(30)
                    
                    if let cardState = self.cardDetailViewModel.cardState {
                        Text("Card State: " + cardState.rawValue)
                    }
                    
                    Button("Show Card Details") {
                        if let cardId = self.viewRouter.selectedCardId {
                            self.cardDetailViewModel.hideCardDetails()
                            self.cardDetailViewModel.showCardDetails(cardId: cardId)
                        }
                    }.padding(20).disabled(self.cardDetailViewModel.pan == nil)
                    
                    Button("Hide Card Details") {
                        self.cardDetailViewModel.hideCardDetails()
                    }.padding(20).disabled(self.cardDetailViewModel.pan == nil)
                    
                    Button("Show Digital Cards") {
                        self.viewRouter.currentPage = .digitalCardList
                    }.padding(20).disabled(self.cardDetailViewModel.pan == nil)
                                        
                    if self.cardDetailViewModel.showProgress {
                        ProgressView()
                    }
                    
                    Spacer()
                }.toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button("Close") {
                            viewRouter.currentPage = .cardList
                        }
                    }
                    
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button("Add Card To Wallet") {
                            if let cardId = self.viewRouter.selectedCardId {
                                self.cardDetailViewModel.digitizeCard(cardId: cardId)
                            }
                        }.disabled(self.cardDetailViewModel.digitizationState == CardDigitizationState.digitized ||
                                   self.cardDetailViewModel.digitizationState == CardDigitizationState.pendingIDVLocal ||
                                   self.cardDetailViewModel.digitizationState == CardDigitizationState.pendingIDVRemote)
                    }
                }.onAppear {
                    if let cardId = self.viewRouter.selectedCardId {
                        self.cardDetailViewModel.getCardMetaData(cardId: cardId)
                        // self.cardDetailViewModel.isCardDigitized(cardId: cardId)
                    }
                }.onChange(of: self.cardDetailViewModel.cardState) { newValue in
                    if self.cardDetailViewModel.cardState == .deleted {
                        self.viewRouter.selectedCardId = nil
                        self.viewRouter.currentPage = .cardList
                    }
                }
                
                if self.cardDetailViewModel.isNotifcationVisible && self.cardDetailViewModel.errorMessage != nil {
                    EmptyView().banner(message: self.$cardDetailViewModel.errorMessage, show: self.$cardDetailViewModel.isNotifcationVisible)
                }
            }
        }
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView().environmentObject(ViewRouter())
    }
}
