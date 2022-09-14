/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

/// Screens available in application.
enum Screen {
    case splash
    case login
    case cardList
    case cardDetail
    case digitalCardList
    case home
    case physicalCardList
    case physicalCardDetail
}

/// Class to hold and notify the state about the current screen shown and to share data between screens.
class ViewRouter: ObservableObject {
    @Published var currentPage: Screen = .splash
    var selectedCardId: String?
}
