//
//  ActivtyFormModel.swift
//  Mutelcor
//
//  Created by on 05/10/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

//    Calculate Data
struct CalculatedValue {
    
    var distance: Double = 0.0
    var duration: Double = 0.0
    var steps: Int = 0
    var calories: Double = 0.0
    var distanceType: DistanceUnit = .kms
    var durationType: DurationUnit = .mins
    var intensityType: IntensityValue = .low
    var activity: Int = 0
    var index: Int = 0
    var isDistanceChanged: Bool = false
    var isDurationChanged: Bool = false
    var isCalorieChanged: Bool = false
    var isStepsChanged: Bool = false
    
    mutating func changeSteps(_ step : Int, _ activityFormModel : [ActivityFormModel]) {
        self.steps = step
        
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    mutating func changeDuration(_ duration : Double, _ activityFormModel : [ActivityFormModel]) {
        
        let durationValue = (self.durationType == .mins) ? duration : duration * 60
        self.duration = durationValue.rounded(toPlaces: 2)
        
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    mutating func changeDistance(_ distance : Double, _ activityFormModel : [ActivityFormModel]) {
        let distanceValue = (self.distanceType == .kms) ? distance : distance / 1.6
        self.distance = distanceValue
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    mutating func changeCalories(_ calories : Double, _ activityFormModel : [ActivityFormModel]) {
        self.calories = calories
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    mutating func changeDistanceType(_ distanceType : DistanceUnit, _ activityFormModel : [ActivityFormModel]) {
        self.distanceType = distanceType
        
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    mutating func changeDurationType(_ durationType : DurationUnit, _ activityFormModel : [ActivityFormModel]) {
        
        self.durationType = durationType

        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    mutating func changeIntensityType(_ intensityType : IntensityValue, _ activityFormModel : [ActivityFormModel]) {
        
        if self.intensityType != intensityType {
            self.intensityType = intensityType
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
    }
    
    mutating func changeActivity(_ changeActivity : Int, _ activityFormModel : [ActivityFormModel], _ index : Int) {
        self.index = index
        self.activity = changeActivity
        calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    }
    
    //        mutating func isDistanceChanged(_ isDistanceChanged : Bool, _ activityFormModel : [ActivityFormModel]) {
    //
    //            if self.isDistanceChanged != isDistanceChanged {
    //            self.isDistanceChanged = isDistanceChanged
    //            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
    //            }
    //        }
    
    private mutating func calculatValues(_ distance : Double, _ duration : Double, _ steps : Int, _ calories : Double , _ distanceType : DistanceUnit, _ durationType : DurationUnit, _ intensityType : IntensityValue, _ activity : Int, isDisChanged : Bool, isDurChanged : Bool, isStepChanged : Bool, isCalChanged : Bool, _ activityFormModel : [ActivityFormModel],_ index : Int) {
        
        if isDurChanged{
            let calFromDuration : Double?
            let distanceFromCal : Double?
            let stepsFormCalories : Double?
            
            switch intensityType{
            case .low :
                calFromDuration = activityFormModel[index].intensity1?.durationCalories
                distanceFromCal = activityFormModel[index].intensity1?.caloriesDistance
                stepsFormCalories = activityFormModel[index].intensity1?.caloriesStep
            case .moderate :
                calFromDuration = activityFormModel[index].intensity2?.durationCalories
                distanceFromCal = activityFormModel[index].intensity2?.caloriesDistance
                stepsFormCalories = activityFormModel[index].intensity2?.caloriesStep
            case .high :
                calFromDuration = activityFormModel[index].intensity3?.durationCalories
                distanceFromCal = activityFormModel[index].intensity3?.caloriesDistance
                stepsFormCalories = activityFormModel[index].intensity3?.caloriesStep
            }
            
            self.calories = duration * calFromDuration!
            let distanceValue = (distanceType == .kms) ? distanceFromCal! / 1000 : distanceFromCal! / 1609.34
            let distance = self.calories * distanceValue
            self.distance = distance.rounded(toPlaces: 2)
            let steps = self.calories * stepsFormCalories!//self.calories * distanceFromCal! * stepsFromDistance!
            self.steps = Int(steps)
        }
        
        if isDisChanged {
            let calFromDistance : Double?
            let stepsFormCalories : Double?
            
            switch intensityType{
            case .low :
                calFromDistance = activityFormModel[index].intensity1?.distanceCalories
                stepsFormCalories = activityFormModel[index].intensity1?.caloriesStep
                
            case .moderate :
                calFromDistance = activityFormModel[index].intensity2?.distanceCalories
                stepsFormCalories = activityFormModel[index].intensity2?.caloriesStep
                
            case .high :
                calFromDistance = activityFormModel[index].intensity3?.distanceCalories
                stepsFormCalories = activityFormModel[index].intensity3?.caloriesStep
            }
            let distanceValue = (distanceType == .kms) ? distance * 1000 : distance * 1609.34
            self.calories = distanceValue * calFromDistance!
            let calculatestep = stepsFormCalories?.rounded(toPlaces: 2)
            let step = distanceValue * calculatestep!
            self.steps = Int(step)
        }
        
        if isStepChanged {
            let calFromSteps : Double?
            let distanceFromSteps : Double?
            
            switch intensityType{
            case .low :
                calFromSteps = activityFormModel[index].intensity1?.stepCalories
                distanceFromSteps = activityFormModel[index].intensity1?.stepDistance
                
            case .moderate :
                calFromSteps = activityFormModel[index].intensity2?.stepCalories
                distanceFromSteps = activityFormModel[index].intensity2?.stepDistance
                
            case .high :
                calFromSteps = activityFormModel[index].intensity3?.stepCalories
                distanceFromSteps = activityFormModel[index].intensity3?.stepDistance
                
            }
            self.calories = Double(steps) * calFromSteps!
            let distance = Double(steps) * distanceFromSteps!
            let distanceValue = (distanceType == .kms) ? distance/1000 : distance/1609.34
//            let dis = distance/1000
            self.distance = distanceValue.rounded(toPlaces: 2)
//            self.distance = dis.rounded(toPlaces: 2)
        }
        
        if isCalChanged {
            let stepsFromCal : Double?
            let distanceFromCal : Double?
            
            switch intensityType{
            case .low :
                stepsFromCal = activityFormModel[index].intensity1?.caloriesStep
                distanceFromCal = activityFormModel[index].intensity1?.caloriesDistance
                
            case .moderate :
                stepsFromCal = activityFormModel[index].intensity2?.caloriesStep
                distanceFromCal = activityFormModel[index].intensity2?.caloriesDistance
                
            case .high :
                stepsFromCal = activityFormModel[index].intensity3?.caloriesStep
                distanceFromCal = activityFormModel[index].intensity3?.caloriesDistance
                
            }
            self.steps = Int(calories * stepsFromCal!)
            let distance = calories * distanceFromCal!
            
            let distanceInKm = distance/1000
            let distanceInMiles = distance/1609.34
            let distanceValue = (distanceType == .kms) ? distanceInKm : distanceInMiles
//            let dis = distance/1000
//            self.distance = dis.rounded(toPlaces: 2)
            self.distance = distanceValue.rounded(toPlaces: 2)
        }
    }
}
