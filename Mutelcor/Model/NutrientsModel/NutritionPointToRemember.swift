//
//  NutritionPointToRemember.swift
//  Mutelcor
//
//  Created by Appinventiv on 07/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

public class NutritionPointToRemember {
    
    var pointToRemember : String?
    public var dailyAllowances : [String] {
        if let allowance = pointToRemember {
            return allowance.components(separatedBy: ",")
        }
        return []
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [NutritionPointToRemember] {
        var models: [NutritionPointToRemember] = []
        for json in array {
            if let allowance = NutritionPointToRemember(json: json) {
                models.append(allowance)
            }
        }
        return models
    }
    
    required public init?(json: JSON) {
        pointToRemember = json[DictionaryKeys.pointToRemember].string
    }
    
    func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        dictionary[DictionaryKeys.pointToRemember] = self.pointToRemember
        return dictionary
    }
}
