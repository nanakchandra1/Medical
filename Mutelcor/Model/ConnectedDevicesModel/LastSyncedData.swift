//
//  LastSyncedData.swift
//  Mutelcor
//
//  Created by  on 24/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import SwiftyJSON

class LastSyncedData {
    
    var id: Int?
    var activityID: Int?
    var activityDate: String = ""
    var activityDateInterval: String = ""
    var distanceUnit: DistanceUnit = .kms
    var durationUnit: DurationUnit = .mins
    var duration: Int = 0
    var intensity: IntensityValue = .moderate
    var activityTime: String = ""
    var calories: Int = 0
    var createdAt: String = ""
    var deviceType: ConnectedDevice = .manual
    var isDeleted: Int = 0
    var isUpdated: Int = 0
    var patientID: Int = 0
    var totalDistance: Double = 0.0
    var steps: Int = 0
    var updatedAt: String = ""
    
    required init(json: JSON){
        
        guard let id = json[DictionaryKeys.cmsId].int else{
            return
        }
        self.id = id
        self.activityID = json[DictionaryKeys.activityID].intValue
        let date = json[DictionaryKeys.activityDate].stringValue
        self.activityDate = date.changeDateFormat(.utcTime, .yyyyMMdd)
        if let date = self.activityDate.getDateFromString(.yyyyMMdd, .utcTime){
           let interval = Date.timeIntervalSince(date)
            self.activityDateInterval = "\(interval)"
        }

        let distance = json[DictionaryKeys.distanceUnit].stringValue
        self.distanceUnit = distance == DistanceUnit.kms.rawValue ? .kms : .miles
        
        let durationUnit = json[DictionaryKeys.durationUnit].stringValue
        self.durationUnit = durationUnit == DurationUnit.mins.rawValue ? .mins : .hours
        
        self.duration = json[DictionaryKeys.activityDuration].intValue
        
        let intensityValue = json[DictionaryKeys.activityIntensity].stringValue
        self.intensity = intensityValue == IntensityValue.moderate.rawValue ? .moderate : .low
        self.activityTime = json[DictionaryKeys.activityTime].stringValue
        self.calories = json[DictionaryKeys.caloriesBurn].intValue
        self.createdAt = json[DictionaryKeys.createdAt].stringValue
        let deviceTyp = json[DictionaryKeys.deviceType].intValue
        
        switch deviceTyp {
        case ConnectedDevice.iHealthApi.rawValue:
            self.deviceType = ConnectedDevice.iHealthApi
        case ConnectedDevice.iHealthDevice.rawValue:
            self.deviceType = ConnectedDevice.iHealthDevice
        case ConnectedDevice.fitbitAPi.rawValue:
            self.deviceType = ConnectedDevice.fitbitAPi
        case ConnectedDevice.fitbitDevice.rawValue:
            self.deviceType = ConnectedDevice.fitbitDevice
        default:
            self.deviceType = ConnectedDevice.manual
        }

        self.isDeleted = json[DictionaryKeys.isDeleted].intValue
        self.isUpdated = json[DictionaryKeys.isUpdated].intValue
        self.patientID = json[DictionaryKeys.patinetId].intValue
        self.totalDistance = json[DictionaryKeys.totalDistance].doubleValue
        self.steps = json[DictionaryKeys.totalSteps].intValue
        self.updatedAt = json[DictionaryKeys.updatedAt].stringValue
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [LastSyncedData]{
        
        var lastSyncData: [LastSyncedData] = []
        
        for value in array {
            lastSyncData.append(LastSyncedData.init(json: value))
        }
        
        return lastSyncData
    }
}
