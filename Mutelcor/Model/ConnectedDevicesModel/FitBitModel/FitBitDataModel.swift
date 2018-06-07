//
//  FitBitDataModel.swift
//  Mutelcor
//
//  Created by on 02/01/18.
//  Copyright © 2018 "" All rights reserved.
//

import Foundation
import SwiftyJSON

class FitBitDataModel {
    
    var date: String = ""
    var timeInterval: String = ""
    var calories: Int = 0
    
    init(json: JSON) {
        self.date = json["dateTime"].stringValue.changeDateFormat(.utcTime, .yyyyMMdd)
        
        if let date = self.date.getDateFromString(.yyyyMMdd, .utcTime){
            let interval = Date.timeIntervalSince(date)
            self.timeInterval = "\(interval)"
        }
        
        self.calories = json["value"].intValue
    }
    
    class func modelsFromDictionaryArray(data: [JSON]) -> [FitBitDataModel]{
        
        var fitBitData: [FitBitDataModel] = []
        for value in data {
            if let caloriesValue = value["value"].string, !caloriesValue.isEmpty, caloriesValue != "0"{
               fitBitData.append(FitBitDataModel.init(json: value))
            }
        }
        return fitBitData
    }
}
