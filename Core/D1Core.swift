/*
 * Copyright © 2023 THALES. All rights reserved.
 */


import Foundation
import D1


/// Main D1Core entry point - D1CoreApi implementation.
class D1Core {
    
    // MARK: - Defines
    
    static private let sharedInstance = D1Core()
    
    private weak var evenListener: D1CoreEventListener?
    private var initState = D1InitState.NotInitialized
    private var d1Task: D1Task?
    private var enabledModules: [Module] = []

    
    public class func shared() -> D1CoreApi {
        return sharedInstance
    }
    
    // MARK: - Life cycle
    
    private init() {
        
    }
}

// MARK: - D1CoreApi
extension D1Core: D1CoreApi {
    
    func configure(eventListener: D1CoreEventListener?,
                   completion: @escaping ([D1.D1Error]?) -> Void,
                   modules: D1ModuleConnector...) {
        
        // First update the listener, because it's used by the report method.
        self.evenListener = eventListener
        
        CoreUtils.publishD1CoreEvent(eventListener: self.evenListener, CoreEventConfig(true, errors: nil))
        
        // Configure should be triggered only once. Check the state before continue.
        if initState == .Initialized {
            CoreUtils.publishD1CoreEvent(eventListener: self.evenListener, CoreEventConfigAlreadyFinished)
            return;
        } else if initState == .OngoingInit {
            CoreUtils.publishD1CoreEvent(eventListener: self.evenListener, CoreEventConfigOngoing)
            return;
        }
        
        // Save the state in order to prevent multiple calls.
        initState = .OngoingInit

        var components = D1Task.Components()
        components.d1ServiceURLString = D1Configuration.D1_SERVICE_URL
        components.issuerID = D1Configuration.ISSUER_ID
        components.d1ServiceRSAExponent = D1Configuration.D1_SERVICE_RSA_EXPONENT
        components.d1ServiceRSAModulus = D1Configuration.D1_SERVICE_MODULUS
        components.digitalCardURLString = D1Configuration.DIGITAL_CARD_URL
        d1Task = components.task()
        
        // Prepare list of configurations provided by the application and
        // configure core module.
        var moduleConfigurations: Set<ConfigParams> = []
        modules.forEach { loopConnector in
            enabledModules.append(loopConnector.getModuleId())
            loopConnector.getConfiguration().forEach { config in
                moduleConfigurations.insert(config)
            }
        }
        
        // optionally, save any authentication related data, to be used in UI extension
        saveToKeychain(key: "D1ConsumerID", value: D1Configuration.CONSUMER_ID)
        
        // Trigger the SDK configuration and wait for the result.
        d1Task!.configure(moduleConfigurations) { [self] errors in
            CoreUtils.publishD1CoreEvent(eventListener: self.evenListener, CoreEventConfig(false, errors: errors))
            CoreUtils.runInMainThreadAsync {
                if errors == nil {
                    self.initState = .Initialized
                } else {
                    self.initState = .NotInitialized
                }
                
                completion(errors)
            }
        }
    }
    
    func login(issuerToken: inout Data, completion: @escaping (D1.D1Error?) -> Void) {
        getD1Task().login(&issuerToken, completion: lambda(CoreEventLogin, completion: completion))
    }
    
    func logout(completion: @escaping (D1.D1Error?) -> Void) {
        getD1Task().logout(lambda(CoreEventLogout, completion: completion))
    }
    
    func getCardMetadata(_ cardId: String, completion: @escaping (D1.CardMetadata?, D1.D1Error?) -> Void) {
        getD1Task().cardMetadata(cardId, completion: lambda(VCEventCardMetadata, completion: completion))
    }
    
    func isModuleEnabled(_ module: Module) -> Bool {
        return enabledModules.contains(module)
    }
    
    func sdkInitState() -> D1InitState {
        return initState
    }
    
    func libVersion() -> String {
        return D1Task.getSDKVersions().description
    }

    func appVersion() -> String {
        let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let versionCode: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"

        return version + "-" + versionCode
    }
    
    func getD1Task() -> D1.D1Task {
        if let d1Task = d1Task {
            return d1Task
        } else {
            fatalError("Need to configure D1 SDK first.")
        }
    }
    
    func getEventListener() -> D1CoreEventListener? {
        return self.evenListener
    }
    
    func createModuleConnector(_ consumerID: String) -> D1ModuleConnector {
        return D1CoreModuleConnector(consumerID)
    }
    
    // MARK: - private
    
    
    /// Saves the value to keychain.
    /// - Parameters:
    ///   - key: Key.
    ///   - value: Value.
    func saveToKeychain(key: String, value: String) {
        guard let valueData = value.data(using: .utf8) else {
            return
        }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "IssuerAppService",
            kSecAttrAccessGroup as String: "group.com.thalesgroup.d1.Templates",
            kSecAttrAccount as String: key]
        var addQuery = query
        addQuery[kSecValueData as String] = valueData
        let status = SecItemAdd(addQuery as CFDictionary, nil)

        if status == errSecDuplicateItem  {
            let updatedData: [String: Any] = [kSecValueData as String: valueData]
            SecItemUpdate(query as CFDictionary, updatedData as CFDictionary)
        }
    }

    
    // MARK: - D1ModuleConnector

    /// D1Core related D1ModuleConnector.
    private class D1CoreModuleConnector: D1ModuleConnector {
        private let consumerID: String
        
        init(_ consumerID: String) {
            self.consumerID = consumerID
        }
        
        func getConfiguration() -> [D1.ConfigParams] {
            // There is no extra configuration needed for this module.
            return [ConfigParams.coreConfig(consumerID: self.consumerID)]
        }
        
        func getModuleId() -> Module {
            .core
        }
    }
}
