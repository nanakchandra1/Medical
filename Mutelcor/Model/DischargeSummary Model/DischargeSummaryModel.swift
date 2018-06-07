//
//  DischargeSummaryModel.swift
//  Mutelcor
//
//  Created by on 24/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class DischargeSummaryModel {
    
    var id : Int?
    var doctorName : String?
    var doctorSpecialization : String?
    var doctorID : Int?
    var patientID : Int?
    var patientName : String?
    var dateAdmission : String?
    var dateSurgery : String?
    var dateDischarge : String?
    var SurgeryID : Int?
    var finalDiaognises : String?
    var procedures : String?
    var surgeryProcedure : String?
    var surgeryType: String?
    var operativeApproach : String?
    var illnessHsitory : String?
    var laboratoryData : String?
    var hospitalCourse : String?
    var dischargeMedication : String?
    var dischargeAdvice : String?
    var followAppointment : String?
    var createdAt : String?
    var updatedAt : String?
    var updatedBy : String?
    var attachment: String?
    
    init(_ data : JSON){
        guard let id = data[DictionaryKeys.cmsId].int else{
            return
        }
        self.id = id
        self.operativeApproach = data[DictionaryKeys.operativeApporoach].stringValue
        self.doctorName = data[DictionaryKeys.doctorName].stringValue
        self.doctorSpecialization = data[DictionaryKeys.doctorSpecialization].stringValue
        if let doctorID = data[DictionaryKeys.doctorID].int{
            self.doctorID = doctorID
        }
        if let patientID = data[DictionaryKeys.patinetId].int{
            self.patientID = patientID
        }
        self.patientName = data[DictionaryKeys.patientName].stringValue
        self.dateAdmission = data[DictionaryKeys.admissionDate].stringValue
        self.dateSurgery = data[DictionaryKeys.surgeryDate].stringValue
        self.dateDischarge = data[DictionaryKeys.dischargeDate].stringValue
        if let surgeryID = data[DictionaryKeys.surgeryID].int{
            self.SurgeryID = surgeryID
        }
        self.finalDiaognises = data[DictionaryKeys.finalDiagnosis].stringValue
        self.procedures = data[DictionaryKeys.procedures].stringValue
        self.surgeryProcedure = data[DictionaryKeys.surgeryName].stringValue
        self.surgeryType = data[DictionaryKeys.surgeryType].stringValue
        self.illnessHsitory = data[DictionaryKeys.illnessHistory].stringValue
        self.laboratoryData = data[DictionaryKeys.laboratoryData].stringValue
        self.hospitalCourse = data[DictionaryKeys.hospitalCourse].stringValue
        self.dischargeMedication = data[DictionaryKeys.dischargeMedication].stringValue
        self.dischargeAdvice = data[DictionaryKeys.dischargeAdvice].stringValue
        self.followAppointment = data[DictionaryKeys.followAppointment].stringValue
        self.createdAt = data[DictionaryKeys.createdAt].stringValue
        self.updatedAt = data[DictionaryKeys.updatedAt].stringValue
        self.updatedBy = data[DictionaryKeys.updatedBy].stringValue
        self.attachment = data[DictionaryKeys.attachment].stringValue
    }
    
    public class func modelsFromDictionaryDualArray(array: [JSON]) -> [DischargeSummaryModel] {
        var model = [DischargeSummaryModel]()
        for value in array{
            model.append(DischargeSummaryModel(value))
        }
        return model
    }
}

