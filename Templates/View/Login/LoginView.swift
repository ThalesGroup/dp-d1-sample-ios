/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

/// Login View.
struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = LoginViewModel()
        
    var body: some View {
        ZStack {
            VStack {
                Image("D1Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125.0, height: 125.0)
                Button("Login") {
                    viewModel.login()
                }.modifier(ButtonOval())
                .disabled(!viewModel.isInitializationSuccess)
            }
            
            // Add common elements for toast and progressbar
            notificationViewModifier(data: $viewModel.bannerData, show: $viewModel.bannerShow)
            progressViewModifier(data: $viewModel.progressData, show: $viewModel.progressShow)
        }
        .onChange(of: viewModel.isLoginSucces) { newValue in
            viewRouter.currentPage = .home
        }
        .onAppear() {
            if let error = viewRouter.loginExpired {
                viewRouter.loginExpired = nil
                viewModel.bannerShow(caption: "Login Expired", description: error, type: .error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {

    static var previews: some View {
        LoginView(viewModel: LoginViewModel()).environmentObject(ViewRouter())
    }
}
