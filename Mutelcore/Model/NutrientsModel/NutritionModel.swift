//
//  NutritionModel.swift
//  Mutelcore
//
//  Created by Appinventiv on 26/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
        
        self.planCalories  = dayWiseNutritionData["plan_calories"].doubleValue
        self.planFats = dayWiseNutritionData["plan_fats"].doubleValue
        self.planCrabs = dayWiseNutritionData["plan_carbs"].doubleValue
        self.planProtiens = dayWiseNutritionData["plan_proteins"].doubleValue
        self.planWater = dayWiseNutritionData["plan_water"].doubleValue
        self.consumeCalories = dayWiseNutritionData["consume_calories"].doubleValue
        self.consumeFats = dayWiseNutritionData["consume_fats"].doubleValue
        self.consumeCrubs = dayWiseNutritionData["consume_carbs"].doubleValue
        self.consumeProtiens = dayWiseNutritionData["consume_proteins"].doubleValue
        self.consumeWater = dayWiseNutritionData["consume_water"].doubleValue
    
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
        
        self.mealSchedule = graphViewData["meal_schedule"].int
        self.fatsTaken = graphViewData["total_fats"].doubleValue
        self.crabsTaken = graphViewData["total_carbs"].doubleValue
        self.protiesTaken = graphViewData["total_proteins"].doubleValue
        self.waterTaken = graphViewData["total_water"].doubleValue
        self.scheduleName = graphViewData["meal_time"].stringValue
        self.caloriesTaken = graphViewData["total_calories"].doubleValue
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
        
        self.nutritionID = tabularData["n_id"].int
        self.mealSchedule = tabularData["meal_schedule"].int
        self.foodTaken = tabularData["food_taken"].stringValue
        self.fatsTaken = tabularData["fats_taken"].doubleValue
        self.crabsTaken = tabularData["carbs_taken"].doubleValue
        self.protiensTaken = tabularData["proteins_taken"].doubleValue
        self.waterTaken = tabularData["water_taken"].doubleValue
        self.scheduleName = tabularData["schedule_name"].stringValue
        self.caloriesTaken = tabularData["calories_taken"].doubleValue
        self.time = tabularData["n_time"].stringValue
        self.date = tabularData["n_date"].stringValue
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
        
        self.mealDuration = weekPerformanceData["meal_time"].stringValue
        self.value = weekPerformanceData["value"].doubleValue
        self.mealDate = weekPerformanceData["n_date"].stringValue
        
    }
}
