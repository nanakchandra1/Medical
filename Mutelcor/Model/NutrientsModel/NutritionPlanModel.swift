//
//  NutritionPlanModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
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
    public var formId = ""
    public var pdfFile = ""
    public var createdDate = ""
    
	private var startDate : String?
    public var startingDate: Date? {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH':'mm':'ss'.'SSS'Z'"
        if let sD = startDate {
            return Date.dateFormatter.date(from: sD)
        }
        return nil
    }
    
    private var endDate : String?
    public var endingDate: Date? {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH':'mm':'ss'.'SSS'Z'"
        if let eD = endDate {
            return Date.dateFormatter.date(from: eD)
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
        
        let mealType = json[DictionaryKeys.mealType].intValue
        guard mealType != 0 else {
            return nil
        }
        self.formId = json[DictionaryKeys.formId].stringValue
        self.pdfFile = json[DictionaryKeys.pdfFile].stringValue
		menuQuantity = json[DictionaryKeys.menuQuantity].stringValue
		meal_type = mealType
		calories = json[DictionaryKeys.calories].intValue
		calories_unit = json[DictionaryKeys.caloriesUnit].stringValue
		carbs = json[DictionaryKeys.carbs].intValue
		carbs_unit = json[DictionaryKeys.carbsUnit].stringValue
		fats = json[DictionaryKeys.fats].intValue
		fats_unit = json[DictionaryKeys.fatsUnit].stringValue
		proteins = json[DictionaryKeys.proteins].intValue
		proteins_unit = json[DictionaryKeys.proteinsUnit].stringValue
		water = json[DictionaryKeys.water].intValue
		water_unit = json[DictionaryKeys.waterUnit].stringValue
		startDate = json[DictionaryKeys.startDate].string
		endDate = json[DictionaryKeys.end_Date].string
		daily_allowance = json[DictionaryKeys.dailyAllowances].string
		food_to_avoid = json[DictionaryKeys.foodToAvoid].string
		attachments = json[DictionaryKeys.measurement_Attachment].string
		attachments_name = json[DictionaryKeys.attachmentName].string
		schedule_name = json[DictionaryKeys.scheduleName].string
		doctor_name = json[DictionaryKeys.doctor_name].string
		doc_specialisation = json[DictionaryKeys.doctorSpecialization].string
        createdDate = json[DictionaryKeys.createdDate].stringValue

	}
    
	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary[DictionaryKeys.menuQuantity] = self.menuQuantity
		dictionary[DictionaryKeys.mealType] = self.meal_type
		dictionary[DictionaryKeys.calories] = self.calories
		dictionary[DictionaryKeys.caloriesUnit] = self.calories_unit
		dictionary[DictionaryKeys.carbs] = self.carbs
		dictionary[DictionaryKeys.carbsUnit] = self.carbs_unit
		dictionary[DictionaryKeys.fats] = self.fats
		dictionary[DictionaryKeys.fatsUnit] = self.fats_unit
		dictionary[DictionaryKeys.proteins] = self.proteins
		dictionary[DictionaryKeys.proteinsUnit] = self.proteins_unit
		dictionary[DictionaryKeys.water] = self.water
		dictionary[DictionaryKeys.waterUnit] = self.water_unit
		dictionary[DictionaryKeys.startDate] = self.startDate
		dictionary[DictionaryKeys.end_Date] = self.endDate
		dictionary[DictionaryKeys.dailyAllowances] = self.daily_allowance
		dictionary[DictionaryKeys.foodToAvoid] = self.food_to_avoid
		dictionary[DictionaryKeys.measurement_Attachment] = self.attachments
		dictionary[DictionaryKeys.attachmentName] = self.attachments_name
		dictionary[DictionaryKeys.scheduleName] = self.schedule_name
		dictionary[DictionaryKeys.doctor_name] = self.doctor_name
		dictionary[DictionaryKeys.doctorSpecialization] = self.doc_specialisation

		return dictionary
	}

}
