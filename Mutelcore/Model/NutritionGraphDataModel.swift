//
//  NutritionGraphDataModel.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

public class NutritionChartData {
	public var planCalories = 0
	public var planFats = 0
	public var planCarbs = 0
    public var planProteins = 0
    public var planWater = 0
    public var consumeCalories = 0
    public var consumeFats = 0
    public var consumeCarbs = 0
    public var consumeProteins = 0
    public var consumeWater = 0
    public var nutritionDate: Date
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [NutritionChartData] {
        var models:[NutritionChartData] = []
        for json in array {
            if let graphData = NutritionChartData(json: json) {
                models.append(graphData)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        guard let date = CommonClass.dateFormatter.date(from: json["nutrition_data"].stringValue) else {
            return nil
        }
        
		planFats = json["plan_fats"].intValue
		planCalories = json["plan_calories"].intValue
		planCarbs = json["plan_carbs"].intValue
        planProteins = json["plan_proteins"].intValue
        planWater = json["plan_water"].intValue
        
        consumeFats = json["consume_fats"].intValue
        consumeCalories = json["consume_calories"].intValue
        consumeCarbs = json["consume_carbs"].intValue
        consumeProteins = json["consume_proteins"].intValue
        consumeWater = json["consume_water"].intValue
        
        nutritionDate = date
	}

	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary["plan_fats"] = self.planFats
		dictionary["plan_calories"] = self.planCalories
		dictionary["plan_carbs"] = self.planCarbs
        dictionary["plan_proteins"] = self.planProteins
        dictionary["plan_water"] = self.planWater
        
        dictionary["consume_fats"] = self.consumeFats
        dictionary["consume_calories"] = self.consumeCalories
        dictionary["consume_carbs"] = self.consumeCarbs
        dictionary["consume_proteins"] = self.consumeProteins
        dictionary["consume_water"] = self.consumeWater
        
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
		dictionary["nutrition_data"] = CommonClass.dateFormatter.string(from: self.nutritionDate)

		return dictionary
	}

}
