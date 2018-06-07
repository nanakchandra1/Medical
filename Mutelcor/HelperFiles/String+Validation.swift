//
//  String+Validation.swift
//  Onboarding
//
//  Created by Gurdeep Singh on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func checkValidity(with validityExression : ValidityExression) -> Bool {
        let regEx = validityExression.rawValue
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: self)
    }
    
    func checkInvalidity(with validityExression : ValidityExression) -> Bool {
        return !self.checkValidity(with: validityExression)
    }

    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

enum ValidityExression : String {
    
    case Username = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,}"
    case MobileNumber = "^[0-9]{8,10}$"
    case Password = "^[a-zA-Z]{5}"
    case Name = "[a-z A-Z]{20}$"
    case getNumberAndUnit = "[0-9]*[ ]*[.][ ]*[0-9]*[ ]*[a-zA-Z]*[ ]*[\\S][ ]*[a-zA-Z]*[a-zA-Z]"
    case getMeasurementValue = "[0-9]*[ ]*[.][ ]*[0-9]*"
}



