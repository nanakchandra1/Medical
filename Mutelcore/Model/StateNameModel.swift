//
//  StateNameModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class StateNameModel {
    
//    var countryCode :String?
    var stateCode : String?
    var stateName : String?
    
    required init?(_ data :JSON){
        
//        self.countryCode = data["country_code"].stringValue
        self.stateCode = data["state_code"].stringValue
        self.stateName = data["state_name"].stringValue
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [StateNameModel] {
        var models: [StateNameModel] = []
        for json in array {
            if let stateName = StateNameModel(json) {
                models.append(stateName)
            }
        }
        return models
    }
}
