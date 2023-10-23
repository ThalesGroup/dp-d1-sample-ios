/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import UIKit
import D1

/// UIViewController used for D1Push.
public class D1PushViewController: UIViewController {
    public var delegate: D1PushViewControllerDelegate?
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var cardId: String = ""
    
    public static func createViewController() -> D1PushViewController {
        return D1PushViewController(nibName: "D1PushViewController", bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.provisionD1Push()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func provisionD1Push() {
        self.activityIndicator.startAnimating()
        
        D1Push.shared().digitizeToDigitalPayCard(self.cardId, viewController: self) { (error: D1Error?) in
            if let delegate = self.delegate {
                delegate.onCardDigitizationFinished(error: error, viewController: self)
            }
        }
    }
}

public protocol D1PushViewControllerDelegate {
    func onCardDigitizationFinished(error: D1Error?, viewController: D1PushViewController)
}
