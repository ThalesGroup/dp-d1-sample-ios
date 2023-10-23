/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

/// Home screen.
struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("D1Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125.0, height: 125.0)
                Button("Virtual Card") {
                    viewRouter.currentPage = .virtualCard
                }.modifier(ButtonOvalBlue())
                Button("Digital Card") {
                    viewRouter.currentPage = .digitalCard
                }.modifier(ButtonOvalBlue())
                Spacer()
                Button("Logout") {
                    viewModel.logout()
                }.modifier(ButtonOvalRed()).padding(10)
            }
            
            // Add common elements for toast and progressbar
            notificationViewModifier(data: $viewModel.bannerData, show: $viewModel.bannerShow)
            progressViewModifier(data: $viewModel.progressData, show: $viewModel.progressShow)
        }
        .onChange(of: viewModel.openLoginPage) { newValue in
            if newValue {
                viewRouter.currentPage = .login
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(ViewRouter())
    }
}
