/*
 * Copyright © 2023 THALES. All rights reserved.
 */


import Foundation
import D1

func VCEventCardMetadata(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20000, message: "Reading card metadata", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20001, message: "Reading card metadata failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20002, message: "Reading card metadata was successful.", type: .Info)
    }
}

func VCEventCardDetails(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20010, message: "Reading card details", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20011, message: "Reading card details failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20012, message: "Reading card details was successful.", type: .Info)
    }
}

func VCEventCardDigitizationState(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20020, message: "Reading card digitization state", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20021, message: "Reading card digitization state failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20022, message: "Reading card digitization state was successful.", type: .Info)
    }
}

func VCEventCardDigitizationLifeCycle(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20020, message: "Digital card life cycle update", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20021, message: "Digital card life cycle update failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20022, message: "Digital card life cycle update was successful.", type: .Info)
    }
}

func VCEventCardActivation(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20020, message: "Card activation update", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20021, message: "Card activation failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20022, message: "Card activation was successful.", type: .Info)
    }
}

func VCEventDigitalCardList(_ trigger: Bool, error: D1.D1Error? = nil) -> D1CoreEvent {
    if trigger {
        return D1CoreEvent(eventCode: 20020, message: "Digital card list", type: .Info)
    } else if let error = error {
        return D1CoreEvent(eventCode: 20021, message: "Digital card list failed: \(error)", type: .Error)
    } else {
        return D1CoreEvent(eventCode: 20022, message: "Digital card list was successful.", type: .Info)
    }
}

