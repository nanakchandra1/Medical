//
//  FoodAvoidModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON
 
public class FoodAvoid {
    
	var foodToAvoid : String?
    public var foodsToAvoid : [String] {
        if let foods = foodToAvoid {
            return foods.components(separatedBy: ",")
        }
        return []
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [FoodAvoid] {
        var models :[FoodAvoid] = []
        for json in array {
            if let avoid = FoodAvoid(json: json) {
                models.append(avoid)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
		foodToAvoid = json[DictionaryKeys.foodToAvoid].string
	}
    
	func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
		dictionary[DictionaryKeys.foodToAvoid] = self.foodToAvoid
		return dictionary
	}

}
