//
//  TaskModel.swift
//  ClearDrive
//
//  Created by  on 19/12/16.
//  Copyright © 2016. All rights reserved.
//

import SwiftyJSON

class Caller {
    
    let uuid: UUID
    let name: String
    let firstname: String
    let identifier: String
    let hasVideo: Bool
    let type: String
    
    var loginId: String {
        return "\(identifier)_\(firstname)"
    }
    
    required init?(json: JSON) {
        
        let uuidString = json["UUID"].stringValue
        let identifier = json["id"].stringValue
        let type = json["type"].stringValue
        
        guard let uuid = UUID(uuidString: uuidString), !identifier.isEmpty, type == "calling" else {
            return nil
        }
        
        self.uuid           = uuid
        name                = json["handle"].stringValue
        self.identifier     = identifier
        hasVideo            = json["hasVideo"].boolValue
        self.type           = type
        firstname           = json["doc_first_name"].stringValue.replacingOccurrences(of: " ", with: "")
    }
    
    init(uuid: UUID, name: String, firstname: String, identifier: String, hasVideo: Bool, type: String) {
        self.uuid           = uuid
        self.name           = name
        self.identifier     = identifier
        self.hasVideo       = hasVideo
        self.type           = type
        self.firstname      = firstname
    }
    
    class func models(from jsonArray: [JSON]) -> [Caller] {
        var models: [Caller] = []
        for json in jsonArray {
            if let caller = Caller(json: json) {
                models.append(caller)
            }
        }
        return models
    }
    
    var dictionaryObject: JSONDictionary {
        var dictionary                  = JSONDictionary()
        dictionary["id"]                = identifier
        dictionary["name"]              = name
        dictionary["UUID"]              = uuid.uuidString
        dictionary["doc_first_name"]    = firstname
        dictionary["type"]              = type
        dictionary["hasVideo"]          = hasVideo
        return dictionary
    }
}

