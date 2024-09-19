# D1 SDK Sample iOS application v2

Sample application to show the integration of D1 SDK in to an iOS application. This serves not only as a guide but also 
as a ready made solution if code needs to be transferred 1:1 to client applications.

# Getting started

*Note: Thales SDK support team will supply all config files directly via email.*

The following files need to be added to the project:

## TLDR files to add:
```bash
.
D1
├── D1Configuration.plist
└── D1 SDK Binaries
```

## D1 Backend Configuration
   
The `D1Configuration.plist` file which holds the D1 backend configuration needs to be added to the project.

**`Core/D1Configuration.plist`**
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
	<key>SANDBOX_JWT_URL</key>
	<string></string>
	<key>SANDBOX_JWT_USER</key>
	<string></string>
	<key>SANDBOX_JWT_PASSWORD</key>
	<string></string>
</dict>
</plist>
```

The `D1Configuration.plist` file is **not** kept under version control to prevent it from being overwritten during repository update.

For more details, please refer to the [D1 SDK Setup](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/4f003bf306c04-initial-setup) section of the D1 Developer Portal.

## D1 SDK Binaries

This sample application was tested with **D1 SDK version 4.0.0**. D1 SDK binaries need to be placed in to the following location.

```bash
Libs/
├── d1-libs-debug
│   ├── D1.xcframework
│   ├── D1Core.xcframework
│   ├── SecureLogAPI.xcframework
│   ├── TPCSDKSwift.xcframework
│   ├── d1-libs-debug.podspec
│   └── package.json
│
└── d1-libs-release
    ├── D1.xcframework
    ├── D1Core.xcframework
    ├── SecureLogAPI.xcframework
    ├── TPCSDKSwift.xcframework
    ├── d1-libs-release.podspec
    └── package.json
```

The D1 SDK binaries are wrapped in to [Pods](https://cocoapods.org/) to differentiate between the Debug and Release version of the SDK.

**`Podfile`**
```bash
target 'Templates' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Templates
  pod 'd1-libs-debug', :path => './Libs/d1-libs-debug', :configurations => ['Debug']
  pod 'd1-libs-release', :path => './Libs/d1-libs-release', :configurations => ['Release']

end
```

For more details, please refer to the [D1 SDK Integration](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/9d11ae3647d6b-integrate-sdk-binary-into-your-i-os-application) section of the D1 Developer Portal.

# Authentication

To receive access to all D1 services, the user needs to authenticate with D1. This authentication is done using a [JSON Web Token (JWT)](https://auth0.com/docs/secure/tokens/json-web-tokens). For the [sandbox environment](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/fa46cefb0ef05-mobile-sdk-sandbox) a web service is used to fetch the JWT. The JWT configuration is part of the `D1Configuration.plist` file.

For more details, please refer to the [D1 SDK Login](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/97566495c786d-sdk-login) section of the D1 Developer Portal.

# CocoaPods

Install CocoaPods:

```bash
>> pod install
```

## Build and run project

After all of the configurations have been updated, the generated xcworkspace can be opened and build using Xcode.

# Project structure
 
The sample application is divided in to multiple modules.

```bash
.
├── Core
├── Features
│   ├── Push
│   └── VirtualCard
├── Libs
│   ├── d1-libs-debug
│   └── d1-libs-release
├── Templates.xcodeproj
├── WalletExtension
└── WalletExtensionUI

```

* Core - Common classes and components for all modules.
* Features/Push - [D1-Push](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/294f33eaf2378-introduction) use cases.
* Features/VirtualCard - [Virtual Card](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/3c8a7e6f0a81a-card-display-introduction) use cases.
* Libs - [D1 SDK binaries](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/9d11ae3647d6b-integrate-sdk-binary-into-your-i-os-application).
* Templates.xcodeproj - Main application project.
* WalletExtension - Non-UI Extension for [Apple Wallet Extension](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/40b4ce42c7778-apple-wallet-extension).
* WalletExtensionUI - UI Extension for [Apple Wallet Extension](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/40b4ce42c7778-apple-wallet-extension).

## Documentation

[D1 Developer portal](https://thales-dis-dbp.stoplight.io/docs/d1-developer-portal/branches/main/de9abde9af194-thales-d1-a-card-api-to-modernise-card-issuance)


## Contributing

If you are interested in contributing to the D1 SDK Sample iOS application, start by reading the [Contributing guide](/CONTRIBUTING.md).

## License

[LICENSE](/LICENSE)
