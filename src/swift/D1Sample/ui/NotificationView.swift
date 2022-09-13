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


/// Notification View.
struct NotificationView: ViewModifier {
        
    @Binding var message:String?
    @Binding var show:Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(message ?? "")
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default)).padding(12)
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .padding(12)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .animation(.linear, value: 0)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
            }
        }
    }
}

/**
 * Notification extension.
 */
extension View {
    
    /**
     * Shows the notification view.
     *
     * @param accessToken Issuer token.
     * @param callback    Callback.
     */
    func banner(message: Binding<String?>, show: Binding<Bool>) -> some View {
        self.modifier(NotificationView(message: message, show: show))
    }
}

struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
        }.banner(message: .constant("message"), show: .constant(true))
    }
}

