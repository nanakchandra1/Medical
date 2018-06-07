//
//  RecentSymptoms.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecentSymptoms {
    var symptomId : String?
    var symptomDate : String?
    var symptomTime : String?
    var symptomName : String?
    var symptomSeverity: Int?
    var symptomFrequency: String?
    
      init?(_ recentSymptoms : JSON){
        
        guard let symptomID = recentSymptoms[DictionaryKeys.symptomId].string, !symptomID.isEmpty else{
            return
        }
        self.symptomId = symptomID
        self.symptomDate = recentSymptoms[DictionaryKeys.symptomDate].stringValue
        self.symptomTime = recentSymptoms[DictionaryKeys.symptomTime].stringValue
        self.symptomName = recentSymptoms[DictionaryKeys.symptomName].stringValue
        
        if let severe = recentSymptoms[DictionaryKeys.symptomSeverity].int {
            self.symptomSeverity = severe
        }
        self.symptomFrequency = recentSymptoms[DictionaryKeys.symptomFrequency].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [RecentSymptoms] {
        var model = [RecentSymptoms]()
        for value in array{
            if let recentSymptom = RecentSymptoms(value) {
                model.append(recentSymptom)
            }
        }
        return model
    }
}



