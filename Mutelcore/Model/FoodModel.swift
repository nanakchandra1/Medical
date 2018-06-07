//
//  SurgeyModel.swift
//  Mutelcore
//
//  Created by Ashish on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class Food {
    
    var id = 0
    var name = ""
    var unit = ""
    var perUnit = 0
    var calories = 0
    var caloriesUnit = ""
    var carbs = 0
    var carbsUnit = ""
    var fats = 0
    var fatsUnit = ""
    var proteins = 0
    var proteinsUnit = ""
    var water = 0
    var waterUnit = ""
    private var is_active = 0
    private var created_at = ""
    private var updated_at = ""
    
    var isActive: Bool {
        get {
            return (is_active == 1 ? true : false)
        }
        set {
            is_active = (newValue ? 1 : 0)
        }
    }
    
    var creationDate: Date? {
        CommonClass.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return CommonClass.dateFormatter.date(from: created_at)
    }
    
    var updationDate: Date? {
        CommonClass.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return CommonClass.dateFormatter.date(from: updated_at)
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [Food] {
        var models: [Food] = []
        for json in array {
            if let food = Food(json: json) {
                models.append(food)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
        guard let foodId = json["id"].int else {
            return nil
        }
        
        id              = foodId
        name            = json["food_name"].stringValue
        unit            = json["food_unit"].stringValue
        perUnit         = json["per_unit"].intValue
        calories        = json["calories"].intValue
        caloriesUnit    = json["calories_unit"].stringValue
        carbs           = json["carbs"].intValue
        carbsUnit       = json["carbs_unit"].stringValue
        fats            = json["fats"].intValue
        fatsUnit        = json["fats_unit"].stringValue
        proteins        = json["proteins"].intValue
        proteinsUnit    = json["proteins_unit"].stringValue
        water           = json["water"].intValue
        waterUnit       = json["water_unit"].stringValue
        is_active       = json["is_active"].intValue
        created_at      = json["created_at"].stringValue
        updated_at      = json["updated_at"].stringValue
    }
    
    func dictionaryRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        
        dictionary["id"]            = self.id
        dictionary["food_name"]     = self.name
        dictionary["food_unit"]     = self.unit
        dictionary["per_unit"]      = self.perUnit
        dictionary["calories"]      = self.calories
        dictionary["calories_unit"] = self.caloriesUnit
        dictionary["carbs"]         = self.carbs
        dictionary["carbs_unit"]    = self.carbsUnit
        dictionary["fats"]          = self.fats
        dictionary["fats_unit"]     = self.fatsUnit
        dictionary["proteins"]      = self.proteins
        dictionary["proteins_unit"] = self.proteinsUnit
        dictionary["water"]         = self.water
        dictionary["water_unit"]    = self.waterUnit
        dictionary["is_active"]     = self.is_active
        dictionary["created_at"]    = self.created_at
        dictionary["updated_at"]    = self.updated_at
        
        return dictionary
    }
}

