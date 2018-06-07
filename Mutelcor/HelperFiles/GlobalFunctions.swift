//
//  GlobalFunctions.swift
//  Mutelcor
//
//  Created by  on 27/03/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit
import GTToast
import SwiftyJSON

//MARk:- Login Type On Login Services
//==================================
enum LoginType : String{
    case email = "0"
    case mobileNumber = "1"
    case otp = "2"
}

//MARK:- DateFormat Enum
//======================
enum DateFormat : String {
    
    case eeee = "EEEE"
    case eee = "EEE"

    case dMMMyyyy = "d MMM yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
    case hmm = "h:mm"
    case hhmmssa = "hh:mm:ss a"
    case DDMMYY = "DDMMYYYY"
    case mmYYYY = "MMM yyyy"
    case DD = "dd"
    case MMM = "MMM"
    case ddMMM = "dd MMM"
    case ddmmyy = "dd/MM/yy"
    case ddMMMYYYY = "dd MMM yyyy"
    case utcTime = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case ddmmyyHHmmss = "dd/MM/yy HH:mm:ss"
    case ddMMMYYYYHHmm = "dd MMM YYYY HH:mm"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case HHmmss = "HH:mm:ss"
    case Hmm = "HH:mm"
    case Hmma = "hh:mm a"
}

//MARK:- tap on icon in TextField
//===============================
public func textFieldTapped(_ sender: UITapGestureRecognizer) {
}

//MARK:- PrintIn Function
//========================
//public func printlnDebug <T> (_ object: T) {
//    #if DEBUG
//        print(object)
//    #endif
//}

//MARK:- Delay Function
//======================
public func delay(_ delay:Double, closure:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
)}

//MARK:- Attributes
//=================
public func addAttributes(_ value  : String, _ attributes : [NSAttributedStringKey : Any]?) -> NSAttributedString{
    let valueAttributes = NSAttributedString(string: value, attributes: attributes)
    return valueAttributes
}

//MARK:- Remove Zero from trailing
//===============================
public func forTailingZero(temp: Double) -> String{
    let tempVar = String(format: "%g", temp)
    return tempVar
}
//MARK:- Toast Messages
//=====================
public func mainQueue(closure:@escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}

public func showToastMessage(_ text: String) {
    
    mainQueue {
        
        let tag = 85673987
        if let toast = AppDelegate.shared.window?.viewWithTag(tag) as? GTToastView {
            toast.removeFromSuperview()
        }else{
        
        let toast = GTToast.create(text, config: CommonFunctions.toastConfigure, image: nil)
        toast.layer.cornerRadius = toast.frame.height / 2
        toast.tag = tag
        toast.show()
        }
    }
}

 public func typeJSONArray(_ arrayDic : [[String : Any]], dicKey: String) -> [String: Any] {
    
    var dic: [String: Any] = [:]
    
    do {
        let typejsonArray = try JSONSerialization.data(withJSONObject: arrayDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return dic }
        dic[dicKey] = typeJSONString as AnyObject?
        
//        var json = try JSONSerialization.jsonObject(with: typejsonArray, options: .mutableContainers) as? JSONDictionary
//
    }catch{
    }
    return dic
}

 func jsonArray(dictionaryArray : JSONDictionaryArray) ->  String{
    
    var  jsonString: String = ""
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionaryArray, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let typeJSONString = String(data: jsonData, encoding: String.Encoding.utf8) else { return "" }
        jsonString = typeJSONString
        
        //        var json = try JSONSerialization.jsonObject(with: typejsonArray, options: .mutableContainers) as? JSONDictionary
        //
    }catch{
    }
    return jsonString
}

public func convertDictionaryIntoJSON(dic:[String: Any]) -> JSON{
    var jsonValue = JSON.null
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        jsonValue = JSON.init(data: jsonData)
    } catch {
    }
    return jsonValue
}

public func matchedString(forRegex regex: String, inText text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch _ {
        return []
    }
}

