//
//  HelpVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class HelpVC: BaseViewController {
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_HELP_FAQ_TITLE.localized)
    }
    
}
