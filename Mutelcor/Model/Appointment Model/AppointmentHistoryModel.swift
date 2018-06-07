//
//  AppointmentHistoryModel.swift
//  Mutelcor
//
//  Created by  on 03/05/17.
//  Copyright © 2017. All rights reserved.
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
        
        self.doctorId = appointmentHistoryData[DictionaryKeys.doctorID].int
        self.appointmentDate = appointmentHistoryData[DictionaryKeys.appointmentDate].stringValue.getDateFromString(.utcTime, .yyyyMMdd)
        self.appointmentStartTime = appointmentHistoryData[DictionaryKeys.appointmentStartTime].stringValue
        self.appointmentEndTime = appointmentHistoryData[DictionaryKeys.appointmentEndTime].stringValue
        self.appointmentSeverity = appointmentHistoryData[DictionaryKeys.appointmentSeverity].int
        self.appointmentStatus = appointmentHistoryData[DictionaryKeys.appointmentStatus].int
        self.appointmentType = appointmentHistoryData[DictionaryKeys.appointmentType].int
        self.appointmentSpecify = appointmentHistoryData[DictionaryKeys.appointmentSpecify].stringValue
        self.appointmentSymptoms = appointmentHistoryData[DictionaryKeys.appointmentSymptoms].stringValue

    }
}
