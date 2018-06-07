//
//  FitBitTokenModel.swift
//  Mutelcor
//
//  Created by on 29/12/17.
//  Copyright © 2017 "" All rights reserved.
//

import Foundation
import SwiftyJSON

class FitbitToken {
    
    var accessToken = ""
    var expiry = 0.0
    var refreshToken = ""
    var userId = ""
    var scope = ""
    var tokenType = ""
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [FitbitToken] {
        var models: [FitbitToken] = []
        for json in array {
            if let token = FitbitToken(json: json) {
                models.append(token)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
        guard let accessTokn = json["access_token"].string else {
            return nil
        }
        
        expiry              = json["expires_in"].doubleValue
        accessToken         = accessTokn
        refreshToken        = json["refresh_token"].stringValue
        userId              = json["user_id"].stringValue
        scope               = json["scope"].stringValue
        tokenType           = json["token_type"].stringValue
    }
    
    func jsonRepresentation() -> [String: Any] {
        
        var dictionary = [String: Any]()
        
        dictionary["Expires"]           = self.expiry
        dictionary["RefreshToken"]      = self.refreshToken
        dictionary["UserID"]            = self.userId
        dictionary["client_para"]       = self.scope
        dictionary["APIName"]           = self.tokenType
        dictionary["AccessToken"]       = self.accessToken
        
        return dictionary
    }
}
