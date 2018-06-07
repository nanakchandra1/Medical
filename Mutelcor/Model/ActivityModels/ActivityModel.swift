//
//  ActivityModel.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityFormModel {
    
    var activityID : Int?
    var activityName : String?
    var intensity1: Intensity1Model?
    var intensity2: Intensity2Model?
    var intensity3: Intensity3Model?
    
   required init?(activityFormData : JSON) {
        
        if let activityID = activityFormData["activity_id"].int{
            self.activityID = activityID
        }
        self.activityName = activityFormData["activity_name"].stringValue
     
        intensity1(intensit1Data: activityFormData)
        intensity2(intensity2Data: activityFormData)
        intensity3(intensity3Data: activityFormData)
    }
    
    init(){
    }
    
   
    @discardableResult func intensity1( intensit1Data : JSON) -> Intensity1Model{
    
    self.intensity1 = Intensity1Model.init(intensit1Data["intensity1"])
    return self.intensity1!
    }
    
    @discardableResult func intensity2( intensity2Data : JSON) -> Intensity2Model{
        
        self.intensity2 = Intensity2Model.init(intensity2Data["intensity2"])
       return self.intensity2!
    }
    
    @discardableResult func intensity3( intensity3Data : JSON) -> Intensity3Model{
        
        self.intensity3 = Intensity3Model.init(intensity3Data["intensity3"])
        return self.intensity3!
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [ActivityFormModel] {
        
        var models :[ActivityFormModel] = []
        
        for json in array {
                models.append(ActivityFormModel(activityFormData: json)!)
        }
        return models
    }
}

class Intensity1Model {
    
    var stepDistance : Double?
    var stepCalories : Double?
    var distanceCalories : Double?
    var caloriesDistance : Double?
    var distanceStep : Double?
    var caloriesStep : Double?
    var durationCalories : Double?
    var durationDistance : Double?

    init(_ intensity1Data : JSON ){
        self.stepDistance = intensity1Data["step_distance"].doubleValue
        self.stepCalories = intensity1Data["step_calories"].doubleValue
        self.distanceCalories = intensity1Data["distance_calories"].doubleValue
        self.caloriesDistance = intensity1Data["calories_distance"].doubleValue
        self.distanceStep = intensity1Data["distance_steps"].doubleValue
        self.caloriesStep = intensity1Data["calories_steps"].doubleValue
        self.durationCalories = intensity1Data["duration_calories"].doubleValue
        self.durationDistance = intensity1Data["duration_dis"].doubleValue
    }
}

class Intensity2Model {
    
    var stepDistance : Double?
    var stepCalories : Double?
    var distanceCalories : Double?
    var caloriesDistance : Double?
    var distanceStep : Double?
    var caloriesStep : Double?
    var durationCalories : Double?
    var durationDistance : Double?
    
    init(_ intensity2Data : JSON ){
        self.stepDistance = intensity2Data["step_distance"].doubleValue
        self.stepCalories = intensity2Data["step_calories"].doubleValue
        self.distanceCalories = intensity2Data["distance_calories"].doubleValue
        self.caloriesDistance = intensity2Data["calories_distance"].doubleValue
        self.distanceStep = intensity2Data["distance_steps"].doubleValue
        self.caloriesStep = intensity2Data["calories_steps"].doubleValue
        self.durationCalories = intensity2Data["duration_calories"].doubleValue
        self.durationDistance = intensity2Data["duration_dis"].doubleValue
    }
}

class Intensity3Model {
    
    var stepDistance : Double?
    var stepCalories : Double?
    var distanceCalories : Double?
    var caloriesDistance : Double?
    var distanceStep : Double?
    var caloriesStep : Double?
    var durationCalories : Double?
    var durationDistance : Double?
    
    init(_ intensity3Data : JSON ){
        self.stepDistance = intensity3Data["step_distance"].doubleValue
        self.stepCalories = intensity3Data["step_calories"].doubleValue
        self.distanceCalories = intensity3Data["distance_calories"].doubleValue
        self.caloriesDistance = intensity3Data["calories_distance"].doubleValue
        self.distanceStep = intensity3Data["distance_steps"].doubleValue
        self.caloriesStep = intensity3Data["calories_steps"].doubleValue
        self.durationCalories = intensity3Data["duration_calories"].doubleValue
        self.durationDistance = intensity3Data["duration_dis"].doubleValue
    }
}

//MARK:- Seven Days ActivityAvg
//=============================
class SevenDaysAvgData {
    
    var activityDuration : String?
    var caloriesBurn : String?
    var totalDistance : String?
    
   required init?(sevenDaysAvgData : JSON ){
        self.activityDuration = sevenDaysAvgData["activity_duration"].stringValue
        self.caloriesBurn = sevenDaysAvgData["calories_burn"].stringValue
        self.totalDistance = sevenDaysAvgData["total_distance"].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [SevenDaysAvgData] {
        var models: [SevenDaysAvgData] = []
        for json in array {
            models.append(SevenDaysAvgData(sevenDaysAvgData: json)!)
        }
        return models
    }
}
//MARK:- ActivityPlan
//===========================
class PreviousActivityPlan {
    
    var activityID : Int?
    var formID: String?
    var activityName : String?
    var activityDuration : Double?
    var activityDurationUnit : String?
    var activityIntensity : String?
    var caloriesBurn : Int?
    var totalSteps : Int?
    var totalDistance : Double?
    var activityDistanceUnit : String?
    var planStartDate : String?
    var planEndDate : String?
    var pointsToRemember : String?
    var dos : String?
    var donts : String?
    var attachments : String?
    var attachemntsName : String?
    var activityFrequency : String?
    var doctorName : String?
    var doctorSpeciality : String?
    var pdfFile: String?
    var createdDate: String?
    
    required init?(_ previousActivityPlanData : JSON ){
        
        if let activityID = previousActivityPlanData["activity_id"].int{
            self.activityID = activityID
        }
        self.formID = previousActivityPlanData["form_id"].stringValue
        self.activityName = previousActivityPlanData["activity_name"].stringValue
        self.activityDuration = previousActivityPlanData["activity_duration"].double
        self.activityDurationUnit = previousActivityPlanData["activity_duration_unit"].stringValue
        self.activityIntensity = previousActivityPlanData["activity_intensity"].stringValue
        
        if let caloriesBurn = previousActivityPlanData["calories_burn"].int{
            self.caloriesBurn = caloriesBurn
        }
        if let totalSteps = previousActivityPlanData["total_steps"].int{
            self.totalSteps = totalSteps
        }
        self.totalDistance = previousActivityPlanData["total_distance"].double
        self.activityDistanceUnit = previousActivityPlanData["activity_distance_unit"].stringValue
        self.planStartDate = previousActivityPlanData["plan_start_date"].stringValue
        self.planEndDate = previousActivityPlanData["plan_end_date"].stringValue
        self.pointsToRemember = previousActivityPlanData["points_to_remember"].stringValue
        self.dos = previousActivityPlanData["do"].stringValue
        self.donts = previousActivityPlanData["do_not"].stringValue
        self.attachments = previousActivityPlanData["attachments"].stringValue
        self.attachemntsName = previousActivityPlanData["attachments_name"].stringValue
        self.activityFrequency = previousActivityPlanData["activity_frequency"].stringValue
        self.doctorName = previousActivityPlanData["doctor_name"].stringValue
        self.doctorSpeciality = previousActivityPlanData["doc_specialisation"].stringValue
        self.pdfFile = previousActivityPlanData["pdf_file"].stringValue
        self.createdDate = previousActivityPlanData["created_date"].stringValue
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [PreviousActivityPlan] {
        
        var models: [PreviousActivityPlan] = []
        
        for json in array {
            models.append(PreviousActivityPlan(json)!)
        }
        return models
    }
}

//MARK:- Activity In Tabular
//==========================
class ActivityDataInTabular{
    
    var activityID : Int?
    var activityDate : String?
    var ActivityTime : String?
    var activityName : String?
    var activityDuration : Double?
    var activityDurationUnit : String?
    var activityIntensity : String?
    var caloriesBurn : Int?
    var totalSteps : Int?
    var totalDistance : Double?
    var activityDistanceUnit : String?
    
   required init?(_ activityInTabularData : JSON ){
        
        self.activityDate = activityInTabularData["activity_date"].stringValue
        self.ActivityTime = activityInTabularData["activity_time"].stringValue
        
        if let activityID = activityInTabularData["activity_id"].int{
            self.activityID = activityID
        }
        self.activityName = activityInTabularData["activity_name"].stringValue
        self.activityDuration = activityInTabularData["activity_duration"].double
        self.activityDurationUnit = activityInTabularData["activity_duration_unit"].stringValue
        self.activityIntensity = activityInTabularData["activity_intensity"].stringValue
        
        if let caloriesBurn = activityInTabularData["calories_burn"].int{
            self.caloriesBurn = caloriesBurn
        }
        if let totalSteps = activityInTabularData["total_steps"].int{
            self.totalSteps = totalSteps
        }
        self.totalDistance = activityInTabularData["total_distance"].double
        self.activityDistanceUnit = activityInTabularData["activity_distance_unit"].stringValue

    }
}

//MARK:- RecentActivity Model
//===========================
class RecentActivityModel {
    
    var activityID : Int?
    var activityDate : String?
    var ActivityTime : String?
    var activityName : String?
    var activityDuration : Double?
    var activityDurationUnit : String?
    var activityIntensity : String?
    var caloriesBurn : Int?
    var totalSteps : Int?
    var totalDistance : Double?
    var activityDistanceUnit : String?
    
    init(_ recentActivityData : JSON ){
        if let activityID = recentActivityData["activity_id"].int{
            self.activityID = activityID
        }
        self.activityDate = recentActivityData["activity_date"].stringValue
        self.ActivityTime = recentActivityData["activity_time"].stringValue
        self.activityName = recentActivityData["activity_name"].stringValue
        self.activityDuration = recentActivityData["activity_duration"].double
        self.activityDurationUnit = recentActivityData["activity_duration_unit"].stringValue
        self.activityIntensity = recentActivityData["activity_intensity"].stringValue
        
        if let caloriesBurn = recentActivityData["calories_burn"].int{
            self.caloriesBurn = caloriesBurn
        }
        if let totalSteps = recentActivityData["total_steps"].int{
            self.totalSteps = totalSteps
        }
        self.totalDistance = recentActivityData["total_distance"].double
        self.activityDistanceUnit = recentActivityData["activity_distance_unit"].stringValue
    }
}
