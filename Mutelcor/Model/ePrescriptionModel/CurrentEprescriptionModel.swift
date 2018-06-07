//
//  CurrentEprescriptionModel.swift
//  Mutelcor
//
//  Created by on 11/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class EprescriptionModel {
    
    var drugName : String
    var drugInfo : String
    var attachmentList : String
    var attachmentPath : String
    var docSpecialisation : String
    var doctorName : String
    var createdAt : String
    var remark : String
    var formID: String
    var pdfFile: String
    
    required init(_ json : JSON){
        
        self.drugName = json[DictionaryKeys.drugName].stringValue
        self.drugInfo = json[DictionaryKeys.drugInfo].stringValue
        self.attachmentList = json[DictionaryKeys.attachmentList].stringValue
        self.attachmentPath = json[DictionaryKeys.attachmentPath].stringValue
        self.docSpecialisation = json[DictionaryKeys.doctorSpecialization].stringValue
        self.doctorName = json[DictionaryKeys.doctor_name].stringValue
        self.createdAt = json[DictionaryKeys.createdAt].stringValue
        self.remark = json[DictionaryKeys.remarks].stringValue
        self.formID = json[DictionaryKeys.formId].stringValue
        self.pdfFile = json[DictionaryKeys.pdfFile].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [EprescriptionModel] {
        var models:[EprescriptionModel] = []
        for json in array {
            models.append(EprescriptionModel(json))
        }
        return models
    }
    
    public class func modelsFromDictionaryDualArray(array: [JSON]) -> [[EprescriptionModel]] {
        
       var models = [[EprescriptionModel]]()
        for (column, currentData) in array.enumerated() {
            for value in currentData.arrayValue {
                if column >= models.count {
                    models.append([EprescriptionModel(value)])
                } else {
                    models[column].append(EprescriptionModel(value))
                }
            }
        }
        return models
    }
}
