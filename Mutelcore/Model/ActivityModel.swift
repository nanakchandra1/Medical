//
//  ActivityModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityFormModel {
    
    var activityID : Int?
    var activityName : String?
    var intensity1: Intensity1Model?
    var intensity2: Intensity2Model?
    var intensity3: Intensity3Model?
    
    init(_ activityFormData : JSON) {
        
        self.activityID = activityFormData["activity_id"].int
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
}

class Intensity1Model {
    
    var stepDistance : Double?
    var stepCalories : Double?
    var distanceCalories : Double?
    var caloriesDistance : Double?
    var distanceStep : Double?
    var caloriesStep : Double?
    var durationCalories : Double?

    init(_ intensity1Data : JSON ){
        
        self.stepDistance = intensity1Data["step_distance"].double
        self.stepCalories = intensity1Data["step_calories"].double
        self.distanceCalories = intensity1Data["distance_calories"].double
        self.caloriesDistance = intensity1Data["calories_distance"].double
        self.distanceStep = intensity1Data["distance_steps"].double
        self.caloriesStep = intensity1Data["calories_steps"].double
        self.durationCalories = intensity1Data["duration_calories"].double
        
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
    
    init(_ intensity2Data : JSON ){
        
        self.stepDistance = intensity2Data["step_distance"].double
        self.stepCalories = intensity2Data["step_calories"].double
        self.distanceCalories = intensity2Data["distance_calories"].double
        self.caloriesDistance = intensity2Data["calories_distance"].double
        self.distanceStep = intensity2Data["distance_steps"].double
        self.caloriesStep = intensity2Data["calories_steps"].double
        self.durationCalories = intensity2Data["duration_calories"].double
        
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
    
    init(_ intensity3Data : JSON ){
        
        self.stepDistance = intensity3Data["step_distance"].double
        self.stepCalories = intensity3Data["step_calories"].double
        self.distanceCalories = intensity3Data["distance_calories"].double
        self.caloriesDistance = intensity3Data["calories_distance"].double
        self.distanceStep = intensity3Data["distance_steps"].double
        self.caloriesStep = intensity3Data["calories_steps"].double
        self.durationCalories = intensity3Data["duration_calories"].double
        
    }
}

//MARK:- Seven Days ActivityAvg
//=============================
class SevenDaysAvgData {
    
    var activityDuration : String?
    var caloriesBurn : String?
    var totalDistance : String?
    
    init(_ sevenDaysAvgData : JSON ){
        
        self.activityDuration = sevenDaysAvgData["activity_duration"].stringValue
        self.caloriesBurn = sevenDaysAvgData["calories_burn"].stringValue
        self.totalDistance = sevenDaysAvgData["total_distance"].stringValue
        
    }
}
//MARK:- PreviousActivityPlan
//===========================
class PreviousActivityPlan {
    
    var activityID : Int?
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
    
    init(_ previousActivityPlanData : JSON ){
        
        self.activityID = previousActivityPlanData["activity_id"].int
        self.activityName = previousActivityPlanData["activity_name"].stringValue
        self.activityDuration = previousActivityPlanData["activity_duration"].double
        self.activityDurationUnit = previousActivityPlanData["activity_duration_unit"].stringValue
        self.activityIntensity = previousActivityPlanData["activity_intensity"].stringValue
        self.caloriesBurn = previousActivityPlanData["calories_burn"].int
        self.totalSteps = previousActivityPlanData["total_steps"].int
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

    }
}

//MARK:- Current Activity Plan MODEL
//==================================
class CurrentActivityPlan{
    
    var activityID : Int?
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
    var doctorname : String?
    var doctorSpeciality : String?
    
    init(_ currentActivityPlanData : JSON ){
        
        self.activityID = currentActivityPlanData["activity_id"].int
        self.activityName = currentActivityPlanData["activity_name"].stringValue
        self.activityDuration = currentActivityPlanData["activity_duration"].double
        self.activityDurationUnit = currentActivityPlanData["activity_duration_unit"].stringValue
        self.activityIntensity = currentActivityPlanData["activity_intensity"].stringValue
        self.caloriesBurn = currentActivityPlanData["calories_burn"].int
        self.totalSteps = currentActivityPlanData["total_steps"].int
        self.totalDistance = currentActivityPlanData["total_distance"].double
        self.activityDistanceUnit = currentActivityPlanData["activity_distance_unit"].stringValue
        self.planStartDate = currentActivityPlanData["plan_start_date"].stringValue
        self.planEndDate = currentActivityPlanData["plan_end_date"].stringValue
        self.pointsToRemember = currentActivityPlanData["points_to_remember"].stringValue
        self.dos = currentActivityPlanData["do"].stringValue
        self.donts = currentActivityPlanData["do_not"].stringValue
        self.attachments = currentActivityPlanData["attachments"].stringValue
        self.attachemntsName = currentActivityPlanData["attachments_name"].stringValue
        self.activityFrequency = currentActivityPlanData["activity_frequency"].stringValue
        self.doctorname = currentActivityPlanData["doctor_name"].stringValue
        self.doctorSpeciality = currentActivityPlanData["doc_specialisation"].stringValue
        
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
    
    init(_ activityInTabularData : JSON ){
        
        self.activityDate = activityInTabularData["activity_date"].stringValue
        self.ActivityTime = activityInTabularData["activity_time"].stringValue
        self.activityID = activityInTabularData["activity_id"].int
        self.activityName = activityInTabularData["activity_name"].stringValue
        self.activityDuration = activityInTabularData["activity_duration"].double
        self.activityDurationUnit = activityInTabularData["activity_duration_unit"].stringValue
        self.activityIntensity = activityInTabularData["activity_intensity"].stringValue
        self.caloriesBurn = activityInTabularData["calories_burn"].int
        self.totalSteps = activityInTabularData["total_steps"].int
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
    
    init(_ RecentActivityData : JSON ){
        
        self.activityDate = RecentActivityData["activity_date"].stringValue
        self.ActivityTime = RecentActivityData["activity_time"].stringValue
        self.activityID = RecentActivityData["activity_id"].int
        self.activityName = RecentActivityData["activity_name"].stringValue
        self.activityDuration = RecentActivityData["activity_duration"].double
        self.activityDurationUnit = RecentActivityData["activity_duration_unit"].stringValue
        self.activityIntensity = RecentActivityData["activity_intensity"].stringValue
        self.caloriesBurn = RecentActivityData["calories_burn"].int
        self.totalSteps = RecentActivityData["total_steps"].int
        self.totalDistance = RecentActivityData["total_distance"].double
        self.activityDistanceUnit = RecentActivityData["activity_distance_unit"].stringValue
        
    }
}
