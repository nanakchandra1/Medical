//
//  AppUserDefaults+Key.swift
//  StarterProj
//
//  Created by MAC on 07/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation

extension AppUserDefaults {

    enum Key : String {
        
        case deviceToken = "deviceToken"
        
        case patientTile = "patientTile"
        case patientName = "patientName"
        case firstname = "firstname"
        case middleName = "middleName"
        case lastName = "lastName"
        case p_gender = "p_gender"
        case email = "email"
        case patientContact = "patientContact"
        case patientpic = "patientpic"
        case uhId = "uhId"
        case nationalID = "nationalID"
        case patientDob = "patientDob"
        case patientMobileNumber = "patientMobileNumber"
        case userId = "p_id"
        case accessToken = "accessToken"

        case fatherTitle = "fatherTitle"
        case spouseTitle = "spouseTitle"
        case fatherName = "fatherName"
        case spouseName = "spouseName"
        
        case doctorName = "doctorName"
        case doctorId = "doctorId"
        case specification = "specification"
        
        case ethinicityId = "ethinicityId"
        case stepVerified = "stepVerified"
        case rating = "rating"
        case patientSpeciality = "patientSpeciality"
        case mobileVerified = "mobileVerified"
        case isproceedToLogIn = "isproceedToLogIn"
        case patientLastVisit = "patientLastVisit"
        case surgeryId = "surgeryId"
        case patientReviewedOn = "patientReviewedOn"
        case doctorSpecialization = "doctorSpecialization"
        
        case patientHeightType = "patientHeightType"
        case patientHeight = "patientHeight"
        case patientHeight1 = "patientHeight1"
        case patientHeight2 = "patientHeight2"
        case weightType = "weightType"
        case patientWeight = "patientWeight"
        case bloddGroup = "bloddGroup"
        case hyperTension = "hyperTension"
        case fatherHyperTension = "fatherHyperTension"
        case motherHyperTension = "motherHyperTension"
        case diabities = "diabities"
        case fatherDiabities = "fatherDiabities"
        case motherDiabities = "motherDiabities"
        case smoking = "smoking"
        
        case patientAllergy = "p_allergies"
        case foodDecription = "food_description"
        case familyAllergy = "f_allergies"
        case previousAllergy = "prev_allergies"
        case foodCategory = "food_category"
        
        case dateOfAdmission = "date_admission"
        case dateOfSurgery = "date_surgery"
        case dateOfDischarge = "date_discharge"
        
        case patientISDCode = "p_isd_code"
        case patientState = "p_state"
        case patientCountry = "p_country"
        case patientCity = "p_city"
        case postalCode = "p_postal_code"
        case patientAddress = "p_address1"
        case patientAddressType = "p_address_type"
        
    }
}
