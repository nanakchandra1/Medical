//
//  CustomTextField.swift
//  Mutelcor
//
//  Created by on 14/09/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
