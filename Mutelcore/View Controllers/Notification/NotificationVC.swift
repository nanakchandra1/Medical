//
//  NotificationVCViewController.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

//    MARK:- Proporties
    enum ProceeedToScreenThrough {
        
        case SideMenu , navigationBar
        
    }
    
    var proceedToScreenThrough : ProceeedToScreenThrough = ProceeedToScreenThrough.SideMenu
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var topBarBackView: UIView!
    @IBOutlet weak var notificationTableView: UITableView!
    
//    MARK:- ViewCOntroller Life Cycle
//    =================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.proceedToScreenThrough == .navigationBar {
            
            self.sideMenuBtnActn = .BackBtn
            
        }else{
            
            self.sideMenuBtnActn = .sideMenuBtn
        }

        self.navigationControllerOn = .dashboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.setNavigationBar("Notifications", 2, 3)
    }
}

//Mark:- UITableViewDataSource Methods
//====================================
extension NotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCellID", for: indexPath) as? NotificationCell else{
            
            fatalError("Cell Not Found!")
        }
        
        return cell
    }
    
}

//MARK:- UITableViewDelegate Methods
//==================================
extension NotificationVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notificationDetailScene = MyNotificationVC.instantiate(fromAppStoryboard: .Notification)
        self.navigationController?.pushViewController(notificationDetailScene, animated: true)
        
    }
}

//MARK:- Methods
//===============
extension NotificationVC {
    
    fileprivate func setupUI(){
        
        self.topBarBackView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.notificationTableView.dataSource = self
        self.notificationTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let notificationCellNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.notificationTableView.register(notificationCellNib, forCellReuseIdentifier: "notificationCellID")
    }
}
