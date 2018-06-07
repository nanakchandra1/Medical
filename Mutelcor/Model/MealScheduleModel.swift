//
//  SurgeyModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class MealSchedule {
    
    var schId : Int?
    var scheduleName : String?
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [MealSchedule] {
        var models: [MealSchedule] = []
        
        for json in array {
            
            if let mealSchedule = MealSchedule(json: json) {
                models.append(mealSchedule)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
        
        schId          = json["sch_id"].int
        scheduleName   = json["schedule_name"].string
    }
    
    func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        
        dictionary["sch_id"]        = self.schId
        dictionary["schedule_name"] = self.scheduleName
        
        return dictionary
    }
    
}

