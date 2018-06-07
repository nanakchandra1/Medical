//
//  SpecialityModel.swift
//  Mutelcore
//
//  Created by Ashish on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SpecialityModel {
    
    let specialityId : Int
    let specialityName : String
    let specialityCreated : String
    
    init(specialityInfoDic : JSON){
        
        self.specialityId = specialityInfoDic["id"].intValue
        self.specialityName = specialityInfoDic["speciality_name"].stringValue
        self.specialityCreated = specialityInfoDic["created_at"].stringValue
        
    }
}
