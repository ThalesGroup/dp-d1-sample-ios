/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1


/// Configuration objects for individual features.
protocol D1ModuleConnector {
    /// Returns the configuration for the Core module.
    /// - Returns: Configuration for the given module. It can be null.
    func getConfiguration() -> [D1.ConfigParams]
    
    /// Returns module identification.
    /// - Returns: Bitmask value of specific module.
    func getModuleId() -> Module
}
