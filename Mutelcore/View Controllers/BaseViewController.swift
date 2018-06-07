//
//  BaseViewController.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Floaty

class BaseViewController: UIViewController {
    
    //MARK:- Properties
    // =================
    enum SidemenuBtnAction {
        
        case sideMenuBtn, BackBtn
        
    }
    
    enum NavigationControllerOn {
        
        case login, dashboard
        
    }
    
    var sideMenuBtnActn : SidemenuBtnAction = SidemenuBtnAction.sideMenuBtn
    var navigationControllerOn : NavigationControllerOn = NavigationControllerOn.login
    var messageCount : Int = 0
    var notificationCount : Int = 0
    var screenTitle = ""
    var appointmentBtnTapped = true
    var visitTypeVC : VisitTypeViewVC!
    let messageBtn = UIButton()
    let notificationBtn = UIButton()
    let appointmentBtn = UIButton()
    
    
    let floatBtn = Floaty()
    
    let dashboardItem = FloatyItem()
    let appointmentItem = FloatyItem()
    let measurementItem = FloatyItem()
    let nutritionItem = FloatyItem()
    let activityItem = FloatyItem()
    let calenderItem = FloatyItem()
    let ePrescriptionItem = FloatyItem()
    let medicationReminderItem = FloatyItem()
    
    
    var dashboardScene : DashboardVC!
    var appointmentScene : AppointmentListingVC!
    var measurementScene : MyMeasurementVC!
    var nutritionScene : NutritionVC!
    var activityScene : ActivityVC!
    var calenderScene : CalenderVC!
    var eprescriptionScene : ePrescriptionVC!
    var medicationReminderScene : MedicationReminderVC!
    
    
    private var keyboardShowNotification : NSObjectProtocol?
    private var keyboardHideNotification : NSObjectProtocol?
    
    var keyBoardAppearClosure : ((_ keyboardHeight : CGFloat) -> ())?
    var keyBoardDisappearClosure : (() -> ())?
    
    //MARK:- view life cycle
    //   ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if self.sideMenuBtnActn == .sideMenuBtn{
        
        self.addFloatyBtn()
        
        self.floatBtn.animationSpeed = 0.1
        self.floatBtn.autoCloseOnTap = true
        self.floatBtn.buttonImage = #imageLiteral(resourceName: "icAppointmentAddFloating")
        self.floatBtn.buttonColor = UIColor.appColor
        self.floatBtn.itemSpace = 10
        self.floatBtn.openAnimationType = .slideUp
        
        // Do any additional setup after loading the view.
        //        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.floatBtn.shadow()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //Notification Observer to decrease the size and scroll the tableView
        self.keyboardShowNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[unowned self] (notification) in
                                                                                
                                                                                guard let info = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
                                                                                
                                                                                let keyBoardHeight = info.cgRectValue.height
                                                                                
                                                                                UIView.animate(withDuration: 0.33,
                                                                                               delay: 0,
                                                                                               options: .curveEaseInOut,
                                                                                               animations: {
                                                                                                
                                                                                                if let keyBoardAppearClosure = self.keyBoardAppearClosure {
                                                                                                    keyBoardAppearClosure(keyBoardHeight)
                                                                                                }
                                                                                }, completion: nil)
        })
        
        //Notification Observer to increase the size of the tableView
        self.keyboardHideNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[unowned self] (notification) in
                                                                                
                                                                                UIView.animate(withDuration: 0.33,
                                                                                               delay: 0,
                                                                                               options: .curveEaseInOut,
                                                                                               animations: {
                                                                                                
                                                                                                if let keyBoardDisappearClosure = self.keyBoardDisappearClosure {
                                                                                                    keyBoardDisappearClosure()                                                                                                }
                                                                                }, completion: nil)
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let keyboardShowNotification = self.keyboardShowNotification {
            NotificationCenter.default.removeObserver(keyboardShowNotification)
        }
        
        if let keyboardHideNotification = self.keyboardHideNotification {
            NotificationCenter.default.removeObserver(keyboardHideNotification)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}

//MARK:- SetUP NavigationBar
//===========================
extension BaseViewController {
    
    func setNavigationBar(_ title : String, _ messageCount : Int, _ notificationCount : Int){
        
        let img = self.navigationController?.imageLayerForGradientBackground()
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.shadow(0, CGSize(width: 0, height: 1.5), UIColor.navigationBarShadowColor)
        
        let leftBtn = UIButton(frame : CGRect(x: 0, y: 0, width : 30, height : 30))
        leftBtn.addTarget(self, action: #selector(self.leftBtnActn(_:)), for: .touchUpInside)
        
        let sideMenuBtn = UIBarButtonItem(customView: leftBtn)
        
        let screenTitle = UILabel()
        screenTitle.text = title
        screenTitle.textColor = .white
        
        if DeviceType.IS_IPHONE_5 {
            
            screenTitle.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
            screenTitle.font = AppFonts.sanProSemiBold.withSize(15)
            
        }else{
            
            screenTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            screenTitle.font = AppFonts.sanProSemiBold.withSize(16)
        }
        
        let screenTitleText = UIBarButtonItem(customView: screenTitle)
        
        if self.sideMenuBtnActn == .sideMenuBtn{
            
            leftBtn.setImage(#imageLiteral(resourceName: "icAppointmentMenu"), for: .normal)
            
        }else{
            
            leftBtn.setImage(#imageLiteral(resourceName: "icAppointmentBack"), for: .normal)
        }
        
        if self.navigationControllerOn == .dashboard {
            
            self.navigationBarItem(messageCount, notificationCount)
            
        }else{
            
        }
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 5
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -10
        
        self.navigationItem.setLeftBarButtonItems([space, sideMenuBtn, fixedSpace, screenTitleText], animated: false)
    }
    
    //NavigatBar Items
    func navigationBarItem(_ messageCount : Int, _ notificationCount : Int){
        
        self.messageBtn.frame = CGRect(x: 10, y: 0, width : 35, height : 30)
        self.messageBtn.setImage(#imageLiteral(resourceName: "icAppointmentMail"), for: .normal)
        self.messageBtn.addTarget(self, action: #selector(messageBtnClicked(_:)), for: .touchUpInside)
        let messageButton = UIBarButtonItem(customView: self.messageBtn)
        
        self.notificationBtn.frame = CGRect(x: 10, y: 0, width : 35, height : 30)
        
        self.notificationBtn.setImage(#imageLiteral(resourceName: "icAppointmentBell"), for: .normal)
        self.notificationBtn.addTarget(self, action: #selector(notificationBtnClicked(_:)), for: .touchUpInside)
        let notificationButton = UIBarButtonItem(customView: self.notificationBtn)
        
        self.appointmentBtn.frame = CGRect(x: UIDevice.getScreenWidth - 30, y: 0, width : 35, height : 30)
        
        self.appointmentBtn.setImage(#imageLiteral(resourceName: "icAppointmentInfo"), for: .normal)
        self.appointmentBtn.addTarget(self, action: #selector(appointmentBtnClicked(_:)), for: .touchUpInside)
        let appointmentButton = UIBarButtonItem(customView: appointmentBtn)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 5
        
        let nagativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        nagativeSpace.width = -10
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -10
        
        
        self.navigationItem.setRightBarButtonItems([nagativeSpace, appointmentButton, notificationButton,fixedSpace, messageButton, nagativeSpace], animated: false)
        
        messageButton.addBadge(number: messageCount)
        notificationButton.addBadge(number: notificationCount)
        
    }
    
    //    MARK:- Floaty Button Action
    //    ===========================
    fileprivate func addFloatyBtn(){
        
        if DeviceType.IS_IPHONE_5{
            
            for button in [self.dashboardItem, self.appointmentItem, self.appointmentItem, self.nutritionItem, self.activityItem, self.calenderItem, self.ePrescriptionItem, self.medicationReminderItem, self.measurementItem]{
                
                button.size = 40
                button.hasShadow = true
                button.titleLabel.font = AppFonts.sanProSemiBold.withSize(12)
            }
            
        }else{
            
            for button in [self.dashboardItem, self.appointmentItem, self.appointmentItem, self.nutritionItem, self.activityItem, self.calenderItem, self.ePrescriptionItem, self.medicationReminderItem, self.measurementItem]{
                
                button.size = 50
                button.hasShadow = true
                button.titleLabel.font = AppFonts.sanProSemiBold.withSize(16)
            }
            
            self.dashboardItem.imageOffset = CGPoint(x: -4.0, y: 2)
            self.appointmentItem.imageOffset = CGPoint(x: -3.0, y: 2)
            self.measurementItem.imageOffset = CGPoint(x: -3.0, y: -2)
            self.nutritionItem.imageOffset = CGPoint(x: -5.0, y: 0)
            self.activityItem.imageOffset = CGPoint(x: -2.0, y: 2)
            self.calenderItem.imageOffset = CGPoint(x: -4.0, y: 1)
            self.ePrescriptionItem.imageOffset = CGPoint(x: -4.0, y: 1)
            self.medicationReminderItem.imageOffset = CGPoint(x: -4.0, y: 3)
        }
        
        
        self.dashboardItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.462745098, alpha: 1)
        self.appointmentItem.buttonColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.9215686275, alpha: 1)
        self.measurementItem.buttonColor = #colorLiteral(red: 0.1803921569, green: 0.568627451, blue: 0.9294117647, alpha: 1)
        self.nutritionItem.buttonColor = #colorLiteral(red: 0.06274509804, green: 0.7450980392, blue: 0.737254902, alpha: 1)
        self.activityItem.buttonColor = #colorLiteral(red: 0.1019607843, green: 0.4901960784, blue: 0.2588235294, alpha: 1)
        self.calenderItem.buttonColor = #colorLiteral(red: 0.5058823529, green: 0.6980392157, blue: 0.03137254902, alpha: 1)
        self.ePrescriptionItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        self.medicationReminderItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.2862745098, blue: 0.1803921569, alpha: 1)
        
        self.dashboardItem.title = "Dashboard"
        self.appointmentItem.title = "Appointment"
        self.measurementItem.title = "Measurement"
        self.nutritionItem.title = "Nutrition"
        self.activityItem.title = "Activity"
        self.calenderItem.title = "Calender"
        self.ePrescriptionItem.title = "ePrescription"
        self.medicationReminderItem.title = "Medication Reminder"
        
        self.dashboardItem.icon = #imageLiteral(resourceName: "icAddmenuDashboard")
        self.appointmentItem.icon = #imageLiteral(resourceName: "icAddmenuAppointment")
        self.measurementItem.icon = #imageLiteral(resourceName: "icAddmenuMeasurement")
        self.nutritionItem.icon = #imageLiteral(resourceName: "icAddmenuNutrition")
        self.activityItem.icon = #imageLiteral(resourceName: "icAddmenuActivity")
        self.calenderItem.icon = #imageLiteral(resourceName: "icAddmenuCalendar")
        self.ePrescriptionItem.icon = #imageLiteral(resourceName: "icAddmenuEprescription")
        self.medicationReminderItem.icon = #imageLiteral(resourceName: "icAddmenuMedication")
        
        
        self.dashboardItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is DashboardVC { }
            else {
                
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.dashboardScene = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
                        self.navigationController?.pushViewController(self.dashboardScene, animated: true)
                    })
                }
            }
        }
        self.appointmentItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is AppointmentListingVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.appointmentScene = AppointmentListingVC.instantiate(fromAppStoryboard: .AppointMent)
                        self.navigationController?.pushViewController(self.appointmentScene, animated: true)
                    })
                }
            }
        }
        self.measurementItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is MyMeasurementVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    self.measurementScene = MyMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
                    self.navigationController?.pushViewController(self.measurementScene, animated: true)
                    
                }
            }
        }
        
        self.nutritionItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is NutritionVC {}
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.nutritionScene = NutritionVC.instantiate(fromAppStoryboard: .Nutrition)
                        self.navigationController?.pushViewController(self.nutritionScene, animated: true)
                    })
                }
            }
        }
        self.activityItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is ActivityVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.activityScene = ActivityVC.instantiate(fromAppStoryboard: .Activity)
                        self.navigationController?.pushViewController(self.activityScene, animated: true)
                    })
                }
            }
        }
        self.calenderItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is CalenderVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.calenderScene = CalenderVC.instantiate(fromAppStoryboard: .Calender)
                        self.navigationController?.pushViewController(self.calenderScene, animated: true)
                    })
                }
            }
        }
        self.ePrescriptionItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is ePrescriptionVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.eprescriptionScene = ePrescriptionVC.instantiate(fromAppStoryboard: .ePrescription)
                        self.navigationController?.pushViewController(self.eprescriptionScene, animated: true)
                    })
                }
            }
        }
        self.medicationReminderItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is MedicationReminderVC { }
            else {
                if self.floatBtn.closed == true{
                    
                    delay(0.3, closure: {
                        
                        self.medicationReminderScene = MedicationReminderVC.instantiate(fromAppStoryboard: .MedicationReminder)
                        self.navigationController?.pushViewController(self.medicationReminderScene, animated: true)
                    })
                }
            }
        }
        
        self.floatBtn.addItem(item: dashboardItem)
        self.floatBtn.addItem(item: appointmentItem)
        self.floatBtn.addItem(item: measurementItem)
        self.floatBtn.addItem(item: nutritionItem)
        self.floatBtn.addItem(item: activityItem)
        self.floatBtn.addItem(item: calenderItem)
        self.floatBtn.addItem(item: ePrescriptionItem)
        self.floatBtn.addItem(item: medicationReminderItem)
        
        self.view.addSubview(self.floatBtn)
    }
    
    //back button
    @objc fileprivate func leftBtnActn(_ sender : UIBarButtonItem){
        
        self.floatBtn.close()
        
        if self.sideMenuBtnActn == .sideMenuBtn {
            
            sharedAppDelegate.slideMenu.openLeft()
            
        }else{
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    //Message button Clicked
    @objc fileprivate func messageBtnClicked(_ messageBtn : UIBarButtonItem){
        
        self.floatBtn.close()
        
        if self is MessagesVC { }
        else {
            delay(0.3) {
                
                let messageScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
                self.navigationController?.pushViewController(messageScene, animated: true)
                
            }
        }
    }
    // Notification button clicked
    @objc fileprivate func notificationBtnClicked(_ notificationBtn : UIBarButtonItem){
        
        self.floatBtn.close()
        
        if self is NotificationVC { }
        else {
            delay(0.3) {
                
                let notificationScene = NotificationVC.instantiate(fromAppStoryboard: .Notification)
                self.navigationController?.pushViewController(notificationScene, animated: true)
            }
        }
    }
    // Appointment Button Clicked
    func appointmentBtnClicked(_ appointmentButton : UIBarButtonItem){
        
        self.appointmentBtntapped()
    }
    
    func appointmentBtntapped(){
        
        self.floatBtn.close()
        
        let x = CGFloat(10)
        let y = CGFloat(0)
        
        if self.appointmentBtnTapped{
            
            WebServices.upcomingAppointments(success: { (_ upcomingAppointment : [UpcomingAppointmentModel]) in
                
                self.visitTypeVC = VisitTypeViewVC.instantiate(fromAppStoryboard: .Dashboard)
                
                self.visitTypeVC.delegate = self
                
                if !upcomingAppointment.isEmpty{
                    
                    if let appointmentDate = upcomingAppointment[0].appointmentDate{
                        
                        self.visitTypeVC.nextVisitDate = appointmentDate.stringFormDate(DateFormat.ddMMMYYYY.rawValue)!
                        
                    }
                }
                
                self.view.addSubview(self.visitTypeVC.view)
                self.addChildViewController(self.visitTypeVC)
                
                self.visitTypeVC.view.frame = CGRect(x: x, y: y , width: UIDevice.getScreenWidth, height: CGFloat(0))
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.visitTypeVC.view.frame = CGRect(x: x, y: y , width: UIDevice.getScreenWidth - 20, height: UIDevice.getScreenHeight)
                }
                
                self.appointmentBtnTapped = false
                
            }, failure: { (error) in
                
                showToastMessage(error.localizedDescription)
                
            })
            
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.visitTypeVC.view.frame = CGRect(x: x, y: y , width: UIDevice.getScreenWidth - 20, height: CGFloat(0))
                
            }, completion: { (true) in
                
                self.visitTypeVC.view.removeFromSuperview()
                self.visitTypeVC.removeFromParentViewController()
            })
            
            self.appointmentBtnTapped = true
            
        }
    }
}

//MARK:- Remove From VisitType Protocol
//====================================
extension BaseViewController : visitTypeSceneRemoveFromSuperView {
    
    func visitTypeViewRemove(remove: Bool) {
        
        self.appointmentBtnTapped = remove
        
    }
}
