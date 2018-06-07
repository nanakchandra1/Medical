//
//  DailyAllowanceModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MeasurementGraphData {
	public var vital_id = 0
	public var measurementDate: Date
	public var value_conversion = 0
	public var vital_severity = 0
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementGraphData] {
        var models:[MeasurementGraphData] = []
        for json in array {
            if let graphData = MeasurementGraphData(json: json) {
                models.append(graphData)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
        Date.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        guard let id = json[DictionaryKeys.vitalID].int, let date = Date.dateFormatter.date(from: json[DictionaryKeys.measurementDate].stringValue) else {
            return nil
        }
		vital_id = id
		measurementDate = date
		value_conversion = json[DictionaryKeys.lastSeenVitalValueConversion].intValue
		vital_severity = json[DictionaryKeys.lastSeenVitalSeverity].intValue
	}
    
	func jsonRepresentation() -> JSONDictionary {
		var dictionary = JSONDictionary()

		dictionary[DictionaryKeys.vitalID] = self.vital_id
		dictionary[DictionaryKeys.lastSeenVitalValueConversion] = self.value_conversion
		dictionary[DictionaryKeys.lastSeenVitalSeverity] = self.vital_severity
        dictionary[DictionaryKeys.measurementDate] = self.measurementDate.stringFormDate(.yyyyMMdd)
        
		return dictionary
	}

}
