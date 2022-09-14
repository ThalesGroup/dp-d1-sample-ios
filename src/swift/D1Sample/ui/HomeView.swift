/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Home screen.
struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Button("Physical Card List") {
                    self.viewRouter.currentPage = .physicalCardList
                }.padding(20)
                
                Button("Virtual Card List") {
                    self.viewRouter.currentPage = .cardList
                }.padding(20)
                
                Button("Logout") {
                    self.homeViewModel.logout()
                }.padding(20)
                
                if self.homeViewModel.showProgress {
                    ProgressView()
                }
                
                Spacer()
                Text(self.homeViewModel.appVersion)
                Text(self.homeViewModel.sdkVersions)
            }.onChange(of: self.homeViewModel.isLogoutSuccess) { (isLogoutSuccess: Bool) in
                if isLogoutSuccess {
                    self.viewRouter.currentPage = .login
                }
            }.onAppear {
                self.homeViewModel.getLibVersions()
                self.homeViewModel.getAppVersions()
            }
            
            if self.homeViewModel.isNotifcationVisible && self.homeViewModel.errorMessage != nil {
                EmptyView().banner(message: self.$homeViewModel.errorMessage, show: self.$homeViewModel.isNotifcationVisible)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(ViewRouter())
    }
}
