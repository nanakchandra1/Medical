//
//  PointsToRememberModel.swift
//  Mutelcor
//
//  Created by Appinventiv on 07/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class PointsToRemember {
    
    var pointsToRember : String?

    public class func modelsFromDictionaryArray(array: [JSON]) -> [PointsToRemember] {
        var models: [PointsToRemember] = []
        for json in array {
            if let remember = PointsToRemember(json: json) {
                models.append(remember)
            }
        }
        return models
    }
    
    required public init?(json: JSON) {
        pointsToRember = json.stringValue
    }
    
    func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        dictionary[DictionaryKeys.pointToRemember] = self.pointsToRember
        return dictionary
    }
}
