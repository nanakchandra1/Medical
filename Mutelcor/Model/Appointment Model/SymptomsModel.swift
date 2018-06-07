//
//  SymptomsModel.swift
//  Mutelcor
//
//  Created by on 13/09/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class Symptoms {
    var id : Int?
    var symptomsTag : String?
    var symptomName : String?
    
    required init(symptomsData : JSON, count: Int) {
        self.id = count
        self.symptomsTag = symptomsData[DictionaryKeys.symptomsTag].stringValue
        self.symptomName = symptomsData[DictionaryKeys.symptomsName].stringValue
    }
    
    class func modelFromDictionary(_ json : [JSON]) -> [Symptoms]{
        
        var model = [Symptoms]()
        for (count, jsonValue) in json.enumerated(){
            model.append(Symptoms(symptomsData: jsonValue, count: count))
        }
        return model
    }
}


