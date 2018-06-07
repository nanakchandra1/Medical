//
//  AllSymptoms.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class AllSymptoms {
    
    var symptomId: Int?
    var symptomTags: String?
    var symptomName: String?
    var isMostCommon: Int?
    var isSymptomSelected: Bool = false
    
    required init(_ allSymptoms: JSON){
        
        guard let symptomID = allSymptoms[DictionaryKeys.symptomId].int else{
            return
        }
        self.symptomId = symptomID
        self.symptomName = allSymptoms[DictionaryKeys.symptomName].stringValue
        self.symptomTags = allSymptoms[DictionaryKeys.symptomTags].stringValue
        if let mostCommon = allSymptoms[DictionaryKeys.isChecked].int{
            self.isMostCommon = mostCommon
        }
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [AllSymptoms] {
        var model = [AllSymptoms]()
        for value in array{
            model.append(AllSymptoms(value))
        }
        return model
    }
}

