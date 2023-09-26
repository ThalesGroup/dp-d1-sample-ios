/*
 * Copyright © 2023 THALES. All rights reserved.
 */


import Foundation

enum D1CoreEventType {
    case Info
    case Warning
    case Error
}

struct D1CoreEvent {
    let eventCode: Int          // Each module does have own Constants class with list of supported codes.
    let message: String         // Informative message in english. It's not intended for end users, only for logs / analytics.
    let type: D1CoreEventType   // Basic event type like info / error to distinguish between expected and unexpected actions.
}


/// Generic protocol that can be used for handling all SDK actions on one place.
protocol D1CoreEventListener: AnyObject {
    func onD1CoreEvent(_ event: D1CoreEvent)
}
