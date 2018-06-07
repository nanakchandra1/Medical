//
//  MedicationReminderVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import EventKit
import TransitionButton

class MedicationReminderVC: BaseViewController {
    
    fileprivate enum RecurrenceButtonState {
        case allButtonDisplayed
        case selectedButtonDisplayed
        case singleButtonDisplayed
    }
    fileprivate enum MonthlyWeelkyButton : Int {
        case weekly = 1
        case monthly = 2
    }
    fileprivate enum ScheduleTimeSelection: Int {
        case once = 1
        case twice = 2
        case thrice = 3
        case none = 0
    }
    
    //    MARK:- Proporties
    //    =================
    fileprivate let medicationRows = [K_NAME_OF_DRUG.localized,[K_START_DATE_TITLE.localized,K_END_DATE_TITLE.localized],[K_RECURRENCE_TITLE.localized, K_WEEKLY_BUTTON_TITLE.localized,K_MONTHLY_BUTTON_TITLE.localized],K_MONTHLY_BUTTON_TITLE.localized,K_RECURRENCE_TITLE.localized,K_SCHEDULE_TITLE.localized,K_REMINDER_TIME_TITLE.localized,"Reminder Time 2","Reminder Time 3",K_DOSAGE_TITLE.localized,K_INSTRUCTTIONS_TITLE.localized] as [Any]
    fileprivate let scheduleTime = [K_ONCE_A_DAY_TITLE.localized, K_TWICE_A_DAY_TITLE.localized, K_THRICE_A_DAY_TITLE.localized]
    fileprivate let dosageValues = [K_ONE_PILLS_TITLE.localized,K_TWO_PILLS_TITLE.localized,K_THREE_PILLS_TITLE.localized]
    fileprivate var recentBtnTapped: Bool = true
    fileprivate var reminderDic = [String : Any]()
    fileprivate var dateIndex = [Int]()
    fileprivate var selectedDate = Set<Int>()
    fileprivate var editActivityScene : EditActivityVC!
    fileprivate var recurrenceButtonState = RecurrenceButtonState.allButtonDisplayed
    fileprivate var monthlyWeeklyBtnTapped: MonthlyWeelkyButton = .weekly
    fileprivate var scheduleTimeSelection: ScheduleTimeSelection = .none
    fileprivate var selectedMonthDay: Int?
    
    lazy var eventStore = EKEventStore()
    var eventStoreCalendar: EKCalendar!
    var reminders: [EKReminder] = []
    var selectedInstruction: ReminderInstruction = .none
    var reminderToBeEdited: EKReminder?
    
    var serverReminders: [Reminder] = []
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var existingReminderViewOutlt: UIView!
    @IBOutlet weak var medicationReminderTableView: UITableView!
    @IBOutlet weak var setReminderBtnOutlt: TransitionButton!
    @IBOutlet weak var existingReminderLabel: UILabel!
    @IBOutlet weak var existingReminderImage: UIImageView!
    
    @IBOutlet weak var existingReminderContainerView: UIView!
    @IBOutlet weak var existingReminderTableView: UITableView!
    @IBOutlet weak var existingReminderTableViewHeight: NSLayoutConstraint!
    
    
    //    MARK:- ViewController LifeCycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatBtn.isHidden = false
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_MEDICATION_REMINDER_SCREEN_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setReminderBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    //    MARK:- IBActions
    //    ================
    @IBAction func setReminderBtnTapped(_ sender: UIButton) {
        self.validateReminder()
    }
    
    func validateReminder() {
        var reminderTime1: Date?
        var reminderTime2: Date?
        var reminderTime3: Date?
        guard let drugName = self.reminderDic["event_name"] as? String, !drugName.isEmpty else{
            showToastMessage(AppMessages.nameOfDrug.rawValue.localized)
            return
        }
        guard let startDate = self.reminderDic["start_date"] as? Date else{
            showToastMessage(AppMessages.medicationStartDate.rawValue.localized)
            return
        }
        guard let endDate = self.reminderDic["end_date"] as? Date else{
            showToastMessage(AppMessages.medicationEndDate.rawValue.localized)
            return
        }
        guard startDate.compare(endDate) == .orderedAscending || startDate.compare(endDate) == .orderedSame else{
            showToastMessage(AppMessages.startDateLessThanEndDate.rawValue.localized)
            return
        }
        
        if self.monthlyWeeklyBtnTapped == .weekly {
            guard !self.selectedDate.isEmpty else {
                showToastMessage(AppMessages.recurrence.rawValue.localized)
                return
            }
        }else{
            guard let _ = self.selectedMonthDay else {
                showToastMessage(AppMessages.recurrence.rawValue.localized)
                return
            }
        }
        guard let schedule = self.reminderDic["event_schedule"] as? Int, schedule != 0 else{
            showToastMessage(AppMessages.medicationSelectSchedule.rawValue.localized)
            return
        }
        guard let reminderTime = self.reminderDic["reminder_time"] as? Date else{
            showToastMessage(AppMessages.medicationReminderTime.rawValue.localized)
            return
        }
        reminderTime1 = reminderTime
        
        if self.scheduleTimeSelection == .twice {
            guard let reminderTime = self.reminderDic["reminder_time2"] as? Date else{
                showToastMessage(AppMessages.medicationReminderTime.rawValue.localized)
                return
            }
            reminderTime2 = reminderTime
        }else if self.scheduleTimeSelection == .thrice {
            guard let reminderTime = self.reminderDic["reminder_time2"] as? Date else{
                showToastMessage(AppMessages.medicationReminderTime.rawValue.localized)
                return
            }
            reminderTime2 = reminderTime
            guard let reminderTim = self.reminderDic["reminder_time3"] as? Date else{
                showToastMessage(AppMessages.medicationReminderTime.rawValue.localized)
                return
            }
            reminderTime3 = reminderTim
        }
        guard let dosage = self.reminderDic["dosage"] as? String, !dosage.isEmpty else{
            showToastMessage(AppMessages.selectDosage.rawValue.localized)
            return
        }
        guard let instructions = self.reminderDic["instruction"] as? String, !instructions.isEmpty else{
            showToastMessage(AppMessages.selectInstruction.rawValue.localized)
            return
        }
        guard let time = reminderTime1 else{
            return
        }
        guard let scheduleValue = self.reminderDic["eventSchedule"] as? String else{
            return
        }
        setReminder(drugName: drugName, startDate: startDate, endDate: endDate, recurrenceDays: self.selectedDate, schedule: scheduleValue, reminderTime1: time, reminderTime2: reminderTime2, reminderTime3: reminderTime3, dosage: dosage, instructions: instructions, existingReminder: nil, serverReminderId: nil, adding: true)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension MedicationReminderVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === medicationReminderTableView {
            return self.medicationRows.count
        }
        return self.serverReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === existingReminderTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingReminderCell", for: indexPath) as? ExistingReminderCell else {
                fatalError("ExistingReminderCell not found!")
            }
//            cell.editBtn.addTarget(self, action:#selector(editReminderBtnTapped), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action:#selector(deleteReminderBtnTapped), for: .touchUpInside)
            cell.populateReminder(reminder: self.serverReminders, indexPath: indexPath, schedule: self.scheduleTime, eventType: self.medicationRows[2] as! [String])
            return cell
        }
        switch indexPath.row {
            
        case 0,2,3,5,6,7,8,9:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameOFDrugCellID", for: indexPath) as? NameOFDrugCell else {
                fatalError("nameOfDrugCell not found!")
            }
            cell.cellTextField.delegate = self
            cell.cellTextField.placeholder = ""
            
            
            cell.cellTitleOutlt.text = self.medicationRows[indexPath.row] as? String
            
            switch indexPath.row {
            case 0:
                cell.cellTextField.rightView = nil
                cell.cellTextField.inputView = nil
                cell.cellTextField.text = reminderDic["event_name"] as? String
                cell.cellTextField.tintColor = UIColor.blue
            case 2:
                cell.weeklyBtnOutlt.isHidden = false
                cell.monthlyBtnOutlt.isHidden = false
                cell.sepratorView.isHidden = true
                cell.cellTextField.isHidden = true
                cell.cellTitleOutlt.isHidden = false
                cell.verticalSpacingbtwnTextFieldAndBtn.constant = 15
                if self.monthlyWeeklyBtnTapped == .weekly {
                    cell.weeklyBtnOutlt.isSelected = true
                    cell.monthlyBtnOutlt.backgroundColor = UIColor.gray
                    cell.weeklyBtnOutlt.backgroundColor = UIColor.appColor
                }else{
                    cell.monthlyBtnOutlt.isSelected = true
                    cell.weeklyBtnOutlt.backgroundColor = UIColor.gray
                    cell.monthlyBtnOutlt.backgroundColor = UIColor.appColor
                }
                if let buttonText = self.medicationRows[indexPath.row] as? [String] {
                    cell.cellTitleOutlt.text = buttonText[0]
                    cell.weeklyBtnOutlt.setTitle(buttonText[1], for: .normal)
                    cell.monthlyBtnOutlt.setTitle(buttonText[2], for: .normal)
                }
                cell.weeklyBtnOutlt.addTarget(self, action: #selector(self.weeklyBtnTapped(_:)), for: .touchUpInside)
                cell.monthlyBtnOutlt.addTarget(self, action: #selector(self.monthlyBtnTapped(_:)), for: .touchUpInside)
            case 3:
                if let day = self.selectedMonthDay {
                    cell.cellTextField.text = String(day)
                }
                cell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
                cell.cellTextField.rightViewMode = .always
            case 5:
                cell.cellTextField.text = reminderDic["eventSchedule"] as? String
                cell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
                cell.cellTextField.rightViewMode = .always
            case 6,7,8:
                cell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
                cell.cellTextField.rightViewMode = .always
                let isHidden = (indexPath.row == 6) ? false : true
                cell.cellTitleOutlt.isHidden = isHidden
                if isHidden {
                    cell.cellTextField.placeholder = self.medicationRows[indexPath.row] as? String
                }else{
                    cell.cellTextField.placeholder = ""
                }
                cell.populateReminderTime(reminderDic: reminderDic, indexPath: indexPath)
            case 9:
                cell.cellTextField.text = reminderDic["dosage"] as? String
                cell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
                cell.cellTextField.rightViewMode = .always
            default:
                fatalError("cell not found!")
            }
            return cell
        case 1:
            guard let selectDateCell = tableView.dequeueReusableCell(withIdentifier: "appointmentDateTimeCellID", for: indexPath) as? AppointmentDateTimeCell else {
                fatalError("AppointmentDateTimeCell not found!")
            }
            
            if !(selectDateCell.appointmentDateTextField.delegate is LogBookVC) {
                selectDateCell.appointmentDateTextField.delegate = self
                selectDateCell.apppointmentTimeTextField.delegate = self
            }
            
            if let startDate = reminderDic["start_date"] as? Date {
                selectDateCell.appointmentDateTextField.text = startDate.stringFormDate(.dMMMyyyy)
            }
            
            if let endDate = reminderDic["end_date"] as? Date {
                selectDateCell.apppointmentTimeTextField.text = endDate.stringFormDate(.dMMMyyyy)
            }
            
            selectDateCell.appointmentDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
            selectDateCell.appointmentDateTextField.rightViewMode = .always
            selectDateCell.apppointmentTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
            selectDateCell.apppointmentTimeTextField.rightViewMode = .always
            
            if let medicationDateTime = self.medicationRows[indexPath.row] as? [String] {
                selectDateCell.appointmentDateLabel.text = medicationDateTime[0]
                selectDateCell.appointmentTimeLabel.text = medicationDateTime[1]
            }
            
            selectDateCell.appointmentTimeBtn.isHidden = true
            return selectDateCell
        case 4 :
            guard let recurrenceCell = tableView.dequeueReusableCell(withIdentifier: "recurrenceCellID", for: indexPath) as? RecurrenceCell else {
                fatalError("recurrenceCell not found!")
            }
            
            if !self.dateIndex.isEmpty{
                self.buttonEnablingState(self.dateIndex, recurrenceCell)
            }
            
            for index in selectedDate {
                switch index {
                case 1:
                    recurrenceCell.sundayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.sundayBtnOutlt)
                case 2:
                    recurrenceCell.mondayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.mondayBtnOutlt)
                case 3:
                    recurrenceCell.tuesdayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.tuesdayBtnOutlt)
                case 4:
                    recurrenceCell.wednesdayBtnOUtlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.wednesdayBtnOUtlt)
                case 5:
                    recurrenceCell.thursdayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.thursdayBtnOutlt)
                case 6:
                    recurrenceCell.fridayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.fridayBtnOutlt)
                case 7:
                    recurrenceCell.saturdayBtnOutlt.isSelected = false
                    toggleBtnSelection(recurrenceCell.saturdayBtnOutlt)
                default:
                    break
                }
            }
            
            recurrenceCell.sundayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.mondayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.tuesdayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.wednesdayBtnOUtlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.thursdayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.fridayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            recurrenceCell.saturdayBtnOutlt.addTarget(self, action: #selector(toggleBtnSelection(_:)), for: .touchUpInside)
            
            return recurrenceCell
            
        case 10:
            guard let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCellID", for: indexPath) as? InstructionCell else {
                fatalError("instructionCell not found!")
            }
            
            instructionCell.cellTitleOutlt.text = self.medicationRows[indexPath.row] as? String
            instructionCell.beforeMealBtnOutlt.addTarget(self, action: #selector(self.beforeMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.afterMealBtnOutlt.addTarget(self, action: #selector(self.afterMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.duringMealBtnOutlt.addTarget(self, action: #selector(self.duringMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.noneBtnOutlt.addTarget(self, action: #selector(self.noneBtnTapped(_:)), for: .touchUpInside)
            
            instructionCell.setInstructionSelected(selectedInstruction)
            return instructionCell
            
        default : fatalError("Cell Not Found!")
        }
    }
    
    @objc func editReminderBtnTapped(_ sender: UIButton) {
        hideShowexistingReminderView()
        guard let indexPath = sender.tableViewIndexPathIn(existingReminderTableView) else {
            return
        }
        let remind = self.serverReminders[indexPath.row]
        for reminder in self.reminders {
            if remind.localIds.contains(reminder.calendarItemExternalIdentifier){
                reminderToBeEdited = reminder
            }
        }
        
        reminderDic["event_name"] = remind.eventName
        reminderDic["start_date"] = remind.startDate
        reminderDic["end_date"] = remind.endDate
        if let startDate = remind.startDate, let enddate = remind.endDate {
            self.buttonStateOnDateBases(startDate: startDate , endDate: enddate)
        }
        reminderDic["reminder_type"] = remind.reminderType
        self.monthlyWeeklyBtnTapped = remind.reminderType == 1 ? .weekly : .monthly
        self.selectedDate = remind.recurringDays
        self.selectedMonthDay = remind.recurringDaymonth
        reminderDic["event_schedule"] = remind.eventSchedule
        
        switch remind.eventSchedule {
        case 1:
            self.scheduleTimeSelection = .once
            reminderDic["eventSchedule"] = self.scheduleTime[0]
        case 2:
            reminderDic["eventSchedule"] = self.scheduleTime[1]
            self.scheduleTimeSelection = .twice
            reminderDic["reminder_time"] = remind.reminderTimeOnce
            reminderDic["reminder_time"] = remind.reminderTimeOnce
            reminderDic["reminder_time2"] = remind.reminderTimeTwice
        default:
            reminderDic["eventSchedule"] = self.scheduleTime[2]
            self.scheduleTimeSelection = .thrice
            reminderDic["reminder_time"] = remind.reminderTimeOnce
            reminderDic["reminder_time2"] = remind.reminderTimeTwice
            reminderDic["reminder_time3"] = remind.reminderTimeTwice
        }
        reminderDic["dosage"] = remind.dosage
        reminderDic["instruction"] = remind.instruction
        if remind.instruction == K_BEFORE_MEAL_TITLE.localized {
            self.selectedInstruction = .beforeMealType
        }else if remind.instruction == K_AFTER_MEAL_TITLE.localized{
            self.selectedInstruction = .afterMeal
        }else if remind.instruction == K_DURING_MEAL_TITLE.localized {
            self.selectedInstruction = .duringMeal
        }else{
            self.selectedInstruction = .none
        }
        
        medicationReminderTableView.reloadData()
    }
    
    @objc func deleteReminderBtnTapped(_ sender: UIButton) {
        guard let indexPath = sender.tableViewIndexPathIn(existingReminderTableView) else {
            return
        }
        self.openDeleteConfirmationPopUp(indexPath)
    }
    
    func getServerReminderId(for localId: String) -> String {
        for serverReminder in serverReminders {
            if serverReminder.localIds.contains(localId) {
                return "\(serverReminder.serverId)"
            }
        }
        fatalError("Must not be possible")
    }
    
    func openDeleteConfirmationPopUp(_ indexPath: IndexPath){
        let confirmationScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        confirmationScene.indexPath = indexPath
        confirmationScene.openConfirmVCFor = .deleteReminder
        confirmationScene.confirmText = K_CANCEL_APPOINTMENT_TITLE.localized
        confirmationScene.deleteReminderDelegate = self
        AppDelegate.shared.window?.addSubview(confirmationScene.view)
        self.addChildViewController(confirmationScene)
    }
}

//MARK:- UITableViewDelegate Methods
//====================================
extension MedicationReminderVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === existingReminderTableView {
            return UITableViewAutomaticDimension
        }
        switch indexPath.row {
        case 2:
            return 90
        case 3:
            let height = self.monthlyWeeklyBtnTapped == .monthly ? 90 : CGFloat.leastNormalMagnitude
            return height
        case 4:
            let height = self.monthlyWeeklyBtnTapped == .weekly ? 100 : CGFloat.leastNormalMagnitude
            return height
        case 0,1,5,6,9:
            return 90
            
        case 7:
            let height = (self.scheduleTimeSelection == .twice) || (self.scheduleTimeSelection == .thrice) ? 50 : CGFloat.leastNormalMagnitude
            return height
        case 8:
            let height = (self.scheduleTimeSelection == .thrice) ? 50 : CGFloat.leastNormalMagnitude
            return height
        case 10:
            return 200
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
}

//MARK:- UITextField Delegate Methods
//===================================
extension MedicationReminderVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let indexPath = textField.tableViewIndexPathIn(self.medicationReminderTableView) else{
            return
        }
        
        switch indexPath.row {
        case 1:
            guard let dateTimeCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? AppointmentDateTimeCell else{
                return
            }
            
            if dateTimeCell.appointmentDateTextField.isFirstResponder {
                DatePicker.openPicker(in: dateTimeCell.appointmentDateTextField, currentDate: Date(), minimumDate: Date(), maximumDate: nil, pickerMode: .date, doneBlock: { (date) in
                    
                    dateTimeCell.appointmentDateTextField.text = date.stringFormDate(.dMMMyyyy)
                    
                    self.reminderDic["start_date"] = date
                    if let endDate = self.reminderDic["end_date"] as? Date{
                        self.buttonStateOnDateBases(startDate: date, endDate: endDate)
                    }
                })
            }else if dateTimeCell.apppointmentTimeTextField.isFirstResponder{
                DatePicker.openPicker(in: dateTimeCell.apppointmentTimeTextField, currentDate: Date(), minimumDate: Date(), maximumDate: nil, pickerMode: .date, doneBlock: { (date) in
                    
                    dateTimeCell.apppointmentTimeTextField.text = date.stringFormDate(.dMMMyyyy)
                    
                    self.reminderDic["end_date"] = date
                    if let startDate = self.reminderDic["start_date"] as? Date{
                        self.buttonStateOnDateBases(startDate: startDate, endDate: date)
                    }
                })
            }
        case 3:
            guard let startDate = self.reminderDic["start_date"] as? Date else {
                showToastMessage(AppMessages.medicationStartDate.rawValue.localized)
                return
            }
            guard let endDate = self.reminderDic["end_date"] as? Date else{
                showToastMessage(AppMessages.medicationEndDate.rawValue.localized)
                return
            }
            var startedDate = startDate
            
            var interval : [String] = []
            while startedDate <= endDate {
                interval.append("\(startedDate.day)")
                startedDate = Calendar.current.date(byAdding: .day, value: 1, to: startedDate)!
            }
            let removeDuplicatesInterval = interval.uniqueElements.sorted(by: {Int($0)! < Int($1)!})
            
            MultiPicker.noOfComponent = 1
            MultiPicker.openPickerIn(textField, firstComponentArray: removeDuplicatesInterval, secondComponentArray: [], firstComponent: textField.text, secondComponent: "", titles: ["Interval"], doneBlock: { (value, _, index, _) in
                
                textField.text = value
                self.selectedMonthDay = Int(value)
            })
        case 5:
            MultiPicker.noOfComponent = 1
            MultiPicker.openPickerIn(textField, firstComponentArray: self.scheduleTime, secondComponentArray: [], firstComponent: textField.text, secondComponent: "", titles: ["Schedule"], doneBlock: { (value, _, index, _) in
                
                textField.text = value
                self.reminderDic["eventSchedule"] = value
                guard let idx = index else{
                    return
                }
                switch idx {
                case 0:
                    self.scheduleTimeSelection = .once
                case 1:
                    self.scheduleTimeSelection = .twice
                case 2:
                    self.scheduleTimeSelection = .thrice
                default:
                    self.scheduleTimeSelection = .none
                }
                self.reminderDic["event_schedule"] = self.scheduleTimeSelection.rawValue
                let indexPath2 = IndexPath.init(row: indexPath.row + 2, section: 0)
                let indexPath3 = IndexPath.init(row: indexPath.row + 3, section: 0)
                self.medicationReminderTableView.reloadRows(at: [indexPath2, indexPath3], with: .automatic)
            })
        case 6,7,8:
            guard let reminderTimeCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? NameOFDrugCell else{
                return
            }
            DatePicker.openPicker(in: reminderTimeCell.cellTextField, currentDate: Date(), minimumDate: nil, maximumDate: nil, pickerMode: .time, doneBlock: { (time) in
                reminderTimeCell.cellTextField.text = time.stringFormDate(.Hmm)
                
                switch indexPath.row {
                case 6:
                    self.reminderDic["reminder_time"] = time
                case 7:
                    self.reminderDic["reminder_time2"] = time
                default:
                    self.reminderDic["reminder_time3"] = time
                }
            })
            
        case 9:
            MultiPicker.noOfComponent = 1
            MultiPicker.openPickerIn(textField, firstComponentArray: self.dosageValues, secondComponentArray: [], firstComponent: textField.text, secondComponent: "", titles: ["Dosage"], doneBlock: { (value, _, index, _) in
                
                textField.text = value
                self.reminderDic["dosage"] = value
            })
            
        default :
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let indexPath = textField.tableViewIndexPathIn(self.medicationReminderTableView) else{
            return true
        }
        
        if indexPath.row == 0{
            delay(0.1, closure: {
                self.reminderDic["event_name"] = textField.text ?? ""
            })
        }
        return true
    }
}
//MARK:- Methods
//==============
extension MedicationReminderVC {
    
    fileprivate func setupUI(){
        
        self.reminderDic["start_date"] = Date()
        self.reminderDic["end_date"] = Date()
        self.reminderDic["instruction"] = self.selectedInstruction.text
        self.reminderDic["reminder_type"] = self.monthlyWeeklyBtnTapped.rawValue
        self.buttonStateOnDateBases(startDate: Date(), endDate: Date())
        
        self.setReminderBtnOutlt.setTitle(K_SET_REMINDER.localized, for: UIControlState.normal)
        self.setReminderBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.setReminderBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.existingReminderImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
        self.existingReminderLabel.text = K_EXISTING_REMINDER.localized
        self.existingReminderLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.existingReminderLabel.textColor = UIColor.grayLabelColor
        self.existingReminderViewOutlt.backgroundColor = UIColor.sepratorColor
        
        let recentViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.recentButtonTapped(_:)))
        self.existingReminderViewOutlt.addGestureRecognizer(recentViewGesture)
        
        let existingReminderContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(existingReminderContainerTapped))
        self.existingReminderContainerView.addGestureRecognizer(existingReminderContainerTapGesture)
        existingReminderContainerView.isUserInteractionEnabled = false
        
        self.medicationReminderTableView.dataSource = self
        self.medicationReminderTableView.delegate = self
        existingReminderTableView.tableFooterView = UIView()
        
        self.registerNibs()
        self.requestAccessToCalendar()
    }
    
    fileprivate func registerNibs(){
        
        let nameOfDrugCellNib = UINib(nibName: "NameOFDrugCell", bundle: nil)
        let recurrenceCellNib = UINib(nibName: "RecurrenceCell", bundle: nil)
        let instructionCellNib = UINib(nibName: "InstructionCell", bundle: nil)
        let dateTimeCellNib = UINib(nibName: "AppointmentDateTime", bundle: nil)
        
        self.medicationReminderTableView.register(nameOfDrugCellNib, forCellReuseIdentifier: "nameOFDrugCellID")
        self.medicationReminderTableView.register(recurrenceCellNib, forCellReuseIdentifier: "recurrenceCellID")
        self.medicationReminderTableView.register(instructionCellNib, forCellReuseIdentifier: "instructionCellID")
        self.medicationReminderTableView.register(dateTimeCellNib, forCellReuseIdentifier: "appointmentDateTimeCellID")
    }
    
    //    MARK: Setup Event Calender
    //    ==========================
    fileprivate func requestAccessToCalendar() {
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            guard granted && (error == nil) else {
                //printlnDebug("Access to store denied")
                return
            }
            self.setEventCalendar()
        }
    }
    
    fileprivate func setEventCalendar() {
        let eventCalenders = eventStore.calendars(for: .reminder)
        for eventCalender in eventCalenders {
            let calendarIdentifier = AppUserDefaults.value(forKey: .eventStoreId, fallBackValue: "")
            if eventCalender.calendarIdentifier == calendarIdentifier.string {
                eventStoreCalendar = eventCalender
                break
            }
        }
        
        if self.eventStoreCalendar == nil {
            let calendar = EKCalendar(for: .reminder, eventStore: self.eventStore)
            calendar.cgColor = UIColor.appColor.cgColor
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
            calendar.title = appName ?? "Mutelcor"
            
            let sourceIdentifier = AppUserDefaults.value(forKey: .eventStoreSourceId, fallBackValue: "")
            var calendarSource: EKSource?
            for source in eventStore.sources {
                if source.sourceIdentifier == sourceIdentifier.string {
                    calendarSource = source
                }
            }
            if let source = calendarSource {
                calendar.source = source
            } else {
                calendar.source = eventStore.defaultCalendarForNewReminders()?.source
                AppUserDefaults.save(value: calendar.source.sourceIdentifier, forKey: .eventStoreSourceId)
            }
            do {
                try eventStore.saveCalendar(calendar, commit: true)
                AppUserDefaults.save(value: calendar.calendarIdentifier, forKey: .eventStoreId)
                eventStoreCalendar = calendar
            } catch let error {
                showToastMessage(error.localizedDescription)
            }
        }
        getExistingReminders(syncing: true)
    }
    
    func getExistingReminders(syncing: Bool) {
        let predicate = eventStore.predicateForReminders(in: [eventStoreCalendar])
        eventStore.fetchReminders(matching: predicate) { reminders in
            self.reminders = reminders ?? []
            self.getServerReminders(syncing: syncing)
            mainQueue {
                self.existingReminderTableView.dataSource = self
                self.existingReminderTableView.delegate = self
            }
        }
    }
    
    func syncAndUpdateReminders() {
        for serverReminder in serverReminders {
            var unsyncedReminder: Reminder? = serverReminder
            for localReminder in reminders {
                if serverReminder.localIds.contains(localReminder.calendarItemExternalIdentifier) {
                    unsyncedReminder = nil
                    if serverReminder.isDeleted {
                        do {
                            try eventStore.remove(localReminder, commit: true)
                        } catch {
                            showToastMessage(error.localizedDescription)
                        }
                    } else if serverReminder.isUpdate {
                        addUpdateServerReminder(serverReminder, existingReminder: localReminder)
                    }
                    continue
                }
            }
            
            if let unwrappedUnsyncedReminder = unsyncedReminder, !unwrappedUnsyncedReminder.isDeleted {
                addUpdateServerReminder(unwrappedUnsyncedReminder, existingReminder: nil)
            }
        }
    }
    
    func addUpdateServerReminder(_ reminder: Reminder, existingReminder: EKReminder?) {
        
        guard let startDate = reminder.startDate,
            let endDate = reminder.endDate,
            let reminderTime = reminder.reminderTimeOnce else {
                return
        }
        var reminderTime2: Date?
        var reminderTime3: Date?
        if let time = reminder.reminderTimeTwice {
            reminderTime2 = time
        }
        if let time = reminder.reminderTimeThrice {
            reminderTime3 = time
        }
        let drugName = reminder.eventName
        let days = reminder.recurringDays
        let schedule = reminder.eventSchedule
        var value : String = ""
        switch schedule {
        case 1:
            value = self.scheduleTime[0]
        case 2:
            value = self.scheduleTime[1]
        default:
            value = self.scheduleTime[2]
        }
        
        let dosage = reminder.dosage
        let instructions = reminder.instruction
        
        setReminder(drugName: drugName, startDate: startDate, endDate: endDate, recurrenceDays: days, schedule: value, reminderTime1: reminderTime, reminderTime2: reminderTime2, reminderTime3: reminderTime3, dosage: dosage, instructions: instructions, existingReminder: existingReminder, serverReminderId: "\(reminder.serverId)", adding: false)
    }
    
    //    MARK:- Button Targets
    //    =====================
    @objc func existingReminderContainerTapped(_ sender: UITapGestureRecognizer) {
        hideShowexistingReminderView()
    }
    
    @objc func toggleBtnSelection(_ sender: IndexedButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setTitleColor(UIColor.white, for: .selected)
            sender.backgroundColor = UIColor.appColor
            sender.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
            selectedDate.insert(sender.outerIndex!)
        }else{
            sender.setTitleColor(UIColor.appColor, for: .selected)
            sender.backgroundColor = UIColor.white
            sender.titleLabel?.font = AppFonts.sansProRegular.withSize(15.9)
            selectedDate.remove(sender.outerIndex!)
        }
    }
    
    @objc fileprivate func weeklyBtnTapped(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            return
        }
        guard let cell = self.medicationReminderTableView.cellForRow(at: indexPath) as? NameOFDrugCell else{
            return
        }
        cell.monthlyBtnOutlt.isSelected = false
        self.monthlyWeeklyBtnTapped = .weekly
        self.reminderDic["reminder_type"] = self.monthlyWeeklyBtnTapped.rawValue
        let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: 0)
        let indexPath2 = IndexPath.init(row: indexPath.row + 2, section: 0)
        self.medicationReminderTableView.reloadRows(at: [indexPath, indexPath1,indexPath2], with: .automatic)
    }
    
    @objc fileprivate func monthlyBtnTapped(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            return
        }
        guard let cell = self.medicationReminderTableView.cellForRow(at: indexPath) as? NameOFDrugCell else{
            return
        }
        cell.weeklyBtnOutlt.isSelected = false
        self.monthlyWeeklyBtnTapped = .monthly
        self.reminderDic["reminder_type"] = self.monthlyWeeklyBtnTapped.rawValue
        let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: 0)
        let indexPath2 = IndexPath.init(row: indexPath.row + 2, section: 0)
        self.medicationReminderTableView.reloadRows(at: [indexPath, indexPath1,indexPath2], with: .automatic)
    }
    
    @objc fileprivate func beforeMealBtnTapped(_ sender : UIButton){
        selectedInstruction = .beforeMealType
        selectReminderInstruction(sender)
    }
    @objc fileprivate func afterMealBtnTapped(_ sender : UIButton){
        selectedInstruction = .afterMeal
        selectReminderInstruction(sender)
    }
    
    @objc fileprivate func duringMealBtnTapped(_ sender : UIButton){
        selectedInstruction = .duringMeal
        selectReminderInstruction(sender)
    }
    
    @objc fileprivate func noneBtnTapped(_ sender : UIButton){
        selectedInstruction = .none
        selectReminderInstruction(sender)
    }
    
    func selectReminderInstruction(_ sender : UIButton) {
        guard !sender.isSelected, let cell = sender.getTableViewCell as? InstructionCell else{
            return
        }
        self.reminderDic["instruction"] = selectedInstruction.text
        cell.setBtnSelected(sender)
    }
    
    @objc fileprivate func recentButtonTapped(_ sender : UITapGestureRecognizer) {
        if self.serverReminders.isEmpty {
            showToastMessage(AppMessages.noExistingReminder.rawValue.localized)
            return
        }
        hideShowexistingReminderView()
    }
    
    func hideShowexistingReminderView() {
        
        let blackColor = UIColor.black
        var height: CGFloat = 0
        var color = blackColor.withAlphaComponent(0)
        switch existingReminderTableViewHeight.constant {
        case 0:
            UIView.animate(withDuration: 0.3, animations: {
                self.existingReminderImage.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            height = 285
            color = blackColor.withAlphaComponent(0.75)
        default:
            UIView.animate(withDuration: 0.3, animations: {
                self.existingReminderImage.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) * 180.0)
            })
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.existingReminderTableViewHeight.constant = height
            self.existingReminderContainerView.backgroundColor = color
            self.view.layoutIfNeeded()
        }, completion: { completed in
            if completed {
                let isEnabled = self.existingReminderContainerView.isUserInteractionEnabled
                self.existingReminderContainerView.isUserInteractionEnabled = !isEnabled
            }
        })
    }
    
    //    Mark:- Set The Reminder
    //    ======================
    fileprivate func setReminder(drugName: String, startDate: Date, endDate: Date, recurrenceDays: Set<Int>, schedule: String, reminderTime1: Date,reminderTime2: Date?,reminderTime3: Date?, dosage: String, instructions: String, existingReminder: EKReminder?, serverReminderId: String?, adding: Bool) {
        var isAdding: Bool = adding
        var reminder: EKReminder!
        var isEdited: Bool = false
        var serverEventId = serverReminderId
        
        if let remindr = existingReminder {
            reminder = remindr
        } else if let remindr = reminderToBeEdited {
            isAdding = false
            isEdited = true
            reminder = remindr
            serverEventId = getServerReminderId(for: remindr.calendarItemExternalIdentifier)
        } else {
            reminder = EKReminder(eventStore: eventStore)
        }
        
        let infoStrings = [schedule, dosage, instructions]
        let info = infoStrings.joined(separator: ", ")
        
        let startDateStr = startDate.stringFormDate(.dMMMyyyy)
        let endDateStr = endDate.stringFormDate(.dMMMyyyy)
        
        let title = "\(drugName) (\(startDateStr) - \(endDateStr)) \(info)"
        
        reminder.title = title
        //reminder.completionDate = endDate
        
        var hours1 = 0
        var minutes1 = 0
        var seconds1 = 0
        
        var hours2: Int?
        var minutes2: Int?
        var seconds2: Int?
        
        var hours3: Int?
        var minutes3: Int?
        var seconds3: Int?
        
        if let hour = reminderTime1.dateComponent().hour {
            hours1 = hour
        }
        if let minute = reminderTime1.dateComponent().minute {
            minutes1 = minute
        }
        if let second = reminderTime1.dateComponent().second {
            seconds1 = second
        }
        
        if let time = reminderTime2, let hour = time.dateComponent().hour {
            hours2 = hour
        }
        if let time = reminderTime2, let minute = time.dateComponent().minute {
            minutes2 = minute
        }
        if let time = reminderTime2, let second = time.dateComponent().second {
            seconds2 = second
        }
        
        if let time = reminderTime3, let hour = time.dateComponent().hour {
            hours3 = hour
        }
        if let time = reminderTime3, let minute = time.dateComponent().minute {
            minutes3 = minute
        }
        if let time = reminderTime3, let second = time.dateComponent().second {
            seconds3 = second
        }
        
        var selectedDate1: Date?
        var selectedDate2: Date?
        var selectedDate3: Date?
        let calenderUnit : Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        if let hour = hours2, let minute = minutes2, let second = seconds2 {
            let dateWithTime = "\(startDate.stringFormDate(.ddmmyy)) \(hour):\(minute):\(second)"
            selectedDate2 = dateWithTime.getDateFromString(.ddmmyyHHmmss, .yyyyMMddHHmmss)
        }
        if let hour = hours3, let minute = minutes3, let second = seconds3 {
            let dateWithTime = "\(startDate.stringFormDate(.ddmmyy)) \(hour):\(minute):\(second)"
            selectedDate3 = dateWithTime.getDateFromString(.ddmmyyHHmmss, .yyyyMMddHHmmss)
        }
        let dateWithTime = "\(startDate.stringFormDate(.ddmmyy)) \(hours1):\(minutes1):\(seconds1)"
        selectedDate1 = dateWithTime.getDateFromString(.ddmmyyHHmmss, .yyyyMMddHHmmss)
        
        if let date = selectedDate1 {
            reminder.startDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            reminder.dueDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
        }
        if let date = selectedDate2 {
            reminder.startDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            reminder.dueDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
        }
        if let date = selectedDate3 {
            reminder.startDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            reminder.dueDateComponents = Calendar.current.dateComponents(calenderUnit, from: date)
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
        }
        
        reminder.calendar = eventStoreCalendar
        
        if self.monthlyWeeklyBtnTapped == .weekly {
            var daysOfWeek = [EKRecurrenceDayOfWeek]()
            
            if !self.selectedDate.isEmpty{
                for value in self.selectedDate {
                    if let day = EKWeekday(rawValue: value) {
                        daysOfWeek.append(EKRecurrenceDayOfWeek(day))
                    }
                }
            }
            reminder.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: daysOfWeek, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endDate))]
        }else{
            guard let day = self.selectedMonthDay else{
                showToastMessage("Schedule day is not selected.")
                return
            }
            let monthDay = NSNumber.init(value: day)
            reminder.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: [monthDay], monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: endDate))]
        }
        
        if isAdding {
            saveReminder(reminder)
            addReminder(id: reminder.calendarItemExternalIdentifier, serverEventId: serverEventId)
        } else if isEdited, let eventID =  serverEventId, let localReminder = reminder{
            saveReminder(localReminder)
            self.editReminderOnServer(serverEventId: eventID, localRemiderId: localReminder.calendarItemExternalIdentifier)
        }else if let serverReminderId = serverEventId {
            saveReminder(reminder)
            updateReminderOnServer(serverEventId: serverReminderId, localRemiderId: reminder.calendarItemExternalIdentifier)
        }
    }
    
    func saveReminder(_ reminder: EKReminder) {
        do {
            try self.eventStore.save(reminder, commit: true)
        } catch( _) {
            //printlnDebug(error.localizedDescription)
        }
    }
    
    func editReminderOnServer(serverEventId: String, localRemiderId: String){
        var parameters: JSONDictionary = self.reminderDic
        parameters["event_id"] = serverEventId
        parameters["google_event_id"] = localRemiderId
        parameters["device_type"] = true.rawValue
        
        let days = selectedDate.map { day in
            return "\(day)"
        }
        if self.monthlyWeeklyBtnTapped == .weekly {
            parameters["recurr_day"] = days.joined(separator: ",")
        }else{
            parameters["recurr_day"] = String(describing: self.selectedMonthDay)
        }
        
        if let time = self.reminderDic["reminder_time"] as? Date, let time2 = self.reminderDic["reminder_time2"] as? Date {
            parameters["reminder_time"] = "\(time)" + "," + "\(time2)"
        }
        if let time = parameters["reminder_time"] as? String, let time3 = self.reminderDic["reminder_time3"] as? Date {
            parameters["reminder_time"] = time + "," + "\(time3)"
        }
        self.setReminderBtnOutlt.startAnimation()
        WebServices.editReminder(parameters: parameters, success: { [weak self] in
            guard let strongSelf = self else{
                return
            }
            strongSelf.setReminderBtnOutlt.stopAnimation(animationStyle: .normal, completion: nil)
        }) {[weak self] (error) in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.setReminderBtnOutlt.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
    
    
    func updateReminderOnServer(serverEventId: String, localRemiderId: String) {
        
        let parameters: JSONDictionary = ["event_id": serverEventId, "google_event_id": localRemiderId]
        //printlnDebug("Added Local Id: \(localRemiderId)")
        
        WebServices.updateMedicationReminders(parameters: parameters, success: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            NSObject.cancelPreviousPerformRequests(withTarget: strongSelf)
            strongSelf.perform(#selector(strongSelf.getExistingRemindersWithoutSync), with: nil, afterDelay: 2.0)
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    fileprivate func buttonStateOnDateBases(startDate: Date ,endDate: Date){
        
        let startDateComponent = startDate.dateComponent().day
        let endDateComponent = endDate.dateComponent().day
        
        if let endDateValue = endDateComponent, let startDateValue = startDateComponent{
            if (endDateValue - startDateValue) < 7, (endDateValue - startDateValue) >= 1{
                self.recurrenceButtonState = .selectedButtonDisplayed
                self.recurrenceButtonstate(startDate, endDate)
            }else if (endDateValue - startDateValue) == 0 {
                self.recurrenceButtonState = .singleButtonDisplayed
                self.recurrenceButtonstate(startDate, endDate)
            }else{
                self.recurrenceButtonState = .allButtonDisplayed
            }
        }
    }
    
    fileprivate func recurrenceButtonstate(_ startDate : Date , _ endDate : Date){
        
        var startedDate = startDate
        
        let orderDescendingResult = Calendar.current.compare(endDate, to: startedDate, toGranularity: .day) == .orderedDescending
        let sameOrderResult = Calendar.current.compare(endDate, to: startedDate, toGranularity: .day) == .orderedSame
        
        self.dateIndex = []
        while orderDescendingResult || sameOrderResult{
            let result = Calendar.current.compare(endDate, to: startedDate, toGranularity: .day)
            
            if result == .orderedDescending{
                let date = startedDate.adding(.day, value: 1)
                self.dateIndex.append(startedDate.dateComponent().weekday!)
                startedDate = date
            } else {
                self.dateIndex.append(startedDate.dateComponent().weekday!)
                break
            }
        }
        let indexPath = IndexPath(row: 4, column: 0)
        self.medicationReminderTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    fileprivate func buttonEnablingState(_ dateIndex : [Int], _ cell : RecurrenceCell){
        
        for button in [cell.sundayBtnOutlt, cell.mondayBtnOutlt, cell.tuesdayBtnOutlt, cell.wednesdayBtnOUtlt, cell.thursdayBtnOutlt, cell.fridayBtnOutlt, cell.saturdayBtnOutlt]{
            
            if dateIndex.contains((button?.outerIndex)!){
                button?.isEnabled = true
                button?.setTitleColor(UIColor.appColor, for: .normal)
                button?.layer.borderColor = UIColor.appColor.cgColor
            } else {
                button?.isEnabled = false
                button?.setTitleColor(UIColor.grayLabelColor, for: .normal)
                button?.layer.borderColor = UIColor.grayLabelColor.cgColor
            }
        }
    }
    
    //    MARK:- WebServices Methods
    //    =========================
    fileprivate func addReminder(id: String, serverEventId: String?) {
        
        var parameters: JSONDictionary = self.reminderDic
        parameters["device_type"] = true.rawValue
        
        let days = selectedDate.map { day in
            return "\(day)"
        }
        if self.monthlyWeeklyBtnTapped == .weekly {
            parameters["recurr_day"] = days.joined(separator: ",")
        }else{
            if let day = self.selectedMonthDay {
                parameters["recurr_day"] = day
            }
        }
        
        parameters["google_event_id"] = id
        
        if let serverEventId = serverEventId {
            parameters["event_id"] = serverEventId
        }
        
        if let time = self.reminderDic["reminder_time"] as? Date, let time2 = self.reminderDic["reminder_time2"] as? Date {
            parameters["reminder_time"] = "\(time)" + "," + "\(time2)"
        }
        if let time = parameters["reminder_time"] as? String, let time3 = self.reminderDic["reminder_time3"] as? Date {
            parameters["reminder_time"] = time + "," + "\(time3)"
        }
        
        self.setReminderBtnOutlt.startAnimation()

        WebServices.addReminder(parameters: parameters,
                                loader : false,
                                success: { [weak self](_ message: String) in
            guard let strongSelf = self else {
                return
            }
            showToastMessage(message)
            strongSelf.reminderDic = [:]
            strongSelf.setReminderBtnOutlt.stopAnimation(animationStyle: .normal, completion: {
                strongSelf.navigationController?.popViewController(animated: true)
                NSObject.cancelPreviousPerformRequests(withTarget: strongSelf)
                strongSelf.perform(#selector(strongSelf.getExistingRemindersWithoutSync), with: nil, afterDelay: 2.0)
            })
        }) {[weak self] (error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setReminderBtnOutlt.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
    
    @objc func getExistingRemindersWithoutSync() {
        getExistingReminders(syncing: false)
    }
    
    fileprivate func getServerReminders(syncing: Bool) {
        var param: [String: Any] = [:]
        param["event_type"] = false.rawValue
        WebServices.getMedicationReminders(parameters: param, success: { [weak self] reminders in
            guard let strongSelf = self else{
                return
            }
            strongSelf.serverReminders = reminders.filter({ (reminder) -> Bool in
                return !reminder.isDeleted
            })
            strongSelf.existingReminderTableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
//            if strongSelf.serverReminders.isEmpty{
//                strongSelf.hideShowexistingReminderView()
//            }
            if syncing {
                strongSelf.syncAndUpdateReminders()
            }
        }){ (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- delegates
//================
extension MedicationReminderVC : EditActivityVCRemove {
    func recentActivityData(_ data: RecentActivityModel) {
        
    }
    
    func removeActivityVC() {
        self.recentBtnTapped = true
    }
}

//MARK:- Table Cell Class
class ExistingReminderCell: UITableViewCell {
    
    // MARK: IBOulets
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var durationPeriodLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    // MARK: Table Cell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()

        editBtn.isHidden = true
        editBtn.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        medicineNameLabel.text = nil
        durationPeriodLabel.text = nil
        infoLabel.text = nil
        
        editBtn.removeTarget(nil, action: nil, for: .allEvents)
        deleteBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARK: Public Methods
    func populate(with reminder: EKReminder) {
        let string = reminder.title ?? ""
        let openingParenthesisRange = string.range(of: "(")
        let closingParenthesisRange = string.range(of: ")")
        
        if let openingRange = openingParenthesisRange, let closingRange = closingParenthesisRange {
            
            let medicineName = string[string.startIndex..<openingRange.lowerBound]
            medicineNameLabel.text = String(medicineName)
            
            let durationPeriod = string[openingRange.upperBound..<closingRange.lowerBound]
            durationPeriodLabel.text = String(durationPeriod)
            
            let info = string[closingRange.upperBound..<string.endIndex]
            infoLabel.text = String(info)
        }
    }
    
    func populateReminder(reminder: [Reminder], indexPath: IndexPath, schedule: [String], eventType: [String]){
        guard !reminder.isEmpty else{
            return
        }
        medicineNameLabel.text = reminder[indexPath.row].eventName
        let startDate = reminder[indexPath.row].startDate?.stringFormDate(.ddMMMYYYY) ?? ""
        let endDate = reminder[indexPath.row].endDate?.stringFormDate(.ddMMMYYYY) ?? ""
        durationPeriodLabel.text = startDate + " - " + endDate
        let scheduleTime = reminder[indexPath.row].eventSchedule
        let type = reminder[indexPath.row].reminderType
        var info = ""
        switch type {
        case 1:
            info = eventType[1]
        default:
            info = eventType[2]
        }
        switch scheduleTime {
        case 1:
            info = info + ", " + schedule[0]
        case 2:
            info = info + ", " + schedule[1]
        default:
            info = info + ", " + schedule[2]
        }

        var pillsText = reminder[indexPath.row].dosage

        if let pillCount = Int(pillsText) {
            if pillCount == 1 {
                pillsText = "\(pillCount) \(K_PILL.localized)"
            } else {
                pillsText = "\(pillCount) \(K_PILLS.localized)"
            }
        }

        infoLabel.text = info + ", " + pillsText + ", " + reminder[indexPath.row].instruction
    }
}

extension MedicationReminderVC: DeleteReminderDelegate {
    
    func deleteReminder(_ indexPath: IndexPath){
        let remind = self.serverReminders[indexPath.row]
        let serverReminderId = remind.serverId
        WebServices.deleteMedicationReminders(serverReminderId: "\(serverReminderId)", success: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.serverReminders.remove(at: indexPath.row)
            strongSelf.remove(reminder: strongSelf.reminders, indexPath: indexPath, serverReminder: remind)
            NSObject.cancelPreviousPerformRequests(withTarget: strongSelf)
            strongSelf.perform(#selector(strongSelf.getExistingRemindersWithoutSync), with: nil, afterDelay: 2.0)
            
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func remove(reminder: [EKReminder], indexPath: IndexPath, serverReminder: Reminder){
        for remind in reminder {
            if serverReminder.localIds.contains(remind.calendarItemExternalIdentifier){
                reminderToBeEdited = remind
                self.removeReminderFromCalendar(remind)
            }
        }
    }
    
    
    func removeReminderFromCalendar(_ reminder: EKReminder) {
        
        do {
            try eventStore.remove(reminder, commit: true)
            if reminder.calendarItemIdentifier == reminderToBeEdited?.calendarItemIdentifier {
                reminderToBeEdited = nil
            }
        } catch {
            showToastMessage("Failed to remove this reminder! Please try again.")
        }
    }
}
