/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import D1


/// SwiftUI wrapper for UIKit element - D1PINDisplayTextField
struct D1PINDisplayTextFieldWrap: UIViewRepresentable {
    let textField: D1PINDisplayTextField = D1PINDisplayTextField()
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // nothing to do
    }
    
    func makeUIView(context: Context) -> some D1PINDisplayTextField {
        return self.textField
    }
    
}
