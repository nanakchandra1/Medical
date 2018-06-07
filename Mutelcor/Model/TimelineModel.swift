//
//  TimelineModel.swift
//  Mutelcor
//
//  Created by Nanak on 13/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimelineModel {
    
    var id: Int
    var photo_time: String
    var created_at: String
    var p_id: Int
    var image_url: String
    var is_updated: Int
    var is_after: Int
    var updated_at: String
    var photo_date: String
    var is_deleted: Int
    var image_name: String
    var is_before: Int
    
    var startDate: Date? {
        Date.dateFormatter.dateFormat = DateFormat.utcTime.rawValue
        return Date.dateFormatter.date(from: created_at)
    }
    
    required init?(json: JSON) {
        
        self.id = json["id"].intValue
        self.photo_time = json["photo_time"].stringValue
        self.created_at = json["created_at"].stringValue
        self.p_id = json["p_id"].intValue
        self.image_url = json["image_url"].stringValue
        self.is_updated = json["is_updated"].intValue
        
        self.is_after = json["is_after"].intValue
        self.updated_at = json["updated_at"].stringValue
        self.photo_date = json["photo_date"].stringValue
        self.is_deleted = json["is_deleted"].intValue
        self.image_name = json["image_name"].stringValue
        self.is_before = json["is_before"].intValue

    }
    

}
