//
//  DasboardDataModel.swift
//  Mutelcor
//
//  Created by on 20/09/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class DashboardDataModel {
    
    var messageUnreadCount: Int?
    var notificationUnreadCount: Int?
    var rating: Double?
    private var nextVisit: String
    var weightInfo = [Weight]()
    var nutritionCalories = [NutritionCalories]()
    var bmiLevel = [BmiLevel]()
    var reviewDate = [ReviewDate]()
    var latestAppointment = [LatestAppointment]()
    var activityCalories = [ActivityCalories]()
    var nextSchedule = [NextSchedule]()
    var lastSentData = [LastSentData]()
    
    var nextVisitDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: nextVisit)
    }
    
    required init(json : JSON) {
        self.messageUnreadCount = json[DictionaryKeys.messageUnreadCount].intValue
        self.notificationUnreadCount = json[DictionaryKeys.notificationUnreadCount].intValue
        self.rating = json[DictionaryKeys.starRating].doubleValue
        
        self.nextVisit = json[DictionaryKeys.nextVisit].stringValue.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
        AppUserDefaults.save(value: self.nextVisit, forKey: .nextVisitDate)
        
        weightData(json[DictionaryKeys.weight])
        nutritionCalories(json[DictionaryKeys.nutritionCalories].arrayValue)
        bmiLevel(json[DictionaryKeys.bmiLevel])
        reviewDate(json[DictionaryKeys.reviewDate])
        latestAppointmentData(json[DictionaryKeys.latestAppointment])
        activityCaloriesData(json[DictionaryKeys.activityCalories].arrayValue)
        nextScheduleData(json[DictionaryKeys.nextSchedule].arrayValue)
        lastSentData(json[DictionaryKeys.lastSentData].arrayValue)
    }
    
   @discardableResult func weightData(_ weightData: JSON) -> [Weight]{
        
        let weightData = Weight.init(json: weightData)
        self.weightInfo.append(weightData)
        return self.weightInfo
    }
    
    @discardableResult func nutritionCalories(_ nutritionCalories: [JSON]) -> [NutritionCalories]{
        for json in nutritionCalories {
            let nutritionCaloriesData = NutritionCalories.init(json: json)
            self.nutritionCalories.append(nutritionCaloriesData)
        }
        return self.nutritionCalories
    }
    @discardableResult func bmiLevel(_ bmiLevel: JSON) -> [BmiLevel]{
        
        let bmiLevelData = BmiLevel.init(json: bmiLevel)
        self.bmiLevel.append(bmiLevelData)
        return self.bmiLevel
    }
    @discardableResult func reviewDate(_ reviewDate: JSON) -> [ReviewDate]{
        if let reviewDateData = ReviewDate.init(json: reviewDate){
            self.reviewDate.append(reviewDateData)
        }
        return self.reviewDate
    }
    @discardableResult func latestAppointmentData(_ lastestAppointment: JSON) -> [LatestAppointment]{
        
        if let lastestAppointmentData = LatestAppointment(lastestAppointment) {
            self.latestAppointment.append(lastestAppointmentData)
        }
        return self.latestAppointment
    }
    @discardableResult func activityCaloriesData(_ activityCalories: [JSON]) -> [ActivityCalories]{
        for json in activityCalories {
            if let activityCaloriesData = ActivityCalories.init(json) {
                self.activityCalories.append(activityCaloriesData)
            }
        }
        return self.activityCalories
    }
    @discardableResult func nextScheduleData(_ nextSchedule: [JSON]) -> [NextSchedule]{
        for json in nextSchedule {
            if let nextScheduleData = NextSchedule(json) {
                self.nextSchedule.append(nextScheduleData)
            }
        }
        return self.nextSchedule
    }
    @discardableResult func lastSentData(_ lastSent: [JSON]) -> [LastSentData]{
        for json in lastSent {
            if let lastSentData = LastSentData(json) {
                self.lastSentData.append(lastSentData)
            }
        }
        return self.lastSentData
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [DashboardDataModel] {
        var model = [DashboardDataModel]()
        for value in array{
            model.append(DashboardDataModel(json: value))
        }
        return model
    }
}

class Weight {
    
    var currentWeight: Double
    var startWeight: Double
    var idealWeight: Double
    var targetWeight: Double
    
    init(json : JSON) {
        self.idealWeight = json[DictionaryKeys.idealWeight].doubleValue
        self.currentWeight = json[DictionaryKeys.currentWeight].doubleValue
        self.startWeight = json[DictionaryKeys.startingWeight].doubleValue
        self.targetWeight = json[DictionaryKeys.targetWeight].doubleValue
    }
}

class NutritionCalories {
    
    var planCalories : Double?
    var planWater: Double?
    var consumeCalories: Double?
    var consumeWater: Double?
    
    init(json : JSON) {
        self.planCalories = json[DictionaryKeys.planCalories].doubleValue
        self.planWater = json[DictionaryKeys.planWater].doubleValue
        self.consumeCalories = json[DictionaryKeys.consumeCalories].doubleValue
        self.consumeWater = json[DictionaryKeys.consumeWater].doubleValue
    }
}

class BmiLevel {
    let bmiLevel: Double
    
    init(json : JSON) {
        self.bmiLevel = json[DictionaryKeys.bmiLevel].doubleValue
    }
}

class ReviewDate {
    var reviewDate: String?
    
    init?(json : JSON) {
        if let date = json[DictionaryKeys.date].string , date != "0000-00-00"{
            self.reviewDate = date
        }else{
            return nil
        }
    }
}

class LatestAppointment {
    var appointmentId : Int?
    var serverID: String?
    var googleEventID: [String]
    var appointmentDescription: String?
    var date : String?
    var startTime: String?
    var endTime: String?
    
    init?(_ json: JSON){
        if let id = json[DictionaryKeys.appointmentID].string, !id.isEmpty {
            self.appointmentId = Int(id)
        } else {
            return nil
        }
        self.serverID = json[DictionaryKeys.apponitmentServerID].stringValue
        self.googleEventID = []
        for json in json[DictionaryKeys.appointmentGoogleEventID].arrayValue {
            self.googleEventID.append(json.stringValue)
        }
        self.appointmentDescription = json[DictionaryKeys.cmsDescription].stringValue
        self.date = json[DictionaryKeys.date].stringValue
        self.startTime = json[DictionaryKeys.appointmentStart_Time].stringValue
        self.endTime = json[DictionaryKeys.appointmentEnd_Time].stringValue
    }
}
class ActivityCalories {
    
    var planCalories: Double?
    var consumeCalories: Double?
    
    init? (_ json: JSON){
        self.planCalories = json[DictionaryKeys.planCalories].doubleValue
        self.consumeCalories = json[DictionaryKeys.consumeCalories].doubleValue
    }
}

class NextSchedule {
    var scheduleID: Int?
    var description: String?
    var googleEventID: [String]
    var serverID: String?
    var scheduleDescription: String?
    var scheduleIcon: String?
    var testName: String?
    var time: String?
    
    init?(_ json: JSON){
        if let id = json[DictionaryKeys.vitalID].int{
            self.scheduleID = id
        }
        self.googleEventID = []
        for json in json[DictionaryKeys.appointmentGoogleEventID].arrayValue {
            self.googleEventID.append(json.stringValue)
        }
        
        self.description = json[DictionaryKeys.cmsDescription].stringValue
        self.serverID = json[DictionaryKeys.apponitmentServerID].stringValue
        self.scheduleDescription = json[DictionaryKeys.cmsDescription].stringValue
        self.testName = json[DictionaryKeys.nextScheduleTestName].stringValue
        self.scheduleIcon = json[DictionaryKeys.nextScheduleIcon].stringValue
        self.time = json[DictionaryKeys.nextScheduleTime].stringValue
    }
}

class LastSentData {
    
    var priority: Int?
    var severity: Int?
    var vitalIcon: String?
    var superId: Int?
    var valueConversion: String = ""
    var vitalName: String?
    var vitalID: Int?
    var vitalSubName: String?
    var vitalUnit: String?
    var vitalRangle: String?
    var measurementDate: String?
    var measurementTime: String?
    
    init? (_ json: JSON){
        if let priority = json[DictionaryKeys.lastSeenPriorty].int{
            self.priority = priority
        }
        if let severity = json[DictionaryKeys.lastSeenVitalSeverity].int{
            self.severity = severity
        }
        self.vitalIcon = json[DictionaryKeys.lastSeenVitalIcon].stringValue
        if let superID = json[DictionaryKeys.lastSeenVitalSuperID].int{
            self.superId = superID
        }
        self.valueConversion = json[DictionaryKeys.lastSeenVitalValueConversion].stringValue
        self.vitalName = json[DictionaryKeys.lastSeenVitalName].stringValue
        if let vitalID = json[DictionaryKeys.vitalID].int{
            self.vitalID = vitalID
        }
        self.vitalSubName = json[DictionaryKeys.lastSeenVitalSubName].stringValue
        self.vitalUnit = json[DictionaryKeys.lastSeenVitalUnit].stringValue
        self.measurementDate = json[DictionaryKeys.measurementDate].stringValue
        self.measurementTime = json[DictionaryKeys.measurementTime].stringValue
    }
}
