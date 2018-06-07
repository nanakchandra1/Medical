//
//  CountryCode.swift
//  Tap
//
//  Created by Appinventiv on 28/02/17.
//  Copyright © 2017 AppinventivAppinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountryCode: NSObject{
    
    let countryName: String
    var countryCode: String
    var max_NSN_NO:Int!
    var min_NSN_NO:Int!
    var countryShortName : String
    var nameWithCode: String!
    
//    init(name: String, countryCode: String,max_NSN_NO:Int!,min_NSN_NO:Int!,countryShortName:String) {
//        self.countryName = name
//        self.countryCode = countryCode
//        self.max_NSN_NO = max_NSN_NO
//        self.min_NSN_NO = min_NSN_NO
//        self.countryShortName = countryShortName
//        let count = countryCode.characters.count
//        
//        print_Debug("\(name) count: \(count)")
//        switch count{
//        case 2:
//            self.nameWithCode = "\(countryCode)    \(name)"
//        case 3:
//            self.nameWithCode = "\(countryCode)   \(name)"
//        case 4:
//            self.nameWithCode = "\(countryCode)  \(name)"
//        case 5:
//            self.nameWithCode = "\(countryCode) \(name)"
//        default:
//            self.nameWithCode = "\(countryCode)\(name)"
//        }
//    }
    
    init(withDict dict: [String:AnyObject]){
        
        self.countryName = dict["name"] as? String ?? ""
        self.countryCode = dict["dial_code"] as? String ?? ""
        self.max_NSN_NO = 0
        self.min_NSN_NO = 0
        self.countryShortName = dict["code"] as? String ?? ""
    }
}
