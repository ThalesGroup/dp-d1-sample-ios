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
    
