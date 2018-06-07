//
//  DailyAllowanceModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MeasurementGraphList {
	public var selected_sub_vitals = ""
	public var graphData : [MeasurementGraphData] = []
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [MeasurementGraphList] {
        var models:[MeasurementGraphList] = []
        for json in array {
            if let graphList = MeasurementGraphList(json: json) {
                models.append(graphList)
            }
        }
        return models
    }
    
	required public init?(json: JSON) {
        guard let sub_vital = json[DictionaryKeys.selectedSubVital].string else {
            return
        }
		selected_sub_vitals = sub_vital
		if let jsonResponse = json[DictionaryKeys.response].array {
            graphData = MeasurementGraphData.modelsFromDictionaryArray(array: jsonResponse)
        }
	}
    
	func jsonRepresentation() -> JSONDictionary {
        var dictionary = JSONDictionary()
		dictionary[DictionaryKeys.selectedSubVital] = self.selected_sub_vitals
        
        var graphDataDict = [JSONDictionary]()
        for data in graphData {
            graphDataDict.append(data.jsonRepresentation())
        }
        dictionary[DictionaryKeys.response] = graphDataDict
        
		return dictionary
	}

}
