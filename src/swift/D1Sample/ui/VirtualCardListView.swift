/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI


/// Virtual card list screen.
struct VirtualCardListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var virtualCardListViewModel = VirtualCardListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    if self.virtualCardListViewModel.cardIds.count != 0 {
                        List(self.virtualCardListViewModel.cardIds) { (card: CardId) in
                            Text(card.name).onTapGesture {
                                self.viewRouter.selectedCardId = card.name
                                self.viewRouter.currentPage = .cardDetail
                            }
                        }.navigationTitle("VIRTUAL CARDS")
                    }
                    
                    if self.virtualCardListViewModel.showProgress {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                
                if self.virtualCardListViewModel.isNotifcationVisible && self.virtualCardListViewModel.errorMessage != nil {
                    EmptyView().banner(message: self.$virtualCardListViewModel.errorMessage, show: self.$virtualCardListViewModel.isNotifcationVisible)
                }
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Close") {
                        viewRouter.currentPage = .home
                    }
                }
            }.onAppear {
                self.virtualCardListViewModel.retrieveCardIds()
            }
        }
    }
}

struct VirtualCardListView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualCardListView().environmentObject(ViewRouter())
    }
}
    
