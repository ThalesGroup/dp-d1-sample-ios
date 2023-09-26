/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

@main
struct TemplatesApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    init() {
        // D1Core basic config mandatory to initialize the SDK.
        D1Configuration.loadConfigurationFromPlist()
    }

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(viewRouter)
        }
    }
}
