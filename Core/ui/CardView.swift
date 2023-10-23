/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI


/// Card View used in VirtualCard and D1Push fetaure to display the card image and details.
struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
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
                                    Text(viewModel.formatPan(pan))
                                        .foregroundColor(viewModel.cardFontColor)
                                } else {
                                    Text(viewModel.displayCardId)
                                        .foregroundColor(viewModel.cardFontColor)
                                }
                                
                                HStack(alignment: .center) {
                                    Text("Valid\nThru")
                                        .font(.system(size: 7))
                                        .foregroundColor(viewModel.cardFontColor)
                                    Text("\(viewModel.valOrReucted(viewModel.cardExp))")
                                        .font(.system(size: 11))
                                        .foregroundColor(viewModel.cardFontColor)
                                    
                                    Spacer()
                                    
                                    if (viewModel.showCvv) {
                                        Text("CVV").font(.system(size: 7))
                                            .foregroundColor(viewModel.cardFontColor)
                                        Text("\(viewModel.valOrReucted(viewModel.cardCvv, 3))")
                                            .font(.system(size: 11))
                                            .foregroundColor(viewModel.cardFontColor)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text(viewModel.cardState)
                                    .font(.system(size: 11))
                                    .foregroundColor(viewModel.cardFontColor)
                            }
                        }
                        .padding([.leading, .trailing], 66.0)
                        .padding([.bottom, .top], 50.0)
                        .redacted(reason: viewModel.loadingValues ? .placeholder : [])
                        
                    }
                    .background(viewModel.cardBackground?.resizable().scaledToFit())
                    .cornerRadius(24.0)
                }
                .aspectRatio(CGSize(width: 85.60, height: 53.98), contentMode: .fit)
                
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: CardViewModel(D1Configuration.CARD_ID))
    }
}
