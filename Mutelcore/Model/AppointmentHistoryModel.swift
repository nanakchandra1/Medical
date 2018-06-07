//
//  AppointmentHistoryModel.swift
//  Mutelcore
//
//  Created by Ashish on 03/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppointmentHistoryModel {
    
    var doctorId : Int?
    var appointmentDate : Date?
    var appointmentStartTime : String?
    var appointmentEndTime : String?
    var appointmentSeverity : Int?
    var appointmentStatus : Int?
    var appointmentType : Int?
    var appointmentSpecify : String?
    var appointmentSymptoms : String?
    
    init(appointmentHistoryData : JSON) {
        
        self.doctorId = appointmentHistoryData["doc_id"].int
        self.appointmentDate = appointmentHistoryData["appointment_date"].stringValue.dateFromString
        self.appointmentStartTime = appointmentHistoryData["appointment_start_time"].stringValue
        self.appointmentEndTime = appointmentHistoryData["appointment_end_time"].stringValue
        self.appointmentSeverity = appointmentHistoryData["appointment_severity"].int
        self.appointmentStatus = appointmentHistoryData["appointment_status"].int
        self.appointmentType = appointmentHistoryData["appointment_type"].int
        self.appointmentSpecify = appointmentHistoryData["appointment_specify"].stringValue
        self.appointmentSymptoms = appointmentHistoryData["appointment_symtomps"].stringValue
        
        print(appointmentHistoryData["appointment_symtomps"].stringValue)
        print(appointmentHistoryData["appointment_specify"].stringValue)

    }
}

//MARK:- Upcoming Appointment
//===========================





//MARK:- Appointment History
//==========================
//{
//    "error_code": 200,
//    "error_string": "Your appointment history fetched successfully",
//    "response": [
//    {
//    "doc_id": 1,
//    "appointment_date": "2017-05-01T00:00:00.000Z",
//    "appointment_start_time": "10:45:00",
//    "appointment_end_time": "11:00:00",
//    "appointment_severity": 1,
//    "appointment_status": 3,
//    "appointment_type": 1,
//    "appointment_specify": "head pain,fever",
//    "appointment_symtomps": "other"
//    },
//    {
//    "doc_id": 1,
//    "appointment_date": "2017-04-24T00:00:00.000Z",
//    "appointment_start_time": "10:00:00",
//    "appointment_end_time": "10:15:00",
//    "appointment_severity": 0,
//    "appointment_status": 2,
//    "appointment_type": 0,
//    "appointment_specify": "nausea",
//    "appointment_symtomps": "Stomachache, other"
//    }
//    ]
//}
