//
//  AppMessages.swift
//  AppUserDefaults
//
//  Created by Gurdeep on 15/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation

enum AppMessages : String {

    case ErrorMessage = ""
    
//    MARK: Login Flow Messages
    
    case emptyEmailAndMobileNumber = "Please enter the email address or mobile Number."
    case validEmail = "Please enter the valid email Address."
    case emptyEmail = "Please enter the Email Address."
    case validEmailOrMobile = "Please enter the valid email or mobile Number."
    case validMobilNumber = "Please enter the valid mobile number."
    case emptyPassword = "Please enter the password."
    case passwordMoreThanSixChar = "Password should be in 6 to 16 characters"
    case mobileNumberLessThanTenDigits = "Mobile number should be in 10 digits."
    case emptyConfirmMessage = "Please enter the Confirm password."
    case passAndConfirmPassMismatched = "password and confirm password is not matched."
    case emptyCountryCode = "Please enter the country code."
    case emptyMobileNumber = "please enter the Mobile Number."
    case emptyConfirmPassword = "Please enter the confirm password."
    case validAuthorizationCode = "Please enter the valid authorization code."
    case authorizationCodeLessThanSixChar = "Authorization code should be six characters long."
    
//    MARK: SignIn With OTPVC
    
//    MARK: Reset Password
    
    case otpFieldEmpty = "Please enter the OTP."
    case otpLessThansixDigit = "Please enter the correct OTP."
    
//    MARK: PersonalInfo Messages
    case emptyFirstName = "Please enter the name."
    case emptyAdhaarCardnumber = "Please enter the Adhaar Card Number."
}
