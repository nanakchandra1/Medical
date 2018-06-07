//
//  NutritionModel.swift
//  Mutelcor
//
//  Created by on 26/06/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class DayWiseNutrition {
    var planCalories : Double?
    var planFats : Double?
    var planCrabs : Double?
    var planProtiens : Double?
    var planWater : Double?
    var consumeCalories : Double?
    var consumeFats : Double?
    var consumeCrubs : Double?
    var consumeProtiens : Double?
    var consumeWater : Double?
    
    
    
    class func modelFromJsonArray(_ data : [JSON]) -> [DayWiseNutrition] {
        
        var dayWisedata : [DayWiseNutrition] = []
        
        for json in data {
            dayWisedata.append(DayWiseNutrition(json))
        }
     return dayWisedata
    }
    
   required init(_ dayWiseNutritionData : JSON){
        
        self.planCalories  = dayWiseNutritionData[DictionaryKeys.planCalories].doubleValue
        self.planFats = dayWiseNutritionData[DictionaryKeys.planFat].doubleValue
        self.planCrabs = dayWiseNutritionData[DictionaryKeys.planCarbs].doubleValue
        self.planProtiens = dayWiseNutritionData[DictionaryKeys.planProtiens].doubleValue
        self.planWater = dayWiseNutritionData[DictionaryKeys.planWater].doubleValue
        self.consumeCalories = dayWiseNutritionData[DictionaryKeys.consumeCalories].doubleValue
        self.consumeFats = dayWiseNutritionData[DictionaryKeys.consumeFats].doubleValue
        self.consumeCrubs = dayWiseNutritionData[DictionaryKeys.consumeCarbs].doubleValue
        self.consumeProtiens = dayWiseNutritionData[DictionaryKeys.consumeProteins].doubleValue
        self.consumeWater = dayWiseNutritionData[DictionaryKeys.consumeWater].doubleValue
    }
}

//MARK:- Data In Graph(Pie Graph)
//================================
class GraphView {
    
    var mealSchedule : Int?
    var caloriesTaken : Double?
    var fatsTaken : Double?
    var crabsTaken : Double?
    var protiesTaken : Double?
    var waterTaken : Double?
    var scheduleName : String?
    
    class func modelFromJsonArray(_ data : [JSON]) -> [GraphView] {
        
        var graphViewData : [GraphView] = []
        for json in data {
            graphViewData.append(GraphView(json))
        }
        return graphViewData
    }
    
    init(_ graphViewData : JSON) {
        
        if let mealSchedule = graphViewData[DictionaryKeys.mealSchedule].int{
          self.mealSchedule = mealSchedule
        }
        self.fatsTaken = graphViewData[DictionaryKeys.totalFats].doubleValue
        self.crabsTaken = graphViewData[DictionaryKeys.totalCarbs].doubleValue
        self.protiesTaken = graphViewData[DictionaryKeys.totalProtiens].doubleValue
        self.waterTaken = graphViewData[DictionaryKeys.totalWater].doubleValue
        self.scheduleName = graphViewData[DictionaryKeys.mealTime].stringValue
        self.caloriesTaken = graphViewData[DictionaryKeys.totalCalories].doubleValue
    }
}

//MARK:- Data in Tabular
//======================
class NutritionGraphData {
    
    var nutritionID : Int?
    var mealSchedule : Int?
    var foodTaken : String?
    var caloriesTaken : Double?
    var fatsTaken : Double?
    var crabsTaken : Double?
    var protiensTaken : Double?
    var waterTaken : Double?
    var time : String?
    var date : String?
    var scheduleName : String?
    
    class func modelFromJsonArray(_ data : [JSON]) -> [NutritionGraphData] {
        
        var nutritionGraphData : [NutritionGraphData] = []
        for json in data {
            nutritionGraphData.append(NutritionGraphData(json))
        }
        return nutritionGraphData
    }
    
    init(_ tabularData : JSON) {
        
        if let nutritionID = tabularData[DictionaryKeys.nutritionID].int {
           self.nutritionID = nutritionID
        }
        
        if let mealSchedule = tabularData[DictionaryKeys.mealSchedule].int {
            self.mealSchedule = mealSchedule
        }

        self.foodTaken = tabularData[DictionaryKeys.foodTaken].stringValue
        self.fatsTaken = tabularData[DictionaryKeys.fatsTaken].doubleValue
        self.crabsTaken = tabularData[DictionaryKeys.carbsTaken].doubleValue
        self.protiensTaken = tabularData[DictionaryKeys.protienTaken].doubleValue
        self.waterTaken = tabularData[DictionaryKeys.waterTaken].doubleValue
        self.scheduleName = tabularData[DictionaryKeys.scheduleName].stringValue
        self.caloriesTaken = tabularData[DictionaryKeys.caloriesTaken].doubleValue
        self.time = tabularData[DictionaryKeys.nutritionTime].stringValue
        self.date = tabularData[DictionaryKeys.n_date].stringValue
    }
}

//MARK:- Week Performance
//=======================
class WeekPerformance {
    
    var mealDuration : String?
    var value : Double?
    var mealDate : String?
    
    class func modelFromJsonArray(_ data : [JSON]) -> [[WeekPerformance]] {
        
        var weekPerformanceData = [[WeekPerformance]]()
        for (column, weekData) in data.enumerated() {
            for value in weekData.arrayValue {
                if column >= weekPerformanceData.count {
                    weekPerformanceData.append([WeekPerformance(value)])
                } else {
                    weekPerformanceData[column].append(WeekPerformance(value))
                }
            }
        }
        return weekPerformanceData
    }
    
    init(_ weekPerformanceData : JSON){
        
        self.mealDuration = weekPerformanceData[DictionaryKeys.mealTime].stringValue
        self.value = weekPerformanceData[DictionaryKeys.nutritionValue].doubleValue
        self.mealDate = weekPerformanceData[DictionaryKeys.n_date].stringValue
    }
}
