//
//  SideMenuVC.swift
//  Mutelcor
//
//  Created by  on 02/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    
    //    MARK:- Proporties
    //    ================
    fileprivate let sideMenuRows : [[Any]] = [[#imageLiteral(resourceName: "icSidemenuDeselectHome"), K_DASHBOARD_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectHealthreport"), K_GENERATE_HEALTH_REPORT_TITLE.localized],[#imageLiteral(resourceName: "ic_sidemenu_calendar"),K_CALENDER_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectLogbook"), K_LOG_BOOK_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectDischargesummary"), K_DISCHARGE_SUMMARY_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectMessage"), K_MESSAGE_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectNotifications"), K_NOTIFICATION_TITLE.localized],[#imageLiteral(resourceName: "ic_sidemenu_deselect_medication_reminder_"), K_MEDICATION_REMINDER_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectConnectdevices"), K_CONNECTED_DEVICES_TITLE.localized]]//[[#imageLiteral(resourceName: "icSidemenuDeselectHome"), K_DASHBOARD_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectHealthreport"), K_GENERATE_HEALTH_REPORT_TITLE.localized],[#imageLiteral(resourceName: "ic_sidemenu_calendar"),K_CALENDER_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectLogbook"), K_LOG_BOOK_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectDischargesummary"), K_DISCHARGE_SUMMARY_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectMessage"), K_MESSAGE_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectNotifications"), K_NOTIFICATION_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectConnectdevices"), K_CONNECTED_DEVICES_TITLE.localized],[#imageLiteral(resourceName: "ic_sidemenu_deselect_medication_reminder_"), K_MEDICATION_REMINDER_SCREEN_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectUserguide"), K_USER_GUIDE_TITLE.localized],[#imageLiteral(resourceName: "icSidemenuDeselectHelp"), K_HELP_FAQ_TITLE.localized]]
    
    fileprivate let selectedRows = [#imageLiteral(resourceName: "icSidemenuSelectHome"),#imageLiteral(resourceName: "icSidemenuSelectHealthreport"),#imageLiteral(resourceName: "ic_sidemenu_calendar_selected"),#imageLiteral(resourceName: "icSidemenuSelectLogbook"),#imageLiteral(resourceName: "icSidemenuSelectDischargesummary"),#imageLiteral(resourceName: "icSidemenuSelectMessage"),#imageLiteral(resourceName: "icSidemenuSelectNotifications"),#imageLiteral(resourceName: "icSidemenuSelectConnectdevices"),#imageLiteral(resourceName: "ic_sidemenu_select_medication_reminder_"),#imageLiteral(resourceName: "icSidemenuSelectHelp"),#imageLiteral(resourceName: "icAppointmentWhiteVideo")]
    fileprivate var name = ""
    fileprivate var selectedIndex = 0
    var dashboardData: [DashboardDataModel] = []
    
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
    @IBOutlet weak var userDetailTapView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageContainerViewHeight: NSLayoutConstraint!

    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.outerView.gradient(withX: 0, withY: 0, cornerRadius: false)
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
        
        sideMenuCell.cellTitle.font = AppFonts.sansProRegular.withSize(CGFloat(15))
        sideMenuCell.cellTitle.text = self.sideMenuRows[indexPath.row][1] as? String
        
        let isHidden = (selectedIndex == indexPath.row) ? true : false
        sideMenuCell.viewContainImage.isHidden = !isHidden
        sideMenuCell.sepratorView.isHidden = isHidden
        sideMenuCell.cellTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sideMenuCell.sepratorView.isHidden = isHidden
        
        if isHidden{
            sideMenuCell.cellTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sideMenuCell.cellImage.image = self.selectedRows[selectedIndex]
            sideMenuCell.cellTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
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
        let rowsHeight = (DeviceType.IS_IPHONE_5) ? 45 : 50
        return CGFloat(rowsHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        switch indexPath.row {
        case 0:
            let dashboardScene = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
            AppDelegate.shared.goFromSideMenu(nextViewController: dashboardScene)
        case 1:
            let genrateHealthReportScene = GenrateHealthReportVC.instantiate(fromAppStoryboard: .GenerateHealthReport)
            AppDelegate.shared.goFromSideMenu(nextViewController: genrateHealthReportScene)
        case 2:
            let calendarScene = CalenderVC.instantiate(fromAppStoryboard: .Calender)
            AppDelegate.shared.goFromSideMenu(nextViewController: calendarScene)
        case 3:
            let logBookScene = LogBookVC.instantiate(fromAppStoryboard: .LogBook)
            AppDelegate.shared.goFromSideMenu(nextViewController: logBookScene)
        case 4:
            let dischargeSummaryScene = DischargeSummaryVC.instantiate(fromAppStoryboard: .DischargeSummary)
            AppDelegate.shared.goFromSideMenu(nextViewController: dischargeSummaryScene)
        case 5:
            AppUserDefaults.save(value: 0, forKey: .messageUnreadCount)
            let MessagesScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
            MessagesScene.proceedToScreenThrough = .sideMenu
            AppDelegate.shared.goFromSideMenu(nextViewController: MessagesScene)
        case 6:
            AppUserDefaults.save(value: 0, forKey: .notificationUnreadCount)
            let notificationScene = NotificationsVC.instantiate(fromAppStoryboard: .Notification)
            notificationScene.proceedToScreenThrough = .sideMenu
            AppDelegate.shared.goFromSideMenu(nextViewController: notificationScene)
        case 7:
            let medicationReminderScene = MedicationReminderVC.instantiate(fromAppStoryboard: .MedicationReminder)
            AppDelegate.shared.goFromSideMenu(nextViewController: medicationReminderScene)
        case 8:
            let connectedDeviceScene = ConnectedDeviceVC.instantiate(fromAppStoryboard: .ConnectedDevices)
            AppDelegate.shared.goFromSideMenu(nextViewController: connectedDeviceScene)
//        case 9:
//            let userGuideScene = UserGuideVC.instantiate(fromAppStoryboard: .UserGuide)
//            AppDelegate.shared.goFromSideMenu(nextViewController: userGuideScene)
//        case 10:
//            let helpScene = HelpVC.instantiate(fromAppStoryboard: .Help)
//            AppDelegate.shared.goFromSideMenu(nextViewController: helpScene)
        default:
            return
        }
        self.sideMenuTableView.reloadData()
        AppDelegate.shared.slideMenu.closeLeft()
    }
}

//MARK:- Methods
//==============
extension SideMenuVC {
    
    func setupUI(){

        logoImageView.image = #imageLiteral(resourceName: "splash_Logo").withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .white
        logoImageContainerViewHeight.constant = (DeviceType.IS_IPHONE_5) ? 45 : 50

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
        
        self.sepratorView.shadow(2.0, CGSize(width: 1.2 , height: 1.2), #colorLiteral(red: 0, green: 0.3529411765, blue: 0.2549019608, alpha: 1), opacity: 0.47)
        self.sepratorView.backgroundColor = UIColor.appColor
        
        self.userName.font = AppFonts.sanProSemiBold.withSize(CGFloat(16))
        self.userUniqueID.font = AppFonts.sansProRegular.withSize(13)
        self.userEmailID.font = AppFonts.sanProSemiBold.withSize(13)
        
        self.userName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.userUniqueID.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.userEmailID.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let viewUserProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToViewProfile(_:)))
        self.userDetailTapView.addGestureRecognizer(viewUserProfileTapGesture)
        
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
        self.setUserImage()
    }
    
    func setUserImage(){
        
        let pic = AppUserDefaults.value(forKey: .patientpic).stringValue
        if !pic.isEmpty {
            let percentageEncodingStr = pic.replacingOccurrences(of: " ", with: "%20")
            let imgUrl = URL(string: percentageEncodingStr)
            self.userImage.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
        }else{
            self.userImage.image = #imageLiteral(resourceName: "personal_info_place_holder")
        }
    }
    
    @objc fileprivate func tapToViewProfile(_ sender: UITapGestureRecognizer){
        
        let personalInformationScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
        personalInformationScene.proceedToScreen = .sideMenu
        AppDelegate.shared.goFromSideMenu(nextViewController: personalInformationScene)
        AppDelegate.shared.slideMenu.closeLeft()
    }
    
    @objc fileprivate func settingBtnTapped(_ sender : UIButton){
        
        AppDelegate.shared.slideMenu.closeLeft()
        let settingScene = SettingVC.instantiate(fromAppStoryboard: .Settings)
        AppDelegate.shared.goFromSideMenu(nextViewController: settingScene)
    }
}
