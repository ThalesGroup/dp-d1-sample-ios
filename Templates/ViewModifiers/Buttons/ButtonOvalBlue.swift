/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI


struct ButtonOvalBlue: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
                .bold()
                .tint(.white)
                .padding([.leading, .trailing], 32)
                .padding([.top, .bottom], 20)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: 48)
                            .stroke(isEnabled ? Color.init("ColorAccentBlue") : Color.gray, lineWidth: 4)
                            .foregroundColor(.white)
                            .shadow(radius: 1, y: 1)
                        RoundedRectangle(cornerRadius: 48)
                            .fill(Color.init("ColorAccentBlue"))
                    }
                )
                
        }
    }
}


struct ButtonOvalBlue_Previews: PreviewProvider {
    static var previews: some View {
        Button("Virtual Card") {
            
        }.modifier(ButtonOvalBlue()).disabled(false)
    }
}
