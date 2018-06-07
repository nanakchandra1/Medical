//
//  RTCIceCandidate+JSON.swift
//  de
//
//  Created by  on 31/08/17.
//  Copyright © 2017. All rights reserved.
//

import SwiftyJSON
import WebRTC

extension RTCIceCandidate {
    
    convenience init(json: JSON) {
        self.init(sdp: json[WebRTCKeys.ICECandidateSdpKey].stringValue,
                  sdpMLineIndex: json[WebRTCKeys.ICECandidateMLineIndexKey].int32Value,
                  sdpMid: json[WebRTCKeys.ICECandidateMidKey].string)
    }
    
    var jsonDictionary: JSONDictionary {
        return [WebRTCKeys.ICECandidateTypeKey: WebRTCKeys.ICECandidateTypeValue,
                WebRTCKeys.ICECandidateMLineIndexKey: sdpMLineIndex,
                WebRTCKeys.ICECandidateMidKey: sdpMid!,
                WebRTCKeys.ICECandidateSdpKey: sdp
        ]
    }
    
}
