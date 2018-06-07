//
//  SurgeyModel.swift
//  Mutelcor
//
//  Created by  on 05/04/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class SurgeryModel {
    
    var surgeryId : Int?
    var surgeryName : String?
    
    required init?(surgeyInfoDic : JSON){
        
        if let surgeryID = surgeyInfoDic[DictionaryKeys.surgeryID].int{
           self.surgeryId = surgeryID
        }
        self.surgeryName = surgeyInfoDic[DictionaryKeys.surgeryName].stringValue
    }
    
    class func modelsFromDictionaryArray(array: [JSON]) -> [SurgeryModel] {
        var models: [SurgeryModel] = []
        for json in array {
            if let surgeryData = SurgeryModel(surgeyInfoDic : json) {
                models.append(surgeryData)
            }
        }
        return models
    }
}
