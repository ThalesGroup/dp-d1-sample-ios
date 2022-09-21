# D1 SDK Sample iOS application

Sample application to show the integration of D1 SDK in to an iOS application.

## Get started

To be able to build and run the sample application:

1. D1 SDK needs to be added to the sample application.
2. Application configuration needs to be updated.
3. Install CocoaPods

Please contact your Thales representative to recieve D1 SDK and a working configuration.

### D1 SDK

Please refer to the sample applications `FRAMEWORK_SEARCH_PATHS` for the correct location of D1 SDK.

**`D1Sample.xcodeproj/project.pbxproj`**
```bash
FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/../D1/Release";
FRAMEWORK_SEARCH_PATHS = "$(PROJECT_DIR)/../D1/Debug";
```

```bash
├── D1Sample
├── D1Sample.xcodeproj
├── Podfile
├── Podfile.lock
└── D1
    ├── Debug
    │   ├── D1.xcframework
    │   ├── D1Core.xcframework
    │   └── TPCSDKSwift.xcframework
    └── Release
        ├── D1.xcframework
        ├── D1Core.xcframework
        └── TPCSDKSwift.xcframework
```

For more details, please refer to the [D1 SDK Integration](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/aae279e415b85-sdk-integration-on-i-os) section of the D1 Developer Portal.

### Configuration

#### D1 backend configuration

The D1 backend configuration needs to be updated in the following file:

**`D1Sample/sdk/Configuration.swift`**
```swift
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
}
```

For more details, please refer to the [D1 SDK Setup](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/ZG9jOjI4ODMzMjkz-onboarding) section of the D1 Developer Portal.

#### Authentication

To receive access to all D1 services, the user needs to authenticate with D1. This authentication is done using a [JSON Web Token (JWT)](https://auth0.com/docs/secure/tokens/json-web-tokens). For simplicity this token is generated in the sample application. To generate the JWT the following configuration needs to be updated:

**`D1Sample/sdk/Configuration.swift`**
```swift

/// Tenant configuration.
public struct Configuration {
    
    static let SANDBOX = Tenant(name: "name",
                                   scope: "scope",
                                   audience: "audience",
                                   jwtKeyID: "jwtKeyId",
                                   algo: .es256,
                                   jwtPrivateKey: "privateKey")
}
```

For more details, please refer to the [D1 SDK Login](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/70d2f0c3dbfd9-login) section of the D1 Developer Portal.

### CocoaPods

Install CocoaPods:

```bash
>> pod install
```

## Build and run project

After all of the configurations have been updated, the generated xcworkspace can be opened and build using Xcode.

## Source code overview
 
Most of D1 SDK related source code is located in the following classes:

* `D1Helper` - most of D1 SDK logic.
* `Configuration` - D1 backend configuration.
* `Tenant` - JWT configuration.

## Documentation

[D1 Developer portal](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/ZG9jOjE1MjEwNTMy-digital-first-d1-ux)


## Contributing

If you are interested in contributing to the D1 SDK Sample Android application, start by reading the [Contributing guide](/CONTRIBUTING.md).

## License

[LICENSE](/LICENSE)
