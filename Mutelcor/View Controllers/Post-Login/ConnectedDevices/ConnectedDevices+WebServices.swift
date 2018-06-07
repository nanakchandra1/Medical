//
//  ConnectedDevices+WebServices.swift
//  Mutelcor
//
//  Created by  on 12/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import SwiftyJSON

extension ConnectedDeviceVC {
    
//    MARK:- Add Multiple Activity
//    ============================
    func addMultipleActivity(parameters: [String: Any]){

        WebServices.addMultipleActivity(parameters: parameters, success: {
            
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func getActivityFormData(){
        
        WebServices.getActivityFormData(success: {[weak self] (activityData: [ActivityFormModel]) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.activityFormModel = activityData
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func addActivity(param: [String: Any]){
        WebServices.addActivity(parameters: param, success: {(_ errorString : String ) in
            showToastMessage("Data Synced Successfully.")
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //Calculate ActivityID and index
    func calculateActivityIDAndIndex() -> (index: Int?, activityID: Int?){
        
        guard !self.activityFormModel.isEmpty else{
            return (nil, nil)
        }
        for (index, activityData) in self.activityFormModel.enumerated() {
            
            if activityData.activityName?.uppercased() == "Walking".uppercased() || activityData.activityName?.uppercased() == "Running".uppercased(){
                
                return (index, activityData.activityID)
            }
        }
        return (nil, nil)
    }
    
    //    MARk:- Claculated Fitbit API data
    //    ==================================
    func calculatedConnectedDevicesData(caloriesUnit: Double, date: String, activityID: Int, index: Int) -> [String: Any]{
        var param: [String: Any] = [:]
        var dic: [String: Any] = [:]
        
        self.calculatedValues[0].index = index
        self.calculatedValues[0].activity = activityID
        self.calculatedValues[0].durationType = .mins
        self.calculatedValues[0].distanceType = .kms
        self.calculatedValues[0].intensityType = .moderate
        self.calculatedValues[0].isCalorieChanged = true
        self.calculatedValues[0].changeCalories(caloriesUnit, self.activityFormModel)
        
        dic["activity_id"]      = self.calculatedValues[0].activity
        dic["duration_unit"]    = self.calculatedValues[0].durationType.rawValue
        dic["duration"]         = self.calculatedValues[0].duration
        dic["intensity"]        = self.calculatedValues[0].intensityType.rawValue
        dic["calories"]         = self.calculatedValues[0].calories
        dic["steps"]            = self.calculatedValues[0].steps
        dic["distance_unit"]    = self.calculatedValues[0].distanceType.rawValue
        dic["distance"]         = self.calculatedValues[0].distance
        
        param["activity_type"] = [dic]
        param["activity_date"] = date
        param["device_type"] = self.connectedDeviceSync.rawValue
        param["activity_time"] = Date().stringFormDate(.Hmm)
        
        return param
    }

//    MARK:- Last Sync Data
//    ======================
    func lastSyncData(){
        
        WebServices.lastSyncData(success: {[weak self] (lastSyncData: [LastSyncedData]) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.lastSyncedData = lastSyncData
        }){(error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
