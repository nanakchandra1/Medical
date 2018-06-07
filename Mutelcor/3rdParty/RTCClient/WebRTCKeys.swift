//
//  WebRTCKeys.swift
//  de
//
//  Created by  on 31/08/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

struct WebRTCKeys {
    
    static let SessionDescriptionTypeKey = "type"
    static let SessionDescriptionSdpKey = "sdp"
    
    static let ICECandidateTypeKey = "type"
    static let ICECandidateTypeValue = "candidate"
    static let ICECandidateMidKey = "id" //"sdpMid"
    static let ICECandidateMLineIndexKey = "label" //"sdpMLineindex"
    static let ICECandidateSdpKey = "candidate"
    
    static let ICEServerUsernameKey = "username"
    static let ICEServerPasswordKey = "password"
    static let ICEServerUrisKey = "uris";
    static let ICEServerUrlKey = "urls"
    static let ICEServerCredentialKey = "credential"
}
