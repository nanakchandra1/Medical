//
//  AddSymptomsVC.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class AddSymptomsVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    fileprivate let symptoms = [K_WRITE_SYMPTOMS.localized,[K_STRENGTH.localized, K_FREQUENCY.localized], [K_DATE_TEXT.localized, K_TIME_TEXT.localized]] as [Any]
    fileprivate let strength = [K_MILD_SEVERITIY.localized, K_MODERATE_SEVERITIY.localized, K_SEVERE_SEVERITIY.localized]
    fileprivate let durtaion = ["1 Day","2 Days","3 Days","4 Days","5 Days","6 Days","7 Days","8 Days","9 Days","10 Days"]
    fileprivate var recentSymptoms: [RecentSymptoms] = []
    fileprivate var allSymptoms: [AllSymptoms] = []
    fileprivate var saveSymptomsDic: [String: Any] = [:]
    fileprivate let currentDate = Date()
    fileprivate var navigateToSearchScreenThrough: NavigateToSearchScreenThrough = .all
    fileprivate var symptomName : String?
    fileprivate var recentBtnTapped = false
    var selectedSymptoms: [AllSymptoms] = []
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var addSymptomsTableView: UITableView!
    @IBOutlet weak var submitBtnOutlt: TransitionButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.getRecentSymptoms()
        self.getAllSymptoms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_ADD_SYMPTOMS_TITLE.localized)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.submitBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
//    MARK:- IBActions
//    ================
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        guard let symptomID = self.saveSymptomsDic["symptom_id"] as? String, !symptomID.isEmpty else{
            showToastMessage(AppMessages.emptySymptoms.rawValue.localized)
            return
        }
        guard let symptomDate = self.saveSymptomsDic["symptom_date"] as? String, !symptomDate.isEmpty else{
            showToastMessage(AppMessages.emptySymptomDate.rawValue.localized)
            return
        }
        guard let symptomTime = self.saveSymptomsDic["symptom_time"] as? String, !symptomTime.isEmpty else{
            showToastMessage(AppMessages.emptySymptomTime.rawValue.localized)
            return
        }
        guard let _ = self.saveSymptomsDic["symptom_severity"] as? Int else{
            showToastMessage(AppMessages.emptySymptomSeverity.rawValue.localized)
            return
        }
        guard let symptomFrequency = self.saveSymptomsDic["symptom_frequency"] as? String, !symptomFrequency.isEmpty else{
            showToastMessage(AppMessages.emptySymptomDuration.rawValue.localized)
            return
        }
        self.saveSymptoms()
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension AddSymptomsVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = (section == 0) ? self.symptoms.count : self.recentSymptoms.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
                
            case 0:
                guard let writeSymptomCell = tableView.dequeueReusableCell(withIdentifier: "visitTypeCellID", for: indexPath) as? VisitTypeCell else {
                    fatalError("Cell Not Found!")
                }
                writeSymptomCell.visitTypeTextFieldBtn.isHidden = false
                writeSymptomCell.apppointmentScheduleLabel.isHidden  = true
                writeSymptomCell.cellTitle.text = self.symptoms[indexPath.row] as? String
                writeSymptomCell.stackViewLeadingConstraint.constant = 19
                writeSymptomCell.stackViewTrailingConstraint.constant = 19
                writeSymptomCell.visitTypeTextFieldBtn.addTarget(self, action: #selector(self.writeSymptomsBtnTapped(_:)), for: .touchUpInside)
                if let symptomName = self.symptomName, !symptomName.isEmpty {
                   writeSymptomCell.cellTextField.text = symptomName
                }
                
                return writeSymptomCell
                
            case 1,2:
                guard let dateTimeCell = tableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else {
                    fatalError("Cell Not Found!")
                }
                
                dateTimeCell.separatorView.isHidden = true
                dateTimeCell.selectDateTextField.borderStyle = .none
                dateTimeCell.selectTimeTextField.borderStyle = .none
                dateTimeCell.selectDateTextField.delegate = self
                dateTimeCell.selectTimeTextField.delegate = self
                
                if indexPath.row == 1{
                    dateTimeCell.selectDateLabel.text = K_STRENGTH.localized
                    dateTimeCell.selectTimeLabel.text = K_FREQUENCY.localized
                    
                    dateTimeCell.selectDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentDownarrow"))
                    dateTimeCell.selectDateTextField.rightViewMode = UITextFieldViewMode.always
                    dateTimeCell.selectTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentDownarrow"))
                    dateTimeCell.selectTimeTextField.rightViewMode = UITextFieldViewMode.always
                    dateTimeCell.selectTimeTextField.text = self.saveSymptomsDic["symptom_frequency"] as? String
                    
                    if let severity = self.saveSymptomsDic["symptom_severity"] as? Int{
                        switch severity {
                        case 1:
                            dateTimeCell.selectDateTextField.text = self.strength[0]
                        case 2:
                            dateTimeCell.selectDateTextField.text = self.strength[1]
                        case 3:
                            dateTimeCell.selectDateTextField.text = self.strength[2]
                        default:
                            fatalError("Severity Not Found!")
                        }
                    }
                }else{
                    dateTimeCell.selectDateLabel.text = K_DATE_TEXT.localized
                    dateTimeCell.selectTimeLabel.text = K_TIME_TEXT.localized
                    let selectedDate = self.saveSymptomsDic["symptom_date"] as? String
                    let selectedTime = self.saveSymptomsDic["symptom_time"] as? String
                    
                    dateTimeCell.selectDateTextField.text = selectedDate?.changeDateFormat(.yyyyMMdd, .dMMMyyyy)
                    dateTimeCell.selectTimeTextField.text = selectedTime
                }

                return dateTimeCell
                
            default :
                fatalError("Cell Not Found!")
            }
            
        case 1:
            guard let recentSymptomCell = tableView.dequeueReusableCell(withIdentifier: "recentNutritionTableCellID", for: indexPath) as? RecentNutritionTableCell else {
                fatalError("Cell Not Found!")
            }
            
            recentSymptomCell.addRecentNutritionBtn.addTarget(self, action: #selector(self.recentSymptomsBtnTapped(_:)), for: .touchUpInside)
            recentSymptomCell.populateData(self.recentSymptoms, indexPath, self.strength)
            return recentSymptomCell
            
        default : fatalError("Section not Found!")
        }
    }
}

//MARk:- UITableViewDelegate Methods
//===================================
extension AddSymptomsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let recentSectionHeight = (recentBtnTapped) ? 0 : 60
        let height = (indexPath.section == 0) ? 80 : recentSectionHeight
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("Table header not found")
        }
        
        sectionHeaderViewCell.headerLabelLeading.constant = 25
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(16)
        sectionHeaderViewCell.headerTitle.text = K_MY_RECENT.localized
        sectionHeaderViewCell.cellBackgroundView.backgroundColor = UIColor.headerColor
        
        let image = recentBtnTapped ? #imageLiteral(resourceName: "icLogbookUparrowGreen") : #imageLiteral(resourceName: "icActivityplanGreendropdown")
        sectionHeaderViewCell.dropDownBtn.setImage(image, for: .normal)
        sectionHeaderViewCell.dropDownBtn.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
        
        return sectionHeaderViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
            
        case 0:
            return CGFloat.leastNormalMagnitude
            
        default:
            let heightForHeader = (recentSymptoms.isEmpty) ? CGFloat.leastNormalMagnitude : 50
            return heightForHeader
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            return
        case 1:
            self.addRecentSymptoms(indexPath)
        default:
            return
        }
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension AddSymptomsVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addSymptomsTableView) else{
            return
        }
        guard let dateTimeCell = textField.getTableViewCell as? SelectDateCell else{
            return
        }
        MultiPicker.noOfComponent = 1
        switch indexPath.row {
        case 1:
            if dateTimeCell.selectDateTextField.isFirstResponder {
                MultiPicker.openPickerIn(textField, firstComponentArray: self.strength, secondComponentArray: [], firstComponent: "", secondComponent: "", titles: ["Severity"], doneBlock: { (result, _, index, _) in
                    textField.text = result
                    self.saveSymptomsDic["symptom_severity"] = index! + 1
                })
            }else{
                MultiPicker.openPickerIn(textField, firstComponentArray: self.durtaion, secondComponentArray: [], firstComponent: "", secondComponent: "", titles: ["Duration"], doneBlock: { (result, _, index, _) in
                    textField.text = result
                    self.saveSymptomsDic["symptom_frequency"] = result
                })
            }
        case 2:
            DatePicker.openPicker(in: dateTimeCell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: .date) { (date) in
                
                dateTimeCell.selectDateTextField.text = date.stringFormDate(.dMMMyyyy)
                self.saveSymptomsDic["symptom_date"] = date.stringFormDate(.yyyyMMdd)
            }
            
            DatePicker.openPicker(in: dateTimeCell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: .time) { (date) in
                dateTimeCell.selectTimeTextField.text = date.stringFormDate(.Hmm)
                self.saveSymptomsDic["symptom_time"] = date.stringFormDate(.Hmm)
            }
        default:
            return
        }
    }
}

//MARK:- Methods
//===============
extension AddSymptomsVC {
    
    fileprivate func setupUI(){
        
        self.addSymptomsTableView.dataSource = self
        self.addSymptomsTableView.delegate = self
        self.submitBtnOutlt.setTitle(K_SUBMIT_BUTTON.localized, for: .normal)
        self.submitBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.submitBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15)
        self.saveSymptomsDic["symptom_date"] = currentDate.stringFormDate(.yyyyMMdd)
        self.saveSymptomsDic["symptom_time"] = currentDate.stringFormDate(.Hmm)
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let visitTypeCellNib = UINib(nibName: "VisitTypeCell", bundle: nil)
        self.addSymptomsTableView.register(visitTypeCellNib, forCellReuseIdentifier: "visitTypeCellID")
        
        let dateTimeCellNib = UINib(nibName: "SelectDateCell", bundle: nil)
        self.addSymptomsTableView.register(dateTimeCellNib, forCellReuseIdentifier: "selectDateCellID")
        
        let attachmentHeaderViewNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        self.addSymptomsTableView.register(attachmentHeaderViewNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        
        let recentSymptomCellNib = UINib(nibName: "RecentNutritionTableCell", bundle: nil)
        self.addSymptomsTableView.register(recentSymptomCellNib, forCellReuseIdentifier: "recentNutritionTableCellID")
    }
    
    @objc fileprivate func writeSymptomsBtnTapped(_ sender : UIButton){
        self.navigateToSearchScreenThrough = .all
        self.presentSearchScreen(self.navigateToSearchScreenThrough)
    }
    
    @objc fileprivate func dropDownTapped(_ sender: UIButton) {
        self.recentBtnTapped = !self.recentBtnTapped
        self.addSymptomsTableView.reloadSections([1], with: .automatic)
    }
    
    @objc fileprivate func recentSymptomsBtnTapped(_ sender : UIButton){
        guard let indexPath = sender.tableViewIndexPathIn(self.addSymptomsTableView) else{
            return
        }
        self.addRecentSymptoms(indexPath)
    }
    
    func addRecentSymptoms(_ indexPath: IndexPath){
        self.symptomName = self.recentSymptoms[indexPath.row].symptomName
        self.saveSymptomsDic["symptom_id"] = self.recentSymptoms[indexPath.row].symptomId
        let date = self.recentSymptoms[indexPath.row].symptomDate
        self.saveSymptomsDic["symptom_date"] = date?.changeDateFormat(.utcTime, .yyyyMMdd)
        self.saveSymptomsDic["symptom_time"] = self.recentSymptoms[indexPath.row].symptomTime
        self.saveSymptomsDic["symptom_severity"] = self.recentSymptoms[indexPath.row].symptomSeverity
        self.saveSymptomsDic["symptom_frequency"] = self.recentSymptoms[indexPath.row].symptomFrequency
        self.addSymptomsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    fileprivate func presentSearchScreen(_ navigateToScreen : NavigateToSearchScreenThrough){
        
        if !self.allSymptoms.isEmpty {
            let searchSymptomScene = SymptomsSearchVC.instantiate(fromAppStoryboard: .Symptoms)
            searchSymptomScene.navigateToSearchScreenThrough = navigateToScreen
            searchSymptomScene.delegate = self
            if let id = self.saveSymptomsDic["symptom_id"] as? String, !id.isEmpty {
            searchSymptomScene.symptomID = id
            }
            searchSymptomScene.allSymptoms = self.allSymptoms
            AppDelegate.shared.window?.addSubview(searchSymptomScene.view)
            self.addChildViewController(searchSymptomScene)
        }else{
            showToastMessage("Symptoms not Found!")
        }
    }
    
    //    MARK:- WebServices
    //    ==================
    fileprivate func getRecentSymptoms(){
        
        WebServices.getRecentSymptoms(success: {[weak self] (_ recentSymptoms : [RecentSymptoms]) in
            
            guard let addSymptomsVC = self else{
                return
            }
            addSymptomsVC.recentSymptoms = recentSymptoms
            addSymptomsVC.addSymptomsTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func saveSymptoms(){
        
        self.submitBtnOutlt.startAnimation()
        WebServices.saveSymptoms(parameters: self.saveSymptomsDic, success: {[weak self]() in
            guard let addSymptomsVC = self else{
                return
            }
            addSymptomsVC.submitBtnOutlt.stopAnimation(animationStyle: .normal,completion: {
                addSymptomsVC.saveSymptomsDic = [:]
                addSymptomsVC.symptomName = ""
                
                addSymptomsVC.addSymptomsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                addSymptomsVC.getRecentSymptoms()
            })
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getAllSymptoms(){
        
        WebServices.getAllSymptoms(success: {[weak self] (_ allSymptoms : [AllSymptoms]) in
            guard let addSymptomsVC = self else{
                return
            }
            addSymptomsVC.allSymptoms = allSymptoms
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- SearchDataDelegate protocol
//==================================
extension AddSymptomsVC : SearchDataDelegate {
    
    func searchData(_ selectedData : [AllSymptoms]){
        if selectedData.isEmpty {
            self.saveSymptomsDic["symptom_id"] = ""
            self.symptomName = ""
        } else {
            self.selectedSymptoms = selectedData
            let symptomName = selectedData.map {$0.symptomName ?? ""}.joined(separator: ", ")
            let symptomID = selectedData.map { (symptom) -> String in
                if let id = symptom.symptomId {
                    return String(id)
                }
                return " "
                }.joined(separator: ",")
            
            self.saveSymptomsDic["symptom_id"] = symptomID
            self.symptomName = symptomName
        }
        self.addSymptomsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

