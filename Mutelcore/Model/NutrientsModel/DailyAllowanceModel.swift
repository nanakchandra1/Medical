//
//  DailyAllowanceModel.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DailyAllowance {
    
    private var dailyAllowance : String?
    public var dailyAllowances : [String] {
        if let allowance = dailyAllowance {
            return allowance.components(separatedBy: ",")
        }
        return []
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [DailyAllowance] {
        var models: [DailyAllowance] = []
        for json in array {
            if let allowance = DailyAllowance(json: json) {
                models.append(allowance)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {

		dailyAllowance = json["daily_allowance"].string
	}
    
	func dictionaryRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary["daily_allowance"] = self.dailyAllowance

		return dictionary
	}

}
