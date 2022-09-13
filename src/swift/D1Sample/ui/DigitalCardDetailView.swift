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

import SwiftUI
import D1

struct DigitalCardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var cardDetailViewModel: CardDetailViewModel = CardDetailViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Spacer()
                        Text(self.cardDetailViewModel.pan ?? "")
                        Text(self.cardDetailViewModel.cvv ?? "")
                        Text(self.cardDetailViewModel.name ?? "")
                        Text(self.cardDetailViewModel.cvv ?? "")
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
                            if let cardId = self.viewRouter.selectedCardId, let cardHolderName = self.cardDetailViewModel.name {
                                self.cardDetailViewModel.digitizeCard(cardId: cardId, cardHolderName: cardHolderName)
                            }
                        }.disabled(true)
                    }
                    
                    ToolbarItem (placement: .bottomBar) {
                        Button("Suspend Card") {
                            if let cardId = self.viewRouter.selectedCardId {
                                self.cardDetailViewModel.suspendCard(cardId: cardId)
                            }
                        }.disabled(self.cardDetailViewModel.cardState != .active)
                    }
                    
                    ToolbarItem (placement: .bottomBar) {
                        Button("Resume Card") {
                            if let cardId = self.viewRouter.selectedCardId {
                                self.cardDetailViewModel.resumeCard(cardId: cardId)
                            }
                        }.disabled(self.cardDetailViewModel.cardState != .inactive)
                    }
                    
                    ToolbarItem (placement: .bottomBar) {
                        Button("Delete Card") {
                            if let cardId = self.viewRouter.selectedCardId {
                                self.cardDetailViewModel.deleteCard(cardId: cardId)
                            }
                        }.disabled(true)
                    }
                }.onAppear {
                    if let cardId = self.viewRouter.selectedCardId {
                        self.cardDetailViewModel.getCardMetaData(cardId: cardId)
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

struct DigitalCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DigitalCardDetailView().environmentObject(ViewRouter())
    }
}
