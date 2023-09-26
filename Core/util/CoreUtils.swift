/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation


/// Core utility class.
public class CoreUtils {
    
    
    /// Posts event on main ui thread.
    /// - Parameters:
    ///   - eventListener: Event listener.
    ///   - event: Event to post.
    class func publishD1CoreEvent(eventListener: D1CoreEventListener?, _ event: D1CoreEvent) {
        // Notify listener if it was specified by the app.
        if let eventListener = eventListener {
            runInMainThreadAsync {
                eventListener.onD1CoreEvent(event)
            }
        }
    }
    
    
    /// Runs closure on main ui thread.
    /// - Parameter runnable: Closure to run.
    class func runInMainThreadAsync(_ runnable: @escaping () -> (Void)) {
        DispatchQueue.main.async {
            runnable()
        }
    }
}
