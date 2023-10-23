/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import PassKit


/// Virtual card detail.
struct VirtualCardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel: VirtualCardDetailViewModel
    
    init(_ cardId: String) {
        _viewModel = StateObject(wrappedValue: VirtualCardDetailViewModel(cardId))
    }
    

    var body: some View {
        ZStack {
            CardView(viewModel: self.viewModel)
            
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
            }.aspectRatio(CGSize(width: 85.60, height: 53.98), contentMode: .fit)
        }
    }
}

struct VirtualCardDetailView_Previews: PreviewProvider {

    static var previews: some View {
        VirtualCardDetailView(D1Configuration.CARD_ID).environmentObject(ViewRouter())
    }
}
