/*
 * Copyright © 2023 THALES. All rights reserved.
 */


import SwiftUI
import PassKit


/// SwiftUI wrapper for UIKit element - PKAddPassButton
struct PKAddPassButtonWrap: UIViewRepresentable {
    
    // MARK: - Defines
    
    private let action: () -> Void
    
    class Coordinator: NSObject {
        let parent: PKAddPassButtonWrap

        init(_ wrappButton: PKAddPassButtonWrap) {
            parent = wrappButton
            super.init()
        }

        @objc func doAction(_ sender: Any) {
            parent.action()
        }
    }
    
    // MARK: - Life Cycle
        
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    // MARK: - UIViewRepresentable
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // nothing to do
    }
    
    func makeUIView(context: Context) -> some PKAddPassButton {
        let retValue = PKAddPassButton(addPassButtonStyle: .black)
        retValue.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)

        return retValue
    }
    
}
