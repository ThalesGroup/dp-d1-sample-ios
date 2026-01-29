/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI


/// Virtual card View.
struct VirtualCardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = VirtualCardViewModel()
    @State var isPresented = false
    @State private var selectedItem = 0
    
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
                                        
                    TabView(selection: $selectedItem) {
                        ForEach(viewModel.listOfCards) { loopCard in
                            VStack{
                                viewModel.getVirtualCardDetailView(loopCard.cardId)
                                    .padding([.leading, .trailing], 15.0)
                                Spacer()
                            }.tag(loopCard.tag).onAppear(){
                                viewModel.cardDigitizationState(viewModel.listOfCards[loopCard.tag].cardId)
                                viewModel.isClickToPayEnrolled(viewModel.listOfCards[loopCard.tag].cardId)
                                print("onAppear: \(loopCard.tag)")
                            }
                            
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.enrollClickToPay(viewModel.listOfCards[self.selectedItem].cardId)
                        } label: {
                            HStack(spacing: 8) {
                                Text("Click To Pay")
                                Image("click_to_pay")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .scaleEffect(2.0)
                            }
                        }.modifier(ButtonOval())
                            .disabled(viewModel.isClickToPayEnrolled)
                        .padding(.vertical, 6)
                        
                        Spacer()
                    }
                    
                    
                    if viewModel.pushAvailable {
                        HStack {
                            Spacer()

                            PKAddPassButtonWrap() {
                                self.isPresented = true
                            }.frame(width: 194, height: 40).disabled(viewModel.disableDigitizationButton).opacity(viewModel.disableDigitizationButton ? 0.2 : 1.0).sheet(isPresented: self.$isPresented) {
                                self.viewModel.digitizeCard(viewModel.listOfCards[self.selectedItem].cardId)
                            }
                                                        
                            Spacer()
                        }
                    }
                    
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
            }
        }
    }
}

struct VirtualCardView_Previews: PreviewProvider {
    static func testModel() -> VirtualCardViewModel {
        let retValue = VirtualCardViewModel()
        retValue.listOfCards = [TabItem(cardId: D1Configuration.CARD_ID, tag: 1),
                                TabItem(cardId: D1Configuration.CARD_ID, tag: 2),
                                TabItem(cardId: D1Configuration.CARD_ID, tag: 3)]
        
        return retValue
    }
    
    
    static var previews: some View {
        VirtualCardView(viewModel: testModel()).environmentObject(ViewRouter())
    }
}
