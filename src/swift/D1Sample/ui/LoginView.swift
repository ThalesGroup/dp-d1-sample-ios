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