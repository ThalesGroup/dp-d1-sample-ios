/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import PassKit


/// Digital card detail View.
struct DigitalCardDetailView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel: DigitalCardDetailViewModel
    
    init(_ cardId: String, _ digitalCardId: String, _ deleteCallback: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: DigitalCardDetailViewModel(cardId, digitalCardId, deleteCallback))
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
            CardView(viewModel: viewModel)
            // Top right eye buttons.
            if (viewModel.digitalCard != nil) {
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            
                        } label: {
                            ZStack{
                                Circle()
                                    .fill(Color(hue: 1.0, saturation: 0.024, brightness: 0.889))
                                    .frame(width: 40, height: 40)
                                Text("...")
                            }
                        }.contextMenu {
                            if (viewModel.digitalCard?.state == .inactive) {
                                Button("Resume") {
                                    viewModel.resumeDigitalCard()
                                }
                            }
                            
                            if (viewModel.digitalCard?.state == .active) {
                                Button("Suspend") {
                                    viewModel.suspendDigitalCard()
                                }
                            }
                            
                            Button("Delete") {
                                viewModel.deleteDigitalCard()
                            }
                            
                            Button("Activate") {
                                viewModel.activateCard()
                            }
                        }
                        
                        Spacer()
                    }.aspectRatio(CGSize(width: 85.60, height: 53.98), contentMode: .fit)
                }
            }
        }.onAppear() {
            viewModel.getDigitalCard()
        }
    }
}

struct DigitalCardDetailViewPreviews: PreviewProvider {

    static var previews: some View {
        DigitalCardDetailView("", "") {}.environmentObject(ViewRouter())
    }
}
