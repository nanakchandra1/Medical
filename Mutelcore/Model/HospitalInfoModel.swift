//
//  hospitalInfoModel.swift
//  Mutelcore
//
//  Created by Ashish on 29/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HospitalInfo {
    
    var hospitalId : Int?
    var hospitalname : String?
    var hospitalAddress : String?
    var hospitalLandlineNumber : String?
    var hospitalAltnumber : String?
    
    init(hospitalInfoDic : JSON){
        
        self.hospitalId = hospitalInfoDic[AppConstants.hospital_Id].int
        self.hospitalname = hospitalInfoDic[AppConstants.hospital_Name].stringValue
        self.hospitalAddress = hospitalInfoDic[AppConstants.hospital_Address].stringValue
        self.hospitalLandlineNumber = hospitalInfoDic[AppConstants.hosp_LandLineNumber].stringValue
        self.hospitalAltnumber = hospitalInfoDic[AppConstants.hosp_AltLandLineNumber].stringValue
        
    }
}
