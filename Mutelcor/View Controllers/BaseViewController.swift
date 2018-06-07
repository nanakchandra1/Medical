//
//  BaseViewController.swift
//  Mutelcor
//
//  Created by on 04/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Floaty
import SwiftyJSON

//MARK:- SideMenu Button Action Type
//==================================
enum SidemenuBtnAction {
    case sideMenuBtn
    case backBtn
}

enum AddBtnDisplayedFor {
    case activity
    case nutrition
    case appointment
    case messageDetail
    case Timeline
    case none
}

enum OpenCameraFor {
    case attachReport
    case addImage
    case other
}

class BaseViewController: UIViewController, ImagePickerDelegate, CropperDelegate {
    
    enum NavigationControllerOn {
        case login
        case dashboard
    }
    
    //MARK:- Properties
    // =================
    var sideMenuBtnActn: SidemenuBtnAction = .sideMenuBtn
    var navigationControllerOn: NavigationControllerOn = .login
    var addBtnDisplayedFor: AddBtnDisplayedFor = .none
    var messageCount: Int = 0
    var notificationCount : Int = 0
    var screenTitle = ""
    var appointmentBtnTapped = true
    var isSideMenuBtnHidden =  false
    let messageBtn = UIButton()
    let notificationBtn = UIButton()
    let appointmentBtn = UIButton()
    let addBtn = UIButton()
    var messageBarButton: UIBarButtonItem?
    var notificationBarButton: UIBarButtonItem?
    var isNavigationBarButton : Bool = true
    
    fileprivate var customCameraView: CustomCameraView!
    fileprivate var openCustomCamera: OpenCameraFor = .other
    fileprivate var capturedImages: [UIImage] = []
    
    let floatBtn = Floaty()
    
    let dashboardItem = FloatyItem()
    let appointmentItem = FloatyItem()
    let measurementItem = FloatyItem()
    let nutritionItem = FloatyItem()
    let activityItem = FloatyItem()
    let ePrescriptionItem = FloatyItem()
    let addSymptomItem = FloatyItem()
    let attachReportItem = FloatyItem()
    let addImage = FloatyItem()
    
    var visitTypeVC : VisitTypeViewVC!
    var dashboardScene: DashboardVC!
    var appointmentScene: AppointmentListingVC!
    var measurementScene: MyMeasurementVC!
    var nutritionScene: NutritionVC!
    var activityScene: ActivityVC!
    var calenderScene: CalenderVC!
    var eprescriptionScene: ePrescriptionVC!
    var addSymptomScene: AddSymptomsVC!

    
    private var keyboardShowNotification: NSObjectProtocol?
    private var keyboardHideNotification: NSObjectProtocol?
    
    var keyBoardAppearClosure: ((_ keyboardHeight : CGFloat) -> ())?
    var keyBoardDisappearClosure: (() -> ())?
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if self.isNavigationBarButton{
            self.addFloatyBtn()
        }
        self.floatBtn.animationSpeed = 0.1
        self.floatBtn.autoCloseOnTap = true
        self.floatBtn.buttonImage = #imageLiteral(resourceName: "icAppointmentAddFloating")
        self.floatBtn.buttonColor = UIColor.appColor
        self.floatBtn.overlayColor = UIColor.black.withAlphaComponent(0.7)
        self.floatBtn.itemSpace = 10
        self.floatBtn.openAnimationType = .slideUp
        self.floatBtn.sticky = true
        self.floatBtn.paddingY = 20
        self.customCameraView = CustomCameraView.instanciateFromNib()
        if let view = self.customCameraView{
            view.capturedImages = []
        }
        self.customCameraView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight))
        self.customCameraView.frame = frame
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    // Image Selection While open camera for timeline(Add Image Button) and Scan Report
    func getSelectedImage(capturedImage image: UIImage){
        
        guard let nvc = self.navigationController else{
            return
        }
        
        if self.openCustomCamera == .addImage {
            Cropper.shared.openCropper(withImage: image, mode: .square, on: self)
            nvc.dismiss(animated: true, completion: nil)
        }else if self.openCustomCamera == .attachReport{
            if let view = self.customCameraView {
                if self.capturedImages.count < 5 {
                self.capturedImages.append(image)
                view.capturedImages = self.capturedImages
                view.imageDisplay(capturedImages: self.capturedImages)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(){
        
        guard let nvc = self.navigationController else{
            return
        }
        nvc.dismiss(animated: true, completion: nil)
    }
    
    func imageCropperDidCancelCrop() {
        //printlnDebug("Crop cancelled")
    }
    
    func imageCropper(didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {

        guard let nvc = self.navigationController else{
            return
        }
        
        let addTimelineScene = AddTimelineVC.instantiate(fromAppStoryboard: .Timeline)
        addTimelineScene.timeLineImage = croppedImage
        nvc.pushViewController(addTimelineScene, animated: true)
    }
}

//MARK:- SetUP NavigationBar
//===========================
extension BaseViewController {
    
    func setNavigationBar(screenTitle : String){
        
        let img = self.navigationController?.imageLayerForGradientBackground()
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.shadow(10.0, .zero, UIColor.appColor, opacity: 0.6)
        
        let leftBtn = UIButton(frame : CGRect(x: 0, y: 0, width : 30, height : 30))
        leftBtn.addTarget(self, action: #selector(self.leftBtnTapped(_:)), for: .touchUpInside)
        let sideMenuBtn = UIBarButtonItem(customView: leftBtn)
        
        let title = UILabel()
        title.text = screenTitle
        title.textColor = .white
        
        let screenTitlewidth = UIDevice.getScreenWidth - 200//DeviceType.IS_IPHONE_5 ? 130 : 120
        title.frame = CGRect(x: 40, y: 0, width: screenTitlewidth, height: 30)
        title.layer.masksToBounds = true
        
        title.clipsToBounds = true
        title.font = AppFonts.sanProSemiBold.withSize(CGFloat(18))
        let screenTitleText = UIBarButtonItem(customView: title)
        
        let image = (self.sideMenuBtnActn == .sideMenuBtn) ? #imageLiteral(resourceName: "icAppointmentMenu") : #imageLiteral(resourceName: "icAppointmentBack")
        leftBtn.setImage(image, for: .normal)
        
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 5
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -10
        
        var buttonItem: [UIBarButtonItem] = []
        
        if self.isSideMenuBtnHidden {
            buttonItem = [space,fixedSpace, screenTitleText]
        }else{
            buttonItem = [space, sideMenuBtn, fixedSpace, screenTitleText]
        }
        
        self.navigationItem.setLeftBarButtonItems(buttonItem, animated: false)
        if self.navigationControllerOn == .dashboard {
            
            if self.addBtnDisplayedFor == .Timeline{
                self.navigationBarAddBtn()
                
            }else{
                
                if self.isNavigationBarButton {
                    self.navigationBarItem()
                }else{
                    self.navigationItem.setRightBarButtonItems(nil, animated: true)
                }
            }
        }
    }
    
    
    //NavigatBar Items
    func navigationBarAddBtn(){
        
        
        let width = (self.addBtnDisplayedFor != .none) ? 35 : 0
        
        self.addBtn.frame = CGRect(x: Int(UIDevice.getScreenWidth - 30), y: 0, width : width, height : 30)
        self.addBtn.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
        self.addBtn.addTarget(self, action: #selector(addBtnClicked(_:)), for: .touchUpInside)
        let addButton = UIBarButtonItem(customView: addBtn)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 5
        let nagativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        nagativeSpace.width = -10
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -10
        
        self.navigationItem.setRightBarButtonItems([nagativeSpace, addButton], animated: false)
        self.addBadges()
    }
    
    func navigationBarItem(){
        
        self.messageBtn.frame = CGRect(x: 10, y: 0, width : 35, height : 30)
        self.messageBtn.setImage(#imageLiteral(resourceName: "icAppointmentMail"), for: .normal)
        self.messageBtn.addTarget(self, action: #selector(messageBtnClicked(_:)), for: .touchUpInside)
        self.messageBarButton = UIBarButtonItem(customView: self.messageBtn)
        
        self.notificationBtn.frame = CGRect(x: 10, y: 0, width : 35, height : 30)
        self.notificationBtn.setImage(#imageLiteral(resourceName: "icAppointmentBell"), for: .normal)
        self.notificationBtn.addTarget(self, action: #selector(notificationBtnClicked(_:)), for: .touchUpInside)
        self.notificationBarButton = UIBarButtonItem(customView: self.notificationBtn)
        
        self.appointmentBtn.frame = CGRect(x: UIDevice.getScreenWidth - 30, y: 0, width : 35, height : 30)
        self.appointmentBtn.setImage(#imageLiteral(resourceName: "icAppointmentInfo"), for: .normal)
        self.appointmentBtn.addTarget(self, action: #selector(appointmentBtnClicked(_:)), for: .touchUpInside)
        let appointmentButton = UIBarButtonItem(customView: appointmentBtn)
        
        let width = (self.addBtnDisplayedFor != .none) ? 35 : 0
        
        self.addBtn.frame = CGRect(x: Int(UIDevice.getScreenWidth - 30), y: 0, width : width, height : 30)
        self.addBtn.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
        self.addBtn.addTarget(self, action: #selector(addBtnClicked(_:)), for: .touchUpInside)
        let addButton = UIBarButtonItem(customView: addBtn)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 5
        let nagativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        nagativeSpace.width = -10
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -10
        
        if self.addBtnDisplayedFor == .none {
                self.navigationItem.setRightBarButtonItems([nagativeSpace, self.notificationBarButton!, fixedSpace, self.messageBarButton!, appointmentButton, nagativeSpace], animated: false)
        }else{
            self.navigationItem.setRightBarButtonItems([nagativeSpace, addButton, self.notificationBarButton!, fixedSpace, self.messageBarButton!, appointmentButton, nagativeSpace], animated: false)
        }
        self.addBadges()
    }
    
    func addBadges(){
        let messageUnreadCount = AppUserDefaults.value(forKey: .messageUnreadCount).intValue
        let notificationUnreadCount = AppUserDefaults.value(forKey: .notificationUnreadCount).intValue
        if let messageBtn = self.messageBarButton {
            messageBtn.addBadge(number: messageUnreadCount)
        }
        if let notificationBtn = self.notificationBarButton {
            notificationBtn.addBadge(number: notificationUnreadCount)
        }
    }
    
    //    MARK:- Floaty Button Action
    //    ===========================
    fileprivate func addFloatyBtn(){
        
        for button in [self.dashboardItem, self.appointmentItem, self.appointmentItem, self.nutritionItem, self.activityItem, self.ePrescriptionItem, self.measurementItem, self.addSymptomItem, self.attachReportItem, self.addImage]{
            button.hasShadow = true
            
            let buttonSize = DeviceType.IS_IPHONE_5 ? 40 : 50
            button.size = CGFloat(buttonSize)
            button.titleLabel.font = AppFonts.sanProSemiBold.withSize(16)
            
            if DeviceType.IS_IPHONE_5{
                let imageOffset = (button === self.measurementItem) ? 0 : 2
                button.imageOffset = CGPoint(x: 1, y: imageOffset)
            }else{
                let imageOffset = (button === self.measurementItem) ? 1 : 1
                button.imageOffset = CGPoint(x: -2, y: imageOffset)
            }
        }
        
        
        self.dashboardItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.1803921569, blue: 0.462745098, alpha: 1)
        self.appointmentItem.buttonColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.9215686275, alpha: 1)
        self.measurementItem.buttonColor = #colorLiteral(red: 0.1803921569, green: 0.568627451, blue: 0.9294117647, alpha: 1)
        self.nutritionItem.buttonColor = #colorLiteral(red: 0.06274509804, green: 0.7450980392, blue: 0.737254902, alpha: 1)
        self.activityItem.buttonColor = #colorLiteral(red: 0.1019607843, green: 0.4901960784, blue: 0.2588235294, alpha: 1)
        self.ePrescriptionItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        self.addSymptomItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.2862745098, blue: 0.1803921569, alpha: 1)
        self.attachReportItem.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.2862745098, blue: 0.1803921569, alpha: 1)
        self.addImage.buttonColor = #colorLiteral(red: 0.9294117647, green: 0.2862745098, blue: 0.1803921569, alpha: 1)
        
        self.dashboardItem.title = K_DASHBOARD_SCREEN_TITLE.localized
        self.appointmentItem.title = K_APPOINTMENT_SCREEN_TITLE.localized
        self.measurementItem.title = K_MEASUREMENT_SCREEN_TITLE.localized
        self.nutritionItem.title = K_NUTRITION_SCREEN_TITLE.localized
        self.activityItem.title = K_ACTIVITY_SCREEN_TITLE.localized
        self.ePrescriptionItem.title = K_EPRESCRIPTION_SCREEN_TITLE.localized
        self.addSymptomItem.title = K_SYMPTOMS.localized
        self.attachReportItem.title = K_ATTACH_REPORT.localized
        self.addImage.title = K_ADD_IMAGE.localized
        
        self.dashboardItem.icon = #imageLiteral(resourceName: "icAddmenuDashboard")
        self.appointmentItem.icon = #imageLiteral(resourceName: "icAddmenuAppointment")
        self.measurementItem.icon = #imageLiteral(resourceName: "icAddmenuMeasurement")
        self.nutritionItem.icon = #imageLiteral(resourceName: "icAddmenuNutrition")
        self.activityItem.icon = #imageLiteral(resourceName: "icAddmenuActivity")
        self.ePrescriptionItem.icon = #imageLiteral(resourceName: "icAddmenuEprescription")
        self.addSymptomItem.icon = #imageLiteral(resourceName: "icAddmenuSymptom")
        self.attachReportItem.icon = #imageLiteral(resourceName: "ic_add_menu_scan_report_")
         self.addImage.icon = #imageLiteral(resourceName: "ic_add_menu_scan_report_")
        
        self.dashboardItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is DashboardVC { }
            else {
                if self.floatBtn.closed{
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
                if self.floatBtn.closed{
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
                if self.floatBtn.closed{
                    self.measurementScene = MyMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
                    self.navigationController?.pushViewController(self.measurementScene, animated: true)
                    
                }
            }
        }
        
        self.nutritionItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is NutritionVC {}
            else {
                if self.floatBtn.closed{
                    delay(0.3, closure: {
                        self.nutritionScene = NutritionVC.instantiate(fromAppStoryboard: .Nutrition)
                        self.nutritionScene.proceedToScreenThrough = .sideMenu
                        self.navigationController?.pushViewController(self.nutritionScene, animated: true)
                    })
                }
            }
        }
        self.activityItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is ActivityVC { }
            else {
                if self.floatBtn.closed{
                    delay(0.3, closure: {
                        self.activityScene = ActivityVC.instantiate(fromAppStoryboard: .Activity)
                        self.activityScene.proceedToScreenThrough = .sideMenu
                        self.navigationController?.pushViewController(self.activityScene, animated: true)
                    })
                }
            }
        }
        self.ePrescriptionItem.handler = { item in
            
            self.floatBtn.close()
            
            if self is ePrescriptionVC { }
            else {
                if self.floatBtn.closed{
                    delay(0.3, closure: {  
                        self.eprescriptionScene = ePrescriptionVC.instantiate(fromAppStoryboard: .ePrescription)
                        self.navigationController?.pushViewController(self.eprescriptionScene, animated: true)
                    })
                }
            }
        }

        self.addSymptomItem.handler = { item in

            self.floatBtn.close()
            if self is AddSymptomsVC { }
            else {
                if self.floatBtn.closed{
                    delay(0.3, closure: {
                        self.addSymptomScene = AddSymptomsVC.instantiate(fromAppStoryboard: .Symptoms)
                        self.navigationController?.pushViewController(self.addSymptomScene, animated: true)
                    })
                }
            }
        }
        
        self.attachReportItem.handler = { item in

            self.floatBtn.close()
            guard let nvc = self.navigationController else{
                return
            }
            guard let viewController = nvc.topViewController as? BaseViewController else{
                return
            }
            self.openCustomCamera = .attachReport
            ImagePicker.shared.imagePickerDelegate = self
            ImagePicker.shared.checkAndOpenCamera(on: viewController, viewForCustomCamera: self.customCameraView)
        }
        
        self.addImage.handler = { item in
            self.floatBtn.close()

            guard let nvc = self.navigationController else{
                return
            }
            guard let viewController = nvc.topViewController as? BaseViewController else{
                return
            }
            self.openCustomCamera = .addImage
            ImagePicker.shared.imagePickerDelegate = self
            ImagePicker.shared.captureImage(on: viewController, photoGallery: true, camera: true, viewForCustomCamera: self.customCameraView)
        }
        
        self.floatBtn.addItem(item: dashboardItem)
        self.floatBtn.addItem(item: appointmentItem)
        self.floatBtn.addItem(item: measurementItem)
        self.floatBtn.addItem(item: nutritionItem)
        self.floatBtn.addItem(item: activityItem)
        self.floatBtn.addItem(item: ePrescriptionItem)
        self.floatBtn.addItem(item: addSymptomItem)
        self.floatBtn.addItem(item: attachReportItem)
        self.floatBtn.addItem(item: addImage)
        self.view.addSubview(self.floatBtn)
    }
    
    //back button
    @objc func leftBtnTapped(_ sender : UIBarButtonItem){
        
        self.floatBtn.close()
        
        if self.sideMenuBtnActn == .sideMenuBtn {
            AppDelegate.shared.slideMenu.openLeft()
        }else{
            guard let nvc = self.navigationController else{
                return
            }
            nvc.popViewController(animated: true)
        }
    }
    //Message button Clicked
    @objc fileprivate func messageBtnClicked(_ messageBtn : UIBarButtonItem){
        self.floatBtn.close()
        if self is MessagesVC { }
        else {
            delay(0.3) {
                guard let nvc = self.navigationController else{
                    return
                }
                let messageScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
                messageScene.proceedToScreenThrough = .navigationBar
                nvc.pushViewController(messageScene, animated: true)
            }
        }
    }
    
    // Notification button clicked
    @objc fileprivate func notificationBtnClicked(_ notificationBtn : UIBarButtonItem){
        self.floatBtn.close()
        if self is NotificationsVC { }
        else {
            delay(0.3) {
                guard let nvc = self.navigationController else{
                    return
                }
                let notificationScene = NotificationsVC.instantiate(fromAppStoryboard: .Notification)
                notificationScene.proceedToScreenThrough = .navigationBar
                nvc.pushViewController(notificationScene, animated: true)
            }
        }
    }
    
    @objc fileprivate func addBtnClicked(_ notificationBtn : UIBarButtonItem){
        
        guard let nvc = self.navigationController else{
            return
        }
        
        if self.addBtnDisplayedFor == .activity {
            let addActivityScene = AddActivityVC.instantiate(fromAppStoryboard: .Activity)
            nvc.pushViewController(addActivityScene, animated: true)
        }else if self.addBtnDisplayedFor == .nutrition {
            let addNutritionScene = AddNutritionVC.instantiate(fromAppStoryboard: .Nutrition)
            nvc.pushViewController(addNutritionScene, animated: true)
        }else if self.addBtnDisplayedFor == .appointment {
            let addAppointmentScene = AddAppointmentVC.instantiate(fromAppStoryboard: .AppointMent)
        
            guard let appointmentListingScene = nvc.viewControllers.last as? AppointmentListingVC else{
                return
            }
            addAppointmentScene.delegate = appointmentListingScene
            addAppointmentScene.proceedToScreen = .addAppointment
            nvc.pushViewController(addAppointmentScene, animated: true)
        }else if self.addBtnDisplayedFor == .Timeline {
            guard let nvc = self.navigationController else{
                return
            }
            guard let viewController = nvc.topViewController as? BaseViewController else{
                return
            }
            self.openCustomCamera = .addImage
            ImagePicker.shared.imagePickerDelegate = self
            ImagePicker.shared.captureImage(on: viewController, photoGallery: true, camera: true, viewForCustomCamera: self.customCameraView)
        }
    }
    
    // Appointment Button Clicked
    @objc func appointmentBtnClicked(_ appointmentButton : UIBarButtonItem){
        self.appointmentButtonTapped(0)
    }
    
    @objc func appointmentButtonTapped(_ y : CGFloat){
        
        self.floatBtn.close()
        let x = CGFloat(10)
        if self.appointmentBtnTapped{
            self.visitTypeVC = VisitTypeViewVC.instantiate(fromAppStoryboard: .Dashboard)
            self.visitTypeVC.appointmentViewDisplayFor = self.addBtnDisplayedFor
            self.visitTypeVC.delegate = self
            self.view.addSubview(self.visitTypeVC.view)
            self.addChildViewController(self.visitTypeVC)
            self.visitTypeVC.view.frame = CGRect(x: x, y: 0 , width: UIDevice.getScreenWidth, height: CGFloat(0))
            self.visitTypeVC.view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.visitTypeVC.view.frame = CGRect(x: x, y: y , width: UIDevice.getScreenWidth - 20, height: UIDevice.getScreenHeight)
                self.visitTypeVC.view.alpha = 1.0
            }, completion: { (true) in
            })
            self.appointmentBtnTapped = false
        }else{
            self.visitTypeVC.view.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                self.visitTypeVC.view.alpha = 0.0                
            }, completion: { (true) in
                self.visitTypeVC.view.frame = CGRect(x: x, y: y , width: UIDevice.getScreenWidth - 20, height: CGFloat(0))
                self.visitTypeVC.view.removeFromSuperview()
                self.visitTypeVC.removeFromParentViewController()
            })
            self.appointmentBtnTapped = true
        }
    }
    
//    MARK:- openshareViewController
//    ==============================
    func openShareViewController(pdfLink: String){
        
        guard !pdfLink.isEmpty else{
            return
        }
        let ActivityController = UIActivityViewController(activityItems: [pdfLink], applicationActivities: nil)
        self.present(ActivityController, animated: true, completion: nil)
    }
}

//MARK:- Remove From VisitType Protocol
//====================================
extension BaseViewController: visitTypeSceneRemoveFromSuperView {
    func visitTypeViewRemove() {
        self.appointmentBtnTapped = true
    }
}

// CameraCustom View Button Action
//===============================
 extension BaseViewController: CustomCameraButtonTapped {
    
    func checkButtonTapped(){
        
        self.proceedToImagePreviewScreen()
    }
    func crossButtonTapped(){
        guard let nvc = self.navigationController else{
            return
        }
        self.capturedImages = []
        if let view = self.customCameraView {
            view.capturedImages = self.capturedImages
            view.imageDisplay(capturedImages: self.capturedImages)
        }
        nvc.popViewController(animated: true)
        nvc.dismiss(animated: true, completion: nil)
    }
    
    func deleteButtonTapped(){
        self.capturedImages.removeLast()
        if let view = self.customCameraView {
            view.capturedImages = self.capturedImages
            view.imageDisplay(capturedImages: self.capturedImages)
        }
    }
    
    // By tap on Image and check button
    fileprivate func proceedToImagePreviewScreen(){
        
        guard let nvc = self.navigationController else{
            return
        }
        
        let imagePreviewScene = ImagePreviewVC.instantiate(fromAppStoryboard: .Dashboard)
        imagePreviewScene.delegate = self
        imagePreviewScene.capturedImageArray = self.capturedImages
        nvc.pushViewController(imagePreviewScene, animated: true)
        nvc.dismiss(animated: true, completion: nil)
    }
}

// Captured Image Delegate from ImagePreviewVC
extension BaseViewController: CapturedImagesDelegate {
     func capturedImages(images: [UIImage]) {
        self.capturedImages = images
            guard let nvc = self.navigationController else{
                return
            }
            guard let viewController = nvc.topViewController as? BaseViewController else{
                return
            }
            self.openCustomCamera = .attachReport
            ImagePicker.shared.imagePickerDelegate = self
            ImagePicker.shared.checkAndOpenCamera(on: viewController, viewForCustomCamera: self.customCameraView)
            if let view = self.customCameraView {
                view.capturedImages = self.capturedImages
                view.imageDisplay(capturedImages: self.capturedImages)
            }
        nvc.popViewController(animated: true)
    }
}
