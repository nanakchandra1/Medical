//
//  NutritionGraphDataModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
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
        Date.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        guard let date = Date.dateFormatter.date(from: json[DictionaryKeys.nutritionDate].stringValue) else {
            return nil
        }
        
		planFats = json[DictionaryKeys.planFat].intValue
		planCalories = json[DictionaryKeys.planCalories].intValue
		planCarbs = json[DictionaryKeys.planCarbs].intValue
        planProteins = json[DictionaryKeys.planProtiens].intValue
        planWater = json[DictionaryKeys.planWater].intValue
        
        consumeFats = json[DictionaryKeys.consumeFats].intValue
        consumeCalories = json[DictionaryKeys.consumeCalories].intValue
        consumeCarbs = json[DictionaryKeys.consumeCarbs].intValue
        consumeProteins = json[DictionaryKeys.consumeProteins].intValue
        consumeWater = json[DictionaryKeys.consumeWater].intValue

        nutritionDate = date
	}

	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary[DictionaryKeys.planFat] = self.planFats
		dictionary[DictionaryKeys.planCalories] = self.planCalories
		dictionary[DictionaryKeys.planCarbs] = self.planCarbs
        dictionary[DictionaryKeys.planProtiens] = self.planProteins
        dictionary[DictionaryKeys.planWater] = self.planWater
        
        dictionary[DictionaryKeys.consumeFats] = self.consumeFats
        dictionary[DictionaryKeys.consumeCalories] = self.consumeCalories
        dictionary[DictionaryKeys.consumeCarbs] = self.consumeCarbs
        dictionary[DictionaryKeys.consumeProteins] = self.consumeProteins
        dictionary[DictionaryKeys.consumeWater] = self.consumeWater
        
        Date.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
		dictionary[DictionaryKeys.nutritionDate] = Date.dateFormatter.string(from: self.nutritionDate)

		return dictionary
	}

}
