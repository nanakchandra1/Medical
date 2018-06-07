//
//  AppUserDefaults.swift
//  AppUserDefaults
//
//  Created by Gurdeep on 15/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AppUserDefaults{

}

extension AppUserDefaults {
    
    static func value(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            return JSON.null
//            fatalError("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key,
                      fallBackValue : T,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            //printlnDebug("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        let calendarIdentifier = AppUserDefaults.value(forKey: .eventStoreId, fallBackValue: "")
        let sourceIdentifier = AppUserDefaults.value(forKey: .eventStoreSourceId, fallBackValue: "")
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        
        AppUserDefaults.save(value: calendarIdentifier.stringValue, forKey: .eventStoreId)
        AppUserDefaults.save(value: sourceIdentifier.stringValue, forKey: .eventStoreSourceId)
    }
    
//    Save UserDetail
//    ===============
    static func saveUserDetail(_ userData : JSON){
        
        //printlnDebug(userData)
        
        if let patient_id = userData["p_id"].int{
            AppUserDefaults.save(value: patient_id, forKey: .userId)
        }
        if let patient_pic = userData["p_pic"].string{
            AppUserDefaults.save(value: patient_pic, forKey: .patientpic)
        }
        if let ptientUnqID = userData["p_uhid"].string{
            AppUserDefaults.save(value: ptientUnqID, forKey: .uhId)
        }
        if let national_id = userData["p_national_id"].string{
            AppUserDefaults.save(value: national_id, forKey: .nationalID)
        }
        if let patient_Title = userData["p_title"].string{
            AppUserDefaults.save(value: patient_Title, forKey: .patientTile)
        }
        if let patient_Name = userData["p_name"].string{
            AppUserDefaults.save(value: patient_Name, forKey: .patientName)
        }
        if let patientFirstname = userData["p_first_name"].string {
            AppUserDefaults.save(value: patientFirstname, forKey: .firstname)
        }
        if let patient_middle_Name = userData["p_middle_name"].string{
            AppUserDefaults.save(value: patient_middle_Name, forKey: .middleName)
        }
        if let patient_Last_Name = userData["p_last_name"].string{
            AppUserDefaults.save(value: patient_Last_Name, forKey: .lastName)
        }
        if let patientGender = userData["p_gender"].int{
            AppUserDefaults.save(value: patientGender, forKey: .p_gender)
        }
        if let patientFatherTitle = userData["p_father_title"].string{
            AppUserDefaults.save(value: patientFatherTitle, forKey: .fatherTitle)
        }
        if let patientSpouseTitle = userData["p_spouse_title"].string{
            AppUserDefaults.save(value: patientSpouseTitle, forKey: .spouseTitle)
        }
        if let patientFathername = userData["p_father_name"].string{
            AppUserDefaults.save(value: patientFathername, forKey: .fatherName)
        }
        if let patientSpouseName = userData["p_spouse_name"].string{
            AppUserDefaults.save(value: patientSpouseName, forKey: .spouseName)
        }
        if let patientDob = userData["p_dob"].string{
            AppUserDefaults.save(value: patientDob, forKey: .patientDob)
        }
        if let patientMobileNumber = userData["p_mobile"].string{
            AppUserDefaults.save(value: patientMobileNumber, forKey: .patientMobileNumber)
        }
        if let patientEmail = userData["p_email"].string{
            AppUserDefaults.save(value: patientEmail, forKey: .email)
        }
        if let accessToken = userData["access_token"].string{
            AppUserDefaults.save(value: accessToken, forKey: .accessToken)
        }
        if let stepVerified = userData["step_verified"].int{
            AppUserDefaults.save(value: stepVerified, forKey: .stepVerified)
        }
        if let mobileVerified = userData["is_mobile_verified"].int{
            AppUserDefaults.save(value: mobileVerified, forKey: .mobileVerified)
        }
        if let rating = userData["rating"].int{
            AppUserDefaults.save(value: rating, forKey: .rating)
        }
       let patientDoctorID = userData["p_doctor_id"].stringValue
            AppUserDefaults.save(value: patientDoctorID, forKey: .doctorId)
        
        if let doctorName = userData["doc_name"].string{
            AppUserDefaults.save(value: doctorName, forKey: .doctorName)
        }
        if let patientHospitalID = userData["p_hosp_id"].int{
            AppUserDefaults.save(value: patientHospitalID, forKey: .hopitalID)
        }
        if let patientSpeciality = userData["p_speciality"].string{
            AppUserDefaults.save(value: patientSpeciality, forKey: .patientSpeciality)
        }
        if let ethinicityId = userData["ethnicity_id"].int{
            AppUserDefaults.save(value: ethinicityId, forKey: .ethinicityId)
        }
        if let patientLastVisit = userData["p_last_visit"].string{
            AppUserDefaults.save(value: patientLastVisit, forKey: .patientLastVisit)
        }
        if let surgeryId = userData["surgery_id"].int{
            AppUserDefaults.save(value: surgeryId, forKey: .surgeryId)
        }
        if let patientReviewedOn = userData["p_reviewed_on"].string{
            AppUserDefaults.save(value: patientReviewedOn, forKey: .patientReviewedOn)
        }
        if let doctorSpecialization = userData["doc_specialisation"].string{
            AppUserDefaults.save(value: doctorSpecialization, forKey: .doctorSpecialization)
        }
    }
    
//    Save UserMedical Detail
//    =======================
    static func saveUserMedicalDetail(_ medicalInfo : JSON){

        //printlnDebug(medicalInfo)
        
        if let patientHeightType = medicalInfo["p_height_type"].int{
            AppUserDefaults.save(value: patientHeightType, forKey: .patientHeightType)
        }
        if let patientHeight = medicalInfo["p_height"].int{
            AppUserDefaults.save(value: patientHeight, forKey: .patientHeight)
        }
        if let patientHeight1 = medicalInfo["p_height1"].int{
            AppUserDefaults.save(value: patientHeight1, forKey: .patientHeight1)
        }
        if let patientHeight2 = medicalInfo["p_height2"].int{
            AppUserDefaults.save(value: patientHeight2, forKey: .patientHeight2)
        }
        if let patientWeight = medicalInfo["p_weight"].int{
            AppUserDefaults.save(value: patientWeight, forKey: .patientWeight)
        }
        if let patientWeightType = medicalInfo["p_weight_type"].int{
            AppUserDefaults.save(value: patientWeightType, forKey: .weightType)
        }
        if let patientBloodGroup = medicalInfo["p_blood_group"].string{
            AppUserDefaults.save(value: patientBloodGroup, forKey: .bloddGroup)
        }
        if let hypertension = medicalInfo["p_hipertension"].int{
            AppUserDefaults.save(value: hypertension, forKey: .hyperTension)
        }
        if let diabities = medicalInfo["p_diabetes"].int{
            AppUserDefaults.save(value: diabities, forKey: .diabities)
        }
        if let patientHyperTensionFather = medicalInfo["p_hipertension_father"].int{
            AppUserDefaults.save(value: patientHyperTensionFather, forKey: .fatherHyperTension)
        }
        if let patientHyperTensionMother = medicalInfo["p_hipertension_mother"].int{
            AppUserDefaults.save(value: patientHyperTensionMother, forKey: .motherHyperTension)
        }
        if let patientDiabitiesFather = medicalInfo["p_diabetes_father"].int{
            AppUserDefaults.save(value: patientDiabitiesFather, forKey: .fatherDiabities)
        }
        if let patientDiabitiesMother = medicalInfo["p_diabetes_mother"].int{
            AppUserDefaults.save(value: patientDiabitiesMother, forKey: .motherDiabities)
        }
        if let smoking = medicalInfo["p_smoking"].int{
            AppUserDefaults.save(value: smoking, forKey: .smoking)
        }
    }
    
    //    save Medical Category Info
    static func saveMedicalCategoryInfo(_ medicalCategoryInfo : JSON){
        
        //printlnDebug(medicalCategoryInfo)
        
        if let patientAllergy = medicalCategoryInfo["p_allergies"].string{
            AppUserDefaults.save(value: patientAllergy, forKey: .patientAllergy)
        }
        if let foodDescription = medicalCategoryInfo["food_description"].string{
            AppUserDefaults.save(value: foodDescription, forKey: .foodDecription)
        }
        if let familyAllergy = medicalCategoryInfo["f_allergies"].string{
            AppUserDefaults.save(value: familyAllergy, forKey: .familyAllergy)
        }
        if let previousAllergy = medicalCategoryInfo["prev_allergies"].string{
            AppUserDefaults.save(value: previousAllergy, forKey: .previousAllergy)
        }
        if let foodCategory = medicalCategoryInfo["food_category"].int{
            AppUserDefaults.save(value: foodCategory, forKey: .foodCategory)
        }
    }
    
    //    save Treatment Info
    static func saveTreatmentDetailInfo(_ tretmentDetailInfo : JSON){
        
        if let dateOfAdmission = tretmentDetailInfo["date_admission"].string{
            
            AppUserDefaults.save(value: dateOfAdmission, forKey: .dateOfAdmission)
        }
        if let dateOfSurgery = tretmentDetailInfo["date_surgery"].string{
            AppUserDefaults.save(value: dateOfSurgery, forKey: .dateOfSurgery)
        }
        if let dateofDischarge = tretmentDetailInfo["date_discharge"].string{
            AppUserDefaults.save(value: dateofDischarge, forKey: .dateOfDischarge)
        }
    }
    
    //    save addressDetail
    static func saveUserAddressDetail(_ addressInfo : JSON){
        
        if let patientIsdCode = addressInfo["p_isd_code"].string{
            AppUserDefaults.save(value: patientIsdCode, forKey: .patientISDCode)
        }
        if let patientState = addressInfo["p_state"].int{
            AppUserDefaults.save(value: patientState, forKey: .patientState)
        }
        if let patientCountry = addressInfo["p_country"].string{
            AppUserDefaults.save(value: patientCountry, forKey: .patientCountry)
        }
        if let patientCity = addressInfo["p_city"].int{
            AppUserDefaults.save(value: patientCity, forKey: .patientCity)
        }
        if let patientPostalCode = addressInfo["p_postal_code"].int{
            AppUserDefaults.save(value: patientPostalCode, forKey: .postalCode)
        }
        if let patientAddress1 = addressInfo["p_address1"].string{
            AppUserDefaults.save(value: patientAddress1, forKey: .patientAddress1)
        }
        if let patientAddress2 = addressInfo["p_address2"].string{
            AppUserDefaults.save(value: patientAddress2, forKey: .patientAddress2)
        }
        if let addressType = addressInfo["p_address_type"].int{
            AppUserDefaults.save(value: addressType, forKey: .patientAddressType)
        }
    }
    
    static func saveHospitalDetail(_ hospitalInfo : JSON){
        
        if let hospitalID = hospitalInfo["hosp_id"].int{
            AppUserDefaults.save(value: hospitalID, forKey: .hopitalID)
        }
        if let hospitalname = hospitalInfo["hosp_name"].string{
            AppUserDefaults.save(value: hospitalname, forKey: .hospName)
        }
        if let hospitalAddress = hospitalInfo["address"].string{
            AppUserDefaults.save(value: hospitalAddress, forKey: .hospitalAddress)
        }
        if let hospitalLandlineNumber = hospitalInfo["hosp_landline"].string{
            AppUserDefaults.save(value: hospitalLandlineNumber, forKey: .hospitalLandline)
        }
        if let hospitalAltnumber = hospitalInfo["hosp_alt_landline"].string{
            AppUserDefaults.save(value: hospitalAltnumber, forKey: .hospitalAlternativeNumber)
        }
    }
}

//MARK : USAGE

// AppUserDefaults.value(forKey :.DOB)
// AppUserDefaults.value(forKey :.DOB, fallBackValue : "11/11/1989")



