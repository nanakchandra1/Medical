//
//  UpcomingAppointment.swift
//  Mutelcor
//
//  Created by  on 03/05/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpcomingAppointmentModel {
    
    var doctorId : Int?
    var appointmentDate : Date?
    var appointmentID : String?
    var appointmentStartTime : String?
    var appointmentEndTime : String?
    var appointmentSeverity : Int?
    var appointmentStatus : Int?
    var appointmentType : Int?
    var appointmentSpecify : String?
    var appointmentSymptoms : String?
    var specification : String?
    var scheduleID : Int?
    
   required init(upcomingAppointmentData : JSON) {
        
        if let doctorID = upcomingAppointmentData[DictionaryKeys.doctorID].int{
            self.doctorId = doctorID
        }
        
        self.appointmentDate = upcomingAppointmentData[DictionaryKeys.appointmentDate].stringValue.getDateFromString(.utcTime, .yyyyMMdd)
        self.appointmentID = upcomingAppointmentData[DictionaryKeys.appointmentID].stringValue
        self.appointmentStartTime = upcomingAppointmentData[DictionaryKeys.appointmentStartTime].stringValue
        self.appointmentEndTime = upcomingAppointmentData[DictionaryKeys.appointmentEndTime].stringValue
        if let appointmentSeverity = upcomingAppointmentData[DictionaryKeys.appointmentSeverity].int{
            self.appointmentSeverity = appointmentSeverity
        }
        if let appointmentStatus = upcomingAppointmentData[DictionaryKeys.appointmentStatus].int{
            self.appointmentStatus = appointmentStatus
        }
        if let appointmentType = upcomingAppointmentData[DictionaryKeys.appointmentType].int{
            self.appointmentType = appointmentType
        }
        self.appointmentSpecify = upcomingAppointmentData[DictionaryKeys.appointmentSpecify].stringValue
        self.appointmentSymptoms = upcomingAppointmentData[DictionaryKeys.appointmentSymptoms].stringValue
        self.specification = upcomingAppointmentData[DictionaryKeys.appointmentSpecification].stringValue
        if let scheduleID = upcomingAppointmentData[DictionaryKeys.scheduleID].int{
            self.scheduleID = scheduleID
        }
    }
    
    class func modelFromDictionary(_ json : [JSON]) -> [UpcomingAppointmentModel]{
        
        var model = [UpcomingAppointmentModel]()
        
        for jsonValue in json{
         model.append(UpcomingAppointmentModel(upcomingAppointmentData: jsonValue))
        }
        return model
    }
    
    var toDictionary: [String : Any] {
        
        get{
            
            var addAppointment = [String : Any]()
            
            addAppointment[DictionaryKeys.scheduleID] = self.scheduleID
            addAppointment[DictionaryKeys.appointmentSpecification] = self.specification
            addAppointment[DictionaryKeys.appointmentType] = self.appointmentType
            addAppointment[DictionaryKeys.symptomes] = self.appointmentSymptoms
            addAppointment[DictionaryKeys.severity] = self.appointmentSeverity
            
            return addAppointment
        }
    }
}

//MARK:- Time Slot Model
//======================
class TimeSlotModel{
    var startTime : String?
    var scheduleID : Int?
    var slotEndTime : String?
    
    init(timeSlotData : JSON){
        
        self.startTime = timeSlotData[DictionaryKeys.slotStartTime].stringValue
        
        if let scheduleID = timeSlotData[DictionaryKeys.scheduleID].int{
            self.scheduleID = scheduleID
        }
        self.slotEndTime = timeSlotData[DictionaryKeys.slotEndTime].stringValue
    }
    
    class func modelFromDictionary(_ json : [JSON]) -> [TimeSlotModel]{
        
        var model = [TimeSlotModel]()
        
        for jsonValue in json{
            model.append(TimeSlotModel(timeSlotData: jsonValue))
        }
        return model
    }
}
