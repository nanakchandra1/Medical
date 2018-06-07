//
//  LogBookModel.swift
//  Mutelcor
//
//  Created by on 21/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class LogBookModel {
    
    var logId : Int?
    var patientId : Int?
    var logType :Int?
    var logTitle : String?
    var logTime : String?
    var logValue : String?
    var createdAt : String?
    var year : String?
    
   required init(_ logBookValues : JSON){
        
        if let logID = logBookValues[DictionaryKeys.logID].int{
            self.logId = logID
        }
        if let patientID = logBookValues[DictionaryKeys.patinetId].int{
            self.patientId = patientID
        }
        if let logType = logBookValues[DictionaryKeys.logType].int{
            self.logType = logType
        }
        
        self.logTitle = logBookValues[DictionaryKeys.logTitle].stringValue
        self.logTime = logBookValues[DictionaryKeys.logTime].stringValue
        self.logValue = logBookValues[DictionaryKeys.logValue].stringValue
        self.createdAt = logBookValues[DictionaryKeys.createdAt].stringValue
        self.year = logBookValues[DictionaryKeys.year1].stringValue
    }
    
    public class func modelsFromDictionaryArray(data: [JSON]) -> [LogBookModel] {
        var models = [LogBookModel]()
        
        for logBookData in data{
            models.append(LogBookModel(logBookData))
        }
        return models
    }
}
