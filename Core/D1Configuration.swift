/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation

/// D1 SDK configuration.
public struct D1Configuration {
    static var D1_SERVICE_URL: String!
    static var ISSUER_ID: String!
    static var DIGITAL_CARD_URL: String!
    static var D1_SERVICE_MODULUS: Data!
    static var D1_SERVICE_RSA_EXPONENT: Data!
    
    static var SANDBOX_JWT_URL: String!
    static var SANDBOX_JWT_USER: String!
    static var SANDBOX_JWT_PASSWORD: String!
    
    // TODO: Used for testing.
    static var CONSUMER_ID: String!
    static var CARD_ID: String!
    
    
    /// Reads the D1 configuration for D1Configuration.plist file. If D1Configuration.plist file is missing then fatalError is executed.
    public static func loadConfigurationFromPlist() {
        if let path = Bundle.main.path(forResource: "D1Configuration", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path) {
                D1_SERVICE_URL = readProperty(dictionary: dictionary, key: "D1_SERVICE_URL")
                ISSUER_ID = readProperty(dictionary: dictionary, key: "ISSUER_ID")
                DIGITAL_CARD_URL = readProperty(dictionary: dictionary, key: "DIGITAL_CARD_URL")
                CONSUMER_ID = readProperty(dictionary: dictionary, key: "CONSUMER_ID")
                CARD_ID = readProperty(dictionary: dictionary, key: "CARD_ID")
                
                let rsaModulus = readProperty(dictionary: dictionary, key: "D1_SERVICE_RSA_MODULUS")
                let rsaExponent = readProperty(dictionary: dictionary, key: "D1_SERVICE_RSA_EXPONENT")
                D1_SERVICE_MODULUS = dataWithHexString(hex: rsaModulus)
                D1_SERVICE_RSA_EXPONENT = dataWithHexString(hex: rsaExponent)
                                                                            
                SANDBOX_JWT_URL = readProperty(dictionary: dictionary, key: "SANDBOX_JWT_URL")
                SANDBOX_JWT_USER = readProperty(dictionary: dictionary, key: "SANDBOX_JWT_USER")
                SANDBOX_JWT_PASSWORD = readProperty(dictionary: dictionary, key: "SANDBOX_JWT_PASSWORD")
            } else {
                fatalError("Cannot read D1Configuration.plist file.")
            }
        } else {
            fatalError("Cannot read D1Configuration.plist file.")
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

extension URLRequest {
    mutating func setBasicAuth(username: String, password: String) {
        let encodedAuthInfo = String(format: "%@:%@", username, password)
            .data(using: String.Encoding.utf8)!
            .base64EncodedString()
        addValue("Basic \(encodedAuthInfo)", forHTTPHeaderField: "Authorization")
    }
}
