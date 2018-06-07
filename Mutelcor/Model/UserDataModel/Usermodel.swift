//
//  model.swift
//  Mutelcor
//
//  Created by  on 02/05/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfo {
    
    var patientID : Int?
    var patientPic: String = ""
    
    var patientUniqueId: String = ""
    var patientNationalId: String = ""
    
    var patientTitle: String = ""
    var patientName: String = ""
    var patientFirstname: String = ""
    var patientMiddleName: String = ""
    var patientLastName: String = ""
    var patientDob : Date?
    var patientGender : Int = 0
    var patientEmail: String = ""
    var patientMobileNumber: String = ""
    var countryCode: String = ""
    
    var addressType: Int = 1
    var patientPostalCode: String = ""
    var address: String = ""
    var country: String = ""
    var state: Int = 0
    var city: String = ""
    var emergencyContactPerson: String = ""
    var patientEmergencyRelationShip: String = ""
    var emergencyCountryCode: String = ""
    var emergencyConatctNumber: String = ""
    
    var referredBy: String = ""
    var ethinicityId : Int?
    var occupation: String = ""
    
    var maritalStatus: String = ""
    var fathername: String = ""
    var motherName: String = ""
    var spouseName: String = ""

    var accessToken: String = ""
    var mobileVerified : Int?
    var rating : Int?
    
    
    var patientLastVisit: String = ""
    var surgeryId : Int?
    var patientReviewedOn: String = ""
    
    var patientDoctorID : Int?
    var doctorName: String = ""
    var assosiatedDoctor: String = ""
    var patientHospitalID : Int?
    var patientHospitalName: String = ""
    var patientSpeciality : Int?
    var doctorSpecialization: String = ""

    var medicalInfo = [MedicalInfo]()
    var medicalCategoryInfo = [MedicalCategoryInfo]()
    var activityInfo = [UserActivityInfo]()
    var hospitalInfo = [UserHospitalInfo]()
    
    var medicalDetailDic = [String : Any]()
    
    init(userData : JSON){  
        
        guard let patient_id = userData[DictionaryKeys.patinetId].int else{
            return
        }
        
        self.patientID = patient_id
        
        self.patientPic = userData[DictionaryKeys.patinetPic].stringValue
        self.patientUniqueId = userData[DictionaryKeys.uniqueID].stringValue
        self.patientNationalId = userData[DictionaryKeys.nationalID].stringValue
        self.patientTitle = userData[DictionaryKeys.patientTitle].stringValue
        self.patientName = userData[DictionaryKeys.patientName].stringValue
        self.patientFirstname = userData[DictionaryKeys.patientFirstName].stringValue
        self.patientMiddleName = userData[DictionaryKeys.patientMiddleName].stringValue
        self.patientLastName = userData[DictionaryKeys.patientLastName].stringValue
        if let dob = userData[DictionaryKeys.dob].string{
            self.patientDob = dob.getDateFromString(.utcTime, .yyyyMMdd)
        }
        if let patient_Gender = userData[DictionaryKeys.patientGender].int{
            self.patientGender = patient_Gender
        }

        self.patientEmail = userData[DictionaryKeys.patientEmail].stringValue
        self.countryCode = userData[DictionaryKeys.countryCode].stringValue
        self.patientMobileNumber = userData[DictionaryKeys.mobileNumber].stringValue
        
        if let addressType = userData[DictionaryKeys.addressType].int{
            self.addressType = addressType
        }
        self.patientPostalCode = userData[DictionaryKeys.postalCode].stringValue
        self.address = userData[DictionaryKeys.address].stringValue
        self.country = userData[DictionaryKeys.country].stringValue
        self.state = userData[DictionaryKeys.state].intValue
        self.city = userData[DictionaryKeys.city].stringValue
        
        if let ethinicityId = userData[DictionaryKeys.ethinicityID].int{
            self.ethinicityId = ethinicityId
        }
        self.referredBy = userData[DictionaryKeys.refferedBy].stringValue
        self.occupation = userData[DictionaryKeys.occupation].stringValue
        self.maritalStatus = userData[DictionaryKeys.maritalStatus].stringValue
        self.fathername = userData[DictionaryKeys.fatherName].stringValue
        self.motherName = userData[DictionaryKeys.motherName].stringValue
        self.spouseName = userData[DictionaryKeys.spouseName].stringValue
        
        self.emergencyContactPerson = userData[DictionaryKeys.emergencyName].stringValue
        self.patientEmergencyRelationShip = userData[DictionaryKeys.emergencyRelationship].stringValue
        self.emergencyCountryCode = userData[DictionaryKeys.emergencyCountryCode].stringValue
        self.emergencyConatctNumber = userData[DictionaryKeys.emergencyContactNumber].stringValue
        self.accessToken = userData[DictionaryKeys.accessToken].stringValue
        if let mobileVerified = userData[DictionaryKeys.isMobileVerified].int{
            self.mobileVerified = mobileVerified
        }
        if let rating = userData[DictionaryKeys.rating].int{
            self.rating = rating
        }

        medicalInfo(userData)
        userActivityInfo(userData)
        hospitalInfo(userData)
        medicalCategoryDetailInfo(userData)
    }
    
    init(){
    }
    
    @discardableResult func medicalInfo(_ userData : JSON) -> [MedicalInfo] {
        
        let medicalIn = MedicalInfo.init(medicalInfo: userData)
        medicalInfo.append(medicalIn)
        return medicalInfo
    }
    
    @discardableResult func userActivityInfo(_ userActivity : JSON) -> [UserActivityInfo] {

        let activnfo = UserActivityInfo.init(userActivityInfo: userActivity)
        activityInfo.append(activnfo)
        return activityInfo
    }

    @discardableResult func medicalCategoryDetailInfo(_ medicalCategory : JSON) -> [MedicalCategoryInfo] {
        
        let medicalCategory = MedicalCategoryInfo.init(medicalCategoryInfo: medicalCategory)
        medicalCategoryInfo.append(medicalCategory)
        return medicalCategoryInfo
    }
    
    @discardableResult func hospitalInfo(_ hospInfo : JSON) -> [UserHospitalInfo] {
        
        let hospInfo = UserHospitalInfo.init(hospitalInfo: hospInfo)
        hospitalInfo.append(hospInfo)
        return hospitalInfo
    }
    
    var toDictionary: [String : Any] {
        get{
            
            var userDetail = [String : Any]()
            
            userDetail[DictionaryKeys.patinetId] = self.patientID
            userDetail[DictionaryKeys.patinetPic] = self.patientPic
            userDetail[DictionaryKeys.uniqueID] = self.patientUniqueId
            userDetail[DictionaryKeys.title] = self.patientTitle
            userDetail[DictionaryKeys.patientName] = self.patientName
            userDetail[DictionaryKeys.emailID] = self.patientEmail
            userDetail[DictionaryKeys.firstName] = self.patientFirstname
            userDetail[DictionaryKeys.middleName] = self.patientMiddleName
            userDetail[DictionaryKeys.lastName] = self.patientLastName
            userDetail[DictionaryKeys.gender] = self.patientGender
            userDetail[DictionaryKeys.father_Name] = self.fathername
            userDetail[DictionaryKeys.spouse_Name] = self.spouseName
            userDetail[DictionaryKeys.motherName] = self.motherName
            userDetail[DictionaryKeys.patientOccupation] = self.occupation
            userDetail[DictionaryKeys.patientMaritalStatus] = self.maritalStatus
            userDetail[DictionaryKeys.address_Type] = self.addressType
            userDetail[DictionaryKeys.postal_Code] = self.patientPostalCode
            userDetail[DictionaryKeys.patientAddress] = self.address
            userDetail[DictionaryKeys.patientState] = self.state
            userDetail[DictionaryKeys.patientCountry] = self.country
            userDetail[DictionaryKeys.patientCity] = self.city
            userDetail[DictionaryKeys.patientEthinicityID] = self.ethinicityId
            userDetail[DictionaryKeys.refferedBy] = self.referredBy
            userDetail[DictionaryKeys.emergencyName] = self.emergencyContactPerson
            userDetail[DictionaryKeys.emergencyCountryCode] = self.emergencyCountryCode
            userDetail[DictionaryKeys.emergencyContactNumber] = self.emergencyConatctNumber
            userDetail[DictionaryKeys.emergencyRelationship] = self.patientEmergencyRelationShip
            
            userDetail[DictionaryKeys.hospitalID] = self.patientHospitalID
            userDetail[DictionaryKeys.speciality] = self.patientSpeciality
            userDetail[DictionaryKeys.surgeryID] = self.surgeryId

            userDetail[DictionaryKeys.reviewedOn] = self.patientReviewedOn
            userDetail[DictionaryKeys.isMobileVerified] = self.mobileVerified
            userDetail[DictionaryKeys.patientDoctorID] = self.patientDoctorID
            userDetail[DictionaryKeys.doctorName] = self.doctorName
            userDetail[DictionaryKeys.accessToken] = self.accessToken
            
            userDetail[DictionaryKeys.dateOFBirth] = self.patientDob?.stringFormDate(.yyyyMMdd)
            
            userDetail[DictionaryKeys.patientMobileNumber] = self.patientMobileNumber
            userDetail[DictionaryKeys.patientLastVisit] = self.patientLastVisit
            
            
            if let medInfo = self.medicalInfo.first {
                userDetail.append(other: medInfo.toDictionary)
            }
            if let medCatInfo = self.medicalCategoryInfo.first {
                userDetail.append(other: medCatInfo.toDictionary)
            }
            
            if let activityInfo = self.activityInfo.first {
                userDetail.append(other: activityInfo.toDictionary)
            }

            return userDetail
        }
    }
}

//Medical Detail
class MedicalInfo {
    
    var patientBloodGroup: String = ""
    var foodCategory : Int = 0
    
    var patientHeightType: Int = 0
    var patientHeight : Double?
    var patientHeight1 : Int?
    var patientHeight2 : Int?
    
    var patientWeight : Int?
    var patientWeightType : Int?
    
    var idealWeightType: Int?
    var patientIdealWeight : Int?
    var excessWeightType: Int?
    var patientExcessWeight : Int?
    
    var patientMaximumWeightAchievedType: Int?
    var patientMaximumWeightAchieved : Int?
    var maximumWeightLossType: Int?
    var patientMaximumWeightLoss : Int?
    
    var maximumLossWeight : String = ""
    var waistCircumference: Int?
    var waistCircumferenceValue : Int?
    var hipCircumference: Int?
    var hipCircumferenceValue : Int?

    var pastMedicalCompliants : String = ""
    var neurological : String = ""
    var respiratory : String = ""
    var cardiac : String = ""
    var abdominal : String = ""
    var jointsAndBones : String = ""
    var hormonal : String = ""
    var physhological : String = ""
    var others : String = ""
    var presentMedicalTreatment : String = ""

    init(medicalInfo: JSON) {
        
        self.patientBloodGroup = medicalInfo[DictionaryKeys.patientBloodGroup].stringValue
        
        if let foodcategory = medicalInfo[DictionaryKeys.foodCategory].int {
            self.foodCategory = foodcategory
        }
        
        
        self.patientHeightType = medicalInfo[DictionaryKeys.patientHeightType].intValue
        if let height = medicalInfo[DictionaryKeys.patientHeight].double{
            self.patientHeight = height
        }

        if let height1 = medicalInfo[DictionaryKeys.patientHeight1].int, height1 != 0{
            self.patientHeight1 = height1
        }
        if let height2 = medicalInfo[DictionaryKeys.patientHeight2].int, height2 != 0{
            self.patientHeight2 = height2
        }

        self.patientWeightType = medicalInfo[DictionaryKeys.patientWeightType].intValue
        if let weight = medicalInfo[DictionaryKeys.patientWeight].int, weight != 0{
            self.patientWeight = weight
        }
        self.idealWeightType = medicalInfo[DictionaryKeys.patientIdealWeightType].intValue
        self.patientIdealWeight = medicalInfo[DictionaryKeys.patientIdealWeight].intValue
        self.excessWeightType = medicalInfo[DictionaryKeys.patientExcessWeightType].intValue
        if let patientExcessWeight = medicalInfo[DictionaryKeys.patientExcessWeight].int, patientExcessWeight != 0{
            self.patientExcessWeight = patientExcessWeight
        }
        self.patientMaximumWeightAchievedType = medicalInfo[DictionaryKeys.weightAchievedType].intValue
        if let meaximumWeightAchieved = medicalInfo[DictionaryKeys.weightAchieved].int, meaximumWeightAchieved != 0{
            self.patientMaximumWeightAchieved = meaximumWeightAchieved
        }

        self.maximumWeightLossType = medicalInfo[DictionaryKeys.weightLossType].intValue
        if let patientMaximumWeightLoss = medicalInfo[DictionaryKeys.weightLoss].int, patientMaximumWeightLoss != 0{
            self.patientMaximumWeightLoss = patientMaximumWeightLoss
        }

        self.maximumLossWeight = medicalInfo[DictionaryKeys.weightLossReason].stringValue
        if let waist = medicalInfo[DictionaryKeys.waist].int{
            self.waistCircumferenceValue = waist
        }
        self.waistCircumference = medicalInfo[DictionaryKeys.waistType].intValue
        self.hipCircumference = medicalInfo[DictionaryKeys.hipType].intValue
        if let hip = medicalInfo[DictionaryKeys.hip].int{
            self.hipCircumferenceValue = hip
        }
        
        self.pastMedicalCompliants = medicalInfo[DictionaryKeys.pastMedicalComplaints].stringValue
        self.neurological = medicalInfo[DictionaryKeys.neurological].stringValue
        self.respiratory = medicalInfo[DictionaryKeys.respiratory].stringValue
        self.cardiac = medicalInfo[DictionaryKeys.cardiac].stringValue
        self.abdominal = medicalInfo[DictionaryKeys.abdominal].stringValue
        self.jointsAndBones = medicalInfo[DictionaryKeys.jointAndBones].stringValue
        self.hormonal = medicalInfo[DictionaryKeys.hormonal].stringValue
        self.physhological = medicalInfo[DictionaryKeys.psychological].stringValue
        self.others = medicalInfo[DictionaryKeys.otherComplaint].stringValue
        self.presentMedicalTreatment = medicalInfo[DictionaryKeys.presentMedicalTreatment].stringValue
    }

    var toDictionary: [String : Any] {
        get{
            var medicalDetail = [String : Any]()
            medicalDetail[DictionaryKeys.weight_type] = self.patientWeightType
            medicalDetail[DictionaryKeys.height_type] = self.patientHeightType
            medicalDetail[DictionaryKeys.height_type1] = self.patientHeight1
            medicalDetail[DictionaryKeys.height_type2] = self.patientHeight2
            medicalDetail[DictionaryKeys.weight] = self.patientWeight
            medicalDetail[DictionaryKeys.bloodGroup] = self.patientBloodGroup
            medicalDetail[DictionaryKeys.foodCategory] = self.foodCategory
            
//            medicalDetail["ideal_weight_type"] = self.idealWeightType
//            medicalDetail["ideal_weight"] = self.patientIdealWeight
//            medicalDetail["excess_weight_type"] = self.excessWeightType //
//            medicalDetail["excess_weight"] = self.patientExcessWeight
//            medicalDetail["weight_achieved_type"] = self.patientMaximumWeightAchievedType
            medicalDetail[DictionaryKeys.weightAchieved] = self.patientMaximumWeightAchieved
            medicalDetail[DictionaryKeys.weightLossType] = self.maximumWeightLossType
            medicalDetail[DictionaryKeys.weightLoss] = self.patientMaximumWeightLoss
            medicalDetail[DictionaryKeys.weightLossReason] = self.maximumLossWeight
            medicalDetail[DictionaryKeys.waistType] = self.waistCircumference
            medicalDetail[DictionaryKeys.waist] = self.waistCircumferenceValue
            medicalDetail[DictionaryKeys.hipType] = self.hipCircumference
            medicalDetail[DictionaryKeys.hip] = self.hipCircumferenceValue
            medicalDetail[DictionaryKeys.previous_medical_history] = self.pastMedicalCompliants
            medicalDetail[DictionaryKeys.neurological] = self.neurological
            medicalDetail[DictionaryKeys.respiratory] = self.respiratory
            medicalDetail[DictionaryKeys.cardiac] = self.cardiac
            medicalDetail[DictionaryKeys.abdominal] = self.abdominal
            
            medicalDetail[DictionaryKeys.jointAndBones] = self.jointsAndBones
            medicalDetail[DictionaryKeys.hormonal] = self.hormonal
            medicalDetail[DictionaryKeys.psychological] = self.physhological
            medicalDetail[DictionaryKeys.otherComplaint] = self.others
            medicalDetail[DictionaryKeys.current_medication_detail] = self.presentMedicalTreatment

            return medicalDetail
        }
    }
}

//MedicalCategoryInfo
class MedicalCategoryInfo {

    var environmentalAllergy: String = ""
    var drugAllergy: String = ""
    var foodAllergy: String = ""
    
    init(medicalCategoryInfo: JSON) {
        
        self.environmentalAllergy = medicalCategoryInfo[DictionaryKeys.environmentalAllergy].stringValue
        self.drugAllergy = medicalCategoryInfo[DictionaryKeys.drugalAllergy].stringValue
        self.foodAllergy = medicalCategoryInfo[DictionaryKeys.foodAllergy].stringValue
    }
    
    var toDictionary: [String : Any] {
        get{
            
            var medicalCategoryinfo = [String : Any]()

            medicalCategoryinfo[DictionaryKeys.inputEnvironmentalAllergy] = self.environmentalAllergy
            medicalCategoryinfo[DictionaryKeys.inputDrugAllergy] = self.foodAllergy
            medicalCategoryinfo[DictionaryKeys.inputFoodAllergy] = self.drugAllergy

            return medicalCategoryinfo
        }
    }
    

}

//Treatment Detail
class TreatmentDetailInfo {
    var operativeApproach: String = ""
    var reasonOfRevision: String = ""
    var isRevision: Bool = false
    var isOtherReasonOfRevision: Bool = false
    var pleaseSpecify: String = ""
    var surgeryName: String = ""
    var surgeryType: String = ""
    var dateOfAdmission : Date?
    var dateOfSurgery : Date?
    var dateofDischarge : Date?
    
    init(tretmentDetailInfo : JSON) {
        self.dateOfAdmission = tretmentDetailInfo[DictionaryKeys.admissionDate].stringValue.getDateFromString(.utcTime, .yyyyMMdd)
        self.dateOfSurgery = tretmentDetailInfo[DictionaryKeys.surgeryDate].stringValue.getDateFromString(.utcTime, .yyyyMMdd)
        self.dateofDischarge = tretmentDetailInfo[DictionaryKeys.dischargeDate].stringValue.getDateFromString(.utcTime, .yyyyMMdd)
        self.isRevision = tretmentDetailInfo[DictionaryKeys.isRevision].boolValue
        self.isOtherReasonOfRevision = tretmentDetailInfo[DictionaryKeys.isOtherRevision].boolValue
        self.reasonOfRevision = tretmentDetailInfo[DictionaryKeys.reasonOfRevision].stringValue
        self.pleaseSpecify = tretmentDetailInfo[DictionaryKeys.otherRevision].stringValue
        self.operativeApproach = tretmentDetailInfo[DictionaryKeys.operativeApporoach].stringValue
        self.surgeryName = tretmentDetailInfo[DictionaryKeys.surgeryName].stringValue
        self.surgeryType = tretmentDetailInfo[DictionaryKeys.surgeryType].stringValue
    }
}

//UserActivityInfo
class UserActivityInfo {

    var activity: Int?
    var familiyHistoryObesity: Int = 0
    var familiyHistoryObesityReason: String = ""
    var familyHistoryOfMedicalDiseases: Int = 0
    var familyHistoryOfMedicalDiseasesReason: String = ""
    var loveToEat: Int = 0
    var excessiveApetite: Int = 0
    var excessiveApetiteReason: String = ""
    var erracticTimming: Int = 0
    var eatingVolume: Int = 0
    var afinitySweets: Int = 0
    var alcohol: Int = 0
    var alcoholReason: String = ""
    var tobacco: Int = 0
    var tobaccoReason: String = ""
    var illegalDrug: Int = 0
    var illegalDrugReason: String = ""
    var presentJunkFood: String = ""
    var pastJunkFood: String = ""
    var obese: Int = 0
    var treatmentForObesity: Int = 0
    var treatmentForObesityReason: String = ""

    init(userActivityInfo : JSON) {
        
        if let activityData = userActivityInfo[DictionaryKeys.patientActivity].int{
            self.activity = activityData
        }
        self.familiyHistoryObesity = userActivityInfo[DictionaryKeys.familyObesity].intValue
        self.familiyHistoryObesityReason = userActivityInfo[DictionaryKeys.familyObesityReason].stringValue
        
        self.familyHistoryOfMedicalDiseases = userActivityInfo[DictionaryKeys.familyMedicalHistory].intValue
        self.familyHistoryOfMedicalDiseasesReason = userActivityInfo[DictionaryKeys.familyMedicalHistoryreason].stringValue
        self.loveToEat = userActivityInfo[DictionaryKeys.loveToEat].intValue
        self.excessiveApetite = userActivityInfo[DictionaryKeys.appetite].intValue
        self.excessiveApetiteReason = userActivityInfo[DictionaryKeys.appetiteReason].stringValue
        self.erracticTimming = userActivityInfo[DictionaryKeys.erratic].intValue
        self.eatingVolume = userActivityInfo[DictionaryKeys.eatingVolumes].intValue
        self.afinitySweets = userActivityInfo[DictionaryKeys.sweetAfinity].intValue
        self.alcohol = userActivityInfo[DictionaryKeys.alcohol].intValue
        self.alcoholReason = userActivityInfo[DictionaryKeys.alcoholReason].stringValue
        
        self.tobacco = userActivityInfo[DictionaryKeys.tobacco].intValue
        self.tobaccoReason = userActivityInfo[DictionaryKeys.tobaccoReason].stringValue
        self.illegalDrug = userActivityInfo[DictionaryKeys.illegalDrugs].intValue
        self.illegalDrugReason = userActivityInfo[DictionaryKeys.illegalDrugsReason].stringValue
        self.presentJunkFood = userActivityInfo[DictionaryKeys.curr_junk_food].stringValue
        self.pastJunkFood = userActivityInfo[DictionaryKeys.past_junk_food].stringValue
        self.obese = userActivityInfo[DictionaryKeys.obese].intValue
        self.treatmentForObesity = userActivityInfo[DictionaryKeys.obesityTreatment].intValue
        self.treatmentForObesityReason = userActivityInfo[DictionaryKeys.obesityTreatmentReason].stringValue
    }
    
    var toDictionary: [String : Any] {
        get {
            var userAddressDetail = [String : Any]()
            
            userAddressDetail[DictionaryKeys.patientActivity] = self.activity
            userAddressDetail[DictionaryKeys.familyObesity] = self.familiyHistoryObesity
            userAddressDetail[DictionaryKeys.familyObesityReason] = self.familiyHistoryObesityReason
            userAddressDetail[DictionaryKeys.familyMedicalHistory] = self.familyHistoryOfMedicalDiseases
            userAddressDetail[DictionaryKeys.familyMedicalHistoryreason] = self.familyHistoryOfMedicalDiseasesReason
            userAddressDetail[DictionaryKeys.loveToEat] = self.loveToEat
            userAddressDetail[DictionaryKeys.appetite] = self.excessiveApetite
            userAddressDetail[DictionaryKeys.appetiteReason] = self.excessiveApetiteReason
            userAddressDetail[DictionaryKeys.erratic] = self.erracticTimming
            userAddressDetail[DictionaryKeys.eatingVolumes] = self.eatingVolume
            userAddressDetail[DictionaryKeys.sweetAfinity] = self.afinitySweets
            userAddressDetail[DictionaryKeys.alcohol] = self.alcohol
            userAddressDetail[DictionaryKeys.alcoholReason] = self.alcoholReason
            userAddressDetail[DictionaryKeys.tobacco] = self.tobacco
            userAddressDetail[DictionaryKeys.tobaccoReason] = self.tobaccoReason
            userAddressDetail[DictionaryKeys.illegalDrugs] = self.illegalDrug
            userAddressDetail[DictionaryKeys.illegalDrugsReason] = self.illegalDrugReason
            userAddressDetail[DictionaryKeys.curr_junk_food] = self.presentJunkFood
            userAddressDetail[DictionaryKeys.past_junk_food] = self.pastJunkFood
            userAddressDetail[DictionaryKeys.obese] = self.obese
            userAddressDetail[DictionaryKeys.obesityTreatment] = self.treatmentForObesity
            userAddressDetail[DictionaryKeys.obesityTreatmentReason] = self.treatmentForObesityReason

            return userAddressDetail
        }
    }
}

//UserActivityInfo
class UserHospitalInfo {
    
    var doctorId: Int?
    var doctorName: String = ""
    var doctorFirstName: String = ""
    var docPic: String = ""
    var doctorSpecialization: String = ""
    var hospitalAddress: String = ""
    var associatedDoctor: String = ""
    var isOtherDoctor: Bool = false
    var otherDoctor: String = ""
    
    init(hospitalInfo : JSON) {

        self.doctorName = hospitalInfo[DictionaryKeys.doctorName].stringValue
        self.doctorFirstName = hospitalInfo[DictionaryKeys.doctorFirstName].stringValue
        self.docPic = hospitalInfo[DictionaryKeys.doctorPic].stringValue
        self.doctorSpecialization = hospitalInfo[DictionaryKeys.doctorSpecialization].stringValue
        self.hospitalAddress = hospitalInfo[DictionaryKeys.hospitalName].stringValue
        self.associatedDoctor = hospitalInfo[DictionaryKeys.otherDcotor].stringValue
        self.isOtherDoctor = hospitalInfo[DictionaryKeys.isOtherDoctor].boolValue
        self.otherDoctor = hospitalInfo[DictionaryKeys.othersDcotor].stringValue
    }
}
