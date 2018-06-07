//
//  iHealthTokenModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class iHealthToken {
    
    var accessToken = ""
    var expiry = 0.0
    var refreshToken = ""
    var userId = ""
    var clientPara = ""
    var allowedApis = ""
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [iHealthToken] {
        var models: [iHealthToken] = []
        for json in array {
            if let token = iHealthToken(json: json) {
                models.append(token)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
        guard let accessTokn = json["AccessToken"].string else {
            return nil
        }
        
        expiry              = json["Expires"].doubleValue
        accessToken         = accessTokn
        refreshToken        = json["RefreshToken"].stringValue
        userId              = json["UserID"].stringValue
        clientPara          = json["client_para"].stringValue
        allowedApis         = json["APIName"].stringValue        
    }
    
    func jsonRepresentation() -> [String: Any] {
        
        var dictionary = [String: Any]()
        
        dictionary["Expires"]           = self.expiry
        dictionary["RefreshToken"]      = self.refreshToken
        dictionary["UserID"]            = self.userId
        dictionary["client_para"]       = self.clientPara
        dictionary["APIName"]           = self.allowedApis
        dictionary["AccessToken"]       = self.accessToken
        
        return dictionary
    }
}


