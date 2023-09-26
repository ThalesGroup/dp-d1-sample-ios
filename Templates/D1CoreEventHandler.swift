/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation

class D1CoreEventHandler: D1CoreEventListener {
    
    // MARK: - Defines
    
    static private let sharedInstance = D1CoreEventHandler()
    
    public class func shared() -> D1CoreEventListener {
        return sharedInstance
    }
    
    // MARK: - D1CoreEventListener
    
    func onD1CoreEvent(_ event: D1CoreEvent) {
        print(event)
        // TODO: Better logging tool or crashlitics.
    }
}
