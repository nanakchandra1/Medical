//
//  NutritionPlanModel.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
 
public class NutritionPlan {
    
	public var menuQuantity =  ""
	public var meal_type = 0
	public var calories = 0
	public var calories_unit =  ""
	public var carbs = 0
	public var carbs_unit =  ""
	public var fats = 0
	public var fats_unit =  ""
	public var proteins = 0
	public var proteins_unit =  ""
	public var water = 0
	public var water_unit =  ""
    
	private var startDate : String?
    public var startingDate: Date? {
        CommonClass.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH':'mm':'ss'.'SSS'Z'"
        if let sD = startDate {
            return CommonClass.dateFormatter.date(from: sD)
        }
        return nil
    }
    
    private var endDate : String?
    public var endingDate: Date? {
        CommonClass.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH':'mm':'ss'.'SSS'Z'"
        if let eD = endDate {
            return CommonClass.dateFormatter.date(from: eD)
        }
        return nil
    }
    
	public var daily_allowance : String?
	public var food_to_avoid : String?
	public var attachments : String?
	public var attachments_name : String?
	public var schedule_name : String?
	public var doctor_name : String?
	public var doc_specialisation : String?
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [NutritionPlan] {
        var models: [NutritionPlan] = []
        for json in array {
            if let plans = NutritionPlan(json: json) {
                models.append(plans)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
        
        let mealType = json["meal_type"].intValue
        guard mealType != 0 else {
            return nil
        }
        
		menuQuantity = json["menu_quntity"].stringValue
		meal_type = mealType
		calories = json["calories"].intValue
		calories_unit = json["calories_unit"].stringValue
		carbs = json["carbs"].intValue
		carbs_unit = json["carbs_unit"].stringValue
		fats = json["fats"].intValue
		fats_unit = json["fats_unit"].stringValue
		proteins = json["proteins"].intValue
		proteins_unit = json["proteins_unit"].stringValue
		water = json["water"].intValue
		water_unit = json["water_unit"].stringValue
		startDate = json["start_date"].string
		endDate = json["end_date"].string
		daily_allowance = json["daily_allowance"].string
		food_to_avoid = json["food_to_avoid"].string
		attachments = json["attachments"].string
		attachments_name = json["attachments_name"].string
		schedule_name = json["schedule_name"].string
		doctor_name = json["doctor_name"].string
		doc_specialisation = json["doc_specialisation"].string
	}
    
	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary["menu_quntity"] = self.menuQuantity
		dictionary["meal_type"] = self.meal_type
		dictionary["calories"] = self.calories
		dictionary["calories_unit"] = self.calories_unit
		dictionary["carbs"] = self.carbs
		dictionary["carbs_unit"] = self.carbs_unit
		dictionary["fats"] = self.fats
		dictionary["fats_unit"] = self.fats_unit
		dictionary["proteins"] = self.proteins
		dictionary["proteins_unit"] = self.proteins_unit
		dictionary["water"] = self.water
		dictionary["water_unit"] = self.water_unit
		dictionary["start_date"] = self.startDate
		dictionary["end_date"] = self.endDate
		dictionary["daily_allowance"] = self.daily_allowance
		dictionary["food_to_avoid"] = self.food_to_avoid
		dictionary["attachments"] = self.attachments
		dictionary["attachments_name"] = self.attachments_name
		dictionary["schedule_name"] = self.schedule_name
		dictionary["doctor_name"] = self.doctor_name
		dictionary["doc_specialisation"] = self.doc_specialisation

		return dictionary
	}

}
