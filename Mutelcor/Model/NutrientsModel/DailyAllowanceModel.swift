//
//  DailyAllowanceModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DailyAllowance {
    
    var dailyAllowance : String?
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
		dailyAllowance = json[DictionaryKeys.dailyAllowances].string
	}
    
	func jsonRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()
		dictionary[DictionaryKeys.dailyAllowances] = self.dailyAllowance
		return dictionary
	}
}
