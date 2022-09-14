/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Root view of the application.
struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        switch self.viewRouter.currentPage {
        case .splash:
            SplashView()
        case .login:
            LoginView()
        case .cardDetail:
            CardDetailView()
        case .cardList:
            VirtualCardListView()
        case .digitalCardList:
            DigitalCardListView()
        case .home:
            HomeView()
        case .physicalCardList:
            PhysicalCardListView()
        case .physicalCardDetail:
            PhysicalCardDetailView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(ViewRouter())
    }
}
