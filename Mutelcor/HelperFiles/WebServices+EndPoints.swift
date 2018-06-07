//
//  WebServices+EndPoints.swift
//  
//
//  Created by  on 08/03/17.
//  Copyright © 2017 . All rights reserved.
// 

import Foundation

extension WebServices {
    
    enum EndPoint : String {

       // case baseURL = "https://digitalhealth.mutelcor.com/v1/"//"https://mutelcor.applaurels.com:3005/v1/"//"https://mutelcor.applaurels.com:7108/v1/"
        case baseURL = "https://mutelcor.applaurels.com:7108/v1/"
//        case baseURL = "https://agauba.dyndns.mutelcor.com:43596/v1/"
        
        case termsConditionBaseUrl = "https://digitalhealth.mutelcor.com/"
        case termsCondition = "terms-conditions"
        case privacyPolicy = "privacy"
        case patientLogin = "login"
        case patientSignUp = "signup"
        case postSignUp1 = "updateprofile1"
        case postSignUp2 = "updateprofile2"
        case postSignUp3 = "updateprofile3"
        case getPatient = "getpatient"
        case sendOtp = "sendotp"
        case otpVerification = "otpverification"
        case resetPassword = "resetpassword"
        case changePassword = "changepassword"
        case forgetPassword = "forgetpassword"
        case typeOfSurgery =  "surgery"
        case speciality = "specialty"
        case fetchEthinicity = "ethinicity"
        case foodCategory = "food_category"
        case getCountry = "country"
        case getStates = "states"
        case getCity = "city"
        case getDoctorAvailiableSlot = "get_slot"
        case getAppointmentHistory = "appointment_history"
        case addAppointment = "add_appointment"
        case upcomingAppointments = "upcoming-appointment"
        case getSymptoms = "get-symtomps"
        case rescheduleAppointment = "reschedule_appointment"
        case cancelAppointment = "cancel-appointment"
        case measurementHomeList = "measurement-home"
        case measurementFormBuilder = "measurement-form-builder"
        case getVitalList = "get_vitals_list"
        case getLatestVitals = "measurement-latest-vital"
        case getTabularList = "measurement_tabular_list"
        case getAttachmentList = "measurement_attachments"
        case addMeasurement = "add_measurement"
        case measurementCategory = "get-measurement-category"
        case getActivityForm = "show-activity-form"
        case sevenDaysActivityAvg = "get-activity-avg-records"
        case getActivityByDate = "get-activity-by-date"
        case previousActivityPlan = "previous-activity-plan"
        case currentActivityPlan = "view-activity-plan"
        case getActivityInTabular = "get-activity-list"
        case recentActivity = "recent-activity"
        case addActivity = "add-activity-form"
        case getMealSchedule = "meal-schedule"
        case getFoods = "food-list"
        case getDayWiseNutrition = "get-nutrition-by-date"
        case getNutritionDataList = "nutrition-data-list"
        case getWeekPerformance = "nutrition-week-performance"
        case getRecentNutritions = "recent-nutrition-data"
        case addNutritionData = "add-nutrition-data"
        case getPreviousNutritionPlan = "get-previous-nutrition-plan"
        case getCurrentNutritionPlan = "get-current-nutrition-plan"
        case getActivityGraphData = "activity-graph-view"
        case getNutritionGraphData = "nutrition-graph-view"
        case getCurrentePrescription = "get-latest-eprescription"
        case getPreviousPrescription = "get-previous-eprescription"
        case getMeasurementGraphData = "measurement_graph_list"
        case getPatientLog = "get-patient-log"
        case getYearlyPatientLog = "get-yearly-log"
        case addReminder = "add-reminder"
        case editReminder = "edit-reminder"
        case deleteReminder = "delete-reminder"
        case getMedicationReminder = "get-mediction-reminder"
        case getDischargeSummary = "current-discharge-summary"
        case getPatientMessage = "get-patient-message"
        case getPatientLatestMessages = "get-latest-message"
        case getOldMessages = "get-old-message"
        case saveMessages = "save-message"
        case getNotification = "get-patient-notification"
        case updatepatientNotification = "update-patient-notification"
        case recentSymptoms = "get-latest-symptom"
        case saveSymptoms = "add-patient-symptom"
        case getAllSymptoms = "get-all-symptom"
        case getCms = "get-cms"
        case getPatientDetails = "get-patient-detail"
        case changeMobileNumberOtp = "change-phonenumber-otp"
        case changePhoneNumber = "change-phone-number"
        case logout = "logout"
        case updateSession = "update-session-info"
        case sendPdf = "send-message-email-pdf"
        case getDashboardData = "get-dashboard"
        case updateMedicationReminder = "update-medication-reminder"
        case updateMultipleEvents = "update-multiple-medication-reminder"
        case addMultipleReminder = "add-multiple-medication-reminder"
        case getShareLink = "get-shared-link"
        case sendGenratehealthReport = "send-health-report-pdf"
        case measurementTestList = "measurement-test-list"
        case addMultipleActivity = "add-multiple-activity-form"
        case lastActivitySync = "last-activity-sync"
        
        case iHealthBaseURL = "https://api.ihealthlabs.com:8443/OpenApiV2/"
        case iHealthAuthUrl = "OAuthv2/userauthorization/"
        case iHealthARDataUrl = "user/{user-id}/activity.json/"
        case iHealthAuthiOSCallbackUrl
        
        case oCRRequestBaseURL = "https://vision.googleapis.com/v1/images:annotate?key="
        case ocrURl
        
        case fitbitBaseURL = "https://www.fitbit.com/"
        case fitbitApiURl = "https://api.fitbit.com/"
        case fitbitAuthUrl = "oauth2/authorize"
        case fitbitDataUrl = "1/user/{user-id}/activities/activityCalories/date/{start-Date}/{end-Date}.json"        
        case fitbitCallBackUrl
        case fitbitAccessRefreshTokenRequest = "oauth2/token"
        
        case add_photo_timeline = "add-photo-timeline"
        case get_photo_timeline = "get-photo-timeline"
        case delete_photo_timeline = "delete-photo-timeline"

        var url: String {
            switch self {
            case .baseURL:
                return self.rawValue
                
            case .termsCondition:
                return "\(EndPoint.termsConditionBaseUrl.rawValue)\(self.rawValue)"
            case .privacyPolicy:
                return "\(EndPoint.termsConditionBaseUrl.rawValue)\(self.rawValue)"
                
            case .iHealthAuthUrl:
                return "\(EndPoint.iHealthBaseURL.rawValue)\(self.rawValue)"
            case .iHealthARDataUrl:
                return "\(EndPoint.iHealthBaseURL.rawValue)\(self.rawValue)"
            case .iHealthAuthiOSCallbackUrl:
                return "http://mutelcor.com/iOS-Callback/"
            case .ocrURl:
                return "\(EndPoint.oCRRequestBaseURL.rawValue)\(AppConstants.googleAPIYKey)"
            case .fitbitAuthUrl:
                return "\(EndPoint.fitbitBaseURL.rawValue)\(self.rawValue)"
            case .fitbitCallBackUrl:
                return "https://www.mutelcor.com/android"
            case .fitbitAccessRefreshTokenRequest:
                return "\(EndPoint.fitbitApiURl.rawValue)\(self.rawValue)"
            case .fitbitDataUrl:
                return "\(EndPoint.fitbitApiURl.rawValue)\(self.rawValue)"
                
            default:
                return "\(EndPoint.baseURL.rawValue)\(self.rawValue)"
            }
        }
    }
}

