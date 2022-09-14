/*
 * Copyright © 2022 THALES. All rights reserved.
 */

import Foundation


/// Tenant configuration.
struct Tenant {
    let name: String
    let scope: String
    let audience: String
    let jwtKeyID: String
    let algo: TenantJwtAlgo
    let jwtPrivateKey: String
    
    static let SANDBOX = Tenant(name: "name",
                                   scope: "scope",
                                   audience: "audience",
                                   jwtKeyID: "jwtKeyId",
                                   algo: .es256,
                                   jwtPrivateKey: """
    privateKey
    """)
}

enum TenantJwtAlgo {
    case rs256
    case es256
}
