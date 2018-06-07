//
//  EthinicityNameModel.swift
//  Mutelcor
//
//  Created by on 30/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class EthinicityNameModel {
    
    var ethinicityName : String?
    var ethinicityID :Int?
    
    required init?(_ ethinicityData : JSON){
        self.ethinicityName = ethinicityData[DictionaryKeys.ethinicityName].stringValue
        
        if let id = ethinicityData[DictionaryKeys.ethinicityId].int{
          self.ethinicityID = id
        }
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [EthinicityNameModel] {
        var models: [EthinicityNameModel] = []
        for json in array {
            if let ethinicityName = EthinicityNameModel(json) {
                models.append(ethinicityName)
            }
        }
        return models
    }
}
