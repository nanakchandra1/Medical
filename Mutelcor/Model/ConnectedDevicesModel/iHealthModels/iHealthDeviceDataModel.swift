//
//  iHealthDeviceDataModel.swift
//  Mutelcor
//
//  Created by  on 23/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import SwiftyJSON

class iHealthDeviceData {
    
    var date: String = ""
    var dateInterval: String = ""
    var calories: Int = 0
    var stepCount: Int = 0
    var stepSize: Int = 0
    var dateValue: String = ""
    var start : Int = 0
    var dataID: String = ""
    
    init(dic: [String : Any]) {
        
        
        guard let id = dic[DictionaryKeys.iHealthDataID] as? String, !id.isEmpty else{
            return
        }
        self.dataID = id
        if let deviceDate = dic[DictionaryKeys.iHealthDate] as? Date {
            self.date = deviceDate.stringFormDate(.yyyyMMdd)
        }

        if let date = self.date.getDateFromString(.yyyyMMdd, .utcTime){
            let interval = Date.timeIntervalSince(date)
            self.dateInterval = "\(interval)"
        }
        
        if let deviceCalories = dic[DictionaryKeys.iHealthCalorie] as? Int {
            self.calories = deviceCalories
        }
        
        if let deviceStepCount = dic[DictionaryKeys.iHealthStepCount] as? Int {
            self.stepCount = deviceStepCount
        }
        
        if let deviceStepSize = dic[DictionaryKeys.iHealthStepSize] as? Int {
            self.stepSize = deviceStepSize
        }
        
        if let deviceDay = dic[DictionaryKeys.iHealthDay] as? String {
            self.dateValue = deviceDay
        }
        
        if let deviceStart = dic[DictionaryKeys.iHealthStart] as? Int {
            self.start = deviceStart
        }
    }
    
    class func modelForDictionary(deviceData: JSONDictionaryArray) -> [iHealthDeviceData]{
        
        var iHealthData = [iHealthDeviceData]()
        for (index , value) in deviceData.enumerated() {
            
            var day: String = ""
            var isDataChangeInMidOfArray: Bool = false
            var deviceDataDic : [String: Any] = [:]
            
            if let start = value[DictionaryKeys.iHealthStart] as? Int, start == true.rawValue {
                if let dayValue = value[DictionaryKeys.iHealthDay] as? String, day != dayValue {
                    isDataChangeInMidOfArray = true
                    if index != 0 {
                    deviceDataDic = deviceData[index - 1]
                    }else if index == (deviceData.count - 1){
                        deviceDataDic = deviceData[index]
                    }
                }else{
                    isDataChangeInMidOfArray = true
                    if index == (deviceData.count - 1){
                        deviceDataDic = deviceData[index]
                    }
                }
            }else{
                guard let dayValue = value[DictionaryKeys.iHealthDay] as? String else{
                    break
                }
                
                day = dayValue
        
                if index == (deviceData.count - 1), !isDataChangeInMidOfArray {
                     deviceDataDic = deviceData[index]
                }
            }
            
            if !deviceDataDic.isEmpty {
                iHealthData.append(iHealthDeviceData.init(dic: deviceDataDic))
            }
        }
        
        return iHealthData
    }
}
