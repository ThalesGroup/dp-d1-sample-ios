/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation
import D1


/// D1 Core functionality.
protocol D1CoreApi {
    
    /// Configures D1 SDK.
    /// - Parameters:
    ///   - eventListener: Optional even listener for every wrapper operation and result. It's not intended for user interaction, but some logging or analytic tool.
    ///   - modules: List of modules we want to support.
    func configure(eventListener: D1CoreEventListener?,
                   completion: @escaping ([D1.D1Error]?) -> Void,
                   modules: D1ModuleConnector...)
    
    /// Logs in to D1 to enable all subsequesnt operations..
    /// - Parameters:
    ///   - issuerToken:  Issuer token.
    ///   - listener: Listener
    func login(issuerToken: inout Data, completion: @escaping (D1.D1Error?) -> Void)

    /// Logs out from D1.
    /// - Parameter completion: Callback
    func logout(completion: @escaping (D1.D1Error?) -> Void)
    
    /// Get Card meta data.
    /// - Parameters:
    ///   - cardId: Card ID.
    ///   - completion: Listener.
    func getCardMetadata(_ cardId: String,
                         completion: @escaping (D1.CardMetadata?, D1.D1Error?) -> Void)
    
    /// Checks if given module is enabled
    /// - Parameter module: Module that we want to check.
    /// - Returns: Boolean
    func isModuleEnabled(_ module: Module) -> Bool
    
    /// Gets D1 SDK Init state
    /// - Returns: D1InitState
    func sdkInitState() -> D1InitState

    /// Returns all SDK part vertsions.
    /// - Returns: SDK versions.
    func libVersion() -> String
    
    /// Returns application versions.
    /// - Returns: Return app version in format version + build
    func appVersion() -> String
    
    
    /// Returns the D1Task.
    /// - Returns: D1Task or runtime exception if D1 SDK is not configured.
    func getD1Task() -> D1Task
        
    
    /// Returns the event listener
    /// - Returns: D1CoreEventListener
    func getEventListener() -> D1CoreEventListener?
    
    /// Creates the Core related D1ModuleConnector.
    /// - Returns: Core related D1ModuleConnector.
    func createModuleConnector(_ consumerID: String) -> D1ModuleConnector;
}
