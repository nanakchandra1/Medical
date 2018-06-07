//
//  model.swift
//  Mutelcore
//
//  Created by Ashish on 02/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfo {
    
    var patientID : Int?
    var patientPic : String?
    var patientUniqueId : String?
    var patientNationalId : String?
    var patientTitle: String?
    var patientName : String?
    var patientFirstname : String?
    var patientMiddleName : String?
    var patientLastName : String?
    var patientGender : Int?
    var patientFatherTitle : String?
    var patientSpouseTitle : String?
    var patientFathername : String?
    var patientSpouseName : String?
    var patientDob : Date?
    var patientMobileNumber : String?
    var patientEmail : String?
    var accessToken : String?
    var stepVerified : Int?
    var mobileVerified : Int?
    var rating : Int?
    
    var ethinicityId : Int?
    var patientLastVisit : String?
    var surgeryId : Int?
    var patientReviewedOn : String?
    
    var patientDoctorID : Int?
    var doctorName : String?
    var patientHospitalID : Int?
    var patientSpeciality : String?
    var doctorSpecialization : String?
    
    var medicalInfo = [MedicalInfo]()
    var userAddressInfo = [UserAddressInfo]()
    var treatmentinfo = [TreatmentDetailInfo]()
    var medicalCategoryInfo = [MedicalCategoryInfo]()
    var medicalDetailDic = [String : Any]()
    
    init(userData : JSON){
        
        if let patient_id = userData[AppConstants.patient_ID].int{
            
           self.patientID = patient_id

        }
         self.patientPic = userData[AppConstants.patient_Pic].stringValue

         self.patientUniqueId = userData[AppConstants.patient_unique_ID].stringValue
        
         self.patientNationalId = userData[AppConstants.patient_National_ID].stringValue
        
         self.patientTitle = userData[AppConstants.patient_Title].stringValue

         self.patientName = userData[AppConstants.patient_Name].stringValue
        
        self.patientFirstname = userData[AppConstants.patient_First_Name].stringValue
        
         self.patientMiddleName = userData[AppConstants.patient_Middle_Name].stringValue
        
        self.patientLastName = userData[AppConstants.patient_Last_Name].stringValue
        
        if let patient_Gender = userData[AppConstants.patient_Gender].int{
            
           self.patientGender = patient_Gender
        }
        self.patientFatherTitle = userData[AppConstants.patient_Father_Title].stringValue
        
        self.patientSpouseTitle = userData[AppConstants.patient_spouse_title].stringValue
        
        self.patientFathername = userData[AppConstants.patient_Father_Name].stringValue
        
        self.patientSpouseName = userData[AppConstants.patient_Spouse_Name].stringValue
        
        self.patientDob = userData[AppConstants.patient_Date_Of_Birth].stringValue.dateFromString
        
        self.patientMobileNumber = userData[AppConstants.patient_Mobile_Number].stringValue
        
        self.patientEmail = userData[AppConstants.patient_Email].stringValue
        
        self.accessToken = userData[AppConstants.access_Token].stringValue
        
        if let stepVerified = userData[AppConstants.step_Verified].int{
            
            self.stepVerified = stepVerified
        }
        if let mobileVerified = userData[AppConstants.is_Mobile_Verified].int{
            
            self.mobileVerified = mobileVerified
        }
        if let rating = userData[AppConstants.rating].int{
            
            self.rating = rating
        }
        if let patientDoctorID = userData[AppConstants.patient_doctor_Id].int{
            
            self.patientDoctorID = patientDoctorID
        }
        self.doctorName = userData[AppConstants.doctor_Name].stringValue
        
        if let patientHospitalID = userData[AppConstants.patient_hospital_Id].int{
            
            self.patientHospitalID = patientHospitalID
        }
        self.patientSpeciality = userData[AppConstants.patient_Speciality].stringValue
        
        if let ethinicityId = userData[AppConstants.ethinicity_ID].int{
            
            self.ethinicityId = ethinicityId
        }
        self.patientLastVisit = userData[AppConstants.patient_Last_Visit].stringValue
        
        if let surgeryId = userData[AppConstants.survey_ID].int{
            
            self.surgeryId = surgeryId
        }
        self.patientReviewedOn = userData[AppConstants.patient_Reviewed_On].stringValue
        
        self.doctorSpecialization = userData[AppConstants.doc_specialisation].stringValue
        
        if let surgeryId = userData[AppConstants.survey_ID].int{
            
            self.surgeryId = surgeryId
        }
        
        medicalInfo(userData)
        
        userAddressInfo(userData)
        
        treatmentInfo(userData)
        
        medicalCategoryDetailInfo(userData)
    }
    
    init(){
        
        
    }
    
    @discardableResult func medicalInfo(_ userData : JSON) -> [MedicalInfo] {
        
        let medicalIn = MedicalInfo.init(medicalInfo: userData)
        
        medicalInfo.append(medicalIn)
        
        return medicalInfo
    }
    
   @discardableResult func userAddressInfo(_ userAddress : JSON) -> [UserAddressInfo] {
        
        let addressInfo = UserAddressInfo.init(addressInfo: userAddress)
        
        userAddressInfo.append(addressInfo)
        
        return userAddressInfo
    }
    
   @discardableResult func treatmentInfo(_ treatmentInfo : JSON) -> [TreatmentDetailInfo] {
        
        let treatmentInfo = TreatmentDetailInfo.init(tretmentDetailInfo: treatmentInfo)
        
        treatmentinfo.append(treatmentInfo)
        
        return treatmentinfo
    }
    
   @discardableResult func medicalCategoryDetailInfo(_ medicalCategory : JSON) -> [MedicalCategoryInfo] {
        
        let medicalCategory = MedicalCategoryInfo.init(medicalCategoryInfo: medicalCategory)
        
        medicalCategoryInfo.append(medicalCategory)
        
        return medicalCategoryInfo
    }
    
    var toDictionary: [String : Any] {
        get{
            
            var userDetail = [String : Any]()
            
            userDetail[patient_ID] = self.patientID
            userDetail[AppConstants.patient_Pic] = self.patientPic
            userDetail[AppConstants.patient_unique_ID] = self.patientUniqueId
            userDetail[patient_Title] = self.patientTitle    
            userDetail[AppConstants.patient_Name] = self.patientName
            userDetail[email_Id] = self.patientEmail
            userDetail[first_name] = self.patientFirstname
            userDetail[middle_name] = self.patientMiddleName
            userDetail[last_name] = self.patientLastName
            userDetail[patient_Hospital_Id] = self.patientHospitalID
            userDetail[patient_Speciality] = self.patientSpeciality
            userDetail[surgeryID] = self.surgeryId
            userDetail[AppConstants.ethinicity_ID] = self.ethinicityId
            userDetail[AppConstants.patient_Reviewed_On] = self.patientReviewedOn
            userDetail[AppConstants.is_Mobile_Verified] = self.mobileVerified
            userDetail[AppConstants.step_Verified] = self.stepVerified
            userDetail[AppConstants.patient_doctor_Id] = self.patientDoctorID
            userDetail[AppConstants.doctor_Name] = self.doctorName
            userDetail[AppConstants.access_Token] = self.accessToken
            userDetail[father_title] = self.patientFatherTitle
            userDetail[spouse_title] = self.patientSpouseTitle
            userDetail[father_name] = self.patientFathername
            userDetail[spouse_name] = self.patientSpouseName
            userDetail[dob] = self.patientDob
            userDetail[gender] = self.patientGender
            userDetail[patient_mobile_number] = self.patientMobileNumber
            userDetail[AppConstants.patient_Last_Visit] = self.patientLastVisit
            userDetail[adhar_card_number] = self.patientNationalId
            
            if let medInfo = self.medicalInfo.first {
                userDetail.append(other: medInfo.toDictionary)
            }
            if let medCatInfo = self.medicalCategoryInfo.first {
                userDetail.append(other: medCatInfo.toDictionary)
            }
            if let treatInfo = self.treatmentinfo.first {
                userDetail.append(other: treatInfo.toDictionary)
            }
            if let addressInfo = self.userAddressInfo.first {
                userDetail.append(other: addressInfo.toDictionary)
            }
            
            return userDetail
        }
    }
}

//Medical Detail
class MedicalInfo {
    
    var patientHeightType : Int?
    var patientHeight : Double?
    var patientHeight1 : Int?
    var patientHeight2 : Int?
    var patientWeight : Int?
    var patientWeightType : Int?
    var patientBloodGroup : String?
    var hypertension : Int?
    var diabities : Int?
    var smoking : Int?
    var patientHyperTensionFather : Int?
    var patientHyperTensionMother : Int?
    var patientDiabitiesFather : Int?
    var patientDiabitiesMother : Int?
    
    
    init(medicalInfo: JSON) {
        
        
        self.patientHeightType = medicalInfo[AppConstants.patient_Height_Type].int
        self.patientHeight = medicalInfo[AppConstants.patient_Height_Type].double
        self.patientHeight1 = medicalInfo[AppConstants.patient_Height1].int
        self.patientHeight2 = medicalInfo[AppConstants.patient_Height2].int
        self.patientWeight = medicalInfo[AppConstants.patient_Weight].int
        self.patientWeightType = medicalInfo[AppConstants.patient_Weight_Type].int
        self.patientBloodGroup = medicalInfo[AppConstants.patient_blood_Group].stringValue
        self.hypertension = medicalInfo[AppConstants.patient_Hypertension].int
        self.diabities = medicalInfo[AppConstants.patient_Diabities].int
        self.patientHyperTensionFather = medicalInfo[AppConstants.patient_Hypertension_Father].int
        self.patientHyperTensionMother = medicalInfo[AppConstants.patient_Hypertension_Mother].int
        self.patientDiabitiesFather = medicalInfo[AppConstants.patient_Diabities_Father].int
        self.patientDiabitiesMother = medicalInfo[AppConstants.patient_Diabities_Mother].int
        self.smoking = medicalInfo[AppConstants.patient_Smoking].int
        
    }
    
    var toDictionary: [String : Any] {
        get{
            var medicalDetail = [String : Any]()
            medicalDetail[patient_Weight_type] = self.patientWeightType
            medicalDetail[patient_Height_Type] = self.patientHeightType
            medicalDetail[patient_Height1] = self.patientHeight1
            medicalDetail[patient_Height2] = self.patientHeight2
            medicalDetail[patient_Weight] = self.patientWeight
            medicalDetail[patient_Blood_Group] = self.patientBloodGroup
            medicalDetail[hyper_Tension] = self.hypertension
            medicalDetail[father_HyperTension] = self.patientHyperTensionFather
            medicalDetail[mother_HyperTension] = self.patientHyperTensionMother
            medicalDetail[di_abities] = self.diabities
            medicalDetail[father_Diabities] = self.patientDiabitiesFather
            medicalDetail[mother_Diabities] = self.patientDiabitiesMother
            medicalDetail[smok_ing] = self.smoking
            return medicalDetail
        }
    }
}

//MedicalCategoryInfo
class MedicalCategoryInfo {
    
    var patientAllergy : String?
    var foodDescription : String?
    var familyAllergy : String
    var previousAllergy : String?
    var foodCategory : Int?
    
    init(medicalCategoryInfo: JSON) {
        
        self.patientAllergy = medicalCategoryInfo[AppConstants.patient_Allergies].stringValue
        self.foodDescription = medicalCategoryInfo[AppConstants.food_Description].stringValue
        self.familyAllergy = medicalCategoryInfo[AppConstants.family_Allergies].stringValue
        self.previousAllergy = medicalCategoryInfo[AppConstants.previous_Allergies].stringValue
        self.foodCategory = medicalCategoryInfo[AppConstants.food_Category].int
        
    }
    
    var toDictionary: [String : Any] {
        get{
            
            var medicalCategoryinfo = [String : Any]()
            medicalCategoryinfo[allergies] = self.patientAllergy
            medicalCategoryinfo[family_Allergies] = self.familyAllergy
            medicalCategoryinfo[previous_Allergies] = self.previousAllergy
            medicalCategoryinfo[food_Description] = self.foodDescription
            medicalCategoryinfo[AppConstants.food_Category] = self.foodCategory
            
            return medicalCategoryinfo
        }
    }
}

//Treatment Detail
class TreatmentDetailInfo {
    
    var dateOfAdmission : Date?
    var dateOfSurgery : Date?
    var dateofDischarge : Date?
    
    init(tretmentDetailInfo : JSON) {

        
        self.dateOfAdmission = tretmentDetailInfo[AppConstants.date_Admission].stringValue.dateFromString
        self.dateOfSurgery = tretmentDetailInfo[AppConstants.date_Surgery].stringValue.dateFromString
        self.dateofDischarge = tretmentDetailInfo[AppConstants.date_Discharge].stringValue.dateFromString
        
    }
    
    init() {
        
    }
    
    var toDictionary: [String : Any] {
        get{
            
            var treatmentDetail = [String : Any]()
            
            treatmentDetail[date_Of_Admission] = self.dateOfAdmission
            treatmentDetail[date_Of_Surgery] = self.dateOfSurgery
            treatmentDetail[date_Of_Discharge] = self.dateofDischarge
            
            return treatmentDetail
        }
    }
}

//UserAddressInfo
class UserAddressInfo {
    
    var patientIsdCode : String?
    var patientState : Int?
    var patientCountry : String?
    var patientCity : Int?
    var patientPostalCode : Int?
    var patientAddress : String?
    var addressType : Int?
    
    init(addressInfo : JSON) {
        
        if let isd = addressInfo[AppConstants.patient_Isd_Code].string {
            
            self.patientIsdCode = isd
            
        }
        
        self.patientIsdCode = addressInfo[AppConstants.patient_Isd_Code].stringValue
        self.patientState = addressInfo[AppConstants.patient_State].int
        self.patientCountry = addressInfo[AppConstants.patient_Country].stringValue
        self.patientCity = addressInfo[AppConstants.patient_City].int
        self.patientPostalCode = addressInfo[AppConstants.patient_Postal_Code].int
        self.patientAddress = addressInfo[AppConstants.patient_Address1].stringValue
        self.addressType = addressInfo[AppConstants.address_Type].int
        
    }
    
    
    var toDictionary: [String : Any] {
        get{
            
            var userAddressDetail = [String : Any]()
            
            userAddressDetail[AppConstants.patient_Isd_Code] = self.patientIsdCode
            userAddressDetail[AppConstants.patient_State] = self.patientState
            userAddressDetail[AppConstants.patient_Country] = self.patientCountry
            userAddressDetail[AppConstants.patient_City] = self.patientCity
            userAddressDetail[AppConstants.patient_Address1] = self.patientAddress
            userAddressDetail[address_Type] = self.addressType
            userAddressDetail[AppConstants.patient_Postal_Code] = self.patientPostalCode
            
            return userAddressDetail
        }
    }
}
