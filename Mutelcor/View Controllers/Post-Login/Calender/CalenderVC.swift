//
//  CalenderVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FSCalendar
import MXParallaxHeader
import EventKit
import CloudKit

class CalenderVC: BaseViewController {
    
    //    MARK:- Proproties
    //    =================
    fileprivate var tableContentView : TableContentView!
    fileprivate var calenderHeaderView : CalenderHeaderView!
    lazy var noDataLabel = UILabel()
    fileprivate var existingEvents: [EKEvent] = []
    fileprivate var firstTimeAddedEvent: [EKEvent] = []
    fileprivate var serverEvent: [Reminder] = []
    fileprivate var filteredEvent: [Reminder] = []
    fileprivate var nextSchedule : [NextSchedule] = []
    fileprivate var filteredNextSchedule: [NextSchedule] = []
    fileprivate var appointment : [LatestAppointment] = []
    fileprivate var filteredAppointment : [LatestAppointment] = []
    fileprivate var selectedDate : Date?
    fileprivate var updateEventDic: [String: Any] = [:]
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var calenderScrollView: MXScrollView!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_CALENDER_SCREEN_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frameOrigin = calenderScrollView.frame.origin
        var frame = CGRect(origin: frameOrigin, size: CGSize(width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight))
        
        self.calenderScrollView.frame = frame
        self.calenderScrollView.contentSize = frame.size
        
        frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight))
        frame.size.height -= self.calenderScrollView.parallaxHeader.minimumHeight - 50
        
        tableContentView.frame = frame
        noDataLabel.superview?.frame = tableContentView.contentTableView.bounds
        noDataLabel.center.y = 100
        noDataLabel.center.x = tableContentView.contentTableView.layer.frame.width / 2 - 75
    }
}

//MARK:- Methods
//==============
extension CalenderVC {
    
    fileprivate func setupUI(){
        
        calenderHeaderView = CalenderHeaderView.instanciateFromNib()
        self.calenderScrollView.parallaxHeader.view = calenderHeaderView
        self.calenderScrollView.parallaxHeader.height = 350
        self.calenderScrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.calenderScrollView.parallaxHeader.minimumHeight = 125
        self.calenderScrollView.keyboardDismissMode = .interactive
        tableContentView = TableContentView.instanciateFromNib()
        self.calenderScrollView.addSubview(tableContentView)
        tableContentView.contentTableView.dataSource = self
        tableContentView.contentTableView.delegate = self
        let lastAppointmentDateCellNib = UINib(nibName: "LastAppointmentDateCell", bundle: nil)
        let attachmentHeaderNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        self.tableContentView.contentTableView.register(lastAppointmentDateCellNib, forCellReuseIdentifier: "lastAppointmentDateCellID")
        self.tableContentView.contentTableView.register(attachmentHeaderNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        self.calenderHeaderView.calendarContentView.delegate = self
        self.calenderHeaderView.calendarContentView.dataSource = self
//        self.iCloudPermissions()
        self.getCalenderEvents(false)
        self.getDashboardData()
    }
    
    private func setupActivityTableBackgroundView(_ isLabelShowing: Bool = false) {
        let tableBackgroundView = UIView(frame: tableContentView.contentTableView.bounds)
        tableBackgroundView.backgroundColor = .groupTableViewBackground
        noDataLabel.font = AppFonts.sanProSemiBold.withSize(16)
        noDataLabel.numberOfLines = 0
        noDataLabel.textColor = .darkGray
        noDataLabel.textAlignment = .center
        noDataLabel.text = "No Records Found!"
        noDataLabel.sizeToFit()
        tableBackgroundView.addSubview(noDataLabel)
        tableContentView.contentTableView.backgroundView = tableBackgroundView
        noDataLabel.isHidden = !isLabelShowing
        tableContentView.contentTableView.backgroundView?.isHidden = !isLabelShowing
        
        //        tableContentView.contentTableView.isHidden = !isLabelShowing
    }
    
    //    MARK:- iCloud Permissions
    //    =========================
    fileprivate func iCloudPermissions(){
        let container = CKContainer(identifier: K_ICLOUD_INDENTFIER.localized)
        container.requestApplicationPermission(.userDiscoverability) { (permissionStatus, error) in
            
            switch permissionStatus{
            case .granted:
                mainQueue {
                    self.requestAccessToCalendar()
                }
            case .denied,.couldNotComplete, .initialState:
                return
//                self.openiCloudPer missionPopUp()
            }
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
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(settings)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //    MARK: Setup Event Calender
    //    ===========================
    fileprivate func requestAccessToCalendar() {
        
        AppDelegate.shared.eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil){
                mainQueue {
                    AppDelegate.shared.setEventCalender()
                    self.getExistingEvent()
                }
            }else {
                //printlnDebug("Access to store denied")
                self.getCalenderEvents(false)
            }
        }
    }
    
    func getExistingEvent(){
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let predicate = AppDelegate.shared.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [AppDelegate.shared.eventStoreCalendar])
        self.existingEvents = AppDelegate.shared.eventStore.events(matching: predicate)
        self.getCalenderEvents(true)
    }
    
    fileprivate func getFilteredEvents(selectedDate: Date){
        let date = selectedDate.stringFormDate(.ddMMMYYYY)
        self.filteredEvent = []
        self.filteredAppointment = []
        self.filteredNextSchedule = []
        
        if !self.serverEvent.isEmpty{
            for event in self.serverEvent {
                let eventDate = event.startDate ?? Date()
                let selectDate = eventDate.stringFormDate(.ddMMMYYYY)
                if date == selectDate {
                    self.filteredEvent.append(event)
                }
            }
        }

        if !self.appointment.isEmpty{
            for appointment in self.appointment {
                if let scheduleDateInString = appointment.date, !scheduleDateInString.isEmpty{
                    let selectDate = scheduleDateInString.changeDateFormat(.utcTime, .ddMMMYYYY)
                    if date == selectDate {
                        self.filteredAppointment.append(appointment)
                    }
                }
            }
        }

        if !self.nextSchedule.isEmpty {
            for schedule in self.nextSchedule {
                if let scheduleDateInString = schedule.time, !scheduleDateInString.isEmpty{
                    let selectDate = scheduleDateInString.changeDateFormat(.utcTime, .ddMMMYYYY)
                    if date == selectDate {
                        self.filteredNextSchedule.append(schedule)
                    }
                }
            }
        }

        let event = (self.filteredEvent.count + self.filteredAppointment.count + self.filteredNextSchedule.count) > 0 ? 1 : 0
        let isLabelHidden = event == 0 ? true : false
        self.setupActivityTableBackgroundView(isLabelHidden)
        self.tableContentView.contentTableView.reloadData()
    }

    fileprivate func getEventOnDate(_ selectedDate : Date) -> Int{
        var nextResult = 0
        let date = selectedDate.stringFormDate(.ddMMMYYYY)
        if !self.serverEvent.isEmpty {
            for event in self.serverEvent {
                let scheduleDate = event.startDate ?? Date()
                let dateOfSchedule = scheduleDate.stringFormDate(.ddMMMYYYY)
                if date == dateOfSchedule {
                    nextResult = 1
                }
            }
        }
        
        if !self.appointment.isEmpty{
            for appointment in self.appointment {
                if let scheduleDateInString = appointment.date, !scheduleDateInString.isEmpty{
                    let selectDate = scheduleDateInString.changeDateFormat(.utcTime, .ddMMMYYYY)
                    if date == selectDate {
                        nextResult = 1
                    }
                }
            }
        }
        
        if !self.nextSchedule.isEmpty{
            for schedule in self.nextSchedule {
                if let scheduleDateInString = schedule.time, !scheduleDateInString.isEmpty{
                    let selectDate = scheduleDateInString.changeDateFormat(.utcTime, .ddMMMYYYY)
                    if date == selectDate {
                        nextResult = 1
                    }
                }
            }
        }
        return nextResult
    }
}

//MARK:- FSCalendarDataSource, FSCalendarDelegate
//===============================================
extension CalenderVC : FSCalendarDelegate , FSCalendarDataSource {
    
    func calenderLeftButtonActon() {
        
        let cal = self.calenderHeaderView.calendarContentView
        let unit = self.calenderHeaderView.calendarContentView.scope == FSCalendarScope.month  ? Calendar.Component.month : Calendar.Component.weekOfYear
        let prevDate = cal?.gregorian.date(byAdding: unit, value: -1, to: (cal?.currentPage)!)
        cal?.setCurrentPage(prevDate!, animated: true)
    }
    
    func calenderRightButtonActon() {
        let cal = self.calenderHeaderView.calendarContentView
        let unit = self.calenderHeaderView.calendarContentView.scope == FSCalendarScope.month  ? Calendar.Component.month : Calendar.Component.weekOfYear
        
        let prevDate = cal?.gregorian.date(byAdding: unit, value: 1, to: (cal?.currentPage)!)
        cal?.setCurrentPage(prevDate!, animated: true)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    }
    
    //    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    //        let date = calendar.currentPage
    //    }
    //
    //    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
    //        let date = calendar.currentPage
    //        //        self.getEventOnDate(date)
    //    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let eventOnDate = self.getEventOnDate(date)
        if date == Date(){
            self.getFilteredEvents(selectedDate: Date())
        }
        return eventOnDate
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if self.selectedDate != date {
            self.selectedDate = date
            self.getFilteredEvents(selectedDate: date)
        }
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension CalenderVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return self.filteredEvent.count
        case 1:
            return self.filteredNextSchedule.count
        default:
            return self.filteredAppointment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastAppointmentDateCellID", for: indexPath) as? LastAppointmentDateCell else{
            fatalError("LastAppointmentDateCell not found")
        }
        cell.populateCalenderData(filteredReminder: self.filteredEvent, filteredAppointment: self.filteredAppointment, filteredSchedule: self.filteredNextSchedule, indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("header")
        }
        
        sectionHeaderViewCell.headerTitle.text = "Events"
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        sectionHeaderViewCell.cellBackgroundView.backgroundColor = UIColor.appColor
        sectionHeaderViewCell.dropDownBtn.isHidden = true
        
        return sectionHeaderViewCell
    }
}
//MARK:- UITableViewDelegate Methods
//===================================
extension CalenderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = section == 0 ? 30 : CGFloat.leastNormalMagnitude
        return height
    }
}

//MARK:- WebServices
//==================
extension CalenderVC {
    
    fileprivate func getCalenderEvents(_ eventType: Bool){
        let param: [String: Any] = ["event_type": eventType.rawValue]
        WebServices.getMedicationReminders(parameters: param, success: {[weak self](events : [Reminder]) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.serverEvent.isEmpty {
                strongSelf.serverEvent += events
            }else{
                strongSelf.serverEvent.append(contentsOf: events)
            }
            
            strongSelf.getFilteredEvents(selectedDate: Date())
            
//            if eventType {
//                strongSelf.updateCalenderEvent()
//            }
            strongSelf.calenderHeaderView.calendarContentView.reloadData()
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    
    fileprivate func getDashboardData(){
        var param = [String: Any]()
        param["doc_id"] = AppUserDefaults.value(forKey: .doctorId).stringValue
        
        WebServices.getDashboardData(parameters: param,
                                     success: {[weak self] (_ dashboardData : [DashboardDataModel]) in
                                        
                                        guard let strongSelf = self else{
                                            return
                                        }
                                        guard let dashboard = dashboardData.first else{
                                            return
                                        }
                                        strongSelf.nextSchedule = dashboard.nextSchedule
                                        strongSelf.appointment = dashboard.latestAppointment
                                        strongSelf.getFilteredEvents(selectedDate: Date())
                                        strongSelf.calenderHeaderView.calendarContentView.reloadData()
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    
    fileprivate func updateCalenderEvent(){
        
        for serverEvents in self.serverEvent {
            var unsycEvents: Reminder? = serverEvents
            for event in self.existingEvents {
                if serverEvents.localIds.contains(event.calendarItemExternalIdentifier) {
                    unsycEvents = nil
                    if serverEvents.eventType == 1 || serverEvents.eventType == 2 {
                        if serverEvents.isDeleted {
                            do {
                                try AppDelegate.shared.eventStore.remove(event, span: .thisEvent, commit: true)
                            } catch {
                                showToastMessage(error.localizedDescription)
                            }
                        }else if serverEvents.isUpdate {
                            //                            self.updateServerEvents(serverEvents, existingEvent: event)
                        }
                    }
                    continue
                }
            }
            
            if let unwrappedUnsyncedEvent = unsycEvents, !unwrappedUnsyncedEvent.isDeleted {
                self.addEvent(unwrappedUnsyncedEvent)
            }
        }
        self.setEvent()
        if !self.updateEventDic.isEmpty {
            self.typeJSONArray(self.updateEventDic)
        }
    }
    
    fileprivate func addEvent(_ events: Reminder){
        let event = EKEvent(eventStore: AppDelegate.shared.eventStore)
        let eventName = events.eventType == 1 ? "Your have an Upcoming Appointment." : events.eventName
        event.title = eventName
        let date = events.startDate ?? Date()
        let addedDate = Calendar.current.date(byAdding: .hour, value: 9, to: date)
        let endDate = Calendar.current.date(byAdding: .hour, value: 23, to: date)
        event.startDate = addedDate!
        event.endDate = endDate!
        event.calendar = AppDelegate.shared.eventStoreCalendar
        event.calendar.cgColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.9215686275, alpha: 1).cgColor
        let alarmDate = Calendar.current.date(byAdding: .hour, value: 13, to: date)
        let alarm = EKAlarm(absoluteDate: alarmDate!)
        event.alarms = [alarm]
        self.firstTimeAddedEvent.append(event)
        self.updateEventDic["\(events.serverId)"] = event.calendarItemExternalIdentifier
    }
    
    fileprivate func setEvent(){
        if !self.firstTimeAddedEvent.isEmpty {
            do {
                for event in self.firstTimeAddedEvent {
                    try AppDelegate.shared.eventStore.save(event, span: .thisEvent, commit: true)
                }
            } catch {
                //printlnDebug(error.localizedDescription)
            }
        }
    }
    fileprivate func typeJSONArray(_ dic : [String : Any]){
        do {
            let typejsonArray = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
            
            let convertedDic = typeJSONString as AnyObject
            let param: [String: Any] = ["event_id" : "\(convertedDic)"]
            WebServices.UpdateMultipleEvents(parameters: param, success: {
            }, failure: { (error: Error) in
                showToastMessage(error.localizedDescription)
            })
        }catch{
            //printlnDebug(error.localizedDescription)
        }
    }
}
