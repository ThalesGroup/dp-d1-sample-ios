/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Login screen.
struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
            
    var body: some View {
        ZStack {
            VStack {
                Button("login") {
                    self.loginViewModel.login()
                }
                                   
                if self.loginViewModel.showProgress {
                    ProgressView()
                }
            }.onChange(of: self.loginViewModel.isLoginSuccess) { (isLoginSuccess: Bool) in
                if isLoginSuccess {
                    self.viewRouter.currentPage = .home
                }
            }
            
            if self.loginViewModel.isNotifcationVisible && self.loginViewModel.errorMessage != nil {
                EmptyView().banner(message: self.$loginViewModel.errorMessage, show: self.$loginViewModel.isNotifcationVisible)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ViewRouter())
    }
}
