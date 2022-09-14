/*
 * Copyright © 2022 THALES. All rights reserved.
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

