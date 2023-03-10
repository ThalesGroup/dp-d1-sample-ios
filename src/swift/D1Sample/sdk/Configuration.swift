/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation

/// D1 SDK configuration.
public struct Configuration {
    static var D1_SERVICE_URL: String!
    static var ISSUER_ID: String!
    static var DIGITAL_CARD_URL: String!
    static var D1_SERVICE_MODULUS: Data!
    static var D1_SERVICE_RSA_EXPONENT: Data!
    
    // TODO: Used for testing.
    static var CONSUMER_ID: String!
    static var CARD_ID: String!
        
    static var SANDBOX: Tenant!
    
    /// Reads the D1 configuration for d1.plist file. If d1.plist file is missing then fatalError is executed.
    public static func loadConfigurationFromPlist() {
        if let path = Bundle.main.path(forResource: "d1", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path) {
                Configuration.D1_SERVICE_URL = readProperty(dictionary: dictionary, key: "D1_SERVICE_URL")
                Configuration.ISSUER_ID = readProperty(dictionary: dictionary, key: "ISSUER_ID")
                Configuration.DIGITAL_CARD_URL = readProperty(dictionary: dictionary, key: "DIGITAL_CARD_URL")
                Configuration.CONSUMER_ID = readProperty(dictionary: dictionary, key: "CONSUMER_ID")
                Configuration.CARD_ID = readProperty(dictionary: dictionary, key: "CARD_ID")
                
                let rsaModulus = readProperty(dictionary: dictionary, key: "D1_SERVICE_RSA_MODULUS")
                let rsaExponent = readProperty(dictionary: dictionary, key: "D1_SERVICE_RSA_EXPONENT")
                Configuration.D1_SERVICE_MODULUS = dataWithHexString(hex: rsaModulus)
                Configuration.D1_SERVICE_RSA_EXPONENT = dataWithHexString(hex: rsaExponent)
                
                let sanboxName = readProperty(dictionary: dictionary, key: "SANDBOX_NAME")
                let sanboxScope = readProperty(dictionary: dictionary, key: "SANDBOX_SCOPE")
                let sandboxAudience = readProperty(dictionary: dictionary, key: "SANDBOX_AUDIENCE")
                let sandboxKeyId = readProperty(dictionary: dictionary, key: "SANDBOX_KEY_ID")
                let sandboxPrivateKey = readProperty(dictionary: dictionary, key: "SANDBOX_PRIVATE_KEY")
                
                let sandboxAlgo = readProperty(dictionary: dictionary, key: "SANDBOX_ALGO")
                
                var algo: TenantJwtAlgo
                switch(sandboxAlgo){
                case "ES256":
                    algo = .es256
                case "RS256":
                    algo = .rs256
                default:
                    fatalError("Unsuported value for SANDBOX_ALGO: \(sandboxAlgo)")
                }
                
                Configuration.SANDBOX = Tenant(name: sanboxName,
                                               scope: sanboxScope,
                                               audience: sandboxAudience,
                                               jwtKeyID: sandboxKeyId,
                                               algo: algo,
                                               jwtPrivateKey: sandboxPrivateKey)
                
                
            } else {
                fatalError("Cannot read d1.plist file.")
            }
        } else {
            fatalError("Cannot read d1.plist file.")
        }
    }
    
    /// Reads and checks D1 configuration parameter
    /// - Parameters:
    ///   - dictionary: Dictionary created from configuration plist file.
    ///   - key: Parameter key.
    /// - Returns: Property value, if property is missing fatalError is executed.
    private static func readProperty(dictionary: NSDictionary, key: String) -> String {
        if let value: String = dictionary.object(forKey: key) as? String {
            return value
        }
        
        fatalError("Mandatory configuration parameter missing: \(key)")
    }
    
    /// Converts hexa string to Data.
    /// - Parameter hex: Input hexa string.
    /// - Returns: Hexa string converted to Data.
    private static func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt64  = 0
            Scanner(string: c).scanHexInt64(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        
        return data
    }
}
