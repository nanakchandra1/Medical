//
//  MeasurementModel.swift
//  Mutelcor
//
//  Created by on 02/06/17.
//  Copyright © 2017. All rights reserved.
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
    var valueConversion : String = ""
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
    var categoryType: Int?
    
    init(measurementHomeData : JSON) {
        
        if let priority = measurementHomeData[DictionaryKeys.lastSeenPriorty].int {
            self.proiority = priority
        }
        if let categoryType = measurementHomeData[DictionaryKeys.categoryType].int {
            self.categoryType = categoryType
        }
        self.vitalIcon = measurementHomeData[DictionaryKeys.lastSeenVitalIcon].stringValue
        if let superID = measurementHomeData[DictionaryKeys.lastSeenVitalSuperID].int {
            self.superID = superID
        }
        if let vitalCategory = measurementHomeData[DictionaryKeys.vitalCategory].int {
            self.vitalCategory = vitalCategory
        }
        self.valueConversion = measurementHomeData[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        
        if let isReviewed = measurementHomeData[DictionaryKeys.isReviewed].int {
            self.isReviewed = isReviewed
        }
        self.vitalName = measurementHomeData[DictionaryKeys.lastSeenVitalName].stringValue
        self.formID = measurementHomeData[DictionaryKeys.formId].stringValue
        
        if let rating = measurementHomeData[DictionaryKeys.rating].int {
            self.rating = rating
        }
        if let vitalId = measurementHomeData[DictionaryKeys.lastSeenVitalSuperID].int {
            self.vitalId = vitalId
        }
        self.vitalValue = measurementHomeData[DictionaryKeys.vitalValue].stringValue
        self.measurementDate = measurementHomeData[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = measurementHomeData[DictionaryKeys.measurementTime].stringValue
        self.vitalSubName = measurementHomeData[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.unit = measurementHomeData[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.mainUnit = measurementHomeData[DictionaryKeys.mainUnit].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementHomeData] {
        
        var models :[MeasurementHomeData] = []
        
        for json in array {
            if let data = json.arrayValue.first {
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
    var isReviewed : Int?
    var measurementId : String?
    var measurementDate : String?
    var measurementTime : String?
    var vitalIcon : String?
    var vitalId: String?
    var vitalName : String?
    var vitalSuperId : String?
    var categoryType : Int?
    
    init(imageData : JSON) {
     
        self.attachments = imageData[DictionaryKeys.measurement_Attachment].stringValue
        self.attachmentName = imageData[DictionaryKeys.attachmentsName].stringValue
        self.createdAt = imageData[DictionaryKeys.createdAt].stringValue
        self.createdTime = imageData[DictionaryKeys.createdTime].stringValue
        self.formID = imageData[DictionaryKeys.formId].stringValue
        
        if let isReviewed = imageData[DictionaryKeys.isReviewed].int {
          self.isReviewed = isReviewed
        }
        if let categoryType = imageData[DictionaryKeys.categoryType].int {
            self.categoryType = categoryType
        }
        self.measurementId = imageData[DictionaryKeys.measurementId].stringValue
        self.measurementDate = imageData[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = imageData[DictionaryKeys.measurementTime].stringValue
        self.vitalIcon = imageData[DictionaryKeys.lastSeenVitalIcon].stringValue
        self.vitalId = imageData[DictionaryKeys.vitalID].stringValue
        self.vitalName = imageData[DictionaryKeys.lastSeenVitalName].stringValue
        self.vitalSuperId = imageData[DictionaryKeys.vitalSuperID].stringValue
          
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [ImageDataModel] {
        
        var models :[ImageDataModel] = []
        
        for json in array {
                models.append(ImageDataModel(imageData: json))
        }
        return models
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
        
        if let priority = vitalData[DictionaryKeys.lastSeenPriorty].int {
            self.proiority = priority
        }
        if let rating = vitalData[DictionaryKeys.rating].int {
            self.rating = rating
        }
        self.unit = vitalData[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.vitalConversion = vitalData[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        if let vitalCategory = vitalData[DictionaryKeys.vitalCategory].int {
            self.vitalCategory = vitalCategory
        }
        
        self.vitalIcon = vitalData[DictionaryKeys.lastSeenVitalIcon].stringValue
        if let vitalId = vitalData[DictionaryKeys.lastSeenVitalSuperID].int {
            self.vitalId = vitalId
        }
        if let vitalSubID = vitalData[DictionaryKeys.vitalID].int {
            self.vitalSubID = vitalSubID
        }
        self.vitalName = vitalData[DictionaryKeys.lastSeenVitalName].stringValue
        self.vitalSubName = vitalData[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.vitalValue = vitalData[DictionaryKeys.vitalValue].stringValue
        self.formID = vitalData[DictionaryKeys.formId].stringValue
        if let isReviewed = vitalData[DictionaryKeys.isReviewed].int {
            self.isReviewed = isReviewed
        }
        self.mainUnit = vitalData[DictionaryKeys.mainUnit].stringValue
        self.measurementDate = vitalData[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = vitalData[DictionaryKeys.measurementTime].stringValue
        
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
    var categoryType: Int?

    required init(vitalListData : JSON) {
        
        if let vitalID = vitalListData[DictionaryKeys.vitalID].int{
            self.vitalID = vitalID
        }
        if let categoryType = vitalListData[DictionaryKeys.categoryType].int {
            self.categoryType = categoryType
        }
        
        self.vitalIcon = vitalListData[DictionaryKeys.lastSeenVitalIcon].stringValue
        self.vitalName = vitalListData[DictionaryKeys.lastSeenVitalName].stringValue
        
        if let vitalCategory = vitalListData[DictionaryKeys.vitalCategory].int{
            self.vitalCategory = vitalCategory
        }
        
        if let subVitalCount = vitalListData[DictionaryKeys.subVitalCount].int{
            self.subVitalCount = subVitalCount
        }        
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [VitalListModel] {
        
        var models :[VitalListModel] = []
        
        for json in array {
            models.append(VitalListModel(vitalListData: json))
        }
        return models
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
        
        self.measurementDate = graphData[DictionaryKeys.measurementDate].stringValue
        self.valueConversion = graphData[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        if let vitalID = graphData[DictionaryKeys.vitalID].int{
            self.vitalID = vitalID
        }
        self.vitalSeverity = graphData[DictionaryKeys.lastSeenVitalSeverity].int
        
    }
}

//MARK:- Measurement TabularData
//==============================
class MeasurementTablurData {
    
    var id : Int?
    var valueConversion : String?
    var patientID : Int?
    var docID : Int?
    var vitalSuperID : Int?
    var vitalSubName : String?
    var vitalValue : String?
    var measurementdate : String?
    var isUpdated : Int?
    var isDeleted: Int?
    var vitalSeverity : Int?
    var measurementTime : String?
    var formID : String?
    var vitalID: Int?
    var unit : String?
    var unitRange : String?
    
 init(jsonData : JSON){
        
        if let id = jsonData[DictionaryKeys.measurementId].int{
         self.id = id
        }
        
        self.valueConversion = jsonData[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        
        if let patientID = jsonData[DictionaryKeys.patinetId].int {
            self.patientID = patientID
        }
        
        if let doctorID = jsonData[DictionaryKeys.doctorID].int {
            self.docID = doctorID
        }
        
        if let vitalSuperID = jsonData[DictionaryKeys.vitalSuperID].int {
            self.vitalSuperID = vitalSuperID
        }
        
        self.vitalSubName = jsonData[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.vitalValue = jsonData[DictionaryKeys.vitalValue].stringValue
        self.measurementdate = jsonData[DictionaryKeys.measurementDate].stringValue
        
        if let isUpdated = jsonData[DictionaryKeys.isUpdated].int{
          self.isUpdated = isUpdated
        }
        
        if let isdeleted = jsonData[DictionaryKeys.isUpdated].int{
            self.isDeleted = isdeleted
        }
        
        if let vitalSeverity = jsonData[DictionaryKeys.lastSeenVitalSeverity].int{
            self.vitalSeverity = vitalSeverity
        }
        
        self.measurementTime = jsonData[DictionaryKeys.measurementTime].stringValue
        self.formID = jsonData[DictionaryKeys.formId].stringValue
        
        if let vitalID = jsonData[DictionaryKeys.vitalID].int {
            self.vitalID = vitalID
        }
        
        self.unit = jsonData[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.unitRange = jsonData[DictionaryKeys.unitRange].stringValue
    }
    
    class func modelFromJsonArray(_ data : [JSON]) -> [[MeasurementTablurData]] {
        var measurementTabularData = [[MeasurementTablurData]]()
        
        for (column, measurementData) in data.enumerated() {
            for value in measurementData.arrayValue {
                if column >= measurementTabularData.count {
                    measurementTabularData.append([MeasurementTablurData(jsonData: value)])
                } else {
                    measurementTabularData[column].append(MeasurementTablurData(jsonData: value))
                }
            }
        }
        return measurementTabularData
    }
}

class MeasurementTabularSubVital {
    
    var subVitalID: Int?
    var mainUnit: String?
    var priority: Int?
    var unit: String?
    var unitRange: String?
    var vitalSubname: String?
    
    init(json: JSON) {
        
        guard let id = json[DictionaryKeys.cmsId].int else{
            return
        }
        self.subVitalID = id
        self.mainUnit = json[DictionaryKeys.mainUnit].stringValue
        self.priority = json[DictionaryKeys.lastSeenPriorty].intValue
        self.unit = json[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.unitRange = json[DictionaryKeys.unitRange].stringValue
        self.vitalSubname = json[DictionaryKeys.lastSeenVitalSubName].stringValue
    }
    
    class func modelFromJsonArray(_ data : [JSON]) -> [MeasurementTabularSubVital] {
        var measurementTabularSubVitalsData = [MeasurementTabularSubVital]()
        
        for subvitals in data {
            measurementTabularSubVitalsData.append(MeasurementTabularSubVital.init(json: subvitals))
        }
        return measurementTabularSubVitalsData
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
        
        if let priority = topMostVitalData[DictionaryKeys.lastSeenPriorty].int {
            
            self.proiority = priority
        }
        if let rating = topMostVitalData[DictionaryKeys.rating].int {
            
            self.rating = rating
        }
        self.unit = topMostVitalData[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.vitalConversion = topMostVitalData[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        if let vitalCategory = topMostVitalData[DictionaryKeys.vitalCategory].int {
            
            self.vitalCategory = vitalCategory
        }
        
        self.vitalIcon = topMostVitalData[DictionaryKeys.lastSeenVitalIcon].stringValue
        if let vitalId = topMostVitalData[DictionaryKeys.lastSeenVitalSuperID].int {
            
            self.vitalId = vitalId
        }
        if let vitalSubID = topMostVitalData[DictionaryKeys.vitalID].int {
            
            self.vitalSubID = vitalSubID
        }
        self.vitalName = topMostVitalData[DictionaryKeys.lastSeenVitalName].stringValue
        self.vitalSubName = topMostVitalData[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.vitalValue = topMostVitalData[DictionaryKeys.vitalValue].stringValue
        self.formID = topMostVitalData[DictionaryKeys.formId].stringValue
        if let isReviewed = topMostVitalData[DictionaryKeys.isReviewed].int {
            
            self.isReviewed = isReviewed
        }
        self.mainUnit = topMostVitalData[DictionaryKeys.mainUnit].stringValue
        self.measurementDate = topMostVitalData[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = topMostVitalData[DictionaryKeys.measurementTime].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [LatestThreeVitalData] {
        
        var models :[LatestThreeVitalData] = []
        
        for json in array {
            models.append(LatestThreeVitalData(topMostVitalData: json))
        }
        return models
    }
}

//MARK:- AttachmentData
//=====================
class AttachmentDataModel {
    
    var attachment : String?
    var attachmentName : String?
    var measurementDate : String?
    var measurementTime : String?
    
    required init(attachmentData : JSON){
        
        self.attachment = attachmentData[DictionaryKeys.attachment].stringValue
        self.attachmentName = attachmentData[DictionaryKeys.attachmentName].stringValue
        self.measurementDate = attachmentData[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = attachmentData[DictionaryKeys.measurementTime].stringValue
        
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [AttachmentDataModel] {
        
        var models :[AttachmentDataModel] = []
        
        for json in array {
            models.append(AttachmentDataModel(attachmentData: json))
        }
        return models
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
        
        if let id = measurementFormList[DictionaryKeys.cmsId].int{
            
            self.id = id
        }
        self.vitalSubName = measurementFormList[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.unit = measurementFormList[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.mainUnit = measurementFormList[DictionaryKeys.mainUnit].stringValue
        self.unitRange = measurementFormList[DictionaryKeys.unitRange].stringValue
        
        if let priority = measurementFormList[DictionaryKeys.lastSeenPriorty].int{
            self.priority = priority
        }
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementFormDataModel] {
        
        var models :[MeasurementFormDataModel] = []
        
        for json in array {
            models.append(MeasurementFormDataModel(measurementFormList: json))
        }
        return models
    }
}

//MARk:- Get Measurement Category
//==============================
class MeasurementCategory {
    
    var id : Int?
    var categoryName : String?
    var categoryType : Int?
    
    required init(categoryList : JSON){
        
        if let id = categoryList[DictionaryKeys.cmsId].int {
            self.id = id
        }
        self.categoryName = categoryList[DictionaryKeys.categoryName].stringValue
        if let categoryType = categoryList[DictionaryKeys.categoryType].int {
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
