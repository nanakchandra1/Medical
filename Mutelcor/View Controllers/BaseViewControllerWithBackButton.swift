//
//  BaseViewControllerWithBackButton.swift
//  Mutelcor
//
//  Created by on 29/09/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class BaseViewControllerWithBackButton: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.shared.slideMenu.leftPanGesture?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.shared.slideMenu.leftPanGesture?.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}
