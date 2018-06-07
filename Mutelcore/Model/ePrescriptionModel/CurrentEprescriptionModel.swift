//
//  CurrentEprescriptionModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 11/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class EprescriptionModel {
    
    var drugName : String?
    var drugInfo : String?
    var attachmentList : String?
    var attachmentPath : String?
    var docSpecialisation : String?
    var doctorName : String?
    var createdAt : String?
    
    required init(json : JSON){
        
        self.drugName = json["drug_name"].stringValue
        self.drugInfo = json["drug_info"].stringValue
        self.attachmentList = json["attachment_list"].stringValue
        self.attachmentPath = json["attachment_path"].stringValue
        self.docSpecialisation = json["doc_specialisation"].stringValue
        self.doctorName = json["doctor_name"].stringValue
        self.createdAt = json["created_at"].stringValue
        
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [EprescriptionModel] {
        var models:[EprescriptionModel] = []
        for json in array {
            models.append(EprescriptionModel(json: json))
        }
        return models
    }
}
