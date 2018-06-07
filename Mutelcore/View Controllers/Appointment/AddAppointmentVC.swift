//
//  AppintmentVC.swift
//  Mutelcore
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON
import QuartzCore

class AddAppointmentVC: BaseViewController {
    
    //    MARK:- Proporties
    //    ==================
    var noOfRows = ["Nature Of Appointment", "Appointment Date", "Visit type", "Symptoms"]
    let visitRows : [[Any]] = [[#imageLiteral(resourceName: "icAppointmentBlackVideo"), "Video Consultation"], [#imageLiteral(resourceName: "icAppointmentBlackPhysical"), "Physical Consultation"]]
    
    var appointmentDetail = [UpcomingAppointmentModel]()
    var rescheduleDic = [String : Any]()
    var addAppointmentDic = [String : Any]()
    
    enum proccedtoScreen {
        
        case reschedule
        case addAppointment
        
    }
    
    var proceedToScreen : proccedtoScreen = .addAppointment
    var selectedTimeSlot = ""
    
    var selectedIndex : Int?
    var timeSlots = [TimeSlotModel]()
    var scheduleID : Int?
    var timeSlotDic = [String : Any]()
    var visitType: String = ""
    var symptomSelectedArray = [String]()
    let viewWidth : CGFloat = 0
    var viewHeight : CGFloat = 0
    
    var selectedDay : String = ""
    var selectedDate : Date!
    var selectedTime : String = ""
    var visitTypeViewFrame : CGRect?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var addAppointmentTableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var visitTypeView: UIView!
    @IBOutlet weak var visitTypeTableView: UITableView!
    
    //    MARK:- VIewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeVisitTypeView))
        
        self.addAppointmentTableView.addGestureRecognizer(gesture)
        
        self.timeSlotsService()
        
        self.view.addSubview(self.visitTypeView)
        self.visitTypeView.isHidden = true
        
        
        self.visitTypeTableView.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.sideMenuBtnActn = .BackBtn
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.submitBtn.gradient(withX: 0, withY: 0, cornerRadius: false)

        self.navigationControllerOn = .dashboard
        
        if proceedToScreen == .addAppointment {
            
            self.setNavigationBar("Add Apppointment", 2, 3)
            
        }else{
           
            self.setNavigationBar("Reschedule Apppointment", 2, 3)
        }
    }
    
    //    MARK:- IBAction
    //    ===============
    @IBAction func submitBtnActn(_ sender: UIButton) {
        
        self.closeVisitTypeView()
        
        guard let appointmentDate = self.addAppointmentDic["appointmentDate"] as? String, !appointmentDate.isEmpty else{
            
            showToastMessage("Please select the appointment date.")
            
            return
        }

        guard let _ = self.addAppointmentDic["schedule_id"] as? Int else{
            
            showToastMessage("Please select the appointment Time.")
            
            return
        }
        guard let _ = self.addAppointmentDic["appointment_type"] as? Int else{
            
            showToastMessage("Please select the visit Type.")
            
            return
        }
        guard let symptoms = self.addAppointmentDic["symptomes"] as? String, !symptoms.isEmpty else{
            showToastMessage("Please select the symptoms.")

            
            return
        }

        if symptoms.contains("Other") {
            
            guard let specifySymptoms = self.addAppointmentDic["Other"] as? String , !specifySymptoms.isEmpty else{
            showToastMessage("Please enter the specify the symptoms")
                
                return
            }
        }
        
        let confirmScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        confirmScene.selectedDay = self.selectedDay
        confirmScene.selectedDate = self.selectedDate
        confirmScene.selectedTime = self.selectedTimeSlot
        confirmScene.addAppointmentDic = self.addAppointmentDic
        
        if proceedToScreen == .reschedule {
            
            confirmScene.openConfirmVCFor = .rescheduleAppointment
        }else{
            
            confirmScene.openConfirmVCFor = .appointmentConfirmation
        }
        
        sharedAppDelegate.window?.addSubview(confirmScene.view)
       
        self.addChildViewController(confirmScene)
        
        confirmScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            confirmScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
        }
    }
}

//MARK:- UITableViewDataSource
//=============================
extension AddAppointmentVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.visitTypeTableView {
            
            return self.visitRows.count
            
        }else{
            
            return self.noOfRows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.visitTypeTableView {
            
            guard let visitSelectionCell = tableView.dequeueReusableCell(withIdentifier: "visitTypeSelectionCellID", for: indexPath) as? VisitTypeSelectionCell else{
                
                fatalError("VisitTypeSelectionCell not found!")
            }
            
            visitSelectionCell.cellLabel.text = self.visitRows[indexPath.row][1] as? String
            
            if let visitType = self.addAppointmentDic["appointment_type"] as? Int{
                
                if visitType == false.rawValue {
                    
                    switch indexPath.row{
                        
                    case 0: visitSelectionCell.contentView.backgroundColor = UIColor.white
                    visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
                    visitSelectionCell.cellImage.image =  #imageLiteral(resourceName: "icAppointmentBlackVideo")
                        
                    case 1: visitSelectionCell.contentView.backgroundColor = UIColor.appColor
                    visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    visitSelectionCell.cellImage.image =  #imageLiteral(resourceName: "icAppointmentWhitePhysical")
                        
                    default: fatalError("Cell Not Found!")
                        
                    }
                    
                }else{
                    
                    switch indexPath.row {
                        
                    case 0: visitSelectionCell.contentView.backgroundColor = UIColor.appColor
                    visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    visitSelectionCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentWhiteVideo")
                        
                    case 1: visitSelectionCell.contentView.backgroundColor = UIColor.white
                    visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
                    visitSelectionCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentBlackPhysical")
                        
                    default: fatalError("Cell Not Found!")
                        
                    }
                }
            }else{
                
                switch indexPath.row{
                    
                case 0: visitSelectionCell.contentView.backgroundColor = UIColor.appColor
                visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                visitSelectionCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentWhiteVideo")
                    
                case 1: visitSelectionCell.contentView.backgroundColor = UIColor.white
                visitSelectionCell.cellLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
                visitSelectionCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentBlackPhysical")
                    
                default: fatalError("Cell Not Found!")
                    
                }
            }
            
            return visitSelectionCell
        }
            
        else {
            
            switch indexPath.row {
                
            case 0: guard let natureOfAppointmentCell = tableView.dequeueReusableCell(withIdentifier: "natureOfAppointmentCellID", for: indexPath) as? NatureOfAppointmentCell else{
                
                fatalError("NatureOfAppointmentCell not found!")
            }
            
            natureOfAppointmentCell.natureOfAppointmentLabel.text = self.noOfRows[indexPath.row]
            
            natureOfAppointmentCell.routineBtn.isSelected = true
            self.addAppointmentDic["severity"] = natureOfAppointmentCell.routineBtn.isSelected ? false.rawValue : true.rawValue
            natureOfAppointmentCell.routineBtn.addTarget(self, action: #selector(routineBtntapped(_:)), for: .touchUpInside)
            
            natureOfAppointmentCell.emergencyBtn.addTarget(self, action: #selector(emergencybtnTapped(_:)), for: .touchUpInside)
            
            if let severity = self.addAppointmentDic["severity"] as? Int{
                
                if severity == true.rawValue {
                    
                    natureOfAppointmentCell.emergencyBtn.isSelected = true
                    
                    
                }else{
                    
                    natureOfAppointmentCell.routineBtn.isSelected = true
                    
                }
            }
            
            return natureOfAppointmentCell
                
            case 1:  guard let appointmentDateTimeCell = tableView.dequeueReusableCell(withIdentifier: "appointmentDateTimeCellID", for: indexPath) as? AppointmentDateTimeCell else {
                
                fatalError("appointmentDateTimeCell not found!")
            }
            
            appointmentDateTimeCell.appointmentDateTextField.delegate = self
            appointmentDateTimeCell.apppointmentTimeTextField.delegate = self
            
            appointmentDateTimeCell.appointmentTimeBtn.addTarget(self, action: #selector(appointmentTimeBtnAction), for: .touchUpInside)
            
            if let date = self.addAppointmentDic["appointmentDate"] as? String {
                
                appointmentDateTimeCell.appointmentDateTextField.text = date
                
            }
            
            appointmentDateTimeCell.apppointmentTimeTextField.text = self.selectedTimeSlot
            
            return appointmentDateTimeCell
                
            case 2:
                
                guard let visitTypeCell = tableView.dequeueReusableCell(withIdentifier: "visitTypeCellID", for: indexPath) as? VisitTypeCell else{
                    
                    fatalError("visitTypeCell not found!")
                }
                
                visitTypeCell.visitTypeTextFieldBtn.isHidden = false
                
                let d = self.addAppointmentTableView.rectForRow(at: indexPath)
                self.visitTypeViewFrame = self.addAppointmentTableView.convert(d, to: self.addAppointmentTableView.superview)
                
                let x = UIDevice.getScreenWidth - self.visitTypeView.frame.width - 15
                let y = self.visitTypeViewFrame!.origin.y + self.visitTypeViewFrame!.height
                self.visitTypeView.frame = CGRect(x: x , y: y, width: self.visitTypeView.frame.width, height: 0)
                
                visitTypeCell.visitTypeTextFieldBtn.addTarget(self, action: #selector(self.openVisitTypeView), for: UIControlEvents.touchUpInside)
                
                visitTypeCell.cellTitle.text = self.noOfRows[indexPath.row]
                visitTypeCell.cellTextField.placeholder = "Choose"
                visitTypeCell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
                visitTypeCell.cellTextField.rightViewMode = .always
                
                visitTypeCell.cellTextField.endEditing(true)
                
                visitTypeCell.cellTextField.delegate = self
                
                if let appointmentType = self.addAppointmentDic["appointment_type"] as? Int{
                    
                    switch appointmentType {
                        
                    case 0: visitTypeCell.cellTextField.text = "Physical Consultation"
                        
                    case 1: visitTypeCell.cellTextField.text = "Video Consultation"
                        
                    default : fatalError("Appointment Type Not Found!")
                    }
                }
                
                if self.proceedToScreen == .addAppointment{
                    
                    visitTypeCell.apppointmentScheduleLabel.isHidden = true
                }else{
                    
                    visitTypeCell.apppointmentScheduleLabel.isHidden = false
                    
                    if !self.appointmentDetail.isEmpty{
                        
                        if let appointmentDate = self.appointmentDetail[0].appointmentDate?.stringFormDate(DateFormat.ddmmyy.rawValue){
                            
                            if let startTime = self.appointmentDetail[0].appointmentStartTime{
                                
                                visitTypeCell.apppointmentScheduleLabel.text = "Appointment already schedule for \(appointmentDate) at \(startTime)"
                                
                            }
                        }else{
                            
                            visitTypeCell.apppointmentScheduleLabel.isHidden = true
                        }
                    }
                }
                
                return visitTypeCell
                
            case 3:
                
                guard let symptomSelectionCell = tableView.dequeueReusableCell(withIdentifier: "selectionCellWithTextViewID", for: indexPath) as? SelectionCellWithTextView else{
                    
                    fatalError("visitTypeCell not found!")
                }
                
                symptomSelectionCell.cellTitle.text = self.noOfRows[indexPath.row]
                symptomSelectionCell.symptomTextView.placeholderText = "Choose"
                
                symptomSelectionCell.arrowButton.addTarget(self, action: #selector(textViewArrowBtnTapped), for: .touchUpInside)
                
                if let symptomes = self.addAppointmentDic["symptomes"] as? String {
                    
                    symptomSelectionCell.symptomTextView.text = symptomes
                    
                    self.view.endEditing(true)
                }
                
                return symptomSelectionCell
                
            case 4: guard let specifyCell = tableView.dequeueReusableCell(withIdentifier: "selectionCellWithTextViewID", for: indexPath) as? SelectionCellWithTextView else{
                
                fatalError("specifyCell not found!")
                
            }
            specifyCell.symptomTextView.delegate = self
            specifyCell.cellTitle.text = self.noOfRows[indexPath.row]
            specifyCell.symptomTextView.returnKeyType = .done
            specifyCell.arrowButton.isHidden = true
            
            return specifyCell
                
            default : fatalError("Cell Not Found!")
                
            }
        }
    }
}

//MARK:- UITableViewDelegate
//==========================
extension AddAppointmentVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView === self.visitTypeTableView{
            
            return 45
            
        }else{
            
            switch indexPath.row{
                
            case 0: return CGFloat(80)
            case 1: return CGFloat(75)
            case 2: if self.proceedToScreen == .reschedule{
                
                return CGFloat(100)
                
            }else{
                
                return CGFloat(75)
                }
                
            case 3: return CGFloat(70)
            case 4: return CGFloat(70)
            default: fatalError("Cell not found!")
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView === self.visitTypeTableView {
            
            self.visitType = (self.visitRows[indexPath.row][1] as? String)!
            
            switch indexPath.row {
                
            case 0: self.addAppointmentDic["appointment_type"] = true.rawValue
                
            case 1: self.addAppointmentDic["appointment_type"] = false.rawValue
                
            default: return
                
            }
            
            let  index = IndexPath(row: 2, section: 0)
            
            self.addAppointmentTableView.reloadRows(at: [index], with: .none)
            
            self.closeVisitTypeView()
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView === self.addAppointmentTableView {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.visitTypeView.frame = CGRect(x: 0, y: self.viewHeight, width: 219, height: 0)
                
            })
        }else{
            
            return
        }
    }
}

//MARK:- UITextFieldDelegate
//==========================
extension AddAppointmentVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.closeVisitTypeView()
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addAppointmentTableView) else{return }
        
        switch indexPath.row {
            
        case 1:
            guard let appointmentCell = self.addAppointmentTableView.cellForRow(at: indexPath) as? AppointmentDateTimeCell else{
                
                return
            }
            
            DatePicker.openPicker(in: appointmentCell.appointmentDateTextField, currentDate: Date(), minimumDate: Date(), maximumDate: nil, pickerMode: .date) { (date) in
                
                self.selectedDay = date.getDayOfWeek()!
                
                let dateInString = date.stringFormDate(DateFormat.dMMMyyyy.rawValue)!
                
                self.timeSlotDic["check_date"] = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)!
                
                appointmentCell.appointmentDateTextField.text = dateInString
                
                self.addAppointmentDic["appointmentDate"] = dateInString
                self.selectedDate = date
                
                self.timeSlotsService()
            }
            
        case 2: return
        case 3,4: return
            
        default: fatalError("Cell Not Found!")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let index = textField.tableViewIndexPathIn(self.addAppointmentTableView)
            else {
                return true
        }
        
        if index.row == 4{
            
            guard let pleaseSpecifyCell = self.addAppointmentTableView.cellForRow(at: index) as? SelectionCellWithTextView else{
                
                return true
            }
            
            pleaseSpecifyCell.resignFirstResponder()
        }
        
        return true
    }
}

//MARK:- UITextViewDelegate Methods
//=================================
extension AddAppointmentVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let index = textView.tableViewIndexPathIn(self.addAppointmentTableView)
            else {
                return true
        }
        
        if index.row == 4{
            
            guard let pleaseSpecifyCell = self.addAppointmentTableView.cellForRow(at: index) as? VisitTypeCell else{
                
                return true
            }
            
            delay(0.1, closure: {
                
                self.addAppointmentDic["Other"] = pleaseSpecifyCell.cellTextField.text
                
            })
        }
        
        return true
    }
}

//MARK:- Methods
//===============
extension AddAppointmentVC {
    
    //    MARK: SetUi
    //    ============
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        
        //        doc Name
        
        self.doctorNameLabel.text = "Dr. \(AppUserDefaults.value(forKey: .doctorName).stringValue)"
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .specification).stringValue
        
        self.addAppointmentTableView.dataSource = self
        self.addAppointmentTableView.delegate = self
        self.visitTypeTableView.dataSource = self
        self.visitTypeTableView.delegate = self
        
        self.registerNibs()
        
        // shadow to visitType view
        self.visitTypeView.shadow(1.0, CGSize(width: 1, height: 1), UIColor.black)
        
        //Gradient
        
        
        //        append Please Specify in no.OF rows
        if let symptom = self.addAppointmentDic["symptomes"] as? String {
            
            if symptom.contains("Other"){
                
                self.noOfRows.append("Please Specify")
                
            }else{
                
                if self.noOfRows.last == "Please Specify" {
                    
                    self.noOfRows.removeLast()
                }
            }
        }
    }
    
    //    Register Nibs
    //    ==============
    fileprivate func registerNibs(){
        
        let natureOfAppointmentNib = UINib(nibName: "NatureOfAppointmentCell", bundle: nil)
        let appointmentDateTimeNib = UINib(nibName: "AppointmentDateTime", bundle: nil)
        let visitTypeNib = UINib(nibName: "VisitTypeCell", bundle: nil)
        let visitSelectionCell = UINib(nibName: "VisitTypeSelectionCell", bundle: nil)
        let symptomTextViewNib = UINib(nibName: "SelectionCellWithTextView", bundle: nil)
        
        self.addAppointmentTableView.register(natureOfAppointmentNib, forCellReuseIdentifier: "natureOfAppointmentCellID")
        self.addAppointmentTableView.register(appointmentDateTimeNib, forCellReuseIdentifier: "appointmentDateTimeCellID")
        self.addAppointmentTableView.register(visitTypeNib, forCellReuseIdentifier: "visitTypeCellID")
        self.addAppointmentTableView.register(symptomTextViewNib, forCellReuseIdentifier: "selectionCellWithTextViewID")
        self.visitTypeTableView.register(visitSelectionCell, forCellReuseIdentifier: "visitTypeSelectionCellID")
        
    }
    
    //    MARK: Routine Button Action
    //    ==============================
    @objc fileprivate func routineBtntapped(_ sender : UIButton){
        
        self.closeVisitTypeView()
        
        guard let index = sender.tableViewIndexPathIn(self.addAppointmentTableView) else{
            
            return
        }
        guard let natureOfAppointmentCell = self.addAppointmentTableView.cellForRow(at: index) as? NatureOfAppointmentCell else{
            
            return
        }
        
        if sender.isSelected { return }
        natureOfAppointmentCell.emergencyBtn.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        
        self.addAppointmentDic["severity"] = sender.isSelected ? false.rawValue : true.rawValue
        
    }
    
    //    MARK: Emergency Button Action
    //    ==============================
    @objc fileprivate func emergencybtnTapped(_ sender : UIButton){
        
        self.closeVisitTypeView()
        
        guard let index = sender.tableViewIndexPathIn(self.addAppointmentTableView) else{
            
            return
        }
        guard let natureOfAppointmentCell = self.addAppointmentTableView.cellForRow(at: index) as? NatureOfAppointmentCell else{
            
            return
        }
        if sender.isSelected { return }
        natureOfAppointmentCell.routineBtn.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        
        self.addAppointmentDic["severity"] = sender.isSelected ? true.rawValue : false.rawValue
        
    }
    
    //    Add Time Button
    //    ===============
    func appointmentTimeBtnAction(_ sender : UIButton){
        
        self.closeVisitTypeView()
        self.view.endEditing(true)
        
        if !self.timeSlots.isEmpty {
            
            let symptomsScene = SymptomsVC.instantiate(fromAppStoryboard: .AppointMent)
            
            if let index = self.selectedIndex {
                
                symptomsScene.selectedSceduledID = self.timeSlots[index].scheduleID
            }
            
            if !self.appointmentDetail.isEmpty{
                
                symptomsScene.selectedSceduledID = self.appointmentDetail[0].scheduleID
            }
            
            symptomsScene.visitTypeTimeSlots = self.timeSlots
            symptomsScene.symptomVCFor = .timeSlots
            
            symptomsScene.delegate = self
            
            symptomsScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                symptomsScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
                self.addChildViewController(symptomsScene)
                
                self.view.addSubview(symptomsScene.view)
                
            }, completion: { (true) in
                
                for childVC in self.childViewControllers{
                    
                    if childVC === symptomsScene{
                        
                    } else {
                        
                        childVC.view.removeFromSuperview()
                        childVC.removeFromParentViewController()
                    }
                }
            })
        }else{
            self.view.endEditing(true)
            
            showToastMessage("TimeSlots Not Found!")
            
        }
    }
    
    //    MARK:- Open VisitType View
    //    ==========================
    func openVisitTypeView(){
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.visitTypeView.isHidden = false
            
            let x = UIDevice.getScreenWidth - self.visitTypeView.frame.width - 15
            let y = self.visitTypeViewFrame!.origin.y + self.visitTypeViewFrame!.height
            
            self.visitTypeView.frame = CGRect(x: x, y: y, width: self.visitTypeView.frame.width, height: 90)
            
            self.view.layoutIfNeeded()
            
        }, completion: { (true) in
            
            for childVC in self.childViewControllers{
                
                if childVC === self.visitTypeView{
                    
                } else {
                    
                    childVC.view.removeFromSuperview()
                    childVC.removeFromParentViewController()
                }
            }
        })
    }
    
    //    MARk:- Close Visit Type View
    //    ============================
    func closeVisitTypeView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            let x = UIDevice.getScreenWidth - self.visitTypeView.frame.width - 15
            let y = self.visitTypeViewFrame!.origin.y + self.visitTypeViewFrame!.height
            
            self.visitTypeView.frame = CGRect(x: x, y: y, width: self.visitTypeView.frame.width, height: 0)
            
        }, completion: { (true) in
            
            self.visitTypeTableView.reloadData()
        })
    }
    
    //    MARK:- TextView Button Tapped
    //    =============================
    @objc fileprivate func textViewArrowBtnTapped (){
        
        self.view.endEditing(true)
        
        self.closeVisitTypeView()
        
        self.getSymptoms()
        
    }
}

//MARK:- Protocol methods
//=======================
extension AddAppointmentVC : SymptomSelectionProtocol {
    
    func symptomSelectOnDidSelect(symptomArray: [String]) {
        
        self.symptomSelectedArray = symptomArray
        
        printlnDebug("symptomArray:\(symptomArray)")
        
        self.addAppointmentDic["symptomes"] = self.symptomSelectedArray.joined(separator: ", ")
        
        if let symptom = self.addAppointmentDic["symptomes"] as? String {
            
            if symptom.contains("Other"){
                
                self.noOfRows.append("Please Specify")
                
                printlnDebug("self.noOfRows: \(self.noOfRows)")
                
            }else{
                
                printlnDebug("self.noOfRows1: \(self.noOfRows)")
                
                if self.noOfRows.last == "Please Specify" {
                    
                    self.noOfRows.removeLast()
                    
                    printlnDebug("self.noOfRows2: \(self.noOfRows)")
                }
            }
        }
        self.addAppointmentTableView.reloadData()
    }
    
    func timeSlotSelectedIndex(selectedIndex: Int) {
        
        self.selectedIndex = selectedIndex
        
        
        self.addAppointmentDic["schedule_id"] = self.timeSlots[selectedIndex].scheduleID
        
        var startTime = ""
        var endTime = ""
        
        if let strtTime = self.timeSlots[selectedIndex].startTime {
            
            startTime = strtTime.dateFString(DateFormat.hhmmssa.rawValue, DateFormat.HHmm.rawValue)!
        }
        
        if let endTim = self.timeSlots[selectedIndex].slotEndTime {
            
            endTime = endTim.dateFString(DateFormat.hhmmssa.rawValue, DateFormat.HHmm.rawValue)!
        }
        
        self.selectedTimeSlot = "\(startTime)-\(endTime)"
        
        let index = IndexPath(row: 1, section: 0)
        
        self.addAppointmentTableView.reloadRows(at: [index], with: .none)
        
    }
}

//MARk:- Hit Services
//===================
extension AddAppointmentVC {
    
    //    GetTimeSlots
    func timeSlotsService(){
        
        self.timeSlotDic["id"] = AppUserDefaults.value(forKey: .userId)
        self.timeSlotDic["doc_id"] = AppUserDefaults.value(forKey: .doctorId)
        
        WebServices.availiableTimeSlot(parameters: self.timeSlotDic,
                                       success: { (timeSlot : [TimeSlotModel], errorCode : Int) in
                                        
                                        printlnDebug(timeSlot)
                                        
                                        self.timeSlots = timeSlot
                                        
                                        if errorCode == 204 {
                                            
                                            showToastMessage("TimeSlots not Found.")
                                           
                                            let index = IndexPath(row: 1, section: 0)
                                            
                                            guard let cell = self.addAppointmentTableView.cellForRow(at: index) as? AppointmentDateTimeCell else{
                                                
                                                return
                                            }
                                            
                                            cell.apppointmentTimeTextField.text = ""
                                            
                                        }
                                        
        }) { (e) in
            
            let str = e.localizedDescription
            
            if str == "TimeSlots not Found."{
                
                let index = IndexPath(row: 1, section: 0)
                guard let cell = self.addAppointmentTableView.cellForRow(at: index) as? AppointmentDateTimeCell else{
                    
                    return
                }
                
                cell.apppointmentTimeTextField.text = ""
                
            }
            
            showToastMessage(str)

        }
    }
    
    //     getSymptomService
    
    func getSymptoms(){
        
        WebServices.getSymptoms(success: { (symptom : [Any]) in
            
            let symptomsScene = SymptomsVC.instantiate(fromAppStoryboard: .AppointMent)
            
            symptomsScene.symptoms = symptom as! [String]
            symptomsScene.symptomVCFor = .symptoms
            
            if let str = self.addAppointmentDic["symptomes"] as? String {
                
                let a = str.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
                
                symptomsScene.selectedSymptom = a
            }
            
            symptomsScene.delegate = self
            
            symptomsScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                symptomsScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
                self.addChildViewController(symptomsScene)
                self.view.addSubview(symptomsScene.view)
                
            }, completion: { (true) in
                
                for childVC in self.childViewControllers{
                    
                    if childVC === symptomsScene{
                        
                    } else {
                        
                        childVC.view.removeFromSuperview()
                        childVC.removeFromParentViewController()
                    }
                }
            })
            
        }) { (e : Error) in
            
            showToastMessage(e.localizedDescription)

        }
    }
}

//MARK:- Protocol
//=============
extension AddAppointmentVC : RemoveFromSuperView {
    
    func removeFromSuperView(_ remove: Bool) {
        
        if remove == true {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
