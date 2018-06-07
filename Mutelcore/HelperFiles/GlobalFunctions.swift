//
//  GlobalFunctions.swift
//  Mutelcore
//
//  Created by Ashish on 27/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import GTToast

//MARk:- Login Type On Login Services
//==================================
enum loginType : String{
    
    case email = "0"
    case mobileNumber = "1"
    case otp = "2"
}

//MARK:- DateFormat Enum
//======================
enum DateFormat : String{
    case dMMMyyyy = "d MMM yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
    case HHmm = "h:mm"
    case hhmmssa = "hh:mm:ss a"
    case DDMMYY = "DDMMYYYY"
    case mmYYYY = "MMM-yyyy"
    case DD = "dd"
    case ddMMM = "dd MMM"
    case ddmmyy = "dd/MM/yy"
    case ddMMMYYYY = "dd MMM YYYY"
    case utcTime = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case HHmmss = "HH:mm:ss"
    case Hmm = "HH:mm"
    
}

//MARK:- tap on icon in TextField
//===============================
public func textFieldTapped(_ sender: UITapGestureRecognizer) {
    printlnDebug(#function)
}

//MARK:- PrintIn Function
//========================
public func printlnDebug <T> (_ object: T) {
    #if DEBUG
    print(object)
    #endif
}

//MARK:- Delay Function
//======================
public func delay(_ delay:Double, closure:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(
        
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        
        execute: closure
)}

//MARK:- Attributes
//=================
public func addAttributes(_ value  : String, _ attributes : [String : Any]?) -> NSAttributedString{
    
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
func mainQueue(closure:@escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}

func showToastMessage(_ text: String) {
    
    mainQueue {
        
        let tag = 85673987
        if let toast = sharedAppDelegate.window?.viewWithTag(tag) as? GTToastView {
            toast.removeFromSuperview()
        }
        
        let toast = GTToast.create(text, config: CommonClass.toastConfigure, image: nil)
        toast.tag = tag
        toast.show()
    }
}
