/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import SwiftUI
import D1


/// SwiftUI wrap for D1PushViewController.
struct D1PushView: UIViewControllerRepresentable {
    public let d1PushViewController: D1PushViewController = D1PushViewController.createViewController()
    var viewModel: VirtualCardViewModel
    var cardId: String
    
    func makeUIViewController(context: Context) -> D1PushViewController {
        self.d1PushViewController.delegate = context.coordinator
        self.d1PushViewController.cardId = context.coordinator.parent.cardId
        return self.d1PushViewController
    }
    
    func updateUIViewController(_ uiViewController: D1PushViewController, context: Context) {
        // nothing to do
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    typealias UIViewControllerType = D1PushViewController
    
    
    public class Coordinator: D1PushViewControllerDelegate {
    
        let parent: D1PushView
        
        init(parent: D1PushView) {
            self.parent = parent
        }
        
        func onCardDigitizationFinished(error: D1Error?, viewController: D1PushViewController) {
            if let error = error {
                self.parent.viewModel.bannerShow(caption: "Error during cardDigitization.", description: error.localizedDescription, type: .error)
            }
             
            parent.viewModel.cardDigitizationState(parent.cardId)
            
            viewController.dismiss(animated: true)
        }
    }
}
