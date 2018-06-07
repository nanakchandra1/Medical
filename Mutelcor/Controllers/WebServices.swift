 //
//  WebServices.swift
//  Mutelcor
//
//  Created by  on 08/03/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire 


extension NSError {
    
    convenience init(localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

class WebServices {
    
    //    MARK:- Login
    //    =============
    static func login(parameters: JSONDictionary,
                      success: @escaping (_ user: UserInfo) -> Void,
                      failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.patientLogin.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            var userInfo: UserInfo?
                            if let userData = json[response].array , !userData.isEmpty {
                                userInfo = UserInfo(userData: userData[0])
                                AppUserDefaults.saveUserDetail(userData[0])
                                AppUserDefaults.saveUserAddressDetail(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                                AppUserDefaults.saveTreatmentDetailInfo(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                            }
                            if let userData = userInfo {
                                success(userData)
                            }
                            
                            if (json[error_code] != 200 && json[error_code] != 204) && (json[response].arrayValue.isEmpty) {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- SendOTP
    //    ==============
    static func sendOtp(parameters: JSONDictionary,
                        success: @escaping (String) -> Void,
                        failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.sendOtp.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Forgot Password Service
    //    ==============================
    static func forgotPassword(parameters: JSONDictionary,
                               success: @escaping (String) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.forgetPassword.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- SignUp Service
    //    ======================
    static func signUp(parameters: JSONDictionary,
                       success: @escaping (_ user: UserInfo) -> Void,
                       failure: @escaping (_ error: Error,_ errorCode: Int?) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.patientSignUp.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array, !data.isEmpty else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error, nil)
                                    return
                                }
                                if !data.isEmpty{
                                    guard let _ = data.first?.dictionary else{
                                        let error = NSError(localizedDescription: json[error_string].stringValue)
                                        failure(error, nil)
                                        return
                                    }
                                }
                                var userInfo: UserInfo!
                                
                                userInfo = UserInfo(userData: data[0])
                                
                                AppUserDefaults.saveUserDetail(data[0])
                                AppUserDefaults.saveUserAddressDetail(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                
                                    success(userInfo)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error, json[error_code].intValue)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error, nil)
        })
    }
    
    //    MARK:- PostSignUP1 Service (Personal InformationDetail)
    //    =======================================================
    static func personalInfo(parameters: JSONDictionary,
                             imageData: [String: Any],
                             success: @escaping (UserInfo) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        var params = parameters
        params["id"] = AppUserDefaults.value(forKey: .userId)
        AppNetworking.PostWithMultipleData(endPoint: EndPoint.postSignUp1.url,
                                           parameters: params,
                                           loader: false,
                                           imageData: imageData,
                                           success: { (json: JSON) in
                                            
                                            var userInfo: UserInfo?
                                            var treatmentData: [TreatmentDetailInfo] = []

                                            if let userData = json[response].array , !userData.isEmpty {
                                                
                                                userInfo = UserInfo(userData: userData[0])
                                                AppUserDefaults.saveUserDetail(userData[0])
                                                AppUserDefaults.saveUserAddressDetail(userData[0])
                                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                                                AppUserDefaults.saveTreatmentDetailInfo(userData[0])
                                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                                            }
                                            if let treatment = json["surgery_data"].array{
                                                for value in treatment{
                                                    treatmentData.append(TreatmentDetailInfo.init(tretmentDetailInfo: value))
                                                }
                                            }
                                            if let userData = userInfo {
                                                success(userData)
                                            }
                                            
                                            if ((json[error_code] != 200 && json[error_code] != 204) && json[response].arrayValue.isEmpty) {
                                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                                failure(error)
                                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Type Of Surgery
    //    =====================
    static func typeOfSurgery(success: @escaping (_ surgeryInfo: [SurgeryModel]) -> Void,
                              failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.typeOfSurgery.url,
                          loader: true,
                          success: {(json: JSON) -> Void in
                            
                            let surgeryData = SurgeryModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(surgeryData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) && surgeryData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        },failure: { (error : Error) -> Void in
            
            failure(error)
        })
    }
    
    //    MARK:- Hit Speciality Service
    //    =============================
    static func speciality(success: @escaping (_ surgeryInfo: [SpecialityModel]) -> Void,
                           failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.speciality.url,
                          loader: true,
                          success: {(_ json: JSON) -> Void in
                            
                            let specialityData = SpecialityModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(specialityData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) && specialityData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        },failure: { (error : Error) in
            failure(error)
        })
    }

    //    MARK: Hit GetCountry Service
    //     =============================
    static func getCountryList(parameters: JSONDictionary,
                               success: @escaping (_ countryInfo: [CountryCodeModel]) -> Void,
                               failure: @escaping (Error) -> Void){
        
        //printlnDebug("getCountryParams: \(parameters)")
        AppNetworking.GET(endPoint: EndPoint.getCountry.url,
                          parameters: parameters,
                          loader: false,
                          success: {(_ json: JSON) -> Void in
                            
                            let countryCode = CountryCodeModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) && countryCode.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
                            success(countryCode)
        },failure: { (error : Error) in
            failure(error)
        })
    }
    
    //    MARK: Fetch ethinicity
    //    =======================
    static func getEthinicityList(parameters: JSONDictionary,
                                  success: @escaping (_ ethinicityInfo: [EthinicityNameModel]) -> Void,
                                  failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.fetchEthinicity.url,
                          loader: false,
                          success: { (_ json: JSON) in
            
            let ethinicityName = EthinicityNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(ethinicityName)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) && ethinicityName.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: Get State Listing
    //    =======================
    
    static func getStateList(parameters: JSONDictionary,
                             success: @escaping (_ stateInfo: [StateNameModel]) -> Void,
                             failure: @escaping (Error) -> Void){
        
        //printlnDebug("getStateParams: \(parameters)")
        AppNetworking.GET(endPoint: EndPoint.getStates.url,
                          parameters: parameters,
                          loader: true,
                          success: {(_ json: JSON) -> Void in
                            
                            let stateName = StateNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(stateName)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) && stateName.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        },failure: { (error : Error) in
            failure(error)
        })
    }
    
    //    Mark: Get CityListing
    //    ======================
    
    static func getTownList(parameters: JSONDictionary,
                            success: @escaping (_ cityInfo: [CityNameModel]) -> Void,
                            failure: @escaping (Error) -> Void){
        //printlnDebug("getTownParams: \(parameters)")
        AppNetworking.GET(endPoint: EndPoint.getCity.url,
                          parameters: parameters,
                          loader: true,
                          success: {(_ json: JSON) -> Void in
                            
                            let cityName = CityNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(cityName)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) && cityName.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        },failure: { (error : Error) in
            
            failure(error)
        })
    }

    //    MARK:- Hit ResetPassword Service
    //    =================================
    static func resetPassword(parameters: JSONDictionary,
                              success: @escaping (_ user: UserInfo) -> Void,
                              failure: @escaping (Error) -> Void) {
        
        //printlnDebug("resetPaaword: \(parameters)")
        AppNetworking.POST(endPoint: EndPoint.resetPassword.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            var userInfo: UserInfo!
                            
                            if let userData = json[response].array{
                                userInfo = UserInfo(userData: userData[0])
                                AppUserDefaults.saveUserDetail(userData[0])
                                AppUserDefaults.saveUserAddressDetail(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                                AppUserDefaults.saveTreatmentDetailInfo(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                            }
                            if let userData = userInfo {
                                success(userData)
                            }
                            if (json[error_code] != 200 && json[error_code] != 204) && (json[response].arrayValue.isEmpty) {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- HIT OTPVerification Service
    //    ==================================
    static func otpVerification(parameters: JSONDictionary,
                                success: @escaping (_ str: String) -> Void,
                                failure: @escaping (Error) -> Void) {
        
        //printlnDebug("resetPaaword: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.otpVerification.url,
                           parameters: parameters,
                           loader: true,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code] == 200 {
                               success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Appointment History
    //    ==========================
    static func appointmentHistory(success: @escaping (_ appHistory: [UpcomingAppointmentModel]) -> Void,
                                   failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getAppointmentHistory.url,
                          success: {(_ json: JSON) -> Void in
                            
                            let appointmentHistory = UpcomingAppointmentModel.modelFromDictionary(json[response].arrayValue)
                            success(appointmentHistory)
                            
                            if ((json[error_code].intValue != 200) && (json[error_code].intValue != 204)) && appointmentHistory.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- UpComing Appointments
    //    ============================
    static func upcomingAppointments(loader: Bool = true,
                                     success: @escaping (_ appHistory: [UpcomingAppointmentModel]) -> Void,
                                     failure: @escaping (Error) -> Void){

        AppNetworking.GET(endPoint: EndPoint.upcomingAppointments.url,
                          loader: loader,
                          success: {(_ json: JSON) -> Void in
                            
                            let upcomingAppointment = UpcomingAppointmentModel.modelFromDictionary(json[response].arrayValue)
                            success(upcomingAppointment)
                            
                            if ((json[error_code].intValue != 200) && (json[error_code].intValue != 204)), upcomingAppointment.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Symptoms
    //    ================
    static func getSymptoms(success: @escaping (_ symptomsList: [Symptoms]) -> Void,
                            failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getSymptoms.url,
                          success: {(_ json: JSON) -> Void in
                            let symptoms = Symptoms.modelFromDictionary(json[response].arrayValue)
                            success(symptoms)
                            if ((json[error_code].intValue != 200) && (json[error_code].intValue != 204)), symptoms.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Reschedule Symptoms
    //    ===========================
    static func rescheduleAppointment(parameters: JSONDictionary,
                                      success: @escaping (_ str: String) -> Void,
                                      failure: @escaping (Error) -> Void) {
        
        //printlnDebug("rescheduleAppointment: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.rescheduleAppointment.url,
                           parameters: parameters,
                           loader: true,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                success(json[error_string].stringValue)
                            }else {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- AvailiableTimeSlot
    //    =========================
    static func availiableTimeSlot(parameters: JSONDictionary,
                                   success: @escaping (_ timeSlots: [TimeSlotModel],_ errorCode: Int) -> Void,
                                   failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getDoctorAvailiableSlot.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json: JSON) in
                            
                            let timeSlotData = TimeSlotModel.modelFromDictionary(json[response].arrayValue)
                            success(timeSlotData, json[error_code].intValue)
                            
                            if ((json[error_code] != 200) && (json[error_code] != 204)), timeSlotData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    // MARK:- Add Appointment
    // ===========================
    static func addAppointment(parameters: JSONDictionary,
                               success: @escaping (_ str: String) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addAppointment.url,
                           parameters: parameters,
                           loader: true,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                success(json[error_string].stringValue)
                            }else if json[error_code].intValue == 500 {
                                success(json[error_string].stringValue)
                            }
                            else {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Cancel Upcoming Appointment
    //    ==================================
    static func cancelAppointment(parameters: JSONDictionary,
                                  success: @escaping (_ str: String) -> Void,
                                  failure: @escaping (Error) -> Void) {
        
        //printlnDebug("cancelAppointment: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.cancelAppointment.url,
                           parameters: parameters,
                           loader: true,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                success(json[error_string].stringValue)
                                
                            }else if json[error_code].intValue == 500{
                                success(json[error_string].stringValue)
                            }
                            else {
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
                            
        }, failure: {(error: Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Measurement Module Services
    //    ====================================
    //    MARK: Get Measurement Category
    //    ==============================
    static func getMeasurementCategory(success: @escaping (_ measurementFormData: [MeasurementCategory]) -> Void,
                                       failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementCategory.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let measurementCategory = MeasurementCategory.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(measurementCategory)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , measurementCategory.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: GetVitalData Service
    //    ============================
    static func getMeasurementHomeData(parameters: JSONDictionary,
                                       success: @escaping (_ measurementHomeData: [MeasurementHomeData], _ imageData: [ImageDataModel]) -> Void,
                                       failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementHomeList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let measurementHomeData = MeasurementHomeData.modelsFromDictionaryArray(array: json[response].arrayValue)
                            let imageData = ImageDataModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(measurementHomeData, imageData)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , (measurementHomeData.isEmpty && imageData.isEmpty) {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: Get Vital List
    //    =====================
    static func getVitalList(parameters: JSONDictionary,
                             success: @escaping (_ vitalList: [VitalListModel]) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getVitalList.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json: JSON) in
                            
                            let vitalData = VitalListModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(vitalData)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , vitalData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: GetLatest Vitals
    //    =======================
    static func getLatestVitals(parameters: JSONDictionary,
                                success: @escaping (_ getLatestThreVitalData: [LatestThreeVitalData]) -> Void,
                                failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getLatestVitals.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let latestVitalData = LatestThreeVitalData.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(latestVitalData)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , latestVitalData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get TabularData
    //    ======================
    static func getTabularData(parameters: JSONDictionary,
                               success: @escaping (_ data: [[MeasurementTablurData]], _ nextCount: Int, _ subvital: [MeasurementTabularSubVital]) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getTabularList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let measurementData = MeasurementTablurData.modelFromJsonArray(json[response].arrayValue)
                            let measurementSubVitalData = MeasurementTabularSubVital.modelFromJsonArray(json["sub_vitals"].arrayValue)
                            guard let count = json["next_count"].int else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                                return
                            }
                            success(measurementData, count, measurementSubVitalData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) , measurementData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    
    //    MARK: Get Attachment Data
    //      =======================
    static func getAttachmentList(parameters: JSONDictionary,
                                  success: @escaping (_ attachmentList: [AttachmentDataModel]) -> Void,
                                  failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getAttachmentList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let attachmentData = AttachmentDataModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(attachmentData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) , attachmentData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: MeasurementFormData
    //    ==========================
    static func getMeasurementFormBuilder(parameters: JSONDictionary,
                                          success: @escaping (_ measurementFormData: [MeasurementFormDataModel]) -> Void,
                                          failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementFormBuilder.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let measuremntFormData = MeasurementFormDataModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(measuremntFormData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) , measuremntFormData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: Add Measurement
    //    ======================
    static func addMeasurement(parameters: JSONDictionary,
                               imageData: [String: Any],
                               success: @escaping (_ str: String) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        //printlnDebug("addMeasuremnetParamerters: \(parameters)")
        
        AppNetworking.PostWithMultipleData(endPoint: EndPoint.addMeasurement.url,
                                           parameters: parameters,
                                           loader: false,
                                           imageData: imageData,
                                           success: { (_ json: JSON) in
                                            
                                            if json[error_code].intValue == 200 {
                                                success(json[error_string].stringValue)
                                            }else{
                                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                                failure(error)
                                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK: ActivityForm
    //    ===================
    static func getActivityFormData(success: @escaping (_ measurementFormData: [ActivityFormModel]) -> Void,
                                    failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityForm.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let activityData = ActivityFormModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(activityData)
                            
                            if (json[error_code] != 200 && json[error_code] != 204) && activityData.isEmpty {
                                
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    
    //MARK:- Seven Days Activity Average
    //===================================
    static func sevenDaysActivityAvg(parameters: JSONDictionary,
                                     success: @escaping (_ sevenDaysAvgData: [SevenDaysAvgData]) -> Void,
                                     failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.sevenDaysActivityAvg.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let sevenDaysData = SevenDaysAvgData.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(sevenDaysData)
                            if (json[error_code] != 200 && json[error_code] != 204) && sevenDaysData.isEmpty {
                                
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Day wise Activity Data(Prescribe and Consume Data)
    //    =========================================================
    static func getActivityBySelectedDate(parameters: JSONDictionary,
                                          success: @escaping (_ prescribeData: [JSON]) -> Void,
                                          failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityByDate.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let activityDataByDate = json[response].arrayValue
                            success(activityDataByDate)
                            
                            if (json[error_code] != 200 &&  json[error_code] != 204) && activityDataByDate.isEmpty {
                                
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            
            failure(error)
            
        }
    }
    
    //    MARK:- Previous Activity Plan
    //    =============================
    static func getPreviousActivity(parameters: JSONDictionary,
                                    success: @escaping (_ prescribeData: [PreviousActivityPlan], _ do: [JSON], _ donts: [JSON],_  pointToRember: [PointsToRemember]) -> Void,
                                    failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.previousActivityPlan.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let previousActivityData = PreviousActivityPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            guard let doArray = json["do"].array else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                                return
                            }
                            
                            guard let dontsArray = json["do_not"].array else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                                return
                            }
                            let pointToRemember = PointsToRemember.modelsFromDictionaryArray(array: json[DictionaryKeys.pointToRemember].arrayValue)
                            success(previousActivityData, doArray, dontsArray, pointToRemember)
                            
                            if (json[error_code] != 200 &&  json[error_code] != 204) && previousActivityData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Current Activity Plan
    //    =============================
    static func getCurrentActivity(parameters: JSONDictionary,
                                   success: @escaping (_ prescribeData: [PreviousActivityPlan], _ do: [JSON], _ donts: [JSON], _ pointToRember: [PointsToRemember]) -> Void,
                                   failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.currentActivityPlan.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let currentActivityPlan = PreviousActivityPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            guard let doArray = json["do"].array else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                                return
                            }
                            
                            guard let dontsArray = json["do_not"].array else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                                return
                            }
                            let pointToRemember = PointsToRemember.modelsFromDictionaryArray(array: json[DictionaryKeys.pointToRemember].arrayValue)
                            success(currentActivityPlan, doArray, dontsArray, pointToRemember)
                            
                            if (json[error_code] != 200 &&  json[error_code] != 204) && currentActivityPlan.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Activity List In Tabular Form
    //    ========================================
    static func getActivityInTabularForm(parameters: JSONDictionary,
                                         loader: Bool,
                                         success: @escaping (_ prescribeData: [ActivityDataInTabular], _ count: Int) -> Void,
                                         failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityInTabular.url,
                          parameters: parameters,
                          loader: loader,
                          success: { (_ json: JSON) in
                            
                            if json[error_code] == 200 {
                                guard let count = json["next_count"].int else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                
                                guard let activityListInTabularData = json[response].array else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                var activityListinTabularForm = [ActivityDataInTabular]()
                                if !activityListInTabularData.isEmpty{
                                    for data in activityListInTabularData {
                                        activityListinTabularForm.append(ActivityDataInTabular(data)!)
                                    }
                                }
                                success(activityListinTabularForm, count)
                            }else{
                                guard let _ = json[response].array else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                
                                let activityListinTabularForm = [ActivityDataInTabular]()
                                
                                success(activityListinTabularForm, 0)
                                
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Recent Activity
    //    ======================
    static func getRecentActivity(parameters: JSONDictionary,
                                  success: @escaping (_ prescribeData: [RecentActivityModel]) -> Void,
                                  failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.recentActivity.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            if json[error_code] == 200 {
                                guard let recentActivityDataValues = json[response].array else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                
                                var recentActivityData = [RecentActivityModel]()
                                
                                if !recentActivityDataValues.isEmpty{
                                    for data in recentActivityDataValues {
                                        recentActivityData.append(RecentActivityModel(data))
                                    }
                                }
                                success(recentActivityData)
                            }else{
                                
                                guard let _ = json[response].array else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                
                                let activityListinTabularForm = [RecentActivityModel]()
                                success(activityListinTabularForm)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Add Activity
    //    ===================
    static func addActivity(parameters: JSONDictionary,
                            success: @escaping (_ meassage: String) -> Void,
                            failure: @escaping (Error) -> Void) {
        
        //printlnDebug("parameters: \(parameters)")
        AppNetworking.POST(endPoint: EndPoint.addActivity.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                guard let errorString = json[error_string].string else{
                                    let error = NSError(localizedDescription: json[error_string].stringValue)
                                    failure(error)
                                    return
                                }
                                success(errorString)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].stringValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK: Get Meal Schedule
    //    =========================
    static func getMealSchedule(success: @escaping ([MealSchedule]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getMealSchedule.url, success: { (json: JSON) -> Void in
            
            let mealSchedules: [MealSchedule] = MealSchedule.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(mealSchedules)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , mealSchedules.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK: Get Food
    //    ==============
    static func getFoods(success: @escaping ([Food]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getFoods.url, success: { (json: JSON) -> Void in
            
            let foods: [Food] = Food.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(foods)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , foods.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK: Day Wise Nutrition
    //    =========================
    static func getDayWiseNutrition(parameters: JSONDictionary, success: @escaping ([DayWiseNutrition], [GraphView]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getDayWiseNutrition.url, parameters: parameters, success: { (json: JSON) -> Void in
            
            if json[error_code].intValue == 200 {
                
                let planedData = json[response].arrayValue
                let graphData = json["graph_view"].arrayValue
                
                let dayWiseData: [DayWiseNutrition] = DayWiseNutrition.modelFromJsonArray(planedData)
                let graphViewData: [GraphView] = GraphView.modelFromJsonArray(graphData)
                
                success(dayWiseData, graphViewData)
                
                if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , (planedData.isEmpty || graphViewData.isEmpty) {
                    
                    let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                    failure(error)
                }
            }
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK: Nutrition Data In Table
    //    =============================
    static func getNutritionDataInTable(parameters: JSONDictionary, loader: Bool, success: @escaping ([NutritionGraphData], _ nextCount: Int) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionDataList.url,
                          parameters: parameters,
                          loader: loader,
                          success: { (json: JSON) -> Void in
            
            let nutrientsData = json[response].arrayValue
            let nutrientsList: [NutritionGraphData] = NutritionGraphData.modelFromJsonArray(nutrientsData)
            
            success(nutrientsList, json["next_count"].intValue)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , nutrientsData.isEmpty{
                
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK: Get week Performance
    //    =============================
    static func getWeekPerformance(parameters: JSONDictionary, success: @escaping ([[WeekPerformance]]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getWeekPerformance.url, parameters: parameters, success: { (json: JSON) -> Void in
            
            let weekPerformanceData = json[response].arrayValue
            
            let weekPerformance: [[WeekPerformance]] = WeekPerformance.modelFromJsonArray(weekPerformanceData)
            
            success(weekPerformance)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , weekPerformanceData.isEmpty{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK: Get Recent Nutrition
    //    ==============
    static func getRecentNutritions(success: @escaping ([RecentFood]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getRecentNutritions.url, success: { (json: JSON) -> Void in
            
            let foods: [RecentFood] = RecentFood.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(foods)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , foods.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK: Add Nutrition
    //    ==============
    static func addNutritionData(parameters: JSONDictionary, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addNutritionData.url,
                           parameters: parameters,
                           loader: false,
                           success: { (json: JSON) -> Void in
            
            if json[error_code].intValue == 200 {
                success(true)
            } else {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK: Previous Nutrition Plan
    //    ==============
    static func getPreviousNutritionPlan(success: @escaping ([NutritionPlan], [FoodAvoid], [DailyAllowance], [NutritionPointToRemember]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPreviousNutritionPlan.url, success: { (json: JSON) -> Void in
            
            let foodAllowances = FoodAvoid.modelsFromDictionaryArray(array: json[DictionaryKeys.foodAvoid].arrayValue)
            let dailyAllowances = DailyAllowance.modelsFromDictionaryArray(array: json[DictionaryKeys.dailyAllowances].arrayValue)
            let nutritionPlans: [NutritionPlan] = NutritionPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
            let pointToRemember = NutritionPointToRemember.modelsFromDictionaryArray(array: json[DictionaryKeys.pointToRemember].arrayValue)
            success(nutritionPlans, foodAllowances, dailyAllowances, pointToRemember)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , nutritionPlans.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK: Current Nutrition Plan
    //    ==============
    static func getCurrentNutritionPlan(success: @escaping ([NutritionPlan], [FoodAvoid], [DailyAllowance], [NutritionPointToRemember]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getCurrentNutritionPlan.url, success: { (json: JSON) -> Void in
            
            let foodAllowances = FoodAvoid.modelsFromDictionaryArray(array: json["food_avoid"].arrayValue)
            let dailyAllowances = DailyAllowance.modelsFromDictionaryArray(array: json[DictionaryKeys.dailyAllowances].arrayValue)
            
            let nutritionPlans: [NutritionPlan] = NutritionPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
            let pointToRemember = NutritionPointToRemember.modelsFromDictionaryArray(array: json[DictionaryKeys.pointToRemember].arrayValue)
            success(nutritionPlans, foodAllowances, dailyAllowances, pointToRemember)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , nutritionPlans.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK: Activity Graph Data
    //    =========================
    static func getActivityGraphData(parameters: JSONDictionary, success: @escaping ([ActivityGraphData]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityGraphData.url, parameters: parameters, success: { (json: JSON) -> Void in
            
            let activityGraphDataArray: [ActivityGraphData] = ActivityGraphData.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(activityGraphDataArray)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , activityGraphDataArray.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    
    //    MARK: Nutrition Graph Data
    //    ==========================
    static func getNutritionGraphData(parameters: JSONDictionary, success: @escaping ([NutritionChartData]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionGraphData.url, parameters: parameters, success: { (json: JSON) -> Void in
            
            let nutritionGraphDataArray: [NutritionChartData] = NutritionChartData.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(nutritionGraphDataArray)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , nutritionGraphDataArray.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue.localized)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    
    //    MARK: Measurement Graph Data
    //    ==========================
    static func getMeasurementGraphData(parameters: JSONDictionary,
                                        success: @escaping (MeasurementGraphList) -> Void,
                                        failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getMeasurementGraphData.url,
                          parameters: parameters,
                          success: { (json: JSON) -> Void in
                            
                            if let measurementGraphList = MeasurementGraphList(json: json) {
                                success(measurementGraphList)
                            } else {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Current EPrescription Services
    //    =====================================
    static func getCurrentEPrescription(success: @escaping ([EprescriptionModel]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getCurrentePrescription.url, success: { (json: JSON) -> Void in
            
            let ePrescriptionData = EprescriptionModel.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(ePrescriptionData)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , ePrescriptionData.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }, failure: { (error : Error) -> Void in
            
            
            failure(error)
        })
    }
    
    //    MARK:- Previous EPrescription Services
    //    =====================================
    static func getPreviousEPrescription(success: @escaping ([[EprescriptionModel]]) -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPreviousPrescription.url, success: { (json: JSON) -> Void in
            let ePrescriptionData = EprescriptionModel.modelsFromDictionaryDualArray(array: json[response].arrayValue)
            success(ePrescriptionData)
            
            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , ePrescriptionData.isEmpty {
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }, failure: { (error : Error) -> Void in
            
            failure(error)
        })
    }
    
    //    MARK:- Get Log Book Data
    //    ========================
    static func getlogBookData(parameters: JSONDictionary,
                               success: @escaping ([LogBookModel]) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPatientLog.url,
                          parameters: parameters,
                          loader: true,
                          success: { (json: JSON) -> Void in
                            
                            let logBookData = LogBookModel.modelsFromDictionaryArray(data: json[response].arrayValue)
                            success(logBookData)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , logBookData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Get LogBook Yearly Data
    //    ==============================
    static func getLogBookYearlyData(parameters: JSONDictionary,
                                     success: @escaping ([YearlyLogBookModel]) -> Void,
                                     failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getYearlyPatientLog.url,
                          parameters: parameters,
                          loader: true,
                          success: { (json: JSON) in
                            
                            let logBookYearData = YearlyLogBookModel.modelsFromDictionaryDualArray(array: json[response].arrayValue)
                            success(logBookYearData)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , logBookYearData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }, failure: { (error : Error) -> Void in
            failure(error)
        })
    }
    
    //    MARK:- Add reminder
    //    ====================
    static func addReminder(parameters: JSONDictionary,
                            loader: Bool,
                            success: @escaping (_ message: String) -> Void,
                            failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addReminder.url,
                           parameters: parameters,
                           loader: loader,
                           success: { (_ json: JSON) in
                            
                            if json[error_code].intValue == 200 {
                                success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
                            
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Delete Reminder
    //    ======================
    static func deleteReminder(success: @escaping ([YearlyLogBookModel]) -> Void,
                               failure: @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.deleteReminder.url,
                          loader: true,
                          success: { (json: JSON) in
                            
        }, failure: { (error : Error) in
            failure(error)
        })
    }
    
    //    MARK:- Get Discharge Summary
    //    ===============================
    static func getDischargeSummary(success: @escaping ([DischargeSummaryModel]) -> Void,
                                    failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getDischargeSummary.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let dischargeSummaryData = DischargeSummaryModel.modelsFromDictionaryDualArray(array: json[response].arrayValue)
                            
                            success(dischargeSummaryData)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , dischargeSummaryData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Patient Message
    //    ===============================
    static func getPatientMessage(success: @escaping ([PatientMessageModel]) -> Void,
                                  failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPatientMessage.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let patientMessageData = PatientMessageModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(patientMessageData)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , patientMessageData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Patient Latest Messages
    //    ==================================
    static func getPatientLatestMessage(parameters: JSONDictionary,
                                        loader: Bool,
                                        success: @escaping ([String: [PatientLatestMessages]]) -> Void,
                                        failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPatientLatestMessages.url,
                          parameters: parameters,
                          loader: loader,
                          success: { (_ json: JSON) in

                            let patientLatestMessages = PatientLatestMessages.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(patientLatestMessages)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , patientLatestMessages.isEmpty {
                                if !(json[error_code].intValue == 204) {
                                    
                                    let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                    failure(error)
                                }
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Patient Old Messages
    //    ==================================
    static func getPatientOldMessage(parameters: JSONDictionary,
                                     success: @escaping ([String: [PatientLatestMessages]], _ nextHit: Int) -> Void,
                                     failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getOldMessages.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json: JSON) in
                            let patientOldMessages = PatientLatestMessages.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            var nextHit = 0
                            if let nextCount = json["next_hit"].int{
                                nextHit = nextCount
                            }
                            
                            success(patientOldMessages,nextHit)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , patientOldMessages.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Save Messages
    //    ====================
    static func saveMessages(parameters: JSONDictionary,
                             success: @escaping ([String: [PatientLatestMessages]]) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.saveMessages.url,
                           parameters: parameters,
                           loader: false,
                           success: { (_ json: JSON) in                            
                            let saveMessages = PatientLatestMessages.modelsFromDictionaryArray(array: json[response].arrayValue)
                            success(saveMessages)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , saveMessages.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Notifications
    //    ========================
    static func getNotification(parameteres: JSONDictionary,
                                loader: Bool,
                                success: @escaping ([NotificationModel], _ nextCount: Int) -> Void,
                                failure: @escaping (Error) -> Void) {
        
        
        
        AppNetworking.GET(endPoint: EndPoint.getNotification.url,
                          parameters: parameteres,
                          loader: loader,
                          success: { (_ json: JSON) in
                            
                            let notificationData = NotificationModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            var nextCount = 0
                            if let nxtCount = json["next_count"].int{
                                nextCount = nxtCount
                            }
                            
                            success(notificationData,nextCount)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , notificationData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Update Notifications
    //    ================================
    static func getUpdateNotification(parameteres: JSONDictionary,
                                      success: @escaping (_ message: String) -> Void,
                                      failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.updatepatientNotification.url,
                          parameters: parameteres,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let message = json[error_string].stringValue
                            success(message)
                            
                            if !(json[error_code].intValue == 200){
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Recent Symptoms
    //    ==========================
    static func getRecentSymptoms(success: @escaping (_ recentSymptoms: [RecentSymptoms]) -> Void,
                                  failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.recentSymptoms.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let recentSymptoms = RecentSymptoms.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(recentSymptoms)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , recentSymptoms.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Save Symptoms
    //    ====================
    static func saveSymptoms(parameters: JSONDictionary,
                             success: @escaping () -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.saveSymptoms.url,
                           parameters: parameters,
                           loader: false,
                           success: { (_ json: JSON) in
                            success()
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204){
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get All Symptoms
    //    ==========================
    static func getAllSymptoms(success: @escaping (_ recentSymptoms: [AllSymptoms]) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getAllSymptoms.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let allSymptoms = AllSymptoms.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(allSymptoms)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , allSymptoms.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get All Symptoms
    //    ==========================
    static func getCmsData(parameters: JSONDictionary,
                           success: @escaping (_ cmsData: [CmsData]) -> Void,
                           failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getCms.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            let cmsData = CmsData.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(cmsData)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , cmsData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    // MARK:- Get iHealth Access Token
    static func getiHealthAccessToken(parameters : JSONDictionary,
                                      success : @escaping (iHealthToken) -> Void,
                                      failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.iHealthAuthUrl.url,
                          parameters: parameters,
                          loader: true, success: { (_ json : JSON) in
                            
                            var editedJson = json
                            let expiryTime = json["Expires"].doubleValue
                            let currentTimeStamp = Date().timeIntervalSince1970
                            editedJson["Expires"] = JSON(currentTimeStamp + expiryTime)
                            
                            if let tokenData = iHealthToken(json: editedJson) {
                                var dict = json.dictionaryObject!
                                dict["client_para"] = nil
                                AppUserDefaults.save(value: dict, forKey: .iHealthToken)
                                success(tokenData)
                            } else {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Get iHealth Activity Data
    static func fetchARDataList(userId: String, parameters : JSONDictionary,
                                success : @escaping ([ARDataList]) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        let genericUrl = EndPoint.iHealthARDataUrl.url
        let url = genericUrl.replacingOccurrences(of: "{user-id}", with: userId)
        
        AppNetworking.GET(endPoint: url,
                          parameters: parameters,
                          loader: true, success: { (_ json : JSON) in
                            if let data = json["ARDataList"].array{
                                let iHealthData = ARDataList.modelsFromDictionaryArray(array: data)
                                
                                if !iHealthData.isEmpty {
                                    success(iHealthData)
                                } else {
                                    let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                    failure(e)
                                }
                            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Get PatientDetail
    static func getPatientDetail(success : @escaping (_ userInfo: UserInfo, _ treatmentInfo: [TreatmentDetailInfo]) -> Void,
                                      failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPatientDetails.url,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            var userInfo: UserInfo?
                            var treatmentData: [TreatmentDetailInfo] = []
                            
                            
                            if let userData = json[response].array , !userData.isEmpty {
                                
                                userInfo = UserInfo(userData: userData[0])
                                AppUserDefaults.saveUserDetail(userData[0])
                                AppUserDefaults.saveUserAddressDetail(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                                AppUserDefaults.saveTreatmentDetailInfo(userData[0])
                                AppUserDefaults.saveUserMedicalDetail(userData[0])
                            }
                            if let treatment = json["surgery_data"].array{
                                for value in treatment{
                                    treatmentData.append(TreatmentDetailInfo.init(tretmentDetailInfo: value))
                                }
                            }
                            if let userData = userInfo {
                                success(userData, treatmentData)
                            }
                            
                            if ((json[error_code] != 200 && json[error_code] != 204) && json[response].arrayValue.isEmpty) {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error) in
            failure(error)
        }
    }
    
    //    MARK:- Chnage Password
    //    =======================
    static func changePassword(parameters: JSONDictionary,
                               success: @escaping (_ errorString: String) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.changePassword.url,
                           parameters: parameters,
                           loader: false,
                           success: { (_ json: JSON) in
                            if json[error_code] == 200 {
                                success(json[error_string].stringValue)
                            }else{
                                    let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                    failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
//    MARK:- Send Otp To Old Number
//    =============================
    static func changeMobileNumberOtp(parameters: JSONDictionary,
                                   success: @escaping (_ errorString: String) -> Void,
                                   failure: @escaping (Error) -> Void) {

        AppNetworking.POST(endPoint: EndPoint.changeMobileNumberOtp.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json: JSON) in
                            
                            if json[error_code] == 200{
                               success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Chnage MobileNumber
    //    ==========================
    static func changeMobileNumber(parameters: JSONDictionary,
                                      success: @escaping (_ errorString: String) -> Void,
                                      failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.changePhoneNumber.url,
                           parameters: parameters,
                           loader: true,
                           success: { (_ json: JSON) in
                            
                            if json[error_code].intValue == 200{
                               success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
//    MARK:- Logout
//    =============
    static func logout(parameters: JSONDictionary,
                       success: @escaping (_ errorString: String) -> Void,
                       failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.logout.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            if json[error_code].intValue == 200 {
                                success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Update Session
    //    =====================
    static func updateSession(parameters: JSONDictionary,
                                   success: @escaping (_ errorString: String) -> Void,
                                   failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.updateSession.url,
                           parameters: parameters,
                           loader: false,
                           success: { (_ json: JSON) in
                            success(json[error_string].stringValue)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204){
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Send Pdf
    //    ===============
    static func sendPdf(parameters: JSONDictionary,
                              success: @escaping (_ errorString: String) -> Void,
                              failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.sendPdf.url,
                           parameters: parameters,
                           loader: true,
                           success: { (_ json: JSON) in
                            
                            if json[error_code].intValue == 200{
                                success(json[error_string].stringValue)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Dashboard Data
    //    ===============
    static func getDashboardData(parameters: JSONDictionary,
                                 success: @escaping (_ dasBoardData: [DashboardDataModel]) -> Void,
                                 failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getDashboardData.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            debugPrint(json)
                            let dashBoardData = DashboardDataModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            if json[error_code].intValue == 200{
                                success(dashBoardData)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Medication Reminders
    //    ===============
    static func getMedicationReminders(parameters: JSONDictionary,
        success: @escaping ([Reminder]) -> Void,
        failure: @escaping (Error) -> Void) {
        AppNetworking.GET(endPoint: EndPoint.getMedicationReminder.url,
                          parameters: parameters,
                          success: { (_ json: JSON) in
                            
                            let reminders: [Reminder] = Reminder.modelsFromArray(json[response].arrayValue)
                            success(reminders)
                            
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , reminders.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Update Medication Reminders
    //    ===============
    static func updateMedicationReminders(parameters: JSONDictionary, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.updateMedicationReminder.url, parameters: parameters, success: { (_ json: JSON) in
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
            
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Delete Medication Reminders
    //    ===============
    static func deleteMedicationReminders(serverReminderId: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let parameters = ["event_id": serverReminderId]
        AppNetworking.GET(endPoint: EndPoint.deleteReminder.url, parameters: parameters, success: { (_ json: JSON) in
            
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Edit Reminder
    //    =====================
    static func editReminder(parameters: JSONDictionary,
                             success: @escaping () -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.editReminder.url,
                           parameters: parameters,
                           success: { (_ json: JSON) in
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }

    //    MARK:- Add Events
    //    =================
    static func addEvents(parameters: JSONDictionary, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addMultipleReminder.url, parameters: parameters, success: { (_ json: JSON) in
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Add Multiple Events
    //    ===========================
    static func UpdateMultipleEvents(parameters: JSONDictionary, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.updateMultipleEvents.url, parameters: parameters, success: { (_ json: JSON) in
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- get Share Link
    //    ======================
    static func getShareLink(parameters: JSONDictionary,
                             success: @escaping (_ link: [JSON]) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getShareLink.url, parameters: parameters, success: { (_ json: JSON) in
            
            if json[error_code].intValue == 200 {
                success(json[response].arrayValue)
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
//    MARK:- Genrate Health Report
//    ==============================
    static func genrateHealthReport(success: @escaping (_ message: String) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.sendGenratehealthReport.url,
                          loader: false,
                          success: { (_ json: JSON) in
            
            if json[error_code].intValue == 200 {
                success(json[error_string].stringValue)
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Hit OCR Request
    //    ======================
    static func ocrRequest(parameter: JSONDictionary,
                           loader: Bool,
                           success: @escaping (_ report: [ScanReportModel]) -> Void,
                           failure: @escaping (Error) -> Void) {
        
        AppNetworking.PostWithOCRData(endPoint: EndPoint.ocrURl.url,
                                      parameters: parameter,
                                      loader: loader,
                                      success: { (_ json: JSON) in
                                        let report = ScanReportModel.getDataFromArray(data: json["responses"].arrayValue)
                                        success(report)
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Measuremnt Test List
    //    ============================
    static func getMeasurementTestList(success: @escaping (_ test: [[MeasurementListModel]]) -> Void,
                                    failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementTestList.url,
                          loader: false,
                          success: { (_ json: JSON) in

                            let measurementTest = MeasurementListModel.measurementListData(json[response].arrayValue)
                            success(measurementTest)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , measurementTest.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    // MARK:- Get Fitbit Access Token
    static func getFitBitAccessToken(parameters : JSONDictionary,
                                      success : @escaping (FitbitToken) -> Void,
                                      failure : @escaping (Error) -> Void) {
        
       guard let clientID = parameters["client_id"] as? String,
        let clientSecret = parameters["client_secret"] as? String else{
           return
        }

        guard let encodedData = "\(clientID):\(clientSecret)".data(using: .utf8)?.base64EncodedString() else{
            return
        }
        
        let header: JSONDictionary = ["Authorization":"Basic \(encodedData)",
                                      "Content-Type" :"application/x-www-form-urlencoded"]
        
        AppNetworking.POST(endPoint: EndPoint.fitbitAccessRefreshTokenRequest.url,
                           parameters: parameters,
                           headers: header,
                           loader: true,
                           success: { (_ json : JSON) in

                            var editedJson = json
                            let expiryTime = json["Expires"].doubleValue
                            let currentTimeStamp = Date().timeIntervalSince1970
                            editedJson["Expires"] = JSON(currentTimeStamp + expiryTime)
                            
                            if let tokenData = FitbitToken(json: editedJson) {
                                var dict = json.dictionaryObject!
                                dict["scope"] = nil
                                AppUserDefaults.save(value: dict, forKey: .fitBitToken)
                                success(tokenData)
                            } else {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
//    MARK:- Get Fitbit Data
//    =======================
    static func getFitBitCalories(userId: String,
                                  token: String,
                                  success : @escaping ([FitBitDataModel]) -> Void,
                                  failure : @escaping (Error) -> Void){
        
        let genericUrl = EndPoint.fitbitDataUrl.url

        let replaceUserIdUrl = genericUrl.replacingOccurrences(of: "{user-id}", with: userId)
        var lastSyncDate = ""
        if let lastSyncedDate = AppUserDefaults.value(forKey: .lastFitbitSyncedDate).string, !lastSyncedDate.isEmpty{
            let interval = Double(lastSyncedDate)
            let date = Date.init(timeIntervalSince1970: interval ?? 0.0)
            lastSyncDate = date.stringFormDate(.yyyyMMdd)
        }else{
            let disChargeDate = AppUserDefaults.value(forKey: .dateOfDischarge).stringValue
            lastSyncDate = disChargeDate.changeDateFormat(.utcTime, .yyyyMMdd)
        }

        let replaceStartDateUrl = replaceUserIdUrl.replacingOccurrences(of: "{start-Date}", with: lastSyncDate)
        let replaceTodateDateUrl = replaceStartDateUrl.replacingOccurrences(of: "{end-Date}", with: "today")
        let replacePeriodUrl = replaceTodateDateUrl.replacingOccurrences(of: "{period}", with: "")

        let header: JSONDictionary = ["Authorization": "Bearer \(token)",
            "Content-Type" :"application/x-www-form-urlencoded"]
        
        AppNetworking.GET(endPoint: replacePeriodUrl,
                          headers: header,
                          success: { (json: JSON) in

                            let currentdate = Date().timeIntervalSince1970
                            AppUserDefaults.save(value: "\(currentdate)", forKey: .lastFitbitSyncedDate)
                            
                            let fitBitData = FitBitDataModel.modelsFromDictionaryArray(data: json.arrayValue)
                            success(fitBitData)
        }) {(error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //    MARK:- Add Multiple Activity
    //    =============================
    static func addMultipleActivity(parameters: JSONDictionary, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addMultipleActivity.url,
                           parameters: parameters,
                           success: { (_ json: JSON) in
            if json[error_code].intValue == 200 {
                success()
            }else{
                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(error)
            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Get Fitbit Data
    //    =======================
    static func lastSyncData(success : @escaping (_ lastSyncData: [LastSyncedData]) -> Void,
                                  failure : @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.lastActivitySync.url,
                          success: { (json: JSON) in
                            
                            let lastSyncData = LastSyncedData.modelsFromDictionaryArray(array: json.arrayValue)
                            success(lastSyncData)
                            if (json[error_code].intValue != 200 && json[error_code].intValue != 204) , lastSyncData.isEmpty {
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) {(error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //    MARK:- PostSignUP1 Service (Personal InformationDetail)
    //    =======================================================
    static func addImage(parameters: JSONDictionary,
                             imageData: [String: Any],
                             success: @escaping (Bool) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        AppNetworking.PostWithMultipleData(endPoint: EndPoint.add_photo_timeline.url,
                                           parameters: parameters,
                                           loader: true,
                                           imageData: imageData,
                                           success: { (json: JSON) in
                                            let code = json[error_code].intValue
                                            if code == 200{
                                                success(true)
                                            }else{
                                                if ((json[error_code] != 200 && json[error_code] != 204) && json[response].arrayValue.isEmpty) {
                                                    let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                                    failure(error)
                                                }

                                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    
    //    MARK:- Get Dashboard Data
    //    ===============
    static func getTimelineData(success: @escaping (_ dasBoardData: [JSON]) -> Void,
                                 failure: @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.get_photo_timeline.url,
                          loader: true,
                          success: { (_ json: JSON) in
                            
                            debugPrint(json)
                            let response = json["response"].arrayValue
                            if json[error_code].intValue == 200{
                                success(response)
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }
    
    //    MARK:- Delete timeline photo
    //    =============================
    static func deleteTimelinePhoto(parameters: JSONDictionary, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.delete_photo_timeline.url,
                           parameters: parameters,loader : true,
                           success: { (_ json: JSON) in
                            if json[error_code].intValue == 200 {
                                success()
                            }else{
                                let error = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(error)
                            }
        }) { (error : Error) in
            failure(error)
        }
    }

}
