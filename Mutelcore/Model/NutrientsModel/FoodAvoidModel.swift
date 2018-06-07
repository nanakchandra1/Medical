//
//  FoodAvoidModel.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
 
public class FoodAvoid {
    
	private var foodToAvoid : String?
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

		foodToAvoid = json["food_to_avoid"].string
	}
    
	func dictionaryRepresentation() -> JSONDictionary {

		var dictionary = JSONDictionary()

		dictionary["food_to_avoid"] = self.foodToAvoid

		return dictionary
	}

}
