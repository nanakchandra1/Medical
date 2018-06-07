//
//  SideMenuVC.swift
//  Mutelcore
//
//  Created by Ashish on 02/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SideMenuController

class SideMenuVC: UIViewController {

//    MARK:- Proporties
//    ================
    
    let sideMenuRows : [[Any]] = [[#imageLiteral(resourceName: "icSidemenuDeselectHome"), "Dashboard"],[#imageLiteral(resourceName: "icSidemenuDeselectHealthreport"), "Genrate Health Report"],[#imageLiteral(resourceName: "icSidemenuDeselectLogbook"), "Log Book"],[#imageLiteral(resourceName: "icSidemenuDeselectDischargesummary"), "Discharge Summary"],[#imageLiteral(resourceName: "icSidemenuDeselectMessage"), "Message"],[#imageLiteral(resourceName: "icSidemenuDeselectNotifications"), "Notifications"],[#imageLiteral(resourceName: "icSidemenuDeselectConnectdevices"), "Connected Devices"],[#imageLiteral(resourceName: "icSidemenuDeselectUserguide"), "User Guide"],[#imageLiteral(resourceName: "icSidemenuDeselectHelp"), "Help/FAQ"]]
    
    let selectedRows = [#imageLiteral(resourceName: "icSidemenuSelectHome"),#imageLiteral(resourceName: "icSidemenuSelectHealthreport"),#imageLiteral(resourceName: "icSidemenuSelectLogbook"),#imageLiteral(resourceName: "icSidemenuSelectDischargesummary"),#imageLiteral(resourceName: "icSidemenuSelectMessage"),#imageLiteral(resourceName: "icSidemenuSelectNotifications"),#imageLiteral(resourceName: "icSidemenuSelectConnectdevices"),#imageLiteral(resourceName: "icSidemenuSelectUserguide"),#imageLiteral(resourceName: "icSidemenuSelectHelp"),#imageLiteral(resourceName: "icAppointmentWhiteVideo")]
    
    var name = ""
    var selectedIndex = 0
//    let gradientView = UIView()

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var userDetailView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userUniqueID: UILabel!
    @IBOutlet weak var userEmailID: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var settingBtnOutlet: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.userDetailView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.settingBtnOutlet.gradient(withX: 0, withY: 0, cornerRadius: true, self.settingBtnOutlet.frame.width / 2)
  
    }
}

//MARK;- UITableViewDataSource Methods
extension SideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sideMenuCell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellID", for: indexPath) as? SideMenuCell else{
            
            fatalError("sideMenuCell Not Found!")
        }
        
        if DeviceType.IS_IPHONE_5 {
            
            sideMenuCell.cellTitle.font = AppFonts.sansProRegular.withSize(13)
        }else{
            
          sideMenuCell.cellTitle.font = AppFonts.sansProRegular.withSize(15)
        }
        
        sideMenuCell.cellTitle.text = self.sideMenuRows[indexPath.row][1] as? String
        
        if selectedIndex == indexPath.row{
            
            sideMenuCell.viewContainImage.isHidden = false
            sideMenuCell.sepratorView.isHidden = true
            sideMenuCell.cellTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sideMenuCell.sepratorView.isHidden = true
            sideMenuCell.cellImage.image = self.selectedRows[selectedIndex]
            sideMenuCell.cellTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }else{
           
            sideMenuCell.sepratorView.isHidden = false
            sideMenuCell.viewContainImage.isHidden = true
            sideMenuCell.cellImage.image = self.sideMenuRows[indexPath.row][0] as? UIImage
            sideMenuCell.cellTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

        return sideMenuCell
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension SideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DeviceType.IS_IPHONE_5 {
            
           return 45
        }else{
            
          return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        
        switch indexPath.row{
            
        case 0: let dashboardScene = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
                sharedAppDelegate.goFromSideMenu(nextViewController: dashboardScene)
            
        case 1: let genrateHealthReportScene = GenrateHealthReportVC.instantiate(fromAppStoryboard: .GenerateHealthReport)
        sharedAppDelegate.goFromSideMenu(nextViewController: genrateHealthReportScene)
            
        case 2: let logBookScene = LogBookVC.instantiate(fromAppStoryboard: .LogBook)
            sharedAppDelegate.goFromSideMenu(nextViewController: logBookScene)
            
        case 3: let dischargeSummaryScene = DischargeSummaryVC.instantiate(fromAppStoryboard: .DischargeSummary)
        sharedAppDelegate.goFromSideMenu(nextViewController: dischargeSummaryScene)

        case 4: let MessagesScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
               MessagesScene.proceedToScreenThrough = .SideMenu
        sharedAppDelegate.goFromSideMenu(nextViewController: MessagesScene)
            
        case 5: let notificationScene = NotificationVC.instantiate(fromAppStoryboard: .Notification)
        notificationScene.proceedToScreenThrough = .SideMenu
        sharedAppDelegate.goFromSideMenu(nextViewController: notificationScene)
            
        case 6: let connectedDeviceScene = ConnectedDeviceVC.instantiate(fromAppStoryboard: .ConnectedDevices)
        sharedAppDelegate.goFromSideMenu(nextViewController: connectedDeviceScene)
            
        case 7: let userGuideScene = UserGuideVC.instantiate(fromAppStoryboard: .UserGuide)
        sharedAppDelegate.goFromSideMenu(nextViewController: userGuideScene)
            
        case 8: let helpScene = HelpVC.instantiate(fromAppStoryboard: .Help)
        sharedAppDelegate.goFromSideMenu(nextViewController: helpScene)
   
        default: fatalError("Cell Not Found!")
            
        }
        self.sideMenuTableView.reloadData()
        sharedAppDelegate.slideMenu.closeLeft()
    }
}

//MARK:- Methods
//==============
extension SideMenuVC {
   
    func setupUI(){
        
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.delegate = self
        
        self.settingBtnOutlet.roundCorner(radius: self.settingBtnOutlet.frame.width / 2, borderColor: UIColor.white, borderWidth: 1.0)

        self.settingBtnOutlet.addTarget(self, action: #selector(self.settingBtnTapped(_:)), for: .touchUpInside)
        
        //Register Nib
        let sideMenuNib = UINib(nibName: "SideMenuCell", bundle: nil)
        self.sideMenuTableView.register(sideMenuNib, forCellReuseIdentifier: "sideMenuCellID")
    
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderWidth = 1.0
        self.userImage.layer.borderColor = UIColor.appColor.cgColor
        
        self.sepratorView.addShadowToFloatingBtn(2.0)
        
        self.userName.font = AppFonts.sanProSemiBold.withSize(16)
        self.userName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.userUniqueID.font = AppFonts.sansProRegular.withSize(13)
        self.userUniqueID.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.userEmailID.font = AppFonts.sanProSemiBold.withSize(13)
        self.userEmailID.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
         let pic = AppUserDefaults.value(forKey: .patientpic).stringValue
            
            if !pic.isEmpty {
                
                let percentageEncodingStr = pic.replacingOccurrences(of: " ", with: "%20")
                let imgUrl = URL(string: percentageEncodingStr)
                
                self.userImage.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
            
            }

        let title = AppUserDefaults.value(forKey: .patientTile).stringValue
        
        if !title.isEmpty{
            
            self.name.append("\(title) ")
        }
        let firstName = AppUserDefaults.value(forKey: .firstname).stringValue
        
        if !firstName.isEmpty{
            
            self.name.append(" \(firstName) ")
        }
        
        let middleName = AppUserDefaults.value(forKey: .middleName).stringValue
            
            if !middleName.isEmpty {
                
               self.name.append(" \(middleName) ")
            }
        
        let lastName = AppUserDefaults.value(forKey: .lastName).stringValue
        
        if !lastName.isEmpty{
            
            self.name.append(" \(lastName)")
        }
        
        self.userName.text = self.name

        let uhid = AppUserDefaults.value(forKey: .uhId).stringValue
        
        if !uhid.isEmpty{
           
            self.userUniqueID.text = "UHID : \(uhid)"
            
        }
        
        let email = AppUserDefaults.value(forKey: .email).stringValue
        
        if !email.isEmpty{
            
            self.userEmailID.text = email
            
        }
    }
    
    @objc fileprivate func settingBtnTapped(_ sender : UIButton){
        
        sharedAppDelegate.slideMenu.closeLeft()
        
        let settingScene = SettingVC.instantiate(fromAppStoryboard: .Settings)
        sharedAppDelegate.goFromSideMenu(nextViewController: settingScene)
        
    }
}
