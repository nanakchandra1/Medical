//
//  CountryCodeModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountryCodeModel{
    
    var countryCode : String?
    var countryName : String?
    
    required init?(_ countryData : JSON){
        
        self.countryCode = countryData["country_code"].stringValue
        self.countryName = countryData["country_name"].stringValue
        
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [CountryCodeModel] {
        var models: [CountryCodeModel] = []
        for json in array {
            if let countryCode = CountryCodeModel(json) {
                models.append(countryCode)
            }
        }
        return models
    }
}
