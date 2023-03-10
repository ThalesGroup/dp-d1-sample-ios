/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import SwiftUI

@main
struct D1SampleApp: App {
        
    @StateObject var viewRouter = ViewRouter()
    
    init() {
        Configuration.loadConfigurationFromPlist()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(viewRouter)
        }
    }
}
