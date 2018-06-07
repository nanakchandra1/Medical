//
//  SpecialityModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class SpecialityModel {
    
    var specialityId : Int?
    var specialityName : String?
    var specialityCreated : String?
    
    required init?(specialityInfoDic : JSON){
        
        if let specialityID = specialityInfoDic[DictionaryKeys.cmsId].int{
            self.specialityId = specialityID
        }
        
        self.specialityName = specialityInfoDic[DictionaryKeys.specialityName].stringValue
        self.specialityCreated = specialityInfoDic[DictionaryKeys.createdAt].stringValue
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [SpecialityModel] {
        var models: [SpecialityModel] = []
        for json in array {
            if let specialityData = SpecialityModel(specialityInfoDic : json) {
                models.append(specialityData)
            }
        }
        return models
    }
}
