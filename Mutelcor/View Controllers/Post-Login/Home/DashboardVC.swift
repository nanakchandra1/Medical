//
//  HomeVCViewController.swift
//  Mutelcor
//
//  Created by  on 06/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import EventKit
import CloudKit


class DashboardVC: BaseViewController {
    
    // MARK:- Proporties
    //    ===================
    var sectionTexts = ["",K_MY_BMI.localized,K_LAST_APPOINTMENT_DATE.localized,K_NEXT_SCHEDULE.localized,K_LAST_SEEN.localized, K_LAST_REVIEWED.localized]
    var dashboardData: [DashboardDataModel] = []
    fileprivate var filteredSchedule: [NextSchedule] = []
    fileprivate var filteredLatestAppointment: [LatestAppointment] = []
    fileprivate var latestAppointment: [LatestAppointment] = []
    fileprivate var nextSchedule: [NextSchedule] = []
    fileprivate var firstTimeAddedEvent: [EKEvent] = []
    fileprivate var selectedLayer: Layer = .first
    
    // MARK:- IBOutlets
    // =================
    @IBOutlet weak var dashboardTableView: UITableView!
    
    // MARK:- ViewController Life Cycle
    // ===================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableCells()
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self

        self.updateSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = .dashboard
        self.sideMenuBtnActn = .sideMenuBtn
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_DASHBOARD_SCREEN_TITLE.localized)
        self.getDashboardData(true)
//        self.icloudPermission()
    }
    
    // MARK:- Private Methods
    private func registerTableCells() {
        
        let dashboardWeightTableCellNib = UINib(nibName: "DashboardWeightTableCell", bundle: nil)
        dashboardTableView.register(dashboardWeightTableCellNib, forCellReuseIdentifier: "DashboardWeightTableCell")
        
        let dashboardBMITableCellNib = UINib(nibName: "DashboardBMITableCell", bundle: nil)
        dashboardTableView.register(dashboardBMITableCellNib, forCellReuseIdentifier: "DashboardBMITableCell")
        
        let measurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        dashboardTableView.register(measurementListCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        
        let lastAppointmentDateCellNib = UINib(nibName: "LastAppointmentDateCell", bundle: nil)
        dashboardTableView.register(lastAppointmentDateCellNib, forCellReuseIdentifier: "lastAppointmentDateCellID")
        
        let attachmentHeaderViewCellNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        dashboardTableView.register(attachmentHeaderViewCellNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
    }
    
    fileprivate func requestToAccessCalender(){
        AppDelegate.shared.eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil){
                mainQueue {
                    AppDelegate.shared.setEventCalender()
                }
                self.getDashboardData(true)
            }else{
                self.getDashboardData(false)
            }
        }
    }
    
    fileprivate func icloudPermission(){
        let container = CKContainer(identifier: K_ICLOUD_INDENTFIER.localized)
        container.requestApplicationPermission(.userDiscoverability) { (permissionStatus, error) in
            
            switch permissionStatus{
            case .granted:
                mainQueue {
                    self.requestToAccessCalender()
                }
            case .denied:
                print("denied")
            case .couldNotComplete:
                let isAvaliable = self.isICloudContainerAvailable()
                if isAvaliable{
                    mainQueue {
                        self.requestToAccessCalender()
                    }
                }else{
                    self.getDashboardData(false)
                    self.openiCloudPermissionPopUp()
                }
                
            case .initialState:
                print("initialState")
                
//            case .denied,.couldNotComplete, .initialState:
//                self.getDashboardData(false)
//                self.openiCloudPermissionPopUp()
            }
        }
    }
    
    func isICloudContainerAvailable()->Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
            return true
        }else {
            return false
        }
    }
    
    fileprivate func openiCloudPermissionPopUp(){
        
        let alert = UIAlertController(title: "Confirmation", message: K_ICLOUD_PERMISSION_TEXT.localized, preferredStyle: UIAlertControllerStyle.alert)
        
        let settings = UIAlertAction(title: "Setting", style: UIAlertActionStyle.default) { (action) in
            let settingUrl = URL(string: "App-prefs:root=CASTLE")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
            }else{
                showToastMessage("Setting url is availiable for iOS 10 or newer")
            }
            self.getDashboardData(false)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.getDashboardData(false)
        }
        alert.addAction(settings)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Table View DataSource Methods
extension DashboardVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTexts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardWeightTableCell", for: indexPath) as? DashboardWeightTableCell else {
                fatalError("DashboardWeightTableCell not found")
            }
            cell.collectionView.outerIndexPath = indexPath
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self

            cell.collectionView.reloadData()
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardBMITableCell", for: indexPath) as? DashboardBMITableCell else {
                fatalError("DashboardBMITableCell not found")
            }
            cell.populateDasboardData(self.dashboardData)
            return cell
        case 3,4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID", for: indexPath) as? MeasurementListCollectionCell else{
                fatalError("MeasurementListCollectionCell not found")
            }
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            cell.measurementListCollectionView.outerIndexPath = indexPath
            cell.measurementListCollectionView.delegate = self
            cell.measurementListCollectionView.dataSource = self
            cell.measurementListCollectionView.reloadData()
            return cell
        case 2,5: guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastAppointmentDateCellID", for: indexPath) as? LastAppointmentDateCell else{
            fatalError("LastAppointmentDateCell not found")
        }
        cell.populateDashboardData(self.dashboardData, indexPath)
        return cell
        default:
            fatalError("IndexPath not allowed")
        }
    }
}

// MARK: Table View Delegate Methods
extension DashboardVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            return (120 + (0.7*screenWidth)) //365
        case 1:
            let bmiImageWidth = (screenWidth - 60)
            let height = (43*bmiImageWidth/105 + 90)
            return height
        case 2:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].latestAppointment.isEmpty ? CGFloat.leastNormalMagnitude : 50
                return height
            }
        case 3:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].nextSchedule.isEmpty ? CGFloat.leastNormalMagnitude : 170
                return height
            }
        case 4:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].lastSentData.isEmpty ? CGFloat.leastNormalMagnitude : 170
                return height
            }
        case 5 :
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].reviewDate.isEmpty ? CGFloat.leastNormalMagnitude : 50
                return height
            }
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            return CGFloat.leastNormalMagnitude
        case 1:
            return 38
        case 2:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].latestAppointment.isEmpty ? CGFloat.leastNormalMagnitude : 38
                return height
            }
        case 3:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].nextSchedule.isEmpty ? CGFloat.leastNormalMagnitude : 38
                return height
            }
            
        case 4:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].lastSentData.isEmpty ? CGFloat.leastNormalMagnitude : 38
                return height
            }
        case 5:
            if self.dashboardData.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                let height = self.dashboardData[0].reviewDate.isEmpty ? CGFloat.leastNormalMagnitude : 50
                return height
            }
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            fatalError("AttachmentHeaderViewCell not Found!")
        }
        
        headerCell.headerTitle.textColor = .black
        headerCell.dropDownBtn.isHidden = true
        headerCell.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        headerCell.headerTitle.text = self.sectionTexts[section]
        headerCell.headerTitle.isHidden = (section == 0)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 3:
            let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
            self.navigationController?.pushViewController(addMeasurementScene, animated: true)
        case 4:
            let measurementDetailScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
            self.navigationController?.pushViewController(measurementDetailScene, animated: true)
        default:
            return
        }
    }
}

// MARK: CollectionView DataSource Methods
//========================================
extension DashboardVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be Indexed Collection View")
        }
        
        switch outerIndexPath.section {
        case 0 :
            return 5
        case 3:
            if !self.dashboardData.isEmpty {
                if !self.dashboardData[0].nextSchedule.isEmpty {
                    return self.dashboardData[0].nextSchedule.count
                }else{
                    return self.dashboardData[0].lastSentData.count
                }
            }else{
                return 0
            }
        case 4:
            let items = !self.dashboardData.isEmpty ? self.dashboardData[0].lastSentData.count : 0
            return items
        default : fatalError("OuterIndexPath not found")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be Indexed Collection View")
        }
        
        switch outerIndexPath.section {
        case 0 :
            switch indexPath.item {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircularSegmentCollectionCell", for: indexPath) as? CircularSegmentCollectionCell else {
                    fatalError("CircularSegmentCollectionCell not found")
                }
                
                cell.circularSegmentView.delegate = self
                cell.populateDashboardData(self.dashboardData)
                setCircularSegmentViewText(cell.circularSegmentView ,selected: selectedLayer)
                
                return cell
            case 1,2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "caloriesConsumedCellID", for: indexPath) as? CaloriesConsumedCell else {
                    fatalError("CircularSegmentCollectionCell not found")
                }
                
                cell.populateDashboardData(self.dashboardData, indexPath)
                return cell
            case 3:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waterIntakeCellID", for: indexPath) as? WaterIntakeCell else {
                    fatalError("CircularSegmentCollectionCell not found")
                }
                
                cell.populateDashboardData(self.dashboardData, indexPath)
                return cell
            case 4:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardTimeLineCell", for: indexPath) as? DashBoardTimeLineCell else {
                    fatalError("CircularSegmentCollectionCell not found")
                }
                
                //cell.populateDashboardData(self.dashboardData, indexPath)
                return cell

            default:
                fatalError("IndexPath not Found!")
            }
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nextScheduleCellID", for: indexPath) as? NextScheduleCell else{
                fatalError("NextScheduleCell not found")
            }
            cell.populateData(self.dashboardData, indexPath)
            return cell
            
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else {
                fatalError("VitalListingCell not found")
            }
            cell.populateDashboardData(self.dashboardData, indexPath)
            return cell
            
        default :
            fatalError("OuterIndexPath not found")
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout Delegate Methods
//=========================================================
extension DashboardVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let indexedCollectionView = collectionView as? IndexedCollectionView, indexedCollectionView.outerIndexPath == IndexPath(row: 0, column: 0) {
            return CGFloat.leastNormalMagnitude
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let indexedCollectionView = collectionView as? IndexedCollectionView{
            if indexedCollectionView.outerIndexPath == IndexPath(row: 0, column: 0) {
                
                let screenWidth = UIScreen.main.bounds.width
                let collectionViewWidth = (screenWidth - 10)
                let height = (82 + (0.7*screenWidth)) // 330
                return CGSize(width: collectionViewWidth, height: height)
            }else{
                return CGSize(width: (collectionView.frame.width/3 - 2) , height: collectionView.frame.height)
            }
        }else{
            return CGSize.zero
        }
    }
}

// MARK: UICollectionViewDelegate Methods
//========================================
extension DashboardVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be Indexed Collection View")
        }
        guard let nvc = self.navigationController else{
            return
        }
        switch outerIndexPath.section {
        case 0:
            switch indexPath.item {
            case 2:
                let activityScene = ActivityVC.instantiate(fromAppStoryboard: .Activity)
                activityScene.proceedToScreenThrough = .navigationBar
                nvc.pushViewController(activityScene, animated: true)
            case 1,3:
                let nutritionScene = NutritionVC.instantiate(fromAppStoryboard: .Nutrition)
                nutritionScene.proceedToScreenThrough = .navigationBar
                nvc.pushViewController(nutritionScene, animated: true)
            case 4:
                let nutritionScene = TimelineVC.instantiate(fromAppStoryboard: .Timeline)
                //nutritionScene.proceedToScreenThrough = .navigationBar
                nvc.pushViewController(nutritionScene, animated: true)

            default:
                return
            }
            
        case 3:
            guard !dashboardData.isEmpty else{
                return
            }
            guard let data = dashboardData.first else{
                return
            }
            guard !data.nextSchedule.isEmpty else{
                return
            }
            let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
            let nextSchedule = data.nextSchedule[indexPath.item]
            addMeasurementScene.selectedVitalName = nextSchedule.testName
            addMeasurementScene.selectedVitalID = nextSchedule.scheduleID
            nvc.pushViewController(addMeasurementScene, animated: true)
            
        case 4:
            guard !dashboardData.isEmpty else{
                return
            }
            guard let data = dashboardData.first else{
                return
            }
            guard !data.lastSentData.isEmpty else{
                return
            }
            let measurementDetailScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
            measurementDetailScene.lastSentData = data.lastSentData[indexPath.item]
            nvc.pushViewController(measurementDetailScene, animated: true)
        default:
            return
        }
    }
}

// MARK: Circular Segment View Delegate Methods
//===================================
extension DashboardVC: CircularSegmentViewDelegate {
    
    func circularSegmentView(_ circularSegmentView: CircularSegmentView, didTapAt layer: Layer) {
        selectedLayer = layer
        setCircularSegmentViewText(circularSegmentView, selected: layer)
    }
    
    func setCircularSegmentViewText(_ circularSegmentView: CircularSegmentView, selected layer: Layer) {
        
        guard !self.dashboardData.isEmpty else {
            return
        }
        
        guard !self.dashboardData[0].weightInfo.isEmpty else {
            return
        }
        
        switch layer {
        case .first:
            let excessWeight = (self.dashboardData[0].weightInfo[0].currentWeight ) - (self.dashboardData[0].weightInfo[0].targetWeight)
            circularSegmentView.setCenterLabel(text: "Excess\nWeight\n\(Int(excessWeight).magnitude)\nkg", highlightedText: "\(Int(excessWeight).magnitude)")
        case .second:
            let idealWeight = self.dashboardData[0].weightInfo[0].idealWeight
            circularSegmentView.setCenterLabel(text: "Ideal\nWeight\n\(Int(idealWeight).magnitude)\nkg", highlightedText: "\(Int(idealWeight).magnitude)")
        case .third:
            let weightLoss = (self.dashboardData[0].weightInfo[0].startWeight ) - (self.dashboardData[0].weightInfo[0].currentWeight)
            circularSegmentView.setCenterLabel(text: "Weight\nLoss\n\(Int(weightLoss).magnitude)\nkg", highlightedText: "\(Int(weightLoss).magnitude)")
        }
    }
}

// MARK: Scroll View Delegate Methods
//===================================
extension DashboardVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != dashboardTableView else {
            return
        }
        guard let cell = scrollView.getTableViewCell as? DashboardWeightTableCell else {
            return
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let offSetX = scrollView.contentOffset.x
        
        if offSetX < (screenWidth/2 - 10) {
            cell.resetAll(selecting: cell.firstPageView)
        } else if offSetX > (screenWidth/2 - 10) && offSetX < (3*screenWidth/2 - 20) {
            cell.resetAll(selecting: cell.secondPageView)
        } else if offSetX > (3*screenWidth/2 - 20) && offSetX < (4*screenWidth/2 - 30) {
            cell.resetAll(selecting: cell.thirdPageView)
        } else if offSetX > (5*screenWidth/2 - 20) && offSetX < (6*screenWidth/2 - 30) {
            cell.resetAll(selecting: cell.fourthPageView)
        }else if offSetX > (6*screenWidth/2 - 30){
            cell.resetAll(selecting: cell.fifthView)
        }
    }
}

//MARK:- WebServices
//==================
extension DashboardVC {
    
    fileprivate func updateSession(){
        
        var param = [String: Any]()
        param["device_token"] = AppUserDefaults.value(forKey: .deviceToken).stringValue
        param["uuid"] = NSUUID().uuidString
        param["calling_device_token"] = AppUserDefaults.value(forKey: .voIPToken).stringValue
        param["device_type"] = true.rawValue
        param["device_model"] = UIDevice.current.modelName
        param["network_type"] = UIDevice.getNetworkType
        param["os_version"] = UIDevice.osType
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        param["app_version"] = version ?? ""
        param["ip_address"] = NSUUID().uuidString

        WebServices.updateSession(parameters: param, success: { (_ str: String) in
            
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getDashboardData(_ sync : Bool){
        var param = [String: Any]()
        param["doc_id"] = AppUserDefaults.value(forKey: .doctorId).stringValue

        WebServices.getDashboardData(parameters: param,
                                     success: {[weak self] (_ dashboardData : [DashboardDataModel]) in
                                        
                                        guard let strongSelf = self else{
                                            return
                                        }
                                        strongSelf.dashboardData = dashboardData
                                        strongSelf.dashboardTableView.reloadData()
                                        guard !dashboardData.isEmpty else{
                                            return
                                        }
                                        let messageCount = dashboardData[0].messageUnreadCount ?? 0
                                        let notificationCount = dashboardData[0].notificationUnreadCount ?? 0
                                        AppUserDefaults.save(value: messageCount, forKey: .messageUnreadCount)
                                        AppUserDefaults.save(value: notificationCount, forKey: .notificationUnreadCount)
                                        strongSelf.addBadges()
//                                        if sync {
//                                            strongSelf.iterateDashboardData()
//                                        }
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func iterateDashboardData(){
        if !self.dashboardData.isEmpty {
            self.latestAppointment = self.dashboardData[0].latestAppointment
            self.nextSchedule = self.dashboardData[0].nextSchedule
        }
        self.iterateAppointmentData()
        self.iterateTestScheduleData()
        self.syncDashboardEvent(self.filteredLatestAppointment, testSchedule: self.filteredSchedule)
    }
    
    fileprivate func iterateAppointmentData(){
        if !self.latestAppointment.isEmpty {
            if let serverID = self.latestAppointment[0].serverID, serverID.isEmpty || self.latestAppointment[0].googleEventID.isEmpty {
                self.filteredLatestAppointment.append(self.latestAppointment[0])
            }
        }
    }
    
    fileprivate func iterateTestScheduleData(){
        if !self.nextSchedule.isEmpty {
            for schedule in self.nextSchedule {
                if let serverID = schedule.serverID, serverID.isEmpty || schedule.googleEventID.isEmpty {
                    self.filteredSchedule.append(schedule)
                }
            }
        }
    }
    
    fileprivate func syncDashboardEvent(_ appointment: [LatestAppointment], testSchedule: [NextSchedule]){
        
        if !appointment.isEmpty {
            self.setAppointmentEvent(appointment)
        }
        if !testSchedule.isEmpty {
            self.setNextScheduleData(testSchedule)
        }
        self.setEvent()
    }
    
    fileprivate func setAppointmentEvent(_ appointment: [LatestAppointment]){
        let appointmentEvent = EKEvent(eventStore: AppDelegate.shared.eventStore)
        appointmentEvent.title = "Your have an Upcoming Appointment."
        let date = appointment[0].date?.getDateFromString(.utcTime, .utcTime)
        let addedDate = Calendar.current.date(byAdding: .hour, value: 9, to: date!)
        let endDate = Calendar.current.date(byAdding: .hour, value: 23, to: date!)
        appointmentEvent.startDate = addedDate!
        appointmentEvent.endDate = endDate!
        appointmentEvent.calendar = AppDelegate.shared.eventStoreCalendar
        appointmentEvent.notes = appointment[0].appointmentDescription
        appointmentEvent.calendar.cgColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.9215686275, alpha: 1).cgColor
        let alarmDate = Calendar.current.date(byAdding: .hour, value: 13, to: date!)
        let alarm = EKAlarm(absoluteDate: alarmDate!)
        appointmentEvent.alarms = [alarm]
        self.firstTimeAddedEvent.append(appointmentEvent)
    }
    
    fileprivate func setNextScheduleData(_ nextScheduleData : [NextSchedule]){
        for value in nextScheduleData {
            let nextScheduleEvent = EKEvent(eventStore: AppDelegate.shared.eventStore)
            nextScheduleEvent.title = value.testName ?? "Next Test"
            let date = value.time?.getDateFromString(.utcTime, .yyyyMMdd) ?? Date()
            let addedDate = Calendar.current.date(byAdding: .hour, value: 9, to: date)
            let endDate = Calendar.current.date(byAdding: .hour, value: 23, to: date)
            nextScheduleEvent.startDate = addedDate!
            nextScheduleEvent.endDate = endDate!
            nextScheduleEvent.calendar = AppDelegate.shared.eventStoreCalendar
            nextScheduleEvent.calendar.cgColor = #colorLiteral(red: 0.1803921569, green: 0.568627451, blue: 0.9294117647, alpha: 1).cgColor
            nextScheduleEvent.notes = value.scheduleDescription
            let alarmDate = Calendar.current.date(byAdding: .hour, value: 13, to: date)
            let alarm = EKAlarm(absoluteDate: alarmDate!)
            nextScheduleEvent.alarms = [alarm]
            self.firstTimeAddedEvent.append(nextScheduleEvent)
        }
    }
    
    fileprivate func setEvent(){
        if !self.firstTimeAddedEvent.isEmpty {
            var eventDic: [[String: Any]] = []
            do {
                for event in self.firstTimeAddedEvent {
                    try AppDelegate.shared.eventStore.save(event, span: .thisEvent, commit: true)
                    var dic: [String: Any] = [:]
                    
                    dic["event_name"] = event.title
                    let eventType = (event.title == "Your have an Upcoming Appointment.") ? 1 : 2
                    dic["event_type"] = eventType
                    dic["google_event_id"] = event.calendarItemExternalIdentifier
                    dic["start_date"] = event.startDate.stringFormDate(.yyyyMMdd)
                    dic["end_date"] = event.endDate.stringFormDate(.yyyyMMdd)
                    let time = Calendar.current.date(byAdding: .hour, value: 4, to: event.startDate)
                    let timeInString = time?.stringFormDate(.Hmm)
                    dic["reminder_time"] = timeInString
                    dic["device_type"] = "iOS"
                    dic["description"] = event.notes
                    eventDic.append(dic)
                }
                self.typeJSONArray(eventDic)
            } catch {
            }
        }
    }
    
    fileprivate func typeJSONArray(_ dic : [[String : Any]]){
        
        do {
            let typejsonArray = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
            self.addEvents(event: typeJSONString as AnyObject)
        }catch{
        }
    }
    
    fileprivate func addEvents(event: AnyObject?){
        var param : [String: Any] = [:]
        if let eventParam = event {
            param["events"] = eventParam
        }else{
            return
        }
//        WebServices.addEvents(parameters: param, success: {
//            
//        }) { (error: Error) in
//            showToastMessage(error.localizedDescription)
//        }
    }
}

