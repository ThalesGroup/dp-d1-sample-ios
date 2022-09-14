/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation
import SwiftJWT
import os.log


/// Helper class for JWT generation.
struct JWTEncoder {
    static let JWT_CLAIMS_DEFAULT_SUB = "testuser"
    static var JWT_CLAIMS_IAT: Date {
        Date()
    }
    
    static var JWT_CLAIMS_EXP : Date {
        Date.init(timeIntervalSinceNow: 3600)
    }
    
    struct JWTClaims: Claims {
        let scope: String
        let sub: String
        let iat: Date
        let iss: String
        let aud: String
        let exp: Date
    }

    /// Defaults to digibank01
    static func generateCustomBAn(consumerID: String) -> Data {
        return generateCustomBAn(consumerID: consumerID, tenant: Tenant.SANDBOX)
    }

    /// Generates an A2 BAn token for a specific {@code customerID}
    /// - Parameters:
    ///   - consumerID: The customer ID..
    ///   - tenant: Tenant.
    /// - Returns: The A2 BAn token.
    static func generateCustomBAn(consumerID: String, tenant: Tenant) -> Data {
        let a2Claims = JWTEncoder.JWTClaims(scope: tenant.scope,
                                            sub: consumerID,
                                            iat: JWTEncoder.JWT_CLAIMS_IAT,
                                            iss: "https://bpsd1-demo-a2oidc.d1-dev.thalescloud.io/oidc/\(tenant.name)",
                                            aud: tenant.audience,
                                            exp: JWTEncoder.JWT_CLAIMS_EXP)
        return generateCustomBAn(tenant: tenant, a2Claims: a2Claims)
    }

    
    /// Generates an A2 BAn token for a specific {@code customerID}
    /// - Parameters:
    ///   - tenant: Tenant.
    ///   - a2Claims: Claims.
    /// - Returns: The A2 BAn token.
    static func generateCustomBAn(tenant: Tenant, a2Claims: JWTClaims) -> Data {
        let header = Header(kid: tenant.jwtKeyID)

        // initialize a JWT by providing the JWT Header and Claims.
        var jwt = JWT(header: header, claims: a2Claims)

        // Sign a JWT using a JWTSigner
        let privateKey = tenant.jwtPrivateKey.data(using: .utf8)!

        var jwtSigner: JWTSigner
        switch tenant.algo {
        case .rs256:
            jwtSigner = JWTSigner.rs256(privateKey: privateKey)
        case .es256:
            jwtSigner = JWTSigner.es256(privateKey: privateKey)
        }

        guard let signedJWT = try? jwt.sign(using: jwtSigner) else {
            fatalError("Failed to generate custom BAn")
        }
        
        return Data(signedJWT.utf8)
    }
}
