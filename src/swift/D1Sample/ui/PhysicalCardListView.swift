/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Physical card list screen.
struct PhysicalCardListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var physicallCardListViewModel = PhysicalCardListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    if self.physicallCardListViewModel.cardIds.count != 0 {
                        List(self.physicallCardListViewModel.cardIds) { (card: CardId) in
                            Text(card.name).onTapGesture {
                                self.viewRouter.selectedCardId = card.name
                                self.viewRouter.currentPage = .physicalCardDetail
                            }
                        }.navigationTitle("PHYSICAL CARDS")
                    }
                    
                    if self.physicallCardListViewModel.showProgress {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                
                if self.physicallCardListViewModel.isNotifcationVisible && self.physicallCardListViewModel.errorMessage != nil {
                    EmptyView().banner(message: self.$physicallCardListViewModel.errorMessage, show: self.$physicallCardListViewModel.isNotifcationVisible)
                }
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Close") {
                        viewRouter.currentPage = .home
                    }
                }
            }.onAppear {
                self.physicallCardListViewModel.retrieveCardIds()
            }
        }
    }
}

struct PhysicalCardListView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicalCardListView().environmentObject(ViewRouter())
    }
}
    
