/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation

/// D1 SDK configuration.
public struct Configuration {
    // The URL of D1 Service Server.
    static let D1_SERVICE_URL: String = ""
    
    // The issuer identifier.
    static let ISSUER_ID: String = ""
    
    // The URL for digital card operation.
    static let DIGITAL_CARD_URL: String = ""
    
    // The RSA modulus of the public key for secure communication between D1 Service Server and the SDK.
    static let D1_SERVICE_MODULUS: [UInt8] = [0x00,0x00,0x00,0x00]
    
    // The RSA exponent of the public key for secure communication between D1 Service Server and the SDK.
    static let D1_SERVICE_RSA_EXPONENT: [UInt8] = [0x00, 0x00, 0x00]
    
    // Consumer ID.
    static let CONSUMER_ID = ""
    
    // Card ID.
    static let CARD_ID = ""
    
    // JWT configuration for authenticatio
    static let SANDBOX = Tenant(name: "name",
                                   scope: "scope",
                                   audience: "audience",
                                   jwtKeyID: "jwtKeyId",
                                   algo: .es256,
                                   jwtPrivateKey: """
    privateKey
    """)
}
