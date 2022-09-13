/*
 MIT License
 
 Copyright (c) 2021 Thales DIS
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
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
