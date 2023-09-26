/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

let CoreEventConfigAlreadyFinished  = D1CoreEvent(eventCode: 10001, message: "D1 Core is already configured.", type: .Warning)
let CoreEventConfigOngoing          = D1CoreEvent(eventCode: 10002, message: "D1 Core config is already in progress.", type: .Warning)


/// Creates a new Configuration D1CoreEvent - CoreEventConfig.
/// - Parameters:
///   - trigger: True if event triggered, else false.
///   - errors: Error.
/// - Returns: CoreEventConfig
func CoreEventConfig(_ trigger: Bool, errors: [D1.D1Error]? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 10000, message: "D1 Core configuration triggered.", type: .Info)
    } else if let errors = errors {
        return D1CoreEvent(eventCode: 10003, message: "D1 Core config failed with error: \(errors)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 10004, message: "D1 Core configuration was successful.", type: .Info)
    }
}


/// Creates a new Login D1CoreEvent - CoreEventLogin.
/// - Parameters:
///   - trigger: True if event triggered, else false.
///   - errors: Error.
/// - Returns: CoreEventLogin
func CoreEventLogin(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 10010, message: "Login triggered.", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 10011, message: "Login failed with error: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 10012, message: "Login was successful.", type: .Info)
    }
}


/// Creates a new Core D1CoreEvent - CoreEventLogout.
/// - Parameters:
///   - trigger: True if event triggered, else false.
///   - errors: Error.
/// - Returns: CoreEventLogout
func CoreEventLogout(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 10020, message: "Logout triggered.", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 10021, message: "Logout failed with error: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 10022, message: "Logout was successful.", type: .Info)
    }
}

struct Module: OptionSet {

    let rawValue: Int
    
//    static let d1Pay        = Module(rawValue: 1 << 0)
    static let d1Push       = Module(rawValue: 1 << 1)
    static let virtualCard  = Module(rawValue: 1 << 2)
    static let core  = Module(rawValue: 1 << 3)
}
