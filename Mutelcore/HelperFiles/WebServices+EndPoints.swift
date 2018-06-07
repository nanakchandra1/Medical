//
//  WebServices+EndPoints.swift
//  TNIGHT
//
//  Created by Ashish on 08/03/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation

extension WebServices {
    
    
    enum EndPoint : String {

        case baseURL = "http://52.9.247.105:3000/v1/"
        
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
        case getSurgeryData = "http://52.9.247.105:3000/v1 /surgery"
        case upcomingAppointments = "upcoming-appointment"
        case getSymptoms = "get-symtomps"
        case rescheduleAppointment = "reschedule_appointment"
        case cancelAppointment = "cancel-appointment"
        case measurementHomeList = "measurement-home"
        case measurementFormBuilder = "measurement-form-builder"
        case getVitalList = "get_vitals_list"
        case getLatestVitals = "measurement-latest-vital"
        case getGraphList = "measurement_graph_list"
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
        
        var url: String {
            switch self {
            case .baseURL:
                return self.rawValue
                
            default:
                return "\(EndPoint.baseURL.rawValue)\(self.rawValue)"
            }
        }
    }
}
