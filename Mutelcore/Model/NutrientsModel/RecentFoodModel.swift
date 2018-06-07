//
//  SurgeyModel.swift
//  Mutelcore
//
//  Created by Ashish on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecentFood {
    
    var id = 0
    var name = ""
    var quantity = 0
    var calories = 0
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
        
        let foodId = json["food_id"].intValue
        guard json["food_id"].intValue != 0 else {
            return nil
        }
        
        id              = foodId
        name            = json["food"].stringValue
        quantity        = json["quantity"].intValue
        calories        = json["calories"].intValue
        carbs           = json["carbs"].intValue
        fats            = json["fats"].intValue
        proteins        = json["proteins"].intValue
        unit            = json["unit"].stringValue
        
        mealName        = json["meal_name"].stringValue
        mealId          = json["meal_id"].intValue
    }
    
    init() {
        
    }
    
    func dictionaryRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        
        dictionary["food_id"]       = self.id
        dictionary["food"]          = self.name
        dictionary["unit"]          = self.unit
        dictionary["calories"]      = self.calories
        dictionary["carbs"]         = self.carbs
        dictionary["fats"]          = self.fats
        dictionary["proteins"]      = self.proteins
        dictionary["quantity"]      = self.quantity
        
        dictionary["meal_name"]     = self.mealName
        dictionary["meal_id"]       = self.mealId
        
        return dictionary
    }
}
