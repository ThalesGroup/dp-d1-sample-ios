/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import PassKit

struct VirtualCardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel: VirtualCardDetailViewModel
    
    init(_ cardId: String?) {
        _viewModel = StateObject(wrappedValue: VirtualCardDetailViewModel(cardId))
    }
    
    private func formatPan(_ value: String) -> String {
        return String(value.enumerated().map { $0 > 0 && $0 % 4 == 0 ? [" ", $1] : [$1]}.joined())
    }
    
    private func valOrReucted(_ value: String?, _ reductedLength: Int = 4) -> String {
        if let value = value, !viewModel.loadingValues {
            return value
        } else {
            return String((0..<reductedLength).map{ _ in "*" })
        }
    }
    
    var body: some View {
        ZStack {
            // Card section + action buttons:
            VStack {
                
                // Card section:
                ZStack {
                    
                    if viewModel.loadingValues {
                        ProgressView().scaleEffect(1.5)
                    }
                    
                    
                    // Card Details like pan etc..
                    ZStack() {
                        ZStack{
                            VStack(alignment:.leading, spacing: 8) {
                                Spacer()
                                
                                if viewModel.showFullPan, let pan = viewModel.cardPan {
                                    Text(formatPan(pan))
                                        .foregroundColor(viewModel.cardFontColor)
                                } else {
                                    Text("**** **** **** \(valOrReucted(viewModel.cardLast4Pan))")
                                        .foregroundColor(viewModel.cardFontColor)
                                }
                                
                                HStack(alignment: .center) {
                                    Text("Valid\nThru")
                                        .font(.system(size: 7))
                                        .foregroundColor(viewModel.cardFontColor)
                                    Text("\(valOrReucted(viewModel.cardExp))")
                                        .font(.system(size: 11))
                                        .foregroundColor(viewModel.cardFontColor)
                                    
                                    Spacer()
                                    
                                    Text("CVV").font(.system(size: 7))
                                        .foregroundColor(viewModel.cardFontColor)
                                    Text("\(valOrReucted(viewModel.cardCvv, 3))")
                                        .font(.system(size: 11))
                                        .foregroundColor(viewModel.cardFontColor)
                                    Spacer()
                                }
                            }
                        }
                        .padding([.leading, .trailing], 66.0)
                        .padding([.bottom, .top], 50.0)
                        .redacted(reason: viewModel.loadingValues ? .placeholder : [])
                        
                    }
                    .background(viewModel.cardBackground?.resizable().scaledToFit())
                    .cornerRadius(24.0)
                    
                    // Top right eye buttons.
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                viewModel.toggleCardDetails()
                            } label: {
                                ZStack{
                                    Circle()
                                        .fill(Color(hue: 1.0, saturation: 0.024, brightness: 0.889))
                                        .frame(width: 40, height: 40)
                                    if !viewModel.showFullPan {
                                        Image(systemName: "eye.fill").font(.system(size: 20))
                                    } else {
                                        Image(systemName: "eye.slash.fill").font(.system(size: 20))
                                    }
                                }
                            }.tint(.black)
                            
                            
                            Spacer()
                        }
                    }
                    .padding(.top, -10)
                }
                .aspectRatio(CGSize(width: 85.60, height: 53.98), contentMode: .fit)
                
                // Buttons section:
                if viewModel.pushAvailable {
                    HStack {
                        PKAddPassButtonWrap() {
                            
                        }.frame(width: 194, height: 40)
                    }
                }
                
                // Add common elements for toast and progressbar
                notificationViewModifier(data: $viewModel.bannerData, show: $viewModel.bannerShow)
                progressViewModifier(data: $viewModel.progressData, show: $viewModel.progressShow)
            }
            .padding(.top, 10)
        }
        .onAppear() {
            viewModel.loadCardMetadata()
        }
        .onChange(of: viewModel.openLoginPage) { newValue in
            if newValue {
                viewRouter.loginExpired = viewModel.openLoginError
                viewRouter.currentPage = .login
            }
        }
    }
}

struct VirtualCardDetailView_Previews: PreviewProvider {

    static var previews: some View {
        VirtualCardDetailView(nil).environmentObject(ViewRouter())
    }
}
