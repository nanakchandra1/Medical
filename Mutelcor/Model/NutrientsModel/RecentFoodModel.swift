//
//  SurgeyModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecentFood {
    
    var id: Int?
    var name = ""
    var quantity = 0
    var calories = 0
    var water = 0
    var carbs = 0
    var fats = 0
    var proteins = 0
    var unit = ""
    
    var mealName = ""
    var mealId = 0
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [RecentFood] {
        var models: [RecentFood] = []
        for json in array {
            if let food = RecentFood(json: json) {
                models.append(food)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
//        let foodId = json["food_id"].intValue
//        guard foodId !=  else {
//            return nil
//        }
        
        id              = json[DictionaryKeys.foodID].intValue
        name            = json[DictionaryKeys.food].stringValue
        quantity        = json[DictionaryKeys.quantity].intValue
        calories        = json[DictionaryKeys.calories].intValue
        carbs           = json[DictionaryKeys.carbs].intValue
        fats            = json[DictionaryKeys.fats].intValue
        proteins        = json[DictionaryKeys.proteins].intValue
        water           = json[DictionaryKeys.quantity].intValue
        unit            = json[DictionaryKeys.lastSeenVitalUnit].stringValue
        
        mealName        = json[DictionaryKeys.mealName].stringValue
        mealId          = json[DictionaryKeys.mealID].intValue
    }
    
    init() {
        
    }
    
    func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        
        dictionary[DictionaryKeys.foodID]       = self.id
        dictionary[DictionaryKeys.food]          = self.name
        dictionary[DictionaryKeys.lastSeenVitalUnit]          = self.unit
        dictionary[DictionaryKeys.calories]      = self.calories
        dictionary[DictionaryKeys.carbs]         = self.carbs
        dictionary[DictionaryKeys.fats]          = self.fats
        dictionary[DictionaryKeys.proteins]      = self.proteins
        dictionary[DictionaryKeys.quantity]      = self.quantity
        dictionary[DictionaryKeys.water]         = self.water
        dictionary[DictionaryKeys.mealName]     = self.mealName
        dictionary[DictionaryKeys.mealID]       = self.mealId
        
        return dictionary
    }
}
