/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI


struct ButtonOval: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
                .bold()
                .tint(Color.init("ColorAccentBlue"))
                .padding([.leading, .trailing], 32)
                .padding([.top, .bottom], 20)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: 48)
                            .stroke(isEnabled ? Color.init("ColorAccentBlue") : Color.gray, lineWidth: 4)
                            .foregroundColor(.white)
                            .shadow(radius: 1, y: 1)
                        RoundedRectangle(cornerRadius: 48)
                            .fill(.white)
                    }
                )
                
        }
    }
}


struct ButtonOval_Previews: PreviewProvider {
    static var previews: some View {
        Button("Login") {
            
        }.modifier(ButtonOval())
    }
}
