/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1


/// D1 Virtual Card related API.
protocol D1VirtualCardApi {

    /// Gets Card details.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - completion: Listener.
    func getCardDetails(_ cardId: String,
                        completion: @escaping (D1.CardDetails?, D1.D1Error?) -> Void)

    
    /// Get Virtual card detail View.
    /// - Parameter cardId: Card ID.
    /// - Returns: VirtualCardDetailView
    func getVirtualCardDetailView(_ cardId: String) -> VirtualCardDetailView
    
    
    /// Creates the VirtualCard related D1ModuleConnector.
    /// - Returns: VirtualCard related D1ModuleConnector.
    func createModuleConnector() -> D1ModuleConnector;
}
