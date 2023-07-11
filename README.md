# D1 SDK Sample iOS application

Sample application to show the integration of D1 SDK in to an iOS application.

## Get started

To be able to build and run the sample application:

1. D1 SDK needs to be added to the sample application.
2. Application configuration needs to be added.
3. Install CocoaPods.

The following files need to be added to the project:

1. D1 backend configuration.
   
```bash
src/swift/D1Sample/D1Sample/d1.plist
```

2. D1 SDK.

```bash
src/swift/D1Sample/D1Sample/D1
                            ├── Debug
                            │   ├── D1.xcframework
                            │   ├── D1Core.xcframework
                            │   └── TPCSDKSwift.xcframework
                            └── Release
                                ├── D1.xcframework
                                ├── D1Core.xcframework
                                └── TPCSDKSwift.xcframework
```

Please contact your Thales representative to recieve D1 SDK and a working configuration.

### D1 SDK
This sample application was tested with **D1 SDK version 3.0.0**. D1 SDK needs to be placed in to the following location:

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

For more details, please refer to the [D1 SDK Integration](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/9d11ae3647d6b-integrate-sdk-binary-into-your-i-os-application) section of the D1 Developer Portal.

### Configuration

#### D1 backend configuration

The `d1.plist` file which holds the D1 backend configuration needs to be added to the project:

**`src/swift/D1Sample/D1Sample/d1.plist`**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>D1_SERVICE_URL</key>
	<string></string>
	<key>ISSUER_ID</key>
	<string></string>
	<key>D1_SERVICE_RSA_EXPONENT</key>
	<string></string>
	<key>D1_SERVICE_RSA_MODULUS</key>
	<string></string>
	<key>DIGITAL_CARD_URL</key>
	<string></string>
	<key>CONSUMER_ID</key>
	<string></string>
	<key>CARD_ID</key>
	<string></string>
	<key>SANDBOX_NAME</key>
	<string></string>
	<key>SANDBOX_SCOPE</key>
	<string></string>
	<key>SANDBOX_AUDIENCE</key>
	<string></string>
	<key>SANDBOX_KEY_ID</key>
	<string></string>
	<key>SANDBOX_ALGO</key>
	<string></string>
	<key>SANDBOX_PRIVATE_KEY</key>
	<string></string>
</dict>
</plist>
```

The `d1.plist` file is not kept under version control to prevent it from being overwritten during repository update.

For more details, please refer to the [D1 SDK Setup](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/4f003bf306c04-initial-setup) section of the D1 Developer Portal.

#### Authentication

To receive access to all D1 services, the user needs to authenticate with D1. This authentication is done using a [JSON Web Token (JWT)](https://auth0.com/docs/secure/tokens/json-web-tokens). For simplicity this token is generated in the sample application. The JWT configuration is part of the `d1.plist` file.

For more details, please refer to the [D1 SDK Login](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/97566495c786d-sdk-login) section of the D1 Developer Portal.

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
* `Tenant` - JWT configuration.

## Documentation

[D1 Developer portal](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/de9abde9af194-thales-d1-a-card-api-to-modernise-card-issuance)


## Contributing

If you are interested in contributing to the D1 SDK Sample Android application, start by reading the [Contributing guide](/CONTRIBUTING.md).

## License

[LICENSE](/LICENSE)
