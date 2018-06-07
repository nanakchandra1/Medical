//
//  HomeVCViewController.swift
//  Mutelcore
//
//  Created by Ashish on 06/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DashboardVC: BaseViewController {

//    MARK:- Proporties
//    =================
    
    
//    MARK:- IBOutlets
//    ================
    
//    MARK:- ViewController LifeCycle
//    ==============================
    override func viewDidLoad() {
        super.viewDidLoad()

//        if self.sideMenuBtnActn == .sideMenuBtn{
        
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    self.navigationControllerOn = .dashboard
    self.sideMenuBtnActn = .sideMenuBtn
    self.setNavigationBar("Dashboard", 2, 3)

    
    }
}
