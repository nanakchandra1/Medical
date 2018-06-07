//
//  StateNameModel.swift
//  Mutelcor
//
//  Created by on 30/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class StateNameModel {
    
//    var countryCode :String?
    var stateCode: Int?
    var stateName: String = ""
    
    required init?(_ data :JSON){
        
//        self.countryCode = data["country_code"].stringValue

        self.stateCode =  data[DictionaryKeys.stateCode].intValue
        self.stateName = data[DictionaryKeys.stateName].stringValue
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
