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
