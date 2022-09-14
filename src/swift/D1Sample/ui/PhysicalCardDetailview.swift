/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI


/// Physical card detail screen.
struct PhysicalCardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var physicalCardDetailViewModel = PhysicalCardDetailViewModel()
    
    let secureTextField: D1SecureTextFieldWrap = D1SecureTextFieldWrap()
    let pinDisplayTextField: D1PINDisplayTextFieldWrap = D1PINDisplayTextFieldWrap()
    
    var body: some View {
        NavigationView {
        ZStack {
            VStack {
                VStack {
                    Divider().background(Color.gray)
                    HStack {
                        Text("Card Activation Method: ")
                        Text(self.physicalCardDetailViewModel.activationMethod)
                        Spacer()
                    }.padding(10)
                    
                    self.secureTextField
                    
                    Spacer()
                    
                    secureTextField.multilineTextAlignment(.center)
                    
                    if self.physicalCardDetailViewModel.showProgress {
                        ProgressView()
                    }
                    
                    if self.physicalCardDetailViewModel.isNotifcationVisible && self.physicalCardDetailViewModel.errorMessage != nil {
                        EmptyView().banner(message: self.$physicalCardDetailViewModel.errorMessage, show: self.$physicalCardDetailViewModel.isNotifcationVisible)
                    }
                                                            
                    Button("Activate Card") {
                        if let cardId = self.viewRouter.selectedCardId {
                            self.physicalCardDetailViewModel.activateCard(cardId: cardId, textField: self.secureTextField.textField)
                        }
                    }
                    
                    Spacer()
                }
                
                Divider().background(Color.gray)
                
                VStack {
                    Spacer()
                    
                    self.pinDisplayTextField
                    
                    Button("Display PIN") {
                        if let cardId = self.viewRouter.selectedCardId {
                            self.physicalCardDetailViewModel.getPin(cardId: cardId, textField: self.pinDisplayTextField.textField)
                        }
                    }
                    
                    Spacer()
                }
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Close") {
                        viewRouter.currentPage = .physicalCardList
                    }
                }
            }.navigationTitle(self.viewRouter.selectedCardId ?? "").onAppear {
                if let cardId = self.viewRouter.selectedCardId {
                    self.physicalCardDetailViewModel.getActivationMethod(cardId: cardId)
                }
            }
        }
    }
    }
}

struct PhysicalCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicalCardDetailView()
    }
}
