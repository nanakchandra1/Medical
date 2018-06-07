//
//  CityNameModel.swift
//  Mutelcor
//
//  Created by on 30/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityNameModel {
    
    var id : String?
    var countryCode :String?
    var stateCode : String?
    var cityName : String?
    
    required init?(_ data :JSON){
        
        let cityID = data[DictionaryKeys.cmsId].stringValue
        
        guard !cityID.isEmpty else{
            return
        }
        self.id = cityID
        self.countryCode = data[DictionaryKeys.country_code].stringValue
        self.stateCode = data[DictionaryKeys.stateCode].stringValue
        self.cityName = data[DictionaryKeys.cityName].stringValue
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
