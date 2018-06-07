//
//  PatientMessageModel.swift
//  Mutelcor
//
//  Created by on 27/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class PatientMessageModel {
    
    var messageID : Int?
    var lastMessage : String?
    var personID : Int?
    var messageTime : String?
    var personName : String?
    var docSpecailization : String?
    var doctorPic : String?
    var messageUnreadCount : Int?
    
    init(_ data : JSON){
        
        if let messageID = data[DictionaryKeys.messageID].int{
            self.messageID = messageID
        }
        self.lastMessage = data[DictionaryKeys.message].stringValue
        if let personID = data[DictionaryKeys.personID].int{
            self.personID = personID
        }
        self.messageTime = data[DictionaryKeys.messageTime].stringValue
        self.personName = data[DictionaryKeys.doctor_name].stringValue
        self.docSpecailization = data[DictionaryKeys.doctorSpecialization].stringValue
        self.doctorPic = data[DictionaryKeys.doctorPic].stringValue
        if let unreadCount = data[DictionaryKeys.unreadCount].int{
            self.messageUnreadCount = unreadCount
        }
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [PatientMessageModel] {
        var model = [PatientMessageModel]()
        for value in array{
            model.append(PatientMessageModel(value))
        }
        return model
    }
}


