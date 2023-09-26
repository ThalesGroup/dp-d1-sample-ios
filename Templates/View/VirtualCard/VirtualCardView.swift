/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI

struct VirtualCardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = VirtualCardViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("Good Afternoon")
                        .font(.system(size: 33))
                        .padding([.leading, .trailing], 30.0)
                    
                    Text("Your virtual card")
                        .font(.system(size: 17))
                        .padding([.leading, .trailing], 30.0)
                    
                    TabView {
                        ForEach(viewModel.listOfCards) { loopCard in
                            VStack{
                                viewModel.getVirtualCardDetailView(loopCard.cardId)
                                    .padding([.leading, .trailing], 15.0)
                                Spacer()
                            }.tag(loopCard.tag).onAppear(){
                                // TODO - retrieve state for individual card.
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
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
            }
        }
    }
}

struct VirtualCardView_Previews: PreviewProvider {
    static func testModel() -> VirtualCardViewModel {
        let retValue = VirtualCardViewModel()
        retValue.listOfCards = [TabItem(cardId: nil, tag: 1),
                                TabItem(cardId: nil, tag: 2),
                                TabItem(cardId: nil, tag: 3)]
        
        return retValue
    }
    
    
    static var previews: some View {
        VirtualCardView(viewModel: testModel()).environmentObject(ViewRouter())
    }
}
