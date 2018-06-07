//
//  YearlyLogBookModel.swift
//  Mutelcor
//
//  Created by on 24/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class YearlyLogBookModel {
    
    var count1 : Int?
    var year1 : String?
    var month1 : String?
    var month2 : Int?
    
    required init(_ yearlyLogBookValues : JSON){
        if let count = yearlyLogBookValues[DictionaryKeys.count1].int{
            self.count1 = count
        }
        self.year1 = yearlyLogBookValues[DictionaryKeys.year1].stringValue
        self.month1 = yearlyLogBookValues[DictionaryKeys.month1].stringValue
        if let month2 = yearlyLogBookValues[DictionaryKeys.month2].int{
            self.month2 = month2
        }
    }
    
    public class func modelsFromDictionaryDualArray(array: [JSON]) -> [YearlyLogBookModel] {
        var model = [YearlyLogBookModel]()
        for value in array{
            model.append(YearlyLogBookModel(value))
        }
        return model
    }
}
