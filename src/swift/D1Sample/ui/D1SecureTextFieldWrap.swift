/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import D1


/// SwiftUI wrapper for UIKit element - D1SecureTextField
struct D1SecureTextFieldWrap: UIViewRepresentable {
    let textField: D1SecureTextField = D1SecureTextField()
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // nothing to do
    }
    
    func makeUIView(context: Context) -> some D1SecureTextField {
        return self.textField
    }
    
}
