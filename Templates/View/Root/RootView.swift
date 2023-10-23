/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

/// Root view of the application.
struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        switch viewRouter.currentPage {
        case .login:
            LoginView()
        case .home:
            HomeView()
        case .virtualCard:
            VirtualCardView()
        case .digitalCard:
            DigitalCardView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(ViewRouter())
    }
}
