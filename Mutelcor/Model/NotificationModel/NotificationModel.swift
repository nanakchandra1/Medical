//
//  NotificationModel.swift
//  Mutelcor
//
//  Created by on 28/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationModel {
    
    var notificationID : Int?
    var unreadCount : Int?
    var patientID : Int?
    var notificationTitle : String?
    var notificationType : Int?
    var message : String?
    var notificationTime : String?
    var isRead : Int?
    var doctorName : String?
    var cmsID : Int?
    var cmsDescription : String?
    
    required init(_ data : JSON){
        
        guard let notificationID = data[DictionaryKeys.notificationId].int else{
            return
        }
        self.notificationID = notificationID
        
//        if let unreadCount = data["notification_id"].int {
//            self.unreadCount = unreadCount
//        }
        if let patientID = data[DictionaryKeys.patinetId].int {
            self.patientID = patientID
        }
        self.notificationTitle = data[DictionaryKeys.notificationTitle].stringValue
        if let notificationType = data[DictionaryKeys.notificationType].int {
            self.notificationType = notificationType
        }
        self.message = data[DictionaryKeys.message].stringValue
        self.notificationTime = data[DictionaryKeys.notificationTime].stringValue
        if let isRead = data[DictionaryKeys.notificationIsRead].int {
            self.isRead = isRead
        }
        self.doctorName = data[DictionaryKeys.doctor_name].stringValue
        
        let cmsid = data[DictionaryKeys.cmsID].intValue
            if cmsid != 0 {
            self.cmsID = cmsid
        }
        self.cmsDescription = data[DictionaryKeys.cmsDescription].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [NotificationModel] {
        var model = [NotificationModel]()
        for value in array{
            model.append(NotificationModel(value))
        }
        return model
    }
}


