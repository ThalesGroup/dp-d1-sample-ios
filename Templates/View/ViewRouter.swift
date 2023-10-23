/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

/// Screens available in application.
enum Screen {
    case login
    case home
    case virtualCard
    case digitalCard
}

/// Class to hold and notify the state about the current screen shown and to share data between screens.
class ViewRouter: ObservableObject {
    @Published var currentPage: Screen = .login
    @Published var loginExpired: String?
    
    var selectedCardId: String?
}
