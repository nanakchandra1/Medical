//
//  WebServices.swift
//  MutelCore
//
//  Created by Ashish on 08/03/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

class WebServices {
    
    //    MARK:- Login
    //    =============
    static func login(parameters : JSONDictionary,
                      success : @escaping (_ user : UserInfo, _ hospInfo : [HospitalInfo]) -> Void,
                      failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        printlnDebug("LoginParams: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.patientLogin.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                printlnDebug(data)
                                
                                if !data.isEmpty{
                                    
                                    guard let _ = data.first?.dictionary else{
                                        
                                        let e = NSError(localizedDescription: json[error_string].string!)
                                        
                                        failure(e)
                                        
                                        return
                                    }
                                    
                                    printlnDebug(data)
                                }
                                guard let hospitalInfo = json[hosp_info].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    // check error code and present respective error message from here only
                                    
                                    failure(e)
                                    
                                    return
                                }
                                printlnDebug(hospitalInfo)
                                
                                var hospInfo = [HospitalInfo]()
                                
                                var userInfo : UserInfo!
                                
                                if !hospitalInfo.isEmpty {
                                    
                                    printlnDebug("hospitalInfo : \(hospitalInfo)")
                                    
                                    for info in hospitalInfo{
                                        
                                        hospInfo.append(HospitalInfo(hospitalInfoDic: info))
                                        
                                    }
                                    printlnDebug("hospInfo : \(hospInfo)")
                                }
                                
                                AppUserDefaults.saveUserDetail(data[0])
                                AppUserDefaults.saveUserAddressDetail(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                
                                userInfo = UserInfo(userData : data[0])
                                
                                success(userInfo, hospInfo)
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- SendOTP
    //    ==============
    static func sendOtp(parameters : JSONDictionary,
                        success : @escaping (String) -> Void,
                        failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        printlnDebug("SendOTPparams: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.sendOtp.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                let errorString = json[error_string].stringValue
                                
                                success(errorString)
                                
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- Forgot Password Service
    //    ==============================
    static func forgotPassword(parameters : JSONDictionary,
                               success : @escaping (String) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        printlnDebug("ForgotPasswordParams: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.forgetPassword.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                let errorString = json[error_string].stringValue
                                success(errorString)
                                
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    
    //    MARK:- SignUp Service
    //    ======================
    static func signUp(parameters : JSONDictionary,
                       success : @escaping (_ user : UserInfo, _ hospInfo :HospitalInfo) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        printlnDebug("SignUpparams: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.patientSignUp.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                printlnDebug(data)
                                
                                if !data.isEmpty{
                                    
                                    guard let _ = data.first?.dictionary else{
                                        
                                        let e = NSError(localizedDescription: json[error_string].string!)
                                        
                                        failure(e)
                                        return
                                        
                                    }
                                    
                                    printlnDebug(data)
                                }
                                guard let hospitalInfo = json[hosp_info].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    // check error code and present respective error message from here only
                                    
                                    failure(e)
                                    return
                                }
                                printlnDebug(hospitalInfo)
                                
                                var hospInfo : HospitalInfo!
                                //                                var userModel : UserModel!
                                
                                var userInfo : UserInfo!
                                
                                if !hospitalInfo.isEmpty{
                                    
                                    printlnDebug("hospitalInfo : \(hospitalInfo)")
                                    
                                    for info in hospitalInfo{
                                        
                                        hospInfo = HospitalInfo(hospitalInfoDic: info)
                                        
                                    }
                                }
                                
                                userInfo = UserInfo(userData: data[0])
                                let _ = MedicalInfo(medicalInfo: data[0])
                                let _ = MedicalCategoryInfo(medicalCategoryInfo: data[0])
                                let _ = TreatmentDetailInfo(tretmentDetailInfo: data[0])
                                let _ = UserAddressInfo(addressInfo: data[0])
                                
                                AppUserDefaults.saveUserDetail(data[0])
                                AppUserDefaults.saveUserAddressDetail(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                
                                success(userInfo, hospInfo)
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- PostSignUP1 Service (Personal InformationDetail)
    //    =======================================================
    
    static func personalInfo(parameters : JSONDictionary,
                             imageData: Data?,
                             imageKey : String,
                             success : @escaping (UserInfo) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        var params = parameters
        params["id"] = AppUserDefaults.value(forKey: .userId)
        
        printlnDebug("PersonalInfoParameters: \(params)")
        
        AppNetworking.PostWithImage(endPoint: EndPoint.postSignUp1.url,
                                    parameters: params,
                                    loader: true,
                                    imageData: imageData,
                                    imageKey: imageKey,
                                    success: { (json : JSON) in
                                        
                                        if json[error_code].intValue == 200 {
                                            
                                            guard let data = json[response].array else{
                                                
                                                let e = NSError(localizedDescription: json[error_string].string!)
                                                
                                                failure(e)
                                                return
                                                
                                            }
                                            
                                            if !data.isEmpty{
                                                
                                                guard let _ = data.first?.dictionary else{
                                                    
                                                    let e = NSError(localizedDescription: json[error_string].string!)
                                                    
                                                    failure(e)
                                                    return
                                                    
                                                }
                                                
                                                printlnDebug(data)
                                                
                                                var userInfo : UserInfo!
                                                
                                                userInfo = UserInfo(userData : data[0])
                                                let _ = MedicalInfo(medicalInfo: data[0])
                                                
                                                let _ = MedicalCategoryInfo(medicalCategoryInfo: data[0])
                                                let _ = TreatmentDetailInfo(tretmentDetailInfo: data[0])
                                                let _ = UserAddressInfo(addressInfo: data[0])
                                                
                                                AppUserDefaults.saveUserDetail(data[0])
                                                AppUserDefaults.saveUserAddressDetail(data[0])
                                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                                AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                                
                                                
                                                success(userInfo)
                                            }
                                        }
                                        
        }) { (e : Error) in
            
            failure(e)
        }
    }
    
    //    MARK:- Type Of Surgery
    //    =====================
    
    static func typeOfSurgery(parameters : JSONDictionary,
                              success : @escaping (_ surgeryInfo : [SurgeryModel]) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        printlnDebug("TypeOfSurgeryParams: \(parameters)")
        
        AppNetworking.GET(endPoint : EndPoint.typeOfSurgery.url,
                          parameters : parameters,
                          loader : true,
                          success : {(json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                }
                                
                                var surgeryInfo = [SurgeryModel]()
                                if !data.isEmpty{
                                    
                                    for surgeryName in data {
                                        
                                        printlnDebug(surgeryName)
                                        surgeryInfo.append(SurgeryModel(surgeyInfoDic: surgeryName))
                                        
                                    }
                                }
                                
                                success(surgeryInfo)
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                failure(e)
                            }
                            
        },failure : {(e : Error) -> Void in
            
            failure(e)
        })
    }
    
    //    MARK:- Hit Speciality Service
    //    =============================
    static func speciality(parameters : JSONDictionary,
                           success : @escaping (_ surgeryInfo : [SpecialityModel]) -> Void,
                           failure : @escaping (Error) -> Void){
        
        printlnDebug("SpecialityParams: \(parameters)")
        AppNetworking.GET(endPoint : EndPoint.speciality.url,
                          parameters : parameters,
                          loader : true,
                          success : {(_ json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let specialityData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                }
                                
                                var specialityModel = [SpecialityModel]()
                                
                                if !specialityData.isEmpty{
                                    
                                    for speciality in specialityData{
                                        
                                        printlnDebug(speciality)
                                        specialityModel.append(SpecialityModel(specialityInfoDic: speciality))
                                    }
                                    
                                    success(specialityModel)
                                    
                                }
                                else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                }
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                failure(e)
                            }
        },failure: { (e: Error) in
            
            failure(e)
        })
    }
    
    //    MARK:- Hit Signup2 Service(Address Detail)
    //    ===========================================
    
    
    
    static func medicalInfo(parameters : JSONDictionary,
                            success : @escaping (UserInfo) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        var params = parameters
        
        params["id"] = AppUserDefaults.value(forKey: .userId)
        
        printlnDebug("MedicalInfoParameters: \(params)")
        
        AppNetworking.POST(endPoint: EndPoint.postSignUp2.url,
                           parameters: params,
                           loader: true,
                           success: { (json : JSON) in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                
                                if !data.isEmpty{
                                    
                                    guard let _ = data.first?.dictionary else{
                                        
                                        let e = NSError(localizedDescription: json[error_string].string!)
                                        
                                        failure(e)
                                        return
                                        
                                    }
                                    printlnDebug("*********************")
                                    printlnDebug(data)
                                    printlnDebug("*********************")
                                    
                                    var userInfo : UserInfo!
                                    
                                    userInfo = UserInfo(userData : data[0])
                                    let _ = MedicalInfo(medicalInfo: data[0])
                                    let _ = MedicalCategoryInfo(medicalCategoryInfo: data[0])
                                    let _ = TreatmentDetailInfo(tretmentDetailInfo: data[0])
                                    let _ = UserAddressInfo(addressInfo: data[0])
                                    
                                    AppUserDefaults.saveUserDetail(data[0])
                                    AppUserDefaults.saveUserAddressDetail(data[0])
                                    AppUserDefaults.saveUserMedicalDetail(data[0])
                                    AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                    AppUserDefaults.saveUserMedicalDetail(data[0])
                                    
                                    success(userInfo)
                                }
                            }
                            
        }) { (e : Error) in
            
            failure(e)
        }
    }
    
    //    MARK: Hit GetCountry Service
    //     =============================
    
    static func getCountryList(parameters : JSONDictionary,
                               success : @escaping (_ countryInfo : [CountryCodeModel]) -> Void,
                               failure : @escaping (Error) -> Void){
        
        printlnDebug("getCountryParams: \(parameters)")
        AppNetworking.GET(endPoint : EndPoint.getCountry.url,
                          parameters : parameters,
                          loader : true,
                          success : {(_ json : JSON) -> Void in
                            
                            let countryCode = CountryCodeModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            if !(json[error_code].intValue == 200) || countryCode.isEmpty {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
                            success(countryCode)
                            
        },failure: { (e: Error) in
            
            failure(e)
        })
    }
    
    //    MARK: Fetch ethinicity
    //    =======================
    static func getEthinicityList(parameters : JSONDictionary,
                                  success : @escaping (_ ethinicityInfo : [EthinicityNameModel]) -> Void,
                                  failure : @escaping (Error) -> Void){
        
        printlnDebug("getethinicityParams: \(parameters)")
        AppNetworking.GET(endPoint: EndPoint.fetchEthinicity.url, success: { (_ json : JSON) in
            
            let ethinicityName = EthinicityNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            if !(json[error_code].intValue == 200) || ethinicityName.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
            success(ethinicityName)
            
        }) { (e : Error) in
            
            failure(e)
        }
    }
    
    //    MARK: Get State Listing
    //    =======================
    
    static func getStateList(parameters : JSONDictionary,
                             success : @escaping (_ stateInfo : [StateNameModel]) -> Void,
                             failure : @escaping (Error) -> Void){
        
        printlnDebug("getStateParams: \(parameters)")
        AppNetworking.GET(endPoint : EndPoint.getStates.url,
                          parameters : parameters,
                          loader : true,
                          success : {(_ json : JSON) -> Void in
                            
                            let stateName = StateNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            if !(json[error_code].intValue == 200) || stateName.isEmpty {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
                            success(stateName)
                            
//                            if json[error_code].intValue == 200{
//
//                                guard let countryData = json[response].arrayObject else{
//
//                                    let e = NSError(localizedDescription: json[error_string].string!)
//                                    failure(e)
//                                    return
//                                }
//
//                                if !countryData.isEmpty{
//
//                                    success(countryData)
//                                }else{
//
//                                    let e = NSError(localizedDescription: json[error_string].string!)
//                                    failure(e)
//                                }
//                            }
//                            else{
//
//                                let e = NSError(localizedDescription: json[error_string].string!)
//                                failure(e)
//
//                            }
        },failure: { (e: Error) in
            
            failure(e)
        })
    }
    
    //    Mark: Get CityListing
    //    ======================
    
    static func getTownList(parameters : JSONDictionary,
                            success : @escaping (_ cityInfo : [CityNameModel]) -> Void,
                            failure : @escaping (Error) -> Void){
        printlnDebug("getTownParams: \(parameters)")
        AppNetworking.GET(endPoint : EndPoint.getCity.url,
                          parameters : parameters,
                          loader : true,
                          success : {(_ json : JSON) -> Void in
                            
                            let cityName = CityNameModel.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            if !(json[error_code].intValue == 200) || cityName.isEmpty {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
                            success(cityName)
                            
//                            if json[error_code].intValue == 200{
//
//                                guard let townData = json[response].arrayObject else{
//
//                                    let e = NSError(localizedDescription: json[error_string].string!)
//                                    failure(e)
//                                    return
//                                }
//
//                                if !townData.isEmpty{
//
//                                    success(townData)
//                                }else{
//
//                                    let e = NSError(localizedDescription: json[error_string].string!)
//                                    failure(e)
//                                }
//                            }
//                            else{
//
//                                let e = NSError(localizedDescription: json[error_string].string!)
//                                failure(e)
//
//                            }
        },failure: { (e: Error) in
            
            failure(e)
        })
    }
    
    //    MARK: Hit SignUp3 (Address Detail)
    //    ==================================
    static func userAddressInfo(parameters : JSONDictionary,
                                success : @escaping (UserInfo) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        var params = parameters
        
        params["id"] = AppUserDefaults.value(forKey: .userId)
        
        printlnDebug("UserAddressInfoParameters: \(params)")
        
        AppNetworking.POST(endPoint: EndPoint.postSignUp3.url,
                           parameters: params,
                           loader: true,
                           success: { (json : JSON) in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                if !data.isEmpty{
                                    
                                    guard let _ = data.first?.dictionary else{
                                        
                                        let e = NSError(localizedDescription: json[error_string].string!)
                                        
                                        failure(e)
                                        return
                                        
                                    }
                                    
                                    printlnDebug("******************************")
                                    printlnDebug(data)
                                    printlnDebug("******************************")
                                    
                                    var userInfo : UserInfo!
                                    
                                    userInfo = UserInfo(userData : data[0])
                                    let _ = MedicalInfo(medicalInfo: data[0])
                                    let _ = MedicalCategoryInfo(medicalCategoryInfo: data[0])
                                    let _ = TreatmentDetailInfo(tretmentDetailInfo: data[0])
                                    let _ = UserAddressInfo(addressInfo: data[0])
                                    
                                    AppUserDefaults.saveUserDetail(data[0])
                                    AppUserDefaults.saveUserAddressDetail(data[0])
                                    AppUserDefaults.saveUserMedicalDetail(data[0])
                                    AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                    AppUserDefaults.saveUserMedicalDetail(data[0])
                                    
                                    success(userInfo)
                                }
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                failure(e)
                                return
                            }
                            
        }) { (e : Error) in
            
            failure(e)
        }
    }
    
    //    MARK:- Hit ResetPassword Service
    //    =================================
    
    static func resetPassword(parameters : JSONDictionary,
                              success : @escaping (_ user : UserInfo, _ hospInfo : [HospitalInfo]) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        printlnDebug("resetPaaword: \(parameters)")
        AppNetworking.POST(endPoint: EndPoint.resetPassword.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                printlnDebug(data)
                                
                                if !data.isEmpty{
                                    
                                    guard let _ = data.first?.dictionary else{
                                        
                                        let e = NSError(localizedDescription: json[error_string].string!)
                                        
                                        failure(e)
                                        return
                                        
                                    }
                                    
                                    printlnDebug("*******************************")
                                    printlnDebug(data)
                                    printlnDebug("*******************************")
                                }
                                guard let hospitalInfo = json[hosp_info].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    // check error code and present respective error message from here only
                                    
                                    failure(e)
                                    return
                                }
                                
                                printlnDebug("*********************")
                                
                                printlnDebug(hospitalInfo)
                                
                                printlnDebug("*********************")
                                
                                var hospInfo = [HospitalInfo]()
                                var userInfo : UserInfo!
                                
                                if !hospitalInfo.isEmpty{
                                    
                                    printlnDebug("hospitalInfo : \(hospitalInfo)")
                                    
                                    for info in hospitalInfo{
                                        
                                        hospInfo.append(HospitalInfo(hospitalInfoDic: info))
                                        
                                    }
                                    printlnDebug("hospInfo : \(hospInfo)")
                                }
                                
                                userInfo = UserInfo(userData : data[0])
                                let _ = MedicalInfo(medicalInfo: data[0])
                                let _ = MedicalCategoryInfo(medicalCategoryInfo: data[0])
                                let _ = TreatmentDetailInfo(tretmentDetailInfo: data[0])
                                let _ = UserAddressInfo(addressInfo: data[0])
                                
                                AppUserDefaults.saveUserDetail(data[0])
                                AppUserDefaults.saveUserAddressDetail(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                AppUserDefaults.saveTreatmentDetailInfo(data[0])
                                AppUserDefaults.saveUserMedicalDetail(data[0])
                                
                                success(userInfo, hospInfo)
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- HIT OTPVerification Service
    //    ==================================
    static func otpVerification(parameters : JSONDictionary,
                                success : @escaping (_ str : String) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        printlnDebug("resetPaaword: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.otpVerification.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                let str = json[error_string].stringValue
                                
                                success(str)
                                
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- Appointment History
    //    ==========================
    static func appointmentHistory(success : @escaping (_ appHistory : [UpcomingAppointmentModel]) -> Void,
                                   failure : @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getAppointmentHistory.url,
                          success: {(_ json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                
                                guard let appHistory = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var appointmentHistory = [UpcomingAppointmentModel]()
                                
                                if !appHistory.isEmpty {
                                    
                                    for history in appHistory{
                                        
                                        appointmentHistory.append(UpcomingAppointmentModel(upcomingAppointmentData: history))
                                        
                                    }
                                }else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    failure(e)
                                    
                                }
                                
                                success(appointmentHistory)
                                
                            }else if json[error_code].intValue == 204{
                                
                                success([UpcomingAppointmentModel]())
                                
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                failure(e)
                                
                            }
        }) { (e: Error) in
            
            failure(e)
        }
    }
    
    //    MARK:- UpComing Appointments
    //    ============================
    static func upcomingAppointments(success : @escaping (_ appHistory : [UpcomingAppointmentModel]) -> Void,
                                     failure : @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.upcomingAppointments.url,
                          success: {(_ json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                
                                guard let upcomingAppoint = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var upComigAppointment = [UpcomingAppointmentModel]()
                                
                                if !upcomingAppoint.isEmpty {
                                    
                                    for appointment in upcomingAppoint{
                                        
                                        upComigAppointment.append(UpcomingAppointmentModel(upcomingAppointmentData: appointment))
                                        
                                    }
                                }else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                }
                                
                                success(upComigAppointment)
                                
                            }else if json[error_code].intValue == 204{
                                
                                success([UpcomingAppointmentModel]())
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                failure(e)
                                
                            }
        }) { (e: Error) in
            
            failure(e)
        }
    }
    
    //    MARK:- Symptoms
    //    ================
    static func getSymptoms(success : @escaping (_ symptomsList : [Any]) -> Void,
                            failure : @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getSymptoms.url,
                          success: {(_ json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200{
                                
                                guard let symptomsList = json[response].array else {
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var symptoms = [String]()
                                
                                if !symptomsList.isEmpty {
                                    
                                    for sym in symptomsList{
                                        
                                        symptoms.append(sym["symtomp_name"].stringValue)
                                        
                                    }
                                    
                                    success(symptoms)
                                    
                                }else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                }
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                failure(e)
                                
                            }
        }) { (e: Error) in
            
            failure(e)
        }
    }
    
    //    MARK:- Reschedule Symptoms
    //    ===========================
    static func rescheduleAppointment(parameters : JSONDictionary,
                                      success : @escaping (_ str : String) -> Void,
                                      failure : @escaping (Error) -> Void) {
        
        printlnDebug("rescheduleAppointment: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.rescheduleAppointment.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                printlnDebug(data)
                                
                                success(json[error_string].string!)
                                
                            }
                            else {
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- AvailiableTimeSlot
    //    =========================
    static func availiableTimeSlot(parameters : JSONDictionary,
                                   success : @escaping (_ timeSlots : [TimeSlotModel],_ errorCode : Int) -> Void,
                                   failure : @escaping (Error) -> Void){
        
        AppNetworking.GET(endPoint: EndPoint.getDoctorAvailiableSlot.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json : JSON) in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                
                                var timeSlotData = [TimeSlotModel]()
                                
                                if !data.isEmpty {
                                    
                                    for timeSlot in data{
                                        
                                        timeSlotData.append(TimeSlotModel(timeSlotData: timeSlot))
                                        
                                    }
                                    
                                }else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                }
                                
                                success(timeSlotData, json[error_code].intValue)
                                
                            }else if json[error_code].intValue == 500  {
                                
                                let e = NSError(localizedDescription: "User is not Authorized.")
                                
                                failure(e)
                                
                            }else if json[error_code].intValue == 404 {
                                
                                let e = NSError(localizedDescription: "TimeSlots not Found.")
                                
                                failure(e)
                                
                            }else if json[error_code].intValue == 204{
                                
                                guard let data = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    return
                                    
                                }
                                
                                var timeSlotData = [TimeSlotModel]()
                                
                                for timeSlot in data{
                                    
                                    timeSlotData.append(TimeSlotModel(timeSlotData: timeSlot))
                                    
                                }
                                
                                success(timeSlotData, json[error_code].intValue)
                                
                            }
                            
        }) { (e : Error) in
            
            printlnDebug(e)
            
        }
    }
    
    // MARK:- Add Appointment
    // ===========================
    static func addAppointment(parameters : JSONDictionary,
                               success : @escaping (_ str : String) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        printlnDebug("addAppointment: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.addAppointment.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                success(json[error_string].stringValue)
                                
                            }else if json[error_code].intValue == 500{
                                
                                success(json[error_string].stringValue)
                            }
                            else {
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- Cancel Upcoming Appointment
    //    ==================================
    static func cancelAppointment(parameters : JSONDictionary,
                                  success : @escaping (_ str : String) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        printlnDebug("cancelAppointment: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.cancelAppointment.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                success(json[error_string].stringValue)
                                
                            }else if json[error_code].intValue == 500{
                                
                                success(json[error_string].stringValue)
                            }
                            else {
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                // check error code and present respective error message from here only
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK:- Measurement Module Services
    //    ====================================
    
    //    MARK: Get Measurement Category
    //    ==============================
    static func getMeasurementCategory(parameters : JSONDictionary,
                                       success : @escaping (_ measurementFormData: [MeasurementCategory]) -> Void,
                                       failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementCategory.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            let measurementCategory = MeasurementCategory.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(measurementCategory)
                            
                            if !(json[error_code].intValue == 200) || measurementCategory.isEmpty {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK: GetVitalData Service
    //    ============================
    static func getMeasurementHomeData(parameters : JSONDictionary,
                                       success : @escaping (_ measurementHomeData : [MeasurementHomeData]) -> Void,
                                       failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementHomeList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            let measurementHomeData = MeasurementHomeData.modelsFromDictionaryArray(array: json[response].arrayValue)
                            
                            success(measurementHomeData)
                            
                            if !(json[error_code].intValue == 200) || measurementHomeData.isEmpty {
                                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                                failure(e)
                            }
                            
        }) { (e : Error) in
            
             failure(e)
            
        }
    }
    
    //    MARK: Get Vital List
    //    =====================
    static func getVitalList(parameters : JSONDictionary,
                             success : @escaping (_ vitalList : [VitalListModel]) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getVitalList.url,
                          parameters: parameters,
                          loader: false,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                // GTToast.create(json[error_string].stringValue, config: ToastConfiguration.toastConfigure, image: nil).show()
                                
                                guard let vitalListData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    return
                                }
                                
                                var vitalList = [VitalListModel]()
                                
                                if !vitalListData.isEmpty{
                                    
                                    for data in vitalListData {
                                        
                                        vitalList.append(VitalListModel(vitalListData: data))
                                        
                                    }
                                }
                                
                                success(vitalList)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK: GetLatest Vitals
    //    =======================
    static func getLatestVitals(parameters : JSONDictionary,
                                success : @escaping (_ getLatestThreVitalData : [LatestThreeVitalData]) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getLatestVitals.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            printlnDebug("attacURl : \(EndPoint.getLatestVitals.rawValue)")
                            
                            if json[error_code] == 200 {
                                
                                // GTToast.create(json[error_string].stringValue, config: ToastConfiguration.toastConfigure, image: nil).show()
                                
                                guard let latestData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var topMostVitalData = [LatestThreeVitalData]()
                                
                                if !latestData.isEmpty{
                                    
                                    for data in latestData {
                                        
                                        topMostVitalData.append(LatestThreeVitalData(topMostVitalData: data))
                                        
                                    }
                                }
                                
                                success(topMostVitalData)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Get Graph Data
    //    =====================
    static func getGraphData(parameters : JSONDictionary,
                             success : @escaping (_ graphData : [GraphDataModel]) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getGraphList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                // GTToast.create(json[error_string].stringValue, config: ToastConfiguration.toastConfigure, image: nil).show()
                                
                                guard let graphValues = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var graphData = [GraphDataModel]()
                                
                                if !graphValues.isEmpty{
                                    
                                    for data in graphValues {
                                        
                                        graphData.append(GraphDataModel(graphData: data))
                                        
                                    }
                                }
                                
                                success(graphData)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    //    MARK:- Get TabularData
    //    ======================
    //    MARK:- Get Graph Data
    //    =====================
    static func getTabularData(parameters : JSONDictionary,
                               success : @escaping (_ data : [Any], _ nextCount : Int) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getTabularList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let count = json["next_count"].int else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let tabularData = json[response].arrayObject else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                success(tabularData, count)
                                
                            }else{
                                
                                guard let count = json["next_count"].int else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let tabularData = json[response].arrayObject else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                success(tabularData, count)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK: Get Attachment Data
    //      =======================
    static func getAttachmentList(parameters : JSONDictionary,
                                  success : @escaping (_ attachmentList : [AttachmentDataModel]) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getAttachmentList.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            printlnDebug("attacURl : \(EndPoint.getAttachmentList.rawValue)")
                            
                            if json[error_code] == 200 {
                                
                                //GTToast.create(json[error_string].stringValue, config: ToastConfiguration.toastConfigure, image: nil).show()
                                
                                guard let attachmentValues = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var attachmentData = [AttachmentDataModel]()
                                
                                if !attachmentValues.isEmpty{
                                    
                                    for data in attachmentValues {
                                        
                                        attachmentData.append(AttachmentDataModel(attachmentData: data))
                                        
                                    }
                                }
                                
                                success(attachmentData)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK: MeasurementFormData
    //    ==========================
    static func getMeasurementFormBuilder(parameters : JSONDictionary,
                                          success : @escaping (_ measurementFormData: [MeasurementFormDataModel]) -> Void,
                                          failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.measurementFormBuilder.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let measurementFormValues = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var measurementFormData = [MeasurementFormDataModel]()
                                
                                if !measurementFormValues.isEmpty{
                                    
                                    for data in measurementFormValues {
                                        
                                        measurementFormData.append(MeasurementFormDataModel(measurementFormList:data))
                                        
                                    }
                                }
                                
                                success(measurementFormData)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK: Add Measurement
    //    ======================
    static func addMeasuremnet(parameters : JSONDictionary,
                               imageData : [String : Any],
                               success : @escaping (_ str : String) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        printlnDebug("addMeasuremnetParamerters: \(parameters)")

        AppNetworking.PostWithMultipleData(endPoint: EndPoint.addMeasurement.url,
                                           parameters: parameters, loader: true, imageData: imageData, success: { (_ json : JSON) in
                                            
                                            if json[error_code].intValue == 200 {
                                                
                                                success(json[error_string].stringValue)
                                                
                                            }
                                            else {
                                                
                                                let e = NSError(localizedDescription: json[error_string].string!)
                                                
                                                // check error code and present respective error message from here only
                                                
                                                failure(e)
                                                
                                            }
        }) { (e) in
            
            failure(e)
        }
    }
    
    //    MARK: ActivityForm
    //    ===================
    static func getActivityFormData(parameters : JSONDictionary,
                                    success : @escaping (_ measurementFormData: [ActivityFormModel]) -> Void,
                                    failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityForm.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let activityFormValues = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var activityFormData = [ActivityFormModel]()
                                
                                if !activityFormValues.isEmpty{
                                    
                                    for data in activityFormValues {
                                        
                                        activityFormData.append(ActivityFormModel(data))
                                        
                                    }
                                }
                                
                                success(activityFormData)
                                
                            }else{
                                
                                let e = NSError(localizedDescription: json[error_string].stringValue)
                                
                                failure(e)
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    
    //MARK:- Seven Days Activity Average
    //===================================
    static func sevenDaysActivityAvg(parameters : JSONDictionary,
                                     success : @escaping (_ sevenDaysAvgData: [SevenDaysAvgData]) -> Void,
                                     failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.sevenDaysActivityAvg.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let sevenDaysAvg = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var sevenDaysAvgData = [SevenDaysAvgData]()
                                
                                if !sevenDaysAvg.isEmpty{
                                    
                                    for data in sevenDaysAvg {
                                        
                                        sevenDaysAvgData.append(SevenDaysAvgData(data))
                                        
                                    }
                                }
                                
                                success(sevenDaysAvgData)
                                
                            }else{
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let sevenDaysAvg = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var sevenDaysAvgData = [SevenDaysAvgData]()
                                
                                for data in sevenDaysAvg {
                                    
                                    sevenDaysAvgData.append(SevenDaysAvgData(data))
                                    
                                }
                                
                                success(sevenDaysAvgData)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Day wise Activity Data(Prescribe and Consume Data)
    //    =========================================================
    static func getActivityBySelectedDate(parameters : JSONDictionary,
                                          success : @escaping (_ prescribeData: [JSON]) -> Void,
                                          failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityByDate.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let prescribeAndConsumeData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                success(prescribeAndConsumeData)
                                
                            }else{
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let prescribeData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                success(prescribeData)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Previous Activity Plan
    //    =============================
    static func getPreviousActivity(parameters : JSONDictionary,
                                    success : @escaping (_ prescribeData: [PreviousActivityPlan], _ do : [JSON], _ donts : [JSON]) -> Void,
                                    failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.previousActivityPlan.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let previousActivityPlanData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                
                                guard let doArray = json["do"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let dontsArray = json["do_not"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var previousActivityPlan = [PreviousActivityPlan]()
                                
                                if !previousActivityPlanData.isEmpty{
                                    
                                    for data in previousActivityPlanData {
                                        
                                        previousActivityPlan.append(PreviousActivityPlan(data))
                                        
                                    }
                                }
                                
                                success(previousActivityPlan, doArray, dontsArray)
                                
                            }else{
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let _ = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let doArray = json["do"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let dontsArray = json["do_not"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                let previousActivityPlan = [PreviousActivityPlan]()
                                
                                success(previousActivityPlan, doArray, dontsArray)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Current Activity Plan
    //    =============================
    static func getCurrentActivity(parameters : JSONDictionary,
                                   success : @escaping (_ prescribeData: [CurrentActivityPlan], _ do : [JSON], _ donts : [JSON]) -> Void,
                                   failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.currentActivityPlan.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let currentActivityplanData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                printlnDebug("currentActivityplanData\(currentActivityplanData)")
                                
                                guard let doArray = json["do"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let dontsArray = json["do_not"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var currentActivityPlan = [CurrentActivityPlan]()
                                
                                if !currentActivityplanData.isEmpty{
                                    
                                    for data in currentActivityplanData {
                                        
                                        currentActivityPlan.append(CurrentActivityPlan(data))
                                        
                                    }
                                }
                                
                                success(currentActivityPlan, doArray, dontsArray)
                                
                            }else{
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let _ = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let doArray = json["do"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let dontsArray = json["do_not"].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                let currentActivityPlan = [CurrentActivityPlan]()
                                
                                success(currentActivityPlan, doArray, dontsArray)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Get Activity List In Tabular Form
    //    ========================================
    static func getActivityInTabularForm(parameters : JSONDictionary,
                                         success : @escaping (_ prescribeData: [ActivityDataInTabular], _ count : Int) -> Void,
                                         failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityInTabular.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let count = json["next_count"].int else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                guard let activityListInTabularData = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                var activityListinTabularForm = [ActivityDataInTabular]()
                                
                                if !activityListInTabularData.isEmpty{
                                    
                                    for data in activityListInTabularData {
                                        
                                        activityListinTabularForm.append(ActivityDataInTabular(data))
                                        
                                    }
                                }
                                
                                success(activityListinTabularForm, count)
                                
                            }else{
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let _ = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                let activityListinTabularForm = [ActivityDataInTabular]()
                                
                                success(activityListinTabularForm, 0)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Recent Activity
    //    ======================
    static func getRecentActivity(parameters : JSONDictionary,
                                  success : @escaping (_ prescribeData: [RecentActivityModel]) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.recentActivity.url,
                          parameters: parameters,
                          loader: true,
                          success: { (_ json : JSON) in
                            
                            if json[error_code] == 200 {
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let recentActivityDataValues = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
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
                                
                                showToastMessage(json[error_string].stringValue)
                                
                                guard let _ = json[response].array else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].stringValue)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                let activityListinTabularForm = [RecentActivityModel]()
                                
                                success(activityListinTabularForm)
                                
                            }
        }) { (e : Error) in
            
            failure(e)
            
        }
    }
    
    //    MARK:- Add Activity
    //    ===================
    static func addActivity(parameters : JSONDictionary,
                            success : @escaping (_ meassage : String) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        
        printlnDebug("parameters: \(parameters)")
        
        AppNetworking.POST(endPoint: EndPoint.addActivity.url,
                           parameters: parameters,
                           loader : true,
                           success: { (json : JSON) -> Void in
                            
                            if json[error_code].intValue == 200 {
                                
                                guard let errorString = json[error_string].string else{
                                    
                                    let e = NSError(localizedDescription: json[error_string].string!)
                                    
                                    failure(e)
                                    
                                    return
                                }
                                
                                success(errorString)
                                
                            }
                            else{
                                
                                let e = NSError(localizedDescription: json[error_string].string!)
                                
                                failure(e)
                                
                            }
                            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Get Meal Schedule
    //    =========================
    static func getMealSchedule(parameters : JSONDictionary, success : @escaping ([MealSchedule]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getMealSchedule.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let mealSchedules: [MealSchedule] = MealSchedule.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(mealSchedules)
            
            if !(json[error_code].intValue == 200) || mealSchedules.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Get Food
    //    ==============
    static func getFoods(parameters : JSONDictionary, success : @escaping ([Food]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getFoods.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            var foods: [Food] = Food.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(foods)
            
            if !(json[error_code].intValue == 200) || foods.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Day Wise Nutrition
    //    =========================
    static func getDayWiseNutrition(parameters : JSONDictionary, success : @escaping ([DayWiseNutrition], [GraphView]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getDayWiseNutrition.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            if json[error_code].intValue == 200 {
                
                var planedData = json[response].arrayValue
                var graphData = json["graph_view"].arrayValue
                
                let dayWiseData : [DayWiseNutrition] = DayWiseNutrition.modelFromJsonArray(planedData)
                let graphViewData : [GraphView] = GraphView.modelFromJsonArray(graphData)
                
                success(dayWiseData, graphViewData)
                
                if !(json[error_code].intValue == 200) || planedData.isEmpty || graphViewData.isEmpty{
                    
                    let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                    failure(e)
                }
            }
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Nutrition Data In Table
    //    =============================
    static func getNutritionDataInTable(parameters : JSONDictionary, success : @escaping ([NutritionGraphData], _ nextCount : Int) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionDataList.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            if json[error_code].intValue == 200 {
                
                var nutrientsData = json[response].arrayValue
                
                let nutrientsList : [NutritionGraphData] = NutritionGraphData.modelFromJsonArray(nutrientsData)
                
                success(nutrientsList, json["next_count"].intValue)
                
                if !(json[error_code].intValue == 200) || nutrientsData.isEmpty{
                    
                    let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                    failure(e)
                }
            }
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Get week Performance
    //    =============================
    static func getWeekPerformance(parameters : JSONDictionary, success : @escaping ([[WeekPerformance]]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getWeekPerformance.url, parameters: parameters, success: { (json : JSON) -> Void in
            
                let weekPerformanceData = json[response].arrayValue
                
                let weekPerformance : [[WeekPerformance]] = WeekPerformance.modelFromJsonArray(weekPerformanceData)
                
                success(weekPerformance)
                
                if !(json[error_code].intValue == 200) || weekPerformanceData.isEmpty{
                    
                    let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                    failure(e)
                }
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Get Recent Nutrition
    //    ==============
    static func getRecentNutritions(parameters : JSONDictionary, success : @escaping ([RecentFood]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getRecentNutritions.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let foods: [RecentFood] = RecentFood.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(foods)
            
            if !(json[error_code].intValue == 200) || foods.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Add Nutrition
    //    ==============
    static func addNutritionData(parameters : JSONDictionary, success : @escaping (Bool) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.POST(endPoint: EndPoint.addNutritionData.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            if json[error_code].intValue == 200 {
                success(true)
            } else {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Previous Nutrition Plan
    //    ==============
    static func getPreviousNutritionPlan(success : @escaping ([NutritionPlan], [FoodAvoid], [DailyAllowance]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getPreviousNutritionPlan.url, parameters: JSONDictionary(), success: { (json : JSON) -> Void in
            
            let foodAllowances = FoodAvoid.modelsFromDictionaryArray(array: json["food_avoid"].arrayValue)
            let dailyAllowances = DailyAllowance.modelsFromDictionaryArray(array: json["daily_allowance"].arrayValue)
            
            let nutritionPlans: [NutritionPlan] = NutritionPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(nutritionPlans, foodAllowances, dailyAllowances)
            
            if !(json[error_code].intValue == 200) || nutritionPlans.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Current Nutrition Plan
    //    ==============
    static func getCurrentNutritionPlan(success : @escaping ([NutritionPlan], [FoodAvoid], [DailyAllowance]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getCurrentNutritionPlan.url, parameters: JSONDictionary(), success: { (json : JSON) -> Void in
            
            let foodAllowances = FoodAvoid.modelsFromDictionaryArray(array: json["food_avoid"].arrayValue)
            let dailyAllowances = DailyAllowance.modelsFromDictionaryArray(array: json["daily_allowance"].arrayValue)
            
            let nutritionPlans: [NutritionPlan] = NutritionPlan.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(nutritionPlans, foodAllowances, dailyAllowances)
            
            if !(json[error_code].intValue == 200) || nutritionPlans.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    //    MARK: Activity Graph Data
    //    =========================
    static func getActivityGraphData(parameters : JSONDictionary, success : @escaping ([ActivityGraphData]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getActivityGraphData.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let activityGraphDataArray: [ActivityGraphData] = ActivityGraphData.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(activityGraphDataArray)
            
            if !(json[error_code].intValue == 200) || activityGraphDataArray.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    
    //    MARK: Nutrition Graph Data
    //    ==========================
    static func getNutritionGraphData(parameters : JSONDictionary, success : @escaping ([NutritionChartData]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionGraphData.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let nutritionGraphDataArray: [NutritionChartData] = NutritionChartData.modelsFromDictionaryArray(array: json[response].arrayValue)
            success(nutritionGraphDataArray)
            
            if !(json[error_code].intValue == 200) || nutritionGraphDataArray.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
//    MARK:- EPrescription Services
//    ==============================
    static func getCurrentEPrescription(parameters : JSONDictionary, success : @escaping ([EprescriptionModel]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionGraphData.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let ePrescriptionData = EprescriptionModel.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(ePrescriptionData)
            
            if !(json[error_code].intValue == 200) || ePrescriptionData.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
    
    static func getPreviousEPrescription(parameters : JSONDictionary, success : @escaping ([EprescriptionModel]) -> Void, failure : @escaping (Error) -> Void) {
        
        AppNetworking.GET(endPoint: EndPoint.getNutritionGraphData.url, parameters: parameters, success: { (json : JSON) -> Void in
            
            let ePrescriptionData = EprescriptionModel.modelsFromDictionaryArray(array: json[response].arrayValue)
            
            success(ePrescriptionData)
            
            if !(json[error_code].intValue == 200) || ePrescriptionData.isEmpty {
                let e = NSError(localizedDescription: json[error_string].string ?? AppMessages.ErrorMessage.rawValue)
                failure(e)
            }
            
        }, failure: {(e : Error) -> Void in
            
            // Handle respective error for login
            failure(e)
        })
    }
}
