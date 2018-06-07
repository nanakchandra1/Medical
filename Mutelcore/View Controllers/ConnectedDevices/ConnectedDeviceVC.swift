//
//  ConnectedDeviceVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ConnectedDeviceVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
            self.sideMenuBtnActn = .sideMenuBtn
            self.navigationControllerOn = .dashboard
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Connected Device", 2, 3)

        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
