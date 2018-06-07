//
//  ReminderModel.swift
//  Mutelcor
//
//  Created by Aakash on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class Reminder {
    
    var serverId: Int
    var localIds: [String]
    var patientId: Int
    
    var reminderType: Int
    var eventName: String
    var recurringDays: Set<Int>
    var recurringDaymonth: Int
    var description: String
    var eventSchedule: Int
    var dosage: String
    var instruction: String
    var eventType: Int
    
    
    var isDeleted: Bool
    var isUpdate: Bool
    
    private var reminder_time_once: String
    private var reminder_time_twice: String
    private var reminder_time_thrice: String
    private var start_date: String
    private var end_date: String
    private var created_at: String
    private var updated_at: String
    
    var startDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: start_date)
    }
    
    var endDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: end_date)
    }
    
    var creationDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: created_at)
    }
    
    var updationDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: updated_at)
    }
    
    var reminderTimeOnce: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: reminder_time_once)
    }
    var reminderTimeTwice: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: reminder_time_twice)
    }
    var reminderTimeThrice: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: reminder_time_thrice)
    }
    
    class func modelsFromArray(_ array: [JSON]) -> [Reminder] {
        var models: [Reminder] = []
        for json in array {
            if let reminder = Reminder(json: json) {
                models.append(reminder)
            }
        }
        return models
    }
    
    required init?(json: JSON) {
        guard let patientId = json[DictionaryKeys.patinetId].int, let eventServerId = json[DictionaryKeys.eventID].int, let reminderType = json[DictionaryKeys.reminderType].int else {
            return nil
        }
        
        self.serverId               = eventServerId
        self.patientId              = patientId
        self.reminderType           = reminderType
        
        localIds = []
        for json in json[DictionaryKeys.appointmentGoogleEventID].arrayValue {
            localIds.append(json.stringValue)
        }
        
        recurringDays = []
        for day in json[DictionaryKeys.recurr_day].stringValue.components(separatedBy: ",") {
            if let intValue = Int(day) {
                recurringDays.insert(intValue)
            }
        }
        
        eventName                   = json[DictionaryKeys.eventName].stringValue
        eventSchedule               = json[DictionaryKeys.eventSchedule].intValue
        dosage                      = json[DictionaryKeys.dosage].stringValue
        instruction                 = json[DictionaryKeys.instruction].stringValue
        recurringDaymonth           = json[DictionaryKeys.recurrDayMonth].intValue
        
        isDeleted                   = json[DictionaryKeys.isDeleted].boolValue
        isUpdate                    = json[DictionaryKeys.isUpdated].boolValue
        
        description                 = json[DictionaryKeys.cmsDescription].stringValue
        reminder_time_once          = json[DictionaryKeys.once].stringValue
        reminder_time_twice         = json[DictionaryKeys.twice].stringValue
        reminder_time_thrice        = json[DictionaryKeys.thrice].stringValue
        start_date                  = json[DictionaryKeys.startDate].stringValue
        end_date                    = json[DictionaryKeys.end_Date].stringValue
        created_at                  = json[DictionaryKeys.createdAt].stringValue
        updated_at                  = json[DictionaryKeys.updatedAt].stringValue
        eventType                   = json[DictionaryKeys.eventType].intValue
    }
    
    func jsonRepresentation() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        
        dictionary[DictionaryKeys.eventID]          = serverId
        dictionary[DictionaryKeys.patinetId]              = patientId
        dictionary[DictionaryKeys.eventName]        = eventName
        dictionary[DictionaryKeys.eventSchedule]    = eventSchedule
        dictionary[DictionaryKeys.dosage]            = dosage
        dictionary[DictionaryKeys.instruction]       = instruction
        
        dictionary[DictionaryKeys.isDeleted]        = isDeleted
        dictionary[DictionaryKeys.isUpdated]        = isUpdate
        
        dictionary[DictionaryKeys.reminderTime]     = reminder_time_once
        dictionary[DictionaryKeys.startDate]        = start_date
        dictionary[DictionaryKeys.end_Date]          = end_date
        dictionary[DictionaryKeys.createdAt]        = created_at
        dictionary[DictionaryKeys.updatedAt]        = updated_at
        
        dictionary[DictionaryKeys.appointmentGoogleEventID]   = localIds
        
        var recurr_days = ""
        for day in recurringDays {
            recurr_days += "\(day)"
        }
        
        dictionary[DictionaryKeys.recurr_day]        = recurr_days
        
        return dictionary
    }
}

