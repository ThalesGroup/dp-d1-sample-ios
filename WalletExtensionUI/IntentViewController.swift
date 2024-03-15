/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import UIKit
import PassKit
import D1


/// ViewController to authenticate user for D1Push card provisioning using Apple Wallet Extension.
class IntentViewController: UIViewController, D1IssuerProvisioningExtensionAuthorizationProviding {
    var completionHandler: ((PKIssuerProvisioningExtensionAuthorizationResult) -> Void)?
    private let authButton = UIButton(type: .system)
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* configure UI layout */
        
        self.authButton.setTitle("Authenticate", for: .normal)
        self.authButton.addTarget(self, action: #selector(authButtonTouched), for: .touchUpInside)
        self.authButton.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraintAuthButton = NSLayoutConstraint(item: self.authButton,
                                                                attribute: NSLayoutConstraint.Attribute.centerX,
                                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                                toItem: self.view,
                                                                attribute: NSLayoutConstraint.Attribute.centerX,
                                                                multiplier: 1,
                                                                constant: 0)
        let verticalConstraintAuthButton = NSLayoutConstraint(item: self.authButton,
                                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                                              toItem: self.view,
                                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                                              multiplier: 1,
                                                              constant: 0)
        
        self.view.addSubview(self.authButton)
        self.view.addConstraints([horizontalConstraintAuthButton, verticalConstraintAuthButton])
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.imageView.image = UIImage(named: "D1Icon")
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraintImageView = NSLayoutConstraint(item: self.imageView,
                                                               attribute: NSLayoutConstraint.Attribute.centerX,
                                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                                               toItem: self.view,
                                                               attribute: NSLayoutConstraint.Attribute.centerX,
                                                               multiplier: 1,
                                                               constant: 0)
        let verticalConstraintImageView = NSLayoutConstraint(item: self.imageView,
                                                             attribute: NSLayoutConstraint.Attribute.top,
                                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                                             toItem: self.view,
                                                             attribute: NSLayoutConstraint.Attribute.top,
                                                             multiplier: 1,
                                                             constant: 100)
        
        let verticalConstraintImageViewHeight = NSLayoutConstraint(item: self.imageView,
                                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                                   toItem: nil,
                                                                   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                   multiplier: 1,
                                                                   constant: 125)
        
        let verticalConstraintImageViewWidth = NSLayoutConstraint(item: self.imageView,
                                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                                  toItem: nil,
                                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                  multiplier: 1,
                                                                  constant: 125)
        
        self.view.addSubview(self.imageView)
        self.view.addConstraints([horizontalConstraintImageView,
                                  verticalConstraintImageView,
                                  verticalConstraintImageViewHeight,
                                  verticalConstraintImageViewWidth])
    }

    @objc func authButtonTouched() {
        // optionally, load authentication related data from keychain. e.g. consumerID

        let consumerId = loadFromKeychain(key: "D1ConsumerID")
        
        // Provide both manual and biometric login methods based on Apple functional requirements
        // ...
        
        var request = URLRequest(url: URL(string: D1Configuration.SANDBOX_JWT_URL + consumerId!)!)
        request.setBasicAuth(username: D1Configuration.SANDBOX_JWT_USER,
                             password: D1Configuration.SANDBOX_JWT_PASSWORD)
        
        self.activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if var issuerToken = data {
                login(&issuerToken) { [weak self] error in
                    self?.activityIndicator.stopAnimating()
                    
                    if (error != nil) {
                        self?.completionHandler?(.canceled)
                    } else {
                        self?.completionHandler?(.authorized)
                    }
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.completionHandler?(.canceled)
            }
        }.resume()
    }
    
    // MARK: - private
    
    
    /// Loads the value from keychain.
    /// - Parameter key: Key.
    /// - Returns: Value or nil if not in keychain.
    private func loadFromKeychain(key: String) -> String? {
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "IssuerAppService",
            kSecAttrAccessGroup as String: "group.com.thalesgroup.d1.Templates",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true]
        var item: AnyObject?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        if status == errSecSuccess,
            let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
