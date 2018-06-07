//
//  MedicationReminderVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import EventKit

class MedicationReminderVC: BaseViewController {
    //    MARK:- Proporties
    //     ================
    let medicationRows = ["Name of the drug",["Start Date","End Date"],"Recurrence","Schedule","Reminder Time","Dosage","Instructions"] as [Any]
    var recenBtntapped: Bool = true
    var editActivityScene : EditActivityVC!
    var calender = EKCalendar()
    var reminder : [EKReminder]!
    var reminderDic : [String : Any] = [:]
    let alarm = EKAlarm()
    
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var existingReminderViewOutlt: UIView!
    @IBOutlet weak var medicationReminderTableView: UITableView!
    @IBOutlet weak var cancelBtnOult: UIButton!
    @IBOutlet weak var setReminderBtnOutlt: UIButton!
    @IBOutlet weak var existingReminderLabel: UILabel!
    @IBOutlet weak var existingReminderImage: UIImageView!
    
    //    MARK:- ViewController LifeCycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatBtn.isHidden = false
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Medication Reminder", 2, 3)
        self.setReminderBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func setReminderBtnTapped(_ sender: UIButton) {
        
        self.setReminder()
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension MedicationReminderVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.medicationRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0,3,4,5 :
            
            guard let nameOfDrugCell = tableView.dequeueReusableCell(withIdentifier: "nameOFDrugCellID", for: indexPath) as? NameOFDrugCell else{
                
                fatalError("nameOfDrugCell not found!")
            }
            nameOfDrugCell.cellTextField.delegate = self
            nameOfDrugCell.cellTitleOutlt.text = self.medicationRows[indexPath.row] as? String
            
            if indexPath.row == 3{
                
                nameOfDrugCell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
                nameOfDrugCell.cellTextField.rightViewMode = .always
            }else if indexPath.row == 4 {
                
                nameOfDrugCell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
                nameOfDrugCell.cellTextField.rightViewMode = .always
            }else if indexPath.row == 5{
                
                nameOfDrugCell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
                nameOfDrugCell.cellTextField.rightViewMode = .always
            }
            
            return nameOfDrugCell
        case 1:
            
            guard let selectDateCell = tableView.dequeueReusableCell(withIdentifier: "appointmentDateTimeCellID", for: indexPath) as? AppointmentDateTimeCell else{
                
                fatalError("AppointmentDateTimeCell not found!")
            }
            
            selectDateCell.appointmentDateTextField.delegate = self
            selectDateCell.apppointmentTimeTextField.delegate = self
            
            if let medicationDateTime = self.medicationRows[indexPath.row] as? [String] {
                
                selectDateCell.appointmentDateLabel.text = medicationDateTime[0]
                selectDateCell.appointmentTimeLabel.text = medicationDateTime[1]
            }
            
            selectDateCell.appointmentTimeBtn.isHidden = true
            
            return selectDateCell
            
        case 2 :
            
            guard let recurrenceCell = tableView.dequeueReusableCell(withIdentifier: "recurrenceCellID", for: indexPath) as? RecurrenceCell else{
                
                fatalError("recurrenceCell not found!")
            }
            
            recurrenceCell.sundayBtnOutlt.addTarget(self, action: #selector(self.sundayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.mondayBtnOutlt.addTarget(self, action: #selector(self.mondayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.tuesdayBtnOutlt.addTarget(self, action: #selector(self.tuesdayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.wednesdayBtnOUtlt.addTarget(self, action: #selector(self.wednesdayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.thursdayBtnOutlt.addTarget(self, action: #selector(self.thursdayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.fridayBtnOutlt.addTarget(self, action: #selector(self.fridayBtnTapped(_:)), for: .touchUpInside)
            recurrenceCell.saturdayBtnOutlt.addTarget(self, action: #selector(self.saturdayBtnTapped(_:)), for: .touchUpInside)
            
            recurrenceCell.cellTitle.text = self.medicationRows[indexPath.row] as? String
            
            return recurrenceCell
            
        case 6:
            
            guard let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCellID", for: indexPath) as? InstructionCell else{
                
                fatalError("instructionCell not found!")
            }
            
            instructionCell.cellTitleOutlt.text = self.medicationRows[indexPath.row] as? String
            
            instructionCell.beforeMealBtnOutlt.addTarget(self, action: #selector(self.beforeMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.afterMealBtnOutlt.addTarget(self, action: #selector(self.afterMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.duringMealBtnOutlt.addTarget(self, action: #selector(self.duringMealBtnTapped(_:)), for: .touchUpInside)
            instructionCell.noneBtnOutlt.addTarget(self, action: #selector(self.noneBtnTapped(_:)), for: .touchUpInside)
            
            return instructionCell
            
        default : fatalError("Cell Not Found!")
        }
    }
}
//MARK:- UITableViewDelegate Methods
//====================================
extension MedicationReminderVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 0,1,3,4,5 : return 90
            
        case 2: return 150
            
        case 6: return 200
            
        default : return 0
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
                    
                    dateTimeCell.appointmentDateTextField.text = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
                    
                    self.reminderDic["startDate"] = date.dateComponent()
                    
                })
            }else if dateTimeCell.apppointmentTimeTextField.isFirstResponder{
                
                DatePicker.openPicker(in: dateTimeCell.apppointmentTimeTextField, currentDate: Date(), minimumDate: Date(), maximumDate: nil, pickerMode: .date, doneBlock: { (date) in
                    
                    dateTimeCell.apppointmentTimeTextField.text = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
                    self.reminderDic["endDate"] = date.dateComponent()
                    
                })
                
            }
            
        case 3:
            
            MultiPicker.noOfComponent = 1
            
            MultiPicker.openPickerIn(textField, firstComponentArray: [], secondComponentArray: [], firstComponent: textField.text, secondComponent: "", titles: ["Schedule"], doneBlock: { (value, _, index, _) in
                
                textField.text = value
            })
            
        case 4: return
            
        case 5: MultiPicker.noOfComponent = 1
        
        MultiPicker.openPickerIn(textField, firstComponentArray: [], secondComponentArray: [], firstComponent: textField.text, secondComponent: "", titles: ["Schedule"], doneBlock: { (value, _, index, _) in
            
            textField.text = value
        })
            
        default : return
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return true
        }
        
        if indexPath.row == 0{
            
            delay(0.1, closure: {
                
                self.reminderDic["nameOfDrug"] = textField.text ?? ""
            })
        }
       return true
    }
}
//MARK:- Methods
//==============
extension MedicationReminderVC {
    
    fileprivate func setupUI(){
        
        self.cancelBtnOult.setTitle("CANCEL", for: UIControlState.normal)
        self.cancelBtnOult.setTitleColor(UIColor.white, for: .normal)
        self.cancelBtnOult.titleLabel?.font = AppFonts.sanProSemiBold.withSize(22)
        self.cancelBtnOult.backgroundColor = UIColor.grayLabelColor
        
        self.setReminderBtnOutlt.setTitle("SET REMINDER", for: UIControlState.normal)
        self.setReminderBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.setReminderBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(22)
        
        self.existingReminderImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
        self.existingReminderLabel.text = "Existing Reminder"
        self.existingReminderLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.existingReminderLabel.textColor = UIColor.grayLabelColor
        self.existingReminderViewOutlt.backgroundColor = UIColor.gray
        
        let recentViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.recentButtonTapped(_:)))
        self.existingReminderViewOutlt.addGestureRecognizer(recentViewGesture)
        
        self.medicationReminderTableView.dataSource = self
        self.medicationReminderTableView.delegate = self
        
        self.registerNibs()
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
    
    //    MARK:- Button Targets
    //    =====================
    @objc fileprivate func sundayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            recurrenceCell.sundayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.sundayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.sundayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.sundayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            recurrenceCell.sundayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.sundayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.sundayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func mondayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            recurrenceCell.mondayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.mondayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.mondayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.mondayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            recurrenceCell.mondayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.mondayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.mondayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func tuesdayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            recurrenceCell.tuesdayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.tuesdayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.tuesdayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.tuesdayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            recurrenceCell.tuesdayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.tuesdayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.tuesdayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func wednesdayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            recurrenceCell.wednesdayBtnOUtlt.tintColor = UIColor.clear
            recurrenceCell.wednesdayBtnOUtlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.wednesdayBtnOUtlt.backgroundColor = UIColor.appColor
            recurrenceCell.wednesdayBtnOUtlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            recurrenceCell.wednesdayBtnOUtlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.wednesdayBtnOUtlt.backgroundColor = UIColor.white
            recurrenceCell.wednesdayBtnOUtlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func thursdayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            recurrenceCell.thursdayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.thursdayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.thursdayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.thursdayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            recurrenceCell.thursdayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.thursdayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.thursdayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func fridayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            recurrenceCell.fridayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.fridayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.fridayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.fridayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            
            recurrenceCell.fridayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.fridayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.fridayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func saturdayBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicationReminderTableView) else{
            
            return
        }
        
        guard let recurrenceCell = self.medicationReminderTableView.cellForRow(at: indexPath) as? RecurrenceCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            recurrenceCell.saturdayBtnOutlt.tintColor = UIColor.clear
            recurrenceCell.saturdayBtnOutlt.setTitleColor(UIColor.white, for: .selected)
            recurrenceCell.saturdayBtnOutlt.backgroundColor = UIColor.appColor
            recurrenceCell.saturdayBtnOutlt.titleLabel?.font = AppFonts.sansProBold.withSize(19.6)
        }else{
            
            recurrenceCell.saturdayBtnOutlt.setTitleColor(UIColor.appColor, for: .selected)
            recurrenceCell.saturdayBtnOutlt.backgroundColor = UIColor.white
            recurrenceCell.saturdayBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(19.6)
        }
    }
    @objc fileprivate func beforeMealBtnTapped(_ sender : UIButton){
        
        guard let instructionCell = sender.getTableViewCell as? InstructionCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            
        }else{
            
            
        }
    }
    @objc fileprivate func afterMealBtnTapped(_ sender : UIButton){
        
        guard let instructionCell = sender.getTableViewCell as? InstructionCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            
        }else{
            
            
        }
    }
    @objc fileprivate func duringMealBtnTapped(_ sender : UIButton){
        
        guard let instructionCell = sender.getTableViewCell as? InstructionCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            
        }else{
            
            
        }
    }
    @objc fileprivate func noneBtnTapped(_ sender : UIButton){
        
        guard let instructionCell = sender.getTableViewCell as? InstructionCell else{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            
            
        }else{
            
            
        }
    }
    
    @objc fileprivate func recentButtonTapped(_ sender : UITapGestureRecognizer){
        
        let y = self.existingReminderViewOutlt.frame.origin.y + self.existingReminderViewOutlt.frame.height
        
        self.recenBtntapped = !self.recenBtntapped
        
        if self.recenBtntapped {
            self.existingReminderImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
            self.editActivityScene.view.removeFromSuperview()
            self.editActivityScene.removeFromParentViewController()
            
        }else{
            self.existingReminderImage.image = #imageLiteral(resourceName: "icAppointmentCompletedGreen")
            self.editActivityScene = EditActivityVC.instantiate(fromAppStoryboard: .Activity)
            self.editActivityScene.delegate = self
            
            self.editActivityScene.proceedToScreenThrough = .medication
            
            self.addChildViewController(self.editActivityScene)
            self.view.addSubview(self.editActivityScene.view)
            
            self.editActivityScene.view.frame = CGRect(x: 0, y: y, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - y)
            
        }
    }
    
    fileprivate func setReminder(){
        
        let eventStore = EKEventStore()
        
        if let calenderEvent = eventStore.calendar(withIdentifier: "CalenderID"){
            
            printlnDebug(calenderEvent)
            
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = self.reminderDic["nameOfDrug"] as! String
            reminder.startDateComponents = self.reminderDic["startDate"] as? DateComponents
            reminder.dueDateComponents = self.reminderDic["endDate"] as? DateComponents
            
            reminder.calendar = calenderEvent
            printlnDebug(self.reminderDic["startDate"])
            printlnDebug(self.reminderDic["endDate"])
            printlnDebug(self.reminderDic["nameOfDrug"])
            
            do {
                
                try eventStore.save(reminder, commit: true)
                
            }catch(let error){
                printlnDebug(error)
                printlnDebug("Error while creating event")
            }
        }else{
            
            printlnDebug("Calender Event Not Found!")
        }
    }
}

//MARK:- delegates
//================
extension MedicationReminderVC : EditActivityVCRemove {
    func recentActivityData(_ data: RecentActivityModel) {
        
    }
    
    
    func removeActivityVC(_ remove: Bool) {
        
        self.recenBtntapped = remove
    }
}
