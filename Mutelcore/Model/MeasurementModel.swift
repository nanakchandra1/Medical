//
//  MeasurementModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 02/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:- LabTest Model
//====================
class MeasurementHomeData {
    
    var proiority : Int?
    var vitalIcon : String?
    var superID : Int?
    var vitalCategory : Int?
    var valueConversion : String?
    var isReviewed : Int?
    var vitalName : String?
    var formID : String?
    var rating : Int?
    var vitalId : Int?
    var vitalValue : String?
    var measurementDate : String?
    var measurementTime : String?
    var vitalSubName : String?
    var unit : String?
    var mainUnit : String?
    
    init(measurementHomeData : JSON) {
        
        self.proiority = measurementHomeData["priority"].int
        self.vitalIcon = measurementHomeData["vital_icon"].stringValue
        self.superID = measurementHomeData["super_id"].int
        self.vitalCategory = measurementHomeData["vital_category"].int
        self.valueConversion = measurementHomeData["value_conversion"].stringValue
        self.isReviewed = measurementHomeData["is_reviewed"].int
        self.vitalName = measurementHomeData["vital_name"].stringValue
        self.formID = measurementHomeData["form_id"].stringValue
        self.rating = measurementHomeData["rating"].int
        self.vitalId = measurementHomeData["super_id"].int
        self.vitalValue = measurementHomeData["vital_value"].stringValue
        self.measurementDate = measurementHomeData["measurement_date"].stringValue
        self.measurementTime = measurementHomeData["measurement_time"].stringValue
        self.vitalSubName = measurementHomeData["vital_sub_name"].stringValue
        self.unit = measurementHomeData["unit"].stringValue
        self.mainUnit = measurementHomeData["main_unit"].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementHomeData] {
        
        var models :[MeasurementHomeData] = []
        
        for json in array {
            
            for data in json.arrayValue {
                
                models.append(MeasurementHomeData(measurementHomeData: data))
            }
        }
        return models
    }
}

//MARK:- Image Data Model
//=======================
class ImageDataModel {
    
    var attachments : String?
    var attachmentName : String?
    var createdAt : String?
    var createdTime : String?
    var formID : String?
    var isRevieewed : Int?
    var measurementId : String?
    var measurementDate : String?
    var measurementTime : String?
    var vitalIcon : String?
    var vitalId: String?
    var vitalName : String?
    var vitalSuperId : String?
    
    init(imageData : JSON) {
     
        self.attachments = imageData["attachments"].stringValue
        self.attachmentName = imageData["attachments_name"].stringValue
        self.createdAt = imageData["created_at"].stringValue
        self.createdTime = imageData["created_time"].stringValue
        self.formID = imageData["form_id"].stringValue
        self.isRevieewed = imageData["is_reviewed"].int
        self.measurementId = imageData["m_id"].stringValue
        self.measurementDate = imageData["measurement_date"].stringValue
        self.measurementTime = imageData["measurement_time"].stringValue
        self.vitalIcon = imageData["vital_icon"].stringValue
        self.vitalId = imageData["vital_id"].stringValue
        self.vitalName = imageData["vital_name"].stringValue
        self.vitalSuperId = imageData["vital_super_id"].stringValue
          
    }
}

//MARK:- Vital data on Measurement Home Screen
//=============================================
class VitalDataModel{
    
    var proiority : Int?
    var rating : Int?
    var unit : String?
    var vitalConversion : String?
    var vitalCategory : Int?
    var vitalIcon : String?
    var vitalId : Int?
    var vitalName : String?
    var vitalSubName : String?
    var vitalSubID : Int?
    var vitalValue : String?
    var formID : String?
    var isReviewed : Int?
    var mainUnit : String?
    var measurementDate : String?
    var measurementTime : String?
    
    
    init(vitalData : JSON) {
        
        self.proiority = vitalData["priority"].int
        self.rating = vitalData["rating"].int
        self.unit = vitalData["unit"].stringValue
        self.vitalConversion = vitalData["value_conversion"].stringValue
        self.vitalCategory = vitalData["vital_category"].int
        self.vitalIcon = vitalData["vital_icon"].stringValue
        self.vitalId = vitalData["super_id"].int
        self.vitalSubID = vitalData["vital_id"].int
        self.vitalName = vitalData["vital_name"].stringValue
        self.vitalSubName = vitalData["vital_sub_name"].stringValue
        self.vitalValue = vitalData["vital_value"].stringValue
        self.formID = vitalData["form_id"].stringValue
        self.isReviewed = vitalData["is_reviewed"].int
        self.mainUnit = vitalData["main_unit"].stringValue
        self.measurementDate = vitalData["measurement_date"].stringValue
        self.measurementTime = vitalData["measurement_time"].stringValue
        
    }
}

//MARK:- Vital List Model
//=======================
class VitalListModel{
    
    var vitalIcon : String?
    var vitalID : Int?
    var vitalName : String?
    var vitalCategory : Int?
    var subVitalCount : Int?

    init(vitalListData : JSON) {
        
        self.vitalID = vitalListData["vital_id"].int
        self.vitalIcon = vitalListData["vital_icon"].stringValue
        self.vitalName = vitalListData["vital_name"].stringValue
        self.vitalCategory = vitalListData["vital_category"].int
        self.subVitalCount = vitalListData["sub_vital_count"].int
        
    }
}

//MARK:- GraphData
//================
class GraphDataModel {
    
    var measurementDate : String?
    var valueConversion : String?
    var vitalID : Int?
    var vitalSeverity : Int?
    
    init(graphData : JSON){
        
        self.measurementDate = graphData["measurement_date"].stringValue
        self.valueConversion = graphData["value_conversion"].stringValue
        self.vitalID = graphData["vital_id"].int
        self.vitalSeverity = graphData["vital_severity"].int
        
    }
}

//MARK:- LatestThreeVitalData
//===========================
class LatestThreeVitalData {
    
    var proiority : Int?
    var rating : Int?
    var unit : String?
    var vitalConversion : String?
    var vitalCategory : Int?
    var vitalIcon : String?
    var vitalId : Int?
    var vitalName : String?
    var vitalSubName : String?
    var vitalSubID : Int?
    var vitalValue : String?
    var formID : String?
    var isReviewed : Int?
    var mainUnit : String?
    var measurementDate : String?
    var measurementTime : String?
    
    
    init(topMostVitalData : JSON) {
        
        self.proiority = topMostVitalData["priority"].int
        self.rating = topMostVitalData["rating"].int
        self.unit = topMostVitalData["unit"].stringValue
        self.vitalConversion = topMostVitalData["value_conversion"].stringValue
        self.vitalCategory = topMostVitalData["vital_category"].int
        self.vitalIcon = topMostVitalData["vital_icon"].stringValue
        self.vitalId = topMostVitalData["super_id"].int
        self.vitalSubID = topMostVitalData["vital_id"].int
        self.vitalName = topMostVitalData["vital_name"].stringValue
        self.vitalSubName = topMostVitalData["vital_sub_name"].stringValue
        self.vitalValue = topMostVitalData["vital_value"].stringValue
        self.formID = topMostVitalData["form_id"].stringValue
        self.isReviewed = topMostVitalData["is_reviewed"].int
        self.mainUnit = topMostVitalData["main_unit"].stringValue
        self.measurementDate = topMostVitalData["measurement_date"].stringValue
        self.measurementTime = topMostVitalData["measurement_time"].stringValue
        
    }
}

//MARK:- AttachmentData
//=====================
class AttachmentDataModel {
    
    var attachment : String?
    var attachmentName : String?
    var measurementDate : String?
    var measurementTime : String?
    
    init(attachmentData : JSON){
        
        self.attachment = attachmentData["attachment"].stringValue
        self.attachmentName = attachmentData["attachment_name"].stringValue
        self.measurementDate = attachmentData["measurement_date"].stringValue
        self.measurementTime = attachmentData["measurement_time"].stringValue
        
    }
}

//MARK:- MeasurementFormData
//==========================
class MeasurementFormDataModel{
    
    var id : Int?
    var vitalSubName : String?
    var unit : String?
    var mainUnit : String?
    var unitRange : String?
    var priority : Int?
    
    init(measurementFormList : JSON){
        
        self.id = measurementFormList["id"].int
        self.vitalSubName = measurementFormList["vital_sub_name"].stringValue
        self.unit = measurementFormList["unit"].stringValue
        self.mainUnit = measurementFormList["main_unit"].stringValue
        self.unitRange = measurementFormList["unit_range"].stringValue
        self.priority = measurementFormList["priority"].intValue
        
    }
}

//MARk:- Get Measurement Category
//==============================
class MeasurementCategory {
    
    var id : Int?
    var categoryName : String?
    var categoryType : Int?
    
    required init(categoryList : JSON){
        
        if let id = categoryList["id"].int {
            
            self.id = id
        }
        self.categoryName = categoryList["category_name"].stringValue
        
        if let categoryType = categoryList["category_type"].int {
            
            self.categoryType = categoryType

        }
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementCategory] {
        
        var models :[MeasurementCategory] = []
        
        for json in array {
            
            models.append(MeasurementCategory(categoryList: json))
            
        }
        return models
    }
}
