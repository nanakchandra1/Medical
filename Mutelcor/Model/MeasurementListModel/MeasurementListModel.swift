//
//  MeasurementListModel.swift
//  Mutelcor
//
//  Created by on 08/12/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class MeasurementListModel {
    var mainUnit: String = ""
    var superID: Int?
    var unit: String = ""
    var vitalID: Int?
    var vitalName: String = ""
    var vitalSubName: String = ""
    
    required init(json: JSON){
       self.mainUnit = json[DictionaryKeys.mainUnit].stringValue
        if let superID = json[DictionaryKeys.lastSeenVitalSuperID].int{
         self.superID = superID
        }
        self.unit = json[DictionaryKeys.lastSeenVitalUnit].stringValue
        if let vitalID = json[DictionaryKeys.vitalID].int{
            self.vitalID = vitalID
        }
        self.vitalName = json[DictionaryKeys.lastSeenVitalName].stringValue
        self.vitalSubName = json[DictionaryKeys.lastSeenVitalSubName].stringValue
    }
    
    class func measurementListData(_ measurementTest: [JSON]) -> [[MeasurementListModel]]{
        var measurementTestArray = [[MeasurementListModel]]()
        for  data in measurementTest {
            var measurementTestReport : [MeasurementListModel] = []
            for test in data.arrayValue {
                measurementTestReport.append(MeasurementListModel.init(json: test))
            }
            measurementTestArray.append(measurementTestReport)
        }
        return measurementTestArray
    }
}
