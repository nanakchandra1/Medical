//
//  AppintmentVC.swift
//  Mutelcor
//
//  Created by  on 26/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import QuartzCore
import EventKit

enum AppointmentScreenThrough {
    case reschedule
    case addAppointment
}

protocol AddAppointmentDelegate: class{
    func appointmentAddedSuccessfully()
}

class AddAppointmentVC: BaseViewControllerWithBackButton {
    
    //    MARK:- Proporties
    //    ==================
    fileprivate var appointmentRows = [K_NATURE_OF_APPOINTMENT.localized, K_APPOINTMENT_DATE.localized, K_VISIT_TYPE.localized, K_SYMPTOMS.localized]
    fileprivate let visitRows : [[Any]] = [[#imageLiteral(resourceName: "icAppointmentBlackVideo"), K_VIDEO_CONSULTATION.localized], [#imageLiteral(resourceName: "icAppointmentBlackPhysical"), K_PHYSICAL_CONSULTATION.localized]]
    
    weak var delegate: AddAppointmentDelegate?
    var appointmentDetail = [UpcomingAppointmentModel]()
    var rescheduleDic = [String : Any]()
    var addAppointmentDic = [String : Any]()
    
    var proceedToScreen : AppointmentScreenThrough = .addAppointment
    var selectedTimeSlot = ""
    
    fileprivate var selectedIndex : Int?
    fileprivate var timeSlots = [TimeSlotModel]()
    fileprivate var selectedSlot: TimeSlotModel?
    fileprivate var scheduleID : Int?
    var timeSlotDic = [String : Any]()
    fileprivate var visitType: String = ""
    fileprivate var symptomSelectedArray = [Symptoms]()
    var selectedDay : String = ""
    var selectedDate: Date?
    fileprivate var visitTypeViewFrame : CGRect?
    var symptomsArray = [Symptoms]()
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var addAppointmentTableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var visitTypeView: UIView!
    @IBOutlet weak var visitTypeTableView: UITableView!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.timeSlotsService()
        self.getSymptoms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        let screenName = (proceedToScreen == .addAppointment) ? K_ADD_APPOINTMENT_SCREEN_TITLE.localized : K_RESCHEDULE_APPOINTMENT_SCREEN_TITLE.localized
        self.setNavigationBar(screenTitle: screenName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.submitBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    //    MARK:- IBActions
    //    ================
    @IBAction func submitBtnActn(_ sender: UIButton) {
        
        self.closeVisitTypeView()
        
        guard let appointmentDate = self.addAppointmentDic["appointmentDate"] as? String, !appointmentDate.isEmpty else{
            showToastMessage(AppMessages.selectAppointmentDate.rawValue.localized)
            return
        }
        guard let _ = self.addAppointmentDic["schedule_id"] as? Int else{
            showToastMessage(AppMessages.selectAppointmentTime.rawValue.localized)
            return
        }
        guard let _ = self.addAppointmentDic["appointment_type"] as? Int else{
            showToastMessage(AppMessages.selectVisitType.rawValue.localized)
            return
        }
        guard let symptoms = self.addAppointmentDic["symptomes"] as? String, !symptoms.isEmpty else{
            showToastMessage(AppMessages.selectSymptoms.rawValue.localized)
            return
        }
        if symptoms.contains(K_OTHER_TITLE.localized) {
            guard let specifySymptoms = self.addAppointmentDic["specification"] as? String , !specifySymptoms.isEmpty else{
                showToastMessage(AppMessages.enterSpecifySymptoms.rawValue.localized)
                return
            }
        }
        
        let confirmScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        confirmScene.selectedDay = self.selectedDay
        confirmScene.selectedDate = self.selectedDate
        confirmScene.selectedTime = self.selectedTimeSlot
        confirmScene.addAppointmentDic = self.addAppointmentDic
        
        let confirmationSceneFor : OpenTheConfirmationVCFor = (proceedToScreen == .reschedule) ? .rescheduleAppointment : .appointmentConfirmation
        confirmScene.openConfirmVCFor = confirmationSceneFor
        AppDelegate.shared.window?.addSubview(confirmScene.view)
        self.addChildViewController(confirmScene)
    }
}

//MARK:- UITableViewDataSource
//=============================
extension AddAppointmentVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tableViewRows = (tableView === self.visitTypeTableView) ? self.visitRows.count : self.appointmentRows.count
        return tableViewRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.visitTypeTableView {
            
            guard let visitSelectionCell = tableView.dequeueReusableCell(withIdentifier: "visitTypeSelectionCellID", for: indexPath) as? VisitTypeSelectionCell else{
                fatalError("VisitTypeSelectionCell not found!")
            }
            
            visitSelectionCell.cellLabel.text = self.visitRows[indexPath.row][1] as? String
            visitSelectionCell.cellImage.image = self.visitRows[indexPath.row][0] as? UIImage
            
            if let visitType = self.addAppointmentDic["appointment_type"] as? Int{
                visitSelectionCell.populateData(visitType, indexPath)
            }
            return visitSelectionCell
        }else {
            
            switch indexPath.row {
            case 0:
                guard let natureOfAppointmentCell = tableView.dequeueReusableCell(withIdentifier: "natureOfAppointmentCellID", for: indexPath) as? NatureOfAppointmentCell else{
                    fatalError("NatureOfAppointmentCell not found!")
                }
                
                natureOfAppointmentCell.natureOfAppointmentLabel.text = self.appointmentRows[indexPath.row]
                natureOfAppointmentCell.routineBtn.addTarget(self, action: #selector(routineBtnTapped(_:)), for: .touchUpInside)
                natureOfAppointmentCell.emergencyBtn.addTarget(self, action: #selector(emergencyBtnTapped(_:)), for: .touchUpInside)
                if let severity = self.addAppointmentDic["severity"] as? Int{
                    let severityButton = (severity == true.rawValue) ? natureOfAppointmentCell.emergencyBtn : natureOfAppointmentCell.routineBtn
                    severityButton?.isSelected = true
                }
                return natureOfAppointmentCell
            case 1:
                guard let appointmentDateTimeCell = tableView.dequeueReusableCell(withIdentifier: "appointmentDateTimeCellID", for: indexPath) as? AppointmentDateTimeCell else {
                    fatalError("appointmentDateTimeCell not found!")
                }
                
                appointmentDateTimeCell.appointmentDateTextField.delegate = self
                appointmentDateTimeCell.apppointmentTimeTextField.delegate = self
                
                appointmentDateTimeCell.appointmentTimeBtn.addTarget(self, action: #selector(appointmentTimeBtnTapped), for: .touchUpInside)
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
                if let visitTypeFrame = self.visitTypeViewFrame {
                    let y = visitTypeFrame.origin.y + visitTypeFrame.height
                    self.visitTypeView.frame = CGRect(x: x , y: y, width: self.visitTypeView.frame.width, height: 0)
                }
                visitTypeCell.visitTypeTextFieldBtn.addTarget(self, action: #selector(self.openVisitTypeView), for: UIControlEvents.touchUpInside)
                visitTypeCell.cellTitle.text = self.appointmentRows[indexPath.row]
                visitTypeCell.cellTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
                visitTypeCell.cellTextField.rightViewMode = .always
                visitTypeCell.cellTextField.endEditing(true)
                visitTypeCell.cellTextField.delegate = self
                
                if let appointmentType = self.addAppointmentDic["appointment_type"] as? Int {
                    visitTypeCell.populateApppointmentTypeData(appointmentType, visitTypeArray: self.visitRows)
                }
                
                visitTypeCell.populateAppointmentScheduleData(self.proceedToScreen, upcomingAppointment: self.appointmentDetail)
                return visitTypeCell
            case 3:
                guard let symptomSelectionCell = tableView.dequeueReusableCell(withIdentifier: "symptomsCellID", for: indexPath) as? SymptomsCell else{
                    fatalError("visitTypeCell not found!")
                }
                symptomSelectionCell.cellTitle.text = self.appointmentRows[indexPath.row]
                symptomSelectionCell.addSymptomsBtn.addTarget(self, action: #selector(textViewArrowBtnTapped(sender:)), for: .touchUpInside)
                
                if let symptomes = self.addAppointmentDic["symptomes"] as? String {
                    symptomSelectionCell.symptoms.text = symptomes
                    self.view.endEditing(true)
                }
                
                return symptomSelectionCell
            case 4:
                guard let specifyCell = tableView.dequeueReusableCell(withIdentifier: "selectionCellWithTextViewID", for: indexPath) as? SelectionCellWithTextView else{
                    fatalError("specifyCell not found!")
                }
                
                specifyCell.cellTitle.text = self.appointmentRows[indexPath.row]
                specifyCell.symptomTextView.returnKeyType = .default
                specifyCell.symptomTextView.delegate = self
                
                if let specifyText = self.addAppointmentDic["specification"] as? String {
                    specifyCell.symptomTextView.text = specifyText
                }
                return specifyCell
            default :
                fatalError("Cell Not Found!")
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
            case 0:
                return 80
            case 1:
                return 75
            case 2:
                let height = (self.proceedToScreen == .reschedule) ? 100 : 75
                return CGFloat(height)
            case 3:
                return UITableViewAutomaticDimension
            case 4:
                return 140
            default:
                return CGFloat.leastNormalMagnitude
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView === self.visitTypeTableView {
            self.visitType = (self.visitRows[indexPath.row][1] as? String)!
            let appointmentType  = (indexPath.row == 0 ? true.rawValue : false.rawValue)
            self.addAppointmentDic["appointment_type"] = appointmentType
            self.addAppointmentTableView.reloadData()
            self.closeVisitTypeView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.addAppointmentTableView {
            UIView.animate(withDuration: 0.3, animations: {
                self.visitTypeView.frame = CGRect(x: 0, y: 0, width: 219, height: 0)
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
                
                self.selectedDay = date.stringFormDate(.eeee)
                let dateInString = date.stringFormDate(.dMMMyyyy)
                self.timeSlotDic["check_date"] = date.stringFormDate(.yyyyMMdd)
                appointmentCell.appointmentDateTextField.text = dateInString
                self.addAppointmentDic["appointmentDate"] = dateInString
                self.selectedDate = date
                appointmentCell.apppointmentTimeTextField.text = ""
                self.selectedTimeSlot = ""
                self.addAppointmentDic["schedule_id"] = ""
                
                self.timeSlotsService()
            }
        default:
            fatalError("Cell Not Found!")
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
        delay(0.1, closure: {
            self.addAppointmentDic["specification"] = textView.text
        })
        return true
    }
}

//MARK:- Methods
//===============
extension AddAppointmentVC {
    
    //    MARK: SetupUI
    //    ==============
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        self.doctorNameLabel.text = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(12)
        self.submitBtn.setTitle(K_SUBMIT_BUTTON.localized, for: .normal)
        self.submitBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.submitBtn.setTitleColor(UIColor.white, for: .normal)
        if self.proceedToScreen == .addAppointment {
            self.addAppointmentDic["severity"] = false.rawValue
            self.timeSlotDic["check_date"] = Date().stringFormDate(.yyyyMMdd)
            self.addAppointmentDic["appointmentDate"] = Date().stringFormDate(.dMMMyyyy)
            self.selectedDate = Date()
            self.selectedDay = Date().stringFormDate(.eeee)
        }else{
            if let scheduleID = self.appointmentDetail[0].scheduleID{
                self.addAppointmentDic["appointment_old_slot_id"] = scheduleID
                self.addAppointmentDic["schedule_id"] = scheduleID
                self.scheduleID = scheduleID
            }
            if let appointmentID = self.appointmentDetail[0].appointmentID{
                self.addAppointmentDic["appointment_old_appointment_id"] = appointmentID
            }
            if let appointmentType = self.appointmentDetail[0].appointmentType{
                self.addAppointmentDic["appointment_type"] = appointmentType
            }
            if let severity = self.appointmentDetail[0].appointmentSeverity{
                self.addAppointmentDic["severity"] = severity
            }
            if let date = self.appointmentDetail[0].appointmentDate{
                self.timeSlotDic["check_date"] = date.stringFormDate(.yyyyMMdd)
                self.addAppointmentDic["appointmentDate"] = date.stringFormDate(.dMMMyyyy)
                self.selectedDay = date.stringFormDate(.eeee)
                self.selectedDate = date
            }
            self.addAppointmentDic["specification"] = self.appointmentDetail[0].specification
            self.addAppointmentDic["details"] = self.appointmentDetail[0].appointmentSpecify
            self.addAppointmentDic["symptomes"] = self.appointmentDetail[0].appointmentSymptoms
            self.addAppointmentDic["specification"] = self.appointmentDetail[0].appointmentSpecify
            let startTime = self.appointmentDetail[0].appointmentStartTime ?? ""
            let endTime = self.appointmentDetail[0].appointmentEndTime ?? ""
            self.selectedTimeSlot = "\(startTime) - \(endTime)"
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeVisitTypeView))
        self.addAppointmentTableView.addGestureRecognizer(gesture)
        
        self.view.addSubview(self.visitTypeView)
        self.visitTypeView.isHidden = true
        self.visitTypeTableView.isScrollEnabled = false
        
        self.addAppointmentTableView.dataSource = self
        self.addAppointmentTableView.delegate = self
        self.visitTypeTableView.dataSource = self
        self.visitTypeTableView.delegate = self
        
        self.registerNibs()
        
        // shadow to visitType view
        self.visitTypeView.shadow(1.0, CGSize(width: 1, height: 1), UIColor.black)
    }
    
    //    Register Nibs
    //    ==============
    fileprivate func registerNibs(){
        let natureOfAppointmentNib = UINib(nibName: "NatureOfAppointmentCell", bundle: nil)
        let appointmentDateTimeNib = UINib(nibName: "AppointmentDateTime", bundle: nil)
        let visitTypeNib = UINib(nibName: "VisitTypeCell", bundle: nil)
        let visitSelectionCell = UINib(nibName: "VisitTypeSelectionCell", bundle: nil)
        let symptomTextViewNib = UINib(nibName: "SelectionCellWithTextView", bundle: nil)
        let symptomsCellNib = UINib(nibName: "SymptomsCell", bundle: nil)
        
        self.addAppointmentTableView.register(natureOfAppointmentNib, forCellReuseIdentifier: "natureOfAppointmentCellID")
        self.addAppointmentTableView.register(appointmentDateTimeNib, forCellReuseIdentifier: "appointmentDateTimeCellID")
        self.addAppointmentTableView.register(visitTypeNib, forCellReuseIdentifier: "visitTypeCellID")
        self.addAppointmentTableView.register(symptomTextViewNib, forCellReuseIdentifier: "selectionCellWithTextViewID")
        self.addAppointmentTableView.register(symptomsCellNib, forCellReuseIdentifier: "symptomsCellID")
        self.visitTypeTableView.register(visitSelectionCell, forCellReuseIdentifier: "visitTypeSelectionCellID")
    }
    
    //    MARK: Routine Button Action
    //    ==============================
    @objc fileprivate func routineBtnTapped(_ sender : UIButton){
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
    @objc fileprivate func emergencyBtnTapped(_ sender : UIButton){
        
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
    @objc fileprivate func appointmentTimeBtnTapped(_ sender : UIButton){
        
        self.closeVisitTypeView()
        self.view.endEditing(true)
        
        if !self.timeSlots.isEmpty {
            let symptomsScene = SymptomsVC.instantiate(fromAppStoryboard: .AppointMent)
            if let id = self.scheduleID {
                symptomsScene.selectedScheduleID = id
            }
            symptomsScene.visitTypeTimeSlots = self.timeSlots
            symptomsScene.symptomVCFor = .timeSlots
            if let slot = self.selectedSlot {
                symptomsScene.selectedTimeSlot = slot
            }
            symptomsScene.delegate = self
            symptomsScene.modalPresentationStyle = .overCurrentContext
            self.present(symptomsScene, animated: false, completion: nil)
        }else{
            self.view.endEditing(true)
            showToastMessage(AppMessages.timeSlotsnotFound.rawValue.localized)
        }
    }
    
    //    MARK:- Open VisitType View
    //    ==========================
    @objc fileprivate func openVisitTypeView(){
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
    @objc fileprivate func closeVisitTypeView(){
        
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
    @objc fileprivate func textViewArrowBtnTapped (sender : UIButton){
        
        self.view.endEditing(true)
        self.closeVisitTypeView()
        
        if !self.symptomsArray.isEmpty{
            self.symptomScene()
        }else{
            showToastMessage(AppMessages.noSymptomsAvailiable.rawValue.localized)
        }
    }
    
    fileprivate func symptomScene (){
        let symptomsScene = SymptomsVC.instantiate(fromAppStoryboard: .AppointMent)
        symptomsScene.symptoms = self.symptomsArray
        symptomsScene.symptomVCFor = .symptoms
        symptomsScene.selectedSymptom = self.symptomSelectedArray
        symptomsScene.delegate = self
        symptomsScene.modalPresentationStyle = .overCurrentContext
        self.present(symptomsScene, animated: false, completion: nil)
    }
}

//MARK:- Protocol methods
//=======================
extension AddAppointmentVC : SymptomSelectionProtocol {
    func symptomSelectOnDidSelect(_ symptomArray: [Symptoms]) {
        self.symptomSelectedArray = symptomArray
        var symptomes = ""
        for (i,value) in symptomArray.enumerated(){
            if symptomArray.count - 1 == i {
                symptomes.append("\(value.symptomName ?? "")")
            }else{
                symptomes.append("\(value.symptomName ?? ""), ")
            }
        }
        self.addAppointmentDic["symptomes"] = symptomes
        let lastValue = self.symptomsArray.last?.symptomName
        if symptomes.contains(lastValue!) {
            if self.appointmentRows.last != K_PLEASE_SPECIFY.localized {
                self.appointmentRows.append(K_PLEASE_SPECIFY.localized)
            }
        }else{
            if self.appointmentRows.last == K_PLEASE_SPECIFY.localized {
                self.appointmentRows.removeLast()
            }
        }
        self.addAppointmentTableView.reloadData()
    }
    
    func timeSlotSelectedIndex(_ selectedTimeSlot : TimeSlotModel) {
        self.selectedSlot = selectedTimeSlot
        self.addAppointmentDic["schedule_id"] = selectedTimeSlot.scheduleID
        self.selectedTimeSlot = "\(selectedTimeSlot.startTime ?? "") - \(selectedTimeSlot.slotEndTime ?? "")"
        let index = IndexPath(row: 1, section: 0)
        self.addAppointmentTableView.reloadRows(at: [index], with: .none)
    }
}

//MARk:- Hit Services
//===================
extension AddAppointmentVC {
    
    //    GetTimeSlots
    fileprivate func timeSlotsService(){
        
        self.timeSlotDic["id"] = AppUserDefaults.value(forKey: .userId)
        self.timeSlotDic["doc_id"] = AppUserDefaults.value(forKey: .doctorId)
        WebServices.availiableTimeSlot(parameters: self.timeSlotDic,
                                       success: {[weak self] (timeSlot : [TimeSlotModel], errorCode : Int) in
                                        
                                        guard let addAppointmentVC = self else{
                                            return
                                        }
                                        addAppointmentVC.timeSlots = timeSlot
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    //     getSymptomService
    fileprivate func getSymptoms(){
        
        WebServices.getSymptoms(success:{ [weak self] (symptom : [Symptoms]) in
            guard let addAppointmentVC = self else {
                return
            }
            addAppointmentVC.symptomsArray = symptom
            
            if let symptom = addAppointmentVC.addAppointmentDic["symptomes"] as? String {
                if let lastSymptom = addAppointmentVC.symptomsArray.last{
                    if symptom.contains(lastSymptom.symptomName ?? ""){
                        addAppointmentVC.appointmentRows.append(K_PLEASE_SPECIFY.localized)
                    }else{
                        if addAppointmentVC.appointmentRows.last == K_PLEASE_SPECIFY.localized {
                            addAppointmentVC.appointmentRows.removeLast()
                        }
                    }
                }
                addAppointmentVC.addAppointmentTableView.reloadData()
            }
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- Protocol
//=============
extension AddAppointmentVC : RemoveFromSuperView {
    func removeFromSuperView() {
        guard let nvc = self.navigationController else{
            return
        }
        self.delegate?.appointmentAddedSuccessfully()
        nvc.popViewController(animated: true)
    }
}
