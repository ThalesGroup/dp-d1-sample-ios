/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI


/// Digital card View.
struct DigitalCardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = DigitalCardViewModel()
    @State var isPresented = false
    @State private var selectedItem = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("Good Afternoon")
                        .font(.system(size: 33))
                        .padding([.leading, .trailing], 30.0)
                    
                    if (viewModel.noDigitalCard) {
                        Text("No digital card")
                            .font(.system(size: 17))
                            .padding([.leading, .trailing], 30.0)
                    } else {
                        Text("Your digital card")
                            .font(.system(size: 17))
                            .padding([.leading, .trailing], 30.0)
                    }
                                        
                    TabView(selection: $selectedItem) {
                        ForEach(viewModel.digitalCardList) { loopCard in
                            VStack{
                                viewModel.getDigitalCardDetailView(D1Configuration.CARD_ID, loopCard.cardId) {
                                    // reload card list on card delted
                                    viewModel.getDigitalCardList(D1Configuration.CARD_ID)
                                }.padding([.leading, .trailing], 15.0)
                                Spacer()
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    Spacer()
                    
                }
                .padding([.top, .bottom], 24.0)
                
                // Add common elements for toast and progressbar
                notificationViewModifier(data: $viewModel.bannerData, show: $viewModel.bannerShow)
                progressViewModifier(data: $viewModel.progressData, show: $viewModel.progressShow)
            }
            .onChange(of: viewModel.openLoginPage) { newValue in
                if newValue {
                    viewRouter.currentPage = .login
                }
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Back") {
                        viewRouter.currentPage = .home
                    }
                }
            }.onAppear() {
                viewModel.getDigitalCardList(D1Configuration.CARD_ID)
            }
        }
    }
}

struct DigitalCardView_Previews: PreviewProvider {
    static func testModel() -> DigitalCardViewModel {
        let retValue = DigitalCardViewModel()
        retValue.listOfCards = [TabItem(cardId: D1Configuration.CARD_ID, tag: 1),
                                TabItem(cardId: D1Configuration.CARD_ID, tag: 2),
                                TabItem(cardId: D1Configuration.CARD_ID, tag: 3)]
        
        return retValue
    }
    
    
    static var previews: some View {
        DigitalCardView(viewModel: testModel()).environmentObject(ViewRouter())
    }
}
