/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Splash View.
struct SplashView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var splashViewModel: SplashViewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                if self.splashViewModel.showProgress{
                    ProgressView()
                    Text("Initializing").padding(20)
                }
            }.onAppear {
                self.splashViewModel.configure(consumerId: Configuration.CONSUMER_ID)
            }.onChange(of: self.splashViewModel.isInitializationSuccess) { (isInitializationSuccess: Bool) in
                if (isInitializationSuccess) {
                    self.viewRouter.currentPage = .login
                }
            }
            
            if self.splashViewModel.isNotifcationVisible && self.splashViewModel.errorMessage != nil {
                EmptyView().banner(message: self.$splashViewModel.errorMessage, show: self.$splashViewModel.isNotifcationVisible)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView().environmentObject(ViewRouter())
    }
}
