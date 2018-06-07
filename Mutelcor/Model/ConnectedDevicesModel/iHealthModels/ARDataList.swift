//
//  iHealthTokenModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON
 

class ARDataList {
	var calories : Int = 0
	var dataID : String?
	var distanceTraveled : Double?
	var lat : Double?
	var lon : Double?
	var mDate : Int?
    var measurementDate : String = ""
    var timeInterval: String = ""
	var note : String?
	var steps : Int?

    class func modelsFromDictionaryArray(array: [JSON]) -> [ARDataList]
    {
        var models:[ARDataList] = []
        for json in array {
            if let dataList = ARDataList(json: json) {
                models.append(dataList)
            }
        }
        return models
    }

	required init?(json: JSON) {

        guard let dateId = json["DataID"].string else {
            return nil
        }
        
		calories = json["Calories"].intValue
		dataID = dateId
		distanceTraveled = json["DistanceTraveled"].doubleValue
		lat = json["Lat"].doubleValue
		lon = json["Lon"].doubleValue
		mDate = json["MDate"].intValue
        let date = Date.init(timeIntervalSince1970: TimeInterval(mDate!))
        measurementDate = date.stringFormDate(.yyyyMMdd)

        if let date = measurementDate.getDateFromString(.yyyyMMdd, .utcTime){
            let interval = Date.timeIntervalSince(date)
            self.timeInterval = "\(interval)"
        }

		note = json["Note"].stringValue
		steps = json["Steps"].intValue
	}
    
	func jsonRepresentation() -> [String: Any] {

		var dictionary = [String: Any]()

        dictionary["Calories"]              = self.calories
        dictionary["DataID"]                = self.dataID
        dictionary["DistanceTraveled"]      = self.distanceTraveled
        dictionary["Lat"]                   = self.lat
        dictionary["Lon"]                   = self.lon
        dictionary["MDate"]                 = self.mDate
        dictionary["Note"]                  = self.note
        dictionary["Steps"]                 = self.steps

		return dictionary
	}

}
