//
//  ActivityGraphDataModel.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ActivityGraphData {
	public var planDuration = 0
	public var planCalories = 0
	public var planDistance = 0
	public var consumeDuration = 0
	public var consumeCalories = 0
	public var consumeDistance = 0
    public var activityDate: Date
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [ActivityGraphData] {
        var models:[ActivityGraphData] = []
        for json in array {
            if let graphData = ActivityGraphData(json: json) {
                models.append(graphData)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        guard let date = CommonClass.dateFormatter.date(from: json["activity_date"].stringValue) else {
            return nil
        }
        
		planDuration = json["plan_duration"].intValue
		planCalories = json["plan_calories"].intValue
		planDistance = json["plan_distance"].intValue
		consumeDuration = json["consume_duration"].intValue
		consumeCalories = json["consume_calories"].intValue
		consumeDistance = json["consume_distance"].intValue
        activityDate = date
	}

	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary["plan_duration"] = self.planDuration
		dictionary["plan_calories"] = self.planCalories
		dictionary["plan_distance"] = self.planDistance
		dictionary["consume_duration"] = self.consumeDuration
		dictionary["consume_calories"] = self.consumeCalories
        dictionary["consume_distance"] = self.consumeDistance
        
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
		dictionary["activity_date"] = CommonClass.dateFormatter.string(from: self.activityDate)

		return dictionary
	}

}
