//
//  SurgeyModel.swift
//  Mutelcore
//
//  Created by Ashish on 05/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SurgeryModel {
    
    let surgeryId : Int?
    let surgeryName : String?
    
    init(surgeyInfoDic : JSON){
        
        self.surgeryId = surgeyInfoDic["surgery_id"].int
        self.surgeryName = surgeyInfoDic["surgery_name"].stringValue
        
    }
}
