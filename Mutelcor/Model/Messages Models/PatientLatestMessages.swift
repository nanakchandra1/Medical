//
//  PatientLatestMessages.swift
//  Mutelcor
//
//  Created by on 27/07/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class PatientLatestMessages {
    
    var messageId : Int?
    var message : String?
    var messageTime : Double?
    var messageTimeInUtc: String?
    var senderId : Int?
    var receiverID : Int?
    
    init(_ messageData : JSON){
        
        guard let messageID = messageData[DictionaryKeys.messageID].int else{
             return
        }
        self.messageId = messageID
        self.message = messageData[DictionaryKeys.message].stringValue
        if let messageTime = messageData[DictionaryKeys.messageTime].string {
            let dateTimeArray = messageTime.components(separatedBy: "T")
            let dateTime = dateTimeArray[0].getDateFromString(.yyyyMMdd, .utcTime)
            self.messageTime = dateTime?.timeIntervalSince1970//.changeDateFormat(.yyyyMMdd, .ddMMMYYYY)
            self.messageTimeInUtc = messageTime
        }
        if let senderID = messageData[DictionaryKeys.senderId].int{
            self.senderId = senderID
        }
        if let receiverID = messageData[DictionaryKeys.receiverId].int{
            self.receiverID = receiverID
        }
    }
    
    public class func modelsFromDictionaryArray(array: [JSON]) -> [String: [PatientLatestMessages]] {
        var model = [PatientLatestMessages]()
        for value in array{
            model.append(PatientLatestMessages(value))
        }
        
        let convertedDic = model.group{"\($0.messageTime!)"}

        return convertedDic
    }
}
