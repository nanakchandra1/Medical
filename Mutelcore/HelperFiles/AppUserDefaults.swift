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
            
            printlnDebug("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
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
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        
    }
    
//    Save UserDetail
//    ===============
    static func saveUserDetail(_ userData : JSON){
        
        printlnDebug(userData)
        
        if let patient_id = userData[AppConstants.patient_ID].int{
            
           AppUserDefaults.save(value: patient_id, forKey: AppUserDefaults.Key.userId)
        }
        if let patient_pic = userData[AppConstants.patient_Pic].string{
            
            AppUserDefaults.save(value: patient_pic, forKey: AppUserDefaults.Key.patientpic)
        }
        if let ptientUnqID = userData[AppConstants.patient_unique_ID].string{
            
            AppUserDefaults.save(value: ptientUnqID, forKey: AppUserDefaults.Key.uhId)
        }
        if let national_id = userData[AppConstants.patient_National_ID].string{
            
            AppUserDefaults.save(value: national_id, forKey: AppUserDefaults.Key.nationalID)
        }
        if let patient_Title = userData[AppConstants.patient_Title].string{
            
            AppUserDefaults.save(value: patient_Title, forKey: AppUserDefaults.Key.patientTile)
        }
        if let patient_Name = userData[AppConstants.patient_Name].string{
            
            AppUserDefaults.save(value: patient_Name, forKey: AppUserDefaults.Key.patientName)
        }
        if let patientFirstname = userData[AppConstants.patient_First_Name].string {
            
            AppUserDefaults.save(value: patientFirstname, forKey: AppUserDefaults.Key.firstname)
        }
        if let patient_middle_Name = userData[AppConstants.patient_Middle_Name].string{
            
            AppUserDefaults.save(value: patient_middle_Name, forKey: AppUserDefaults.Key.middleName)
        }
        if let patient_Last_Name = userData[AppConstants.patient_Last_Name].string{
            
            AppUserDefaults.save(value: patient_Last_Name, forKey: AppUserDefaults.Key.lastName)
        }
        if let patientGender = userData[AppConstants.patient_Gender].int{
            
            AppUserDefaults.save(value: patientGender, forKey: AppUserDefaults.Key.p_gender)
        }
        if let patientFatherTitle = userData[AppConstants.patient_Father_Title].string{
            
            AppUserDefaults.save(value: patientFatherTitle, forKey: AppUserDefaults.Key.fatherTitle)
        }
        if let patientSpouseTitle = userData[AppConstants.patient_spouse_title].string{
            
            AppUserDefaults.save(value: patientSpouseTitle, forKey: AppUserDefaults.Key.patientpic)
        }
        if let patientFathername = userData[AppConstants.patient_Father_Name].string{
            
            AppUserDefaults.save(value: patientFathername, forKey: AppUserDefaults.Key.fatherName)
        }
        if let patientSpouseName = userData[AppConstants.patient_Spouse_Name].string{
            
            AppUserDefaults.save(value: patientSpouseName, forKey: AppUserDefaults.Key.spouseName)
        }
        if let patientDob = userData[AppConstants.patient_Date_Of_Birth].string{
            
            AppUserDefaults.save(value: patientDob, forKey: AppUserDefaults.Key.patientDob)
        }
        if let patientMobileNumber = userData[AppConstants.patient_Mobile_Number].string{
            
            AppUserDefaults.save(value: patientMobileNumber, forKey: AppUserDefaults.Key.patientMobileNumber)
        }
        if let patientEmail = userData[AppConstants.patient_Email].string{
            
            AppUserDefaults.save(value: patientEmail, forKey: AppUserDefaults.Key.email)
        }
        if let accessToken = userData[AppConstants.access_Token].string{
            
            AppUserDefaults.save(value: accessToken, forKey: AppUserDefaults.Key.accessToken)
        }
        if let stepVerified = userData[AppConstants.step_Verified].int{
            
            AppUserDefaults.save(value: stepVerified, forKey: AppUserDefaults.Key.stepVerified)
        }
        if let mobileVerified = userData[AppConstants.is_Mobile_Verified].int{
            
            AppUserDefaults.save(value: mobileVerified, forKey: AppUserDefaults.Key.mobileVerified)
        }
        if let rating = userData[AppConstants.rating].int{
            
            AppUserDefaults.save(value: rating, forKey: AppUserDefaults.Key.rating)
        }
        if let patientDoctorID = userData[AppConstants.patient_doctor_Id].int{
            
            AppUserDefaults.save(value: patientDoctorID, forKey: AppUserDefaults.Key.doctorId)
        }
        if let doctorName = userData[AppConstants.doctor_Name].string{
            
            AppUserDefaults.save(value: doctorName, forKey: AppUserDefaults.Key.doctorName)
        }
        if let patientHospitalID = userData[AppConstants.patient_hospital_Id].int{
            
            AppUserDefaults.save(value: patientHospitalID, forKey: AppUserDefaults.Key.patientpic)
        }
        if let patientSpeciality = userData[AppConstants.patient_Speciality].string{
            
            AppUserDefaults.save(value: patientSpeciality, forKey: AppUserDefaults.Key.patientSpeciality)
        }
        if let ethinicityId = userData[AppConstants.ethinicity_ID].int{
            
            AppUserDefaults.save(value: ethinicityId, forKey: AppUserDefaults.Key.ethinicityId)
        }
        if let patientLastVisit = userData[AppConstants.patient_Last_Visit].string{
            
            AppUserDefaults.save(value: patientLastVisit, forKey: AppUserDefaults.Key.patientLastVisit)
        }
        if let surgeryId = userData[AppConstants.survey_ID].int{
            
            AppUserDefaults.save(value: surgeryId, forKey: AppUserDefaults.Key.surgeryId)
        }
        if let patientReviewedOn = userData[AppConstants.patient_Reviewed_On].string{
            
            AppUserDefaults.save(value: patientReviewedOn, forKey: AppUserDefaults.Key.patientReviewedOn)
        }
        if let doctorSpecialization = userData[AppConstants.doc_specialisation].string{
            
            AppUserDefaults.save(value: doctorSpecialization, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
    }
    
//    Save UserMedical Detail
//    =======================
    static func saveUserMedicalDetail(_ medicalInfo : JSON){

        printlnDebug(medicalInfo)
        
        if let patientHeightType = medicalInfo[AppConstants.patient_Height_Type].int{
            
            AppUserDefaults.save(value: patientHeightType, forKey: AppUserDefaults.Key.patientHeightType)
        }
        if let patientHeight = medicalInfo[AppConstants.patient_Height].int{
            
            AppUserDefaults.save(value: patientHeight, forKey: AppUserDefaults.Key.patientHeight)
        }
        if let patientHeight1 = medicalInfo[AppConstants.patient_Height1].int{
            
            AppUserDefaults.save(value: patientHeight1, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientHeight2 = medicalInfo[AppConstants.patient_Height2].int{
            
            AppUserDefaults.save(value: patientHeight2, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientWeight = medicalInfo[AppConstants.patient_Weight].int{
            
            AppUserDefaults.save(value: patientWeight, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientWeightType = medicalInfo[AppConstants.patient_Weight_Type].int{
            
            AppUserDefaults.save(value: patientWeightType, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientBloodGroup = medicalInfo[AppConstants.patient_blood_Group].string{
            
            AppUserDefaults.save(value: patientBloodGroup, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let hypertension = medicalInfo[AppConstants.patient_Hypertension].int{
            
            AppUserDefaults.save(value: hypertension, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let diabities = medicalInfo[AppConstants.patient_Diabities].int{
            
            AppUserDefaults.save(value: diabities, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientHyperTensionFather = medicalInfo[AppConstants.patient_Hypertension_Father].int{
            
            AppUserDefaults.save(value: patientHyperTensionFather, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientHyperTensionMother = medicalInfo[AppConstants.patient_Hypertension_Mother].int{
            
            AppUserDefaults.save(value: patientHyperTensionMother, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientDiabitiesFather = medicalInfo[AppConstants.patient_Diabities_Father].int{
            
            AppUserDefaults.save(value: patientDiabitiesFather, forKey: AppUserDefaults.Key.doctorSpecialization)
        }
        if let patientDiabitiesMother = medicalInfo[AppConstants.patient_Diabities_Mother].int{
            
            AppUserDefaults.save(value: patientDiabitiesMother, forKey: AppUserDefaults.Key.motherDiabities)
        }
        if let smoking = medicalInfo[AppConstants.patient_Smoking].int{
            
            AppUserDefaults.save(value: smoking, forKey: AppUserDefaults.Key.smoking)
        }
    }
//    ========
    
    //    save Medical Category Info
    static func saveMedicalCategoryInfo(_ medicalCategoryInfo : JSON){
        
        printlnDebug(medicalCategoryInfo)
        
        if let patientAllergy = medicalCategoryInfo[AppConstants.patient_Allergies].string{
            
            AppUserDefaults.save(value: patientAllergy, forKey: AppUserDefaults.Key.patientAllergy)
        }
        if let foodDescription = medicalCategoryInfo[AppConstants.food_Description].string{
            
            AppUserDefaults.save(value: foodDescription, forKey: AppUserDefaults.Key.foodDecription)
        }
        if let familyAllergy = medicalCategoryInfo[AppConstants.family_Allergies].string{
            
            AppUserDefaults.save(value: familyAllergy, forKey: AppUserDefaults.Key.familyAllergy)
        }
        if let previousAllergy = medicalCategoryInfo[AppConstants.previous_Allergies].string{
            
            AppUserDefaults.save(value: previousAllergy, forKey: AppUserDefaults.Key.previousAllergy)
        }
        if let foodCategory = medicalCategoryInfo[AppConstants.food_Category].int{
            
            AppUserDefaults.save(value: foodCategory, forKey: AppUserDefaults.Key.foodCategory)
        }
    }
    
    //    save Treatment Info
    static func saveTreatmentDetailInfo(_ tretmentDetailInfo : JSON){
        
        if let dateOfAdmission = tretmentDetailInfo[AppConstants.date_Admission].string{
            
            AppUserDefaults.save(value: dateOfAdmission, forKey: AppUserDefaults.Key.dateOfAdmission)

        }
        if let dateOfSurgery = tretmentDetailInfo[AppConstants.date_Surgery].string{
            
            AppUserDefaults.save(value: dateOfSurgery, forKey: AppUserDefaults.Key.dateOfSurgery)

        }
        if let dateofDischarge = tretmentDetailInfo[AppConstants.date_Discharge].string{
            
            AppUserDefaults.save(value: dateofDischarge, forKey: AppUserDefaults.Key.dateOfDischarge)

        }
    }
    
    //    save addressDetail
    static func saveUserAddressDetail(_ addressInfo : JSON){
        
        if let patientIsdCode = addressInfo[AppConstants.patient_Isd_Code].string{
            
            AppUserDefaults.save(value: patientIsdCode, forKey: AppUserDefaults.Key.patientISDCode)

        }
        if let patientState = addressInfo[AppConstants.patient_State].int{
            
            AppUserDefaults.save(value: patientState, forKey: AppUserDefaults.Key.patientState)

        }
        if let patientCountry = addressInfo[AppConstants.patient_Country].string{
            
            AppUserDefaults.save(value: patientCountry, forKey: AppUserDefaults.Key.patientCountry)

        }
        if let patientCity = addressInfo[AppConstants.patient_City].int{
            
            AppUserDefaults.save(value: patientCity, forKey: AppUserDefaults.Key.patientCity)
        }
        if let patientPostalCode = addressInfo[AppConstants.patient_Postal_Code].int{
            
            AppUserDefaults.save(value: patientPostalCode, forKey: AppUserDefaults.Key.postalCode)
        }
        if let patientAddress = addressInfo[AppConstants.patient_Address1].string{
            
            AppUserDefaults.save(value: patientAddress, forKey: AppUserDefaults.Key.patientAddress)
        }
        if let addressType = addressInfo[AppConstants.address_Type].int{
            
            AppUserDefaults.save(value: addressType, forKey: AppUserDefaults.Key.patientAddressType)
        }
    }
}

//MARK : USAGE

// AppUserDefaults.value(forKey :.DOB)
// AppUserDefaults.value(forKey :.DOB, fallBackValue : "11/11/1989")



