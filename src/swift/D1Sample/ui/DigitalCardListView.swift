/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI


/// Digital card list screen.
struct DigitalCardListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var digitalCardListViewModel = DigitalCardListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    if self.digitalCardListViewModel.cardIds.count != 0 {
                        List(self.digitalCardListViewModel.cardIds) { (card: CardId) in
                            Text(card.name).onTapGesture {
                                self.viewRouter.selectedCardId = card.name
                                self.viewRouter.currentPage = .cardDetail
                            }
                        }.navigationTitle("VIRTUAL CARDS")
                    }
                    
                    if self.digitalCardListViewModel.showProgress {
                        ProgressView()
                        Text("Loading Digital Cards").padding(20)
                    }
                    
                    Spacer()
                }.toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button("Close") {
                            viewRouter.currentPage = .cardDetail
                        }
                    }
                }
                
                if self.digitalCardListViewModel.isNotifcationVisible && self.digitalCardListViewModel.errorMessage != nil {
                    EmptyView().banner(message: self.$digitalCardListViewModel.errorMessage, show: self.$digitalCardListViewModel.isNotifcationVisible)
                }
            }.onAppear {
                if let selectedCardId = viewRouter.selectedCardId {
                    self.digitalCardListViewModel.retrieveDigitalCards(virtualCardId: selectedCardId)
                }
            }
        }
    }
}

struct DigitalCardListView_Previews: PreviewProvider {
    static var previews: some View {
        DigitalCardListView().environmentObject(ViewRouter())
    }
}
    
