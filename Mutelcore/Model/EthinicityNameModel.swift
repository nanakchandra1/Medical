//
//  EthinicityNameModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class EthinicityNameModel {
    
    var ethinicityName : String?
    var ethinicityID :Int?
    
    required init?(_ ethinicityData : JSON){
        
        self.ethinicityName = ethinicityData["ethi_name"].stringValue
        
        if let id = ethinicityData["ethin_id"].int{
            
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
