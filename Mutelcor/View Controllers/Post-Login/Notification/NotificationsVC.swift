//
//  NotificationsVC.swift
//  Mutelcor
//
//  Created by on 28/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

//MARK:- Enum For ProceedToScreen Throght Side Menu
//=================================================
enum ProceedToScreenBy {
    case sideMenu
    case navigationBar
}

class NotificationsVC: BaseViewControllerWithBackButton {
    
    fileprivate enum NotificationType : Int{
        case appointment = 1
        case measurement = 2
        case activity = 3
        case nutrition = 4
        case ePrescription = 5
        case cms = 7
    }
    
    //    MARK:- Proporties
    //    =================
    fileprivate var notifications = [NotificationModel]()
    fileprivate var nextCount: Int?
    var proceedToScreenThrough = ProceedToScreenBy.sideMenu
    fileprivate var notificationDic = [String : Any]()
    fileprivate var indexPath: IndexPath?
    fileprivate var selectedNotification: NotificationModel?
//    private var pullToRefresh = UIRefreshControl()
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var nodataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNotifications(isLoader: true)
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sideMenuBtnActn = (self.proceedToScreenThrough == .navigationBar) ? SidemenuBtnAction.backBtn : SidemenuBtnAction.sideMenuBtn
        self.sideMenuBtnActn = sideMenuBtnActn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        let panGestureEnable = self.sideMenuBtnActn == .sideMenuBtn ? true : false
        AppDelegate.shared.slideMenu.leftPanGesture?.isEnabled = panGestureEnable
        self.setNavigationBar(screenTitle: K_NOTIFICATION_SCREEN_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//=====================================
extension NotificationsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCellID", for: indexPath) as? NotificationCell else{
            fatalError("Cell Not Found!")
        }
        
        cell.populateData(self.notifications, indexPath)
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension NotificationsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.notificationDic["notification_id"] = self.notifications[indexPath.row].notificationID
        self.getUpdateNotification(indexPath)
        
    }
}

//MARK:- UIScrollViewDelegate Methods
//=====================================
extension NotificationsVC : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if scrollView === self.notificationTableView{
            if let nxtCount = self.nextCount, nxtCount != 0{
                self.getNotifications()
            }
        }
    }
}
//MARK:- Methods
//==============
extension NotificationsVC {
    fileprivate func setupUI(){
        self.nodataAvailiableLabel.text = K_NO_NOTIFICATION.localized
        self.nodataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.nodataAvailiableLabel.isHidden = true
        self.nodataAvailiableLabel.textColor = UIColor.appColor
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        
        self.registerNibs()
//        self.addPullToRefresh()
//        self.pullToRefresh.tintColor = UIColor.appColor
//        self.pullToRefresh.addTarget(self, action: #selector(self.getNotifications(isLoader:)), for: .valueChanged)
    }
    
    fileprivate func registerNibs(){
        
        let notificationNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.notificationTableView.register(notificationNib, forCellReuseIdentifier: "notificationCellID")
    }
    
//    fileprivate func addPullToRefresh(){
//        if #available(iOS 10.0, *) {
//            self.notificationTableView.refreshControl = self.pullToRefresh
//        } else {
//            self.notificationTableView.addSubview(self.pullToRefresh)
//        }
//    }
}

//MARK :- WebServices
//===================
extension NotificationsVC {
    
    @objc fileprivate func getNotifications(isLoader: Bool = false){
        
        let nextCount = (self.nextCount != nil) ? "\(self.nextCount ?? 0)" : "0"
        self.notificationDic["next_count"] = nextCount
//        self.pullToRefresh.endRefreshing()
        WebServices.getNotification(parameteres : self.notificationDic,
                                    loader: isLoader,
                                    success: {[weak self] (_ notifcation : [NotificationModel], _ nextCount : Int) in
                                        
                                        guard let notificationVC = self else{
                                            return
                                        }
                                        notificationVC.notifications.append(contentsOf: notifcation)
                                        
                                        let isLabelHidden = notificationVC.notifications.isEmpty ? false : true
                                        notificationVC.nodataAvailiableLabel.isHidden = isLabelHidden

                                        notificationVC.nextCount = nextCount
                                        notificationVC.notificationTableView.reloadData()
        }){(error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getUpdateNotification(_ indexPath: IndexPath){
        
        WebServices.getUpdateNotification(parameteres: self.notificationDic, success: {[weak self] (_ message : String) in
            
            guard let notificationVC = self else{
                return
            }
            notificationVC.tappedOnNotification(indexPath)
        }){(error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func tappedOnNotification(_ indexPath: IndexPath){
        
        self.nextCount = 0
        self.notifications[indexPath.row].isRead = 1
        self.notificationTableView.reloadRows(at: [indexPath], with: .automatic)
        if let notificationType = self.notifications[indexPath.row].notificationType {
            
            guard let nvc = self.navigationController else{
                return
            }
            
            switch notificationType {
            case NotificationType.appointment.rawValue:
                let appointmentScene = AppointmentListingVC.instantiate(fromAppStoryboard: .AppointMent)
                appointmentScene.navigateToScreenBy = .noitificationVC
                nvc.pushViewController(appointmentScene, animated: true)
                
            case NotificationType.measurement.rawValue:
                let measurementScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
                nvc.pushViewController(measurementScene, animated: true)
                
            case NotificationType.activity.rawValue:
                let activityScene = ActivityPlanVC.instantiate(fromAppStoryboard: .Activity)
                nvc.pushViewController(activityScene, animated: true)
                
            case NotificationType.nutrition.rawValue:
                let nutritionPlanScene = NutritionPlanVC.instantiate(fromAppStoryboard: .Nutrition)
                nvc.pushViewController(nutritionPlanScene, animated: true)
                
            case NotificationType.ePrescription.rawValue:
                let ePrescriptionScene = ePrescriptionVC.instantiate(fromAppStoryboard: .ePrescription)
                ePrescriptionScene.navigateToScreenBy = .noitificationVC
                nvc.pushViewController(ePrescriptionScene, animated: true)
                
            case NotificationType.cms.rawValue:
                let cmsScene = CmsVC.instantiate(fromAppStoryboard: .CMS)
                if let id = self.notifications[indexPath.row].cmsID {
                    cmsScene.cmsDic["cms_id"] = id
                }
                nvc.pushViewController(cmsScene, animated: true)
            default:
                return
            }
        }
    }
}
