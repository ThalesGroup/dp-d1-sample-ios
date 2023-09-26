/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import D1


/// Lambda helper method - logs event and runs completion on main thread.
/// - Parameters:
///   - event: Event block.
///   - completion: Completion block.
/// - Returns: Block, which logs the event and runs the completion block on the main thread.
internal func lambda(_ event: @escaping (Bool, D1.D1Error?) -> D1CoreEvent,
                     completion: @escaping (D1.D1Error?) -> Void) -> (D1.D1Error?) -> Void {
    CoreUtils.publishD1CoreEvent(eventListener: D1Core.shared().getEventListener(), event(true, nil))
    
    return { error in
        CoreUtils.publishD1CoreEvent(eventListener: D1Core.shared().getEventListener(), event(false, error))
        
        CoreUtils.runInMainThreadAsync {
            completion(error)
        }
    }
}

/// Generic lambda helper method - logs event and runs completion on main thread.
/// - Parameters:
///   - event: Event block.
///   - completion: Completion block.
/// - Returns: Block, which logs the event and runs the completion block on the main thread.
internal func lambda<T>(_ event: @escaping (Bool, D1.D1Error?) -> D1CoreEvent,
                        completion: @escaping (T?, D1.D1Error?) -> Void) -> (T?, D1.D1Error?) -> Void {
    CoreUtils.publishD1CoreEvent(eventListener: D1Core.shared().getEventListener(), event(true, nil))
    
    return { result, error in
        CoreUtils.publishD1CoreEvent(eventListener: D1Core.shared().getEventListener(), event(false, error))
        
        CoreUtils.runInMainThreadAsync {
            completion(result, error)
        }
    }
}
