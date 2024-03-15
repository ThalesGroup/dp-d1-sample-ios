/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1

private func d1Task() -> D1Task {
    return D1Core.shared().getD1Task()
}


/// D1VirtualCardApi implementation.
class D1VirtualCard {
    
    // MARK: - Defines
    
    static private let sharedInstance = D1VirtualCard()
        
    /// Retrieves the singleton instance of D1VirtualCard.
    /// - Returns: Singleton instance of D1VirtualCard.
    public class func shared() -> D1VirtualCardApi {
        return sharedInstance
    }
    
    // MARK: - Life cycle
    
    private init() {
        // private constructor.
    }
        
}

// MARK: - D1VirtualCardApi

extension D1VirtualCard: D1VirtualCardApi {
    
    func getCardDetails(_ cardId: String,
                        completion: @escaping (D1.CardDetails?, D1.D1Error?) -> Void) {
        d1Task().cardDetails(cardId, completion: lambda(VCEventCardDetails, completion: completion))
    }

    func getVirtualCardDetailView(_ cardId: String) -> VirtualCardDetailView {
        return VirtualCardDetailView(cardId)
    }
    
    func createModuleConnector() -> D1ModuleConnector {
        return D1VirtualCardModuleConnector()
    }
}

// MARK: - D1ModuleConnector


/// D1VirtualCard related D1ModuleConnector.
private class D1VirtualCardModuleConnector: D1ModuleConnector {
    func getConfiguration() -> [D1.ConfigParams] {
        // There is no extra configuration needed for this module.
        return []
    }
    
    func getModuleId() -> Module {
        .virtualCard
    }
}
