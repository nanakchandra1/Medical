//
//  UpcomingAppointment.swift
//  Mutelcore
//
//  Created by Ashish on 03/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
    
    init(upcomingAppointmentData : JSON) {
        
        self.doctorId = upcomingAppointmentData["doc_id"].int
        self.appointmentDate = upcomingAppointmentData["appointment_date"].stringValue.dateFromString
        self.appointmentID = upcomingAppointmentData["appointment_id"].stringValue
        self.appointmentStartTime = upcomingAppointmentData["appointment_start_time"].stringValue
        self.appointmentEndTime = upcomingAppointmentData["appointment_end_time"].stringValue
        self.appointmentSeverity = upcomingAppointmentData["appointment_severity"].int
        self.appointmentStatus = upcomingAppointmentData["appointment_status"].int
        self.appointmentType = upcomingAppointmentData["appointment_type"].int
        self.appointmentSpecify = upcomingAppointmentData["appointment_specify"].stringValue
        self.appointmentSymptoms = upcomingAppointmentData["appointment_symtomps"].stringValue
        self.specification = upcomingAppointmentData["specification"].stringValue
        self.scheduleID = upcomingAppointmentData["schedule_id"].int
        
    }
    
    var toDictionary: [String : Any] {
        
        get{
            
            var addAppointment = [String : Any]()
            
            addAppointment["schedule_id"] = self.scheduleID
            addAppointment["specification"] = self.specification
            addAppointment["appointment_type"] = self.appointmentType
            addAppointment["symptomes"] = self.appointmentSymptoms
            addAppointment["severity"] = self.appointmentSeverity
            
            return addAppointment
        }
        set{
            
            
            
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
        
        self.startTime = timeSlotData["slot_start_time"].stringValue
        self.scheduleID = timeSlotData["schedule_id"].int
        self.slotEndTime = timeSlotData["slot_end_time"].stringValue
        
    }
}
