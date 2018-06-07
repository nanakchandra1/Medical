//
//  CityNameModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityNameModel {
    
    var id : Int?
    var countryCode :String?
    var stateCode : String?
    var cityName : String?
    
    required init?(_ data :JSON){
        
        self.id = data["id"].int
        self.countryCode = data["country_code"].stringValue
        self.stateCode = data["state_code"].stringValue
        self.cityName = data["city_name"].stringValue
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [CityNameModel] {
        var models: [CityNameModel] = []
        
        for json in array {
            if let cityName = CityNameModel(json) {
                models.append(cityName)
            }
        }
        return models
    }
}
