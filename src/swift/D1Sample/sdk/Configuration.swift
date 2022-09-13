/*
 MIT License
 
 Copyright (c) 2021 Thales DIS
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
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
}
