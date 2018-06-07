//
//  AddActivityVC.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//


import UIKit
import TransitionButton

enum DistanceUnit : String {
    case kms = "kms"
    case miles = "miles"
}
enum DurationUnit : String {
    case mins = "mins"
    case hours = "hours"
}
enum IntensityValue : String {
    case high = "intensity3"
    case moderate = "intensity2"
    case low = "intensity1"
}
enum OnAddActivityScreenBy {
    case connectedDevices
    case others
}

class AddActivityVC: BaseViewControllerWithBackButton {

    //    MARK:- Proporties
    //    ==================
    fileprivate var editActivityScene: EditActivityVC!
    fileprivate var addActivityDic = [String: Any]()
    fileprivate let durationUnit = [K_DURATION_UNIT_MINS.localized,K_DURATION_UNIT_HOURS.localized]
    fileprivate let distanceUnit = [K_KILOMETERS_UNIT.localized,K_DISTANCE_UNIT_MILES.localized]
    fileprivate let intensityValues = ["Low","Moderate","High"]
    fileprivate var activityName = [String]()
    fileprivate var totalDuration = 0.0
    fileprivate var totalDistance = 0.0
    fileprivate var totalCalories = 0.0
    fileprivate var activityFormModel = [ActivityFormModel]()
    fileprivate var recentActivityData = [RecentActivityModel]()
    fileprivate var distanceValue = DistanceUnit.kms
    fileprivate var durationValue = DurationUnit.mins
    fileprivate var intensityValue = IntensityValue.low
    var calculatedValues: [CalculatedValue] = []
    var connectDeviceData: JSONDictionary = [:]
    fileprivate var insertIdAt: Int = 0
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var myRecentBtnOutlt: UIButton!
    @IBOutlet weak var myRecentArrowImage: UIImageView!
    @IBOutlet weak var addActivityTableView: UITableView!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var saveBtnOutlt: UIButton!
    @IBOutlet weak var recentBtnLabel: UILabel!
    @IBOutlet weak var transitionView: TransitionButton!
    
    //    MARK:- ViewController LifeCycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_ADD_ACTIVITY_SCREEN_TITLE.localized)
        
        self.getActivityFormData()
        self.getRecentActivity()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cancelBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)    
        self.saveBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    
    //    MARK:- IBActions
    //    ================
    @IBAction func myRecentBtnTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        let y = self.myRecentBtnOutlt.frame.origin.y + self.myRecentBtnOutlt.frame.height
        if sender.isSelected{
            self.editActivityScene = EditActivityVC.instantiate(fromAppStoryboard: .Activity)
            self.editActivityScene.delegate = self
            self.editActivityScene.recentActivityData = self.recentActivityData
            self.addChildViewController(self.editActivityScene)
            self.view.addSubview(self.editActivityScene.view)
            self.myRecentArrowImage.image = #imageLiteral(resourceName: "icLogbookUparrowGreen")
            self.editActivityScene.view.frame = CGRect(x: 0, y: y, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - y)
        }else{
            self.myRecentArrowImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
            self.editActivityScene.view.removeFromSuperview()
            self.editActivityScene.removeFromParentViewController()
        }
    }
    
    @IBAction func CancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        var activityType = [Any]()
        var dic = [String : Any]()
        for calculatedValue in self.calculatedValues {
                        guard calculatedValue.activity != 0 else{
                            showToastMessage(AppMessages.selectActivityType.rawValue.localized)
                            return
                        }
                        guard calculatedValue.duration != 0 else{
                            showToastMessage(AppMessages.enterDuration.rawValue.localized)
                            return
                        }
                        guard calculatedValue.calories != 0 else{
                            showToastMessage(AppMessages.enterCalories.rawValue.localized)
                            return
                        }
                        guard calculatedValue.steps != 0 else {
                            showToastMessage(AppMessages.enterSteps.rawValue.localized)
                            return
                        }
                        guard calculatedValue.distance != 0 else{
                            showToastMessage(AppMessages.enterDistance.rawValue.localized)
                            return
                        }
            dic["activity_id"]   = calculatedValue.activity
            dic["duration_unit"]    = calculatedValue.durationType.rawValue
            dic["duration"]         = calculatedValue.duration
            dic["intensity"]        = calculatedValue.intensityType.rawValue
            dic["calories"]         = calculatedValue.calories
            dic["steps"]            = calculatedValue.steps
            dic["distance_unit"]    = calculatedValue.distanceType.rawValue
            dic["distance"]         = calculatedValue.distance
            
            activityType.append(dic)
        }
        let activityValue = typeJSONArray(activityType as! [[String : Any]], dicKey: "activity_type")
        self.addActivityDic["activity_type"] = activityValue["activity_type"]
        guard let date = self.addActivityDic["activity_date"] as? Date else{
            showToastMessage(AppMessages.selectActivityDate.rawValue.localized)
            return
        }
        guard let time = self.addActivityDic["activity_time"] as? Date else{
            showToastMessage(AppMessages.selectActivityTime.rawValue.localized)
            return
        }
        
        self.addActivityDic["device_type"] = ActivityData.manual.rawValue
        var param: JSONDictionary = self.addActivityDic
        param["activity_date"] = date.stringFormDate(.yyyyMMdd)
        param["activity_time"] = time.stringFormDate(.Hmm)
        self.addActivity(parameters: param)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension AddActivityVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let sections = (section == false.rawValue) ? self.calculatedValues.count : 3
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.section == 0{
            guard let activityCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as? ActivityCell else{
                fatalError("Activity Cell Not Found!")
            }
            activityCell.deleteActivityBtnOutlet.addTarget(self, action: #selector(self.deleteBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            activityCell.selectActivityTextField.delegate = self
            activityCell.durationTextField.delegate = self
            activityCell.durationUnitTextField.delegate = self
            activityCell.intensityTextField.delegate = self
            activityCell.distanceTextField.delegate = self
            activityCell.distanceUnitTextField.delegate = self
            activityCell.stepsTextField.delegate = self
            activityCell.caloriestextField.delegate = self
            
            activityCell.populateActivityData(calculatedValue: self.calculatedValues, activityFormData: self.activityFormModel, intensityValues: self.intensityValues, distanceUnit: self.distanceUnit, durationUnit: self.durationUnit, indexPath: indexPath)
            
            return activityCell
        }else{
            
            switch indexPath.row{
            case 0:
                guard let addActivityCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "addActivityCellID", for: indexPath) as? AddActivityCell else{
                    fatalError("AddActivityCell Cell Not Found!")
                }
                
                addActivityCell.addActivityBtn.addTarget(self, action: #selector(self.addActivityBtnTapped(_:)), for: UIControlEvents.touchUpInside)
                
                let isAddActivityBtnHidden = (self.calculatedValues.count > 3) ? true : false
                addActivityCell.addActivityBtn.isHidden = isAddActivityBtnHidden
                
                return addActivityCell
                
            case 1:
                guard let selectDateCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else{
                    fatalError("selectDateCell Cell Not Found!")
                }
                selectDateCell.populateActivityData(dic: self.addActivityDic)

                if !(selectDateCell.selectDateTextField.delegate is AddActivityVC) {
                    selectDateCell.selectDateTextField.delegate = self
                    selectDateCell.selectTimeTextField.delegate = self
                }
                return selectDateCell
                
            case 2:
                guard let durationDistanceCaloriesUnitCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "durationDistanceCaloriesUnitCellID", for: indexPath) as? DurationDistanceCaloriesUnitCell else{
                    fatalError("AddActivityCell Cell Not Found!")
                }
                durationDistanceCaloriesUnitCell.populateData(self.totalDuration, self.totalDistance, self.totalCalories)
                return durationDistanceCaloriesUnitCell
            default:
                fatalError("Cell Not Found!")
                
            }
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension AddActivityVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 353
        }else{
            switch indexPath.row {
            case 0:
                return 70
            case 1:
                return 100
            case 2:
                return 70
            default:
                return CGFloat.leastNormalMagnitude
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

//MARK:- UITextFieldDelegate Methods
//===================================
extension AddActivityVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        guard let indexPath = textField.tableViewIndexPathIn(self.addActivityTableView) else{
            return
        }
        if indexPath.section == 0 {
            guard let cell = textField.getTableViewCell as? ActivityCell else{
                return
            }
            
            MultiPicker.noOfComponent = 1
            if textField === cell.selectActivityTextField{
                MultiPicker.openPickerIn(cell.selectActivityTextField, firstComponentArray: self.activityName, secondComponentArray: [], firstComponent: cell.selectActivityTextField.text, secondComponent: "", titles: ["Activity"]) { (value, _, index, _) in
                    
                    let activityID = self.activityFormModel[index!].activityID
                    self.calculatedValues[indexPath.row].changeActivity(activityID!, self.activityFormModel, index!)
                    self.addActivityTableView.reloadData()
                }
            }else if textField === cell.durationUnitTextField {
                MultiPicker.openPickerIn(cell.durationUnitTextField, firstComponentArray: self.durationUnit, secondComponentArray: [], firstComponent: cell.durationUnitTextField.text, secondComponent: "", titles: ["Units"]) { (value, _, Index, _) in
                    
                    let durationUnit = (Index == 0) ? DurationUnit.mins : DurationUnit.hours
                    self.durationValue = durationUnit
                    self.calculatedValues[indexPath.row].changeDurationType(durationUnit, self.activityFormModel)
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }else if textField === cell.intensityTextField{
                MultiPicker.openPickerIn(cell.intensityTextField, firstComponentArray: self.intensityValues, secondComponentArray: [], firstComponent: cell.intensityTextField.text, secondComponent: "", titles: ["Intensity"]) { (value, i, Index, _) in
                    
                    if Index == 0{
                        self.intensityValue = IntensityValue.low
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.low, self.activityFormModel)
                    }else if Index == 1{
                        self.intensityValue = IntensityValue.moderate
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.moderate, self.activityFormModel)
                    }else{
                        self.intensityValue = IntensityValue.high
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.high, self.activityFormModel)
                    }
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }else if textField === cell.distanceUnitTextField {
                
                MultiPicker.openPickerIn(cell.distanceUnitTextField, firstComponentArray: self.distanceUnit, secondComponentArray: [], firstComponent: cell.distanceUnitTextField.text, secondComponent: "", titles: ["Units"]) { (value, _, Index, _) in
                    let distanceUnit = (Index == 0) ? DistanceUnit.kms : DistanceUnit.miles
                    self.distanceValue = distanceUnit
                    self.calculatedValues[indexPath.row].changeDistanceType(distanceUnit, self.activityFormModel)
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }else{
            guard let cell = self.addActivityTableView.cellForRow(at: indexPath) as? SelectDateCell else{
                return
            }
            if cell.selectDateTextField.isFirstResponder{
                DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { (date) in
                    
                    cell.selectDateTextField.text = date.stringFormDate(.ddMMMYYYY)
                    self.addActivityDic["activity_date"] = date
                })
            }else{
                DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: nil, pickerMode: UIDatePickerMode.time, doneBlock: {(time) in
                    
                    cell.selectTimeTextField.text = time.stringFormDate(.Hmm)
                    self.addActivityDic["activity_time"] =  time
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addActivityTableView) else{
            return
        }
        
        if indexPath.section == 0 {
            guard let cell = self.addActivityTableView.cellForRow(at: indexPath) as? ActivityCell else{
                return
            }
            
            if textField === cell.durationTextField {
                let text = (textField.text!.isEmpty) ? 0.0 : Double(textField.text!)!
                self.calculatedValues[indexPath.row].changeDuration(text, self.activityFormModel)
                self.calculateValues()
                
            } else if textField === cell.distanceTextField {
                if !textField.text!.isEmpty{
                    self.calculatedValues[indexPath.row].changeDistance(Double(textField.text!)!, self.activityFormModel)
                    self.totalDuration = 0.0
                    self.calculateValues()
                }
                
            } else if textField === cell.caloriestextField {
                if !textField.text!.isEmpty{
                    self.calculatedValues[indexPath.row].changeCalories(Double(textField.text!)!, self.activityFormModel)
                    self.totalDuration = 0.0
                    self.calculateValues()
                }
                
            }else if textField === cell.stepsTextField {
                if !textField.text!.isEmpty{
                    self.calculatedValues[indexPath.row].changeSteps(Int(textField.text!)!, self.activityFormModel)
                    self.totalDuration = 0.0
                    self.calculateValues()
                }
            }
            self.addActivityTableView.reloadData()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.addActivityTableView) else{
            return true
        }
        
        if indexPath.section == 0 {
            
            guard let cell = self.addActivityTableView.cellForRow(at: indexPath) as? ActivityCell else{
                return true
            }
            
            let userEnteredString = textField.text ?? ""
            let _ = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as String
            
            if textField === cell.durationTextField {
                self.calculatedValues[indexPath.row].isDurationChanged = true
                self.calculatedValues[indexPath.row].isDistanceChanged = false
                self.calculatedValues[indexPath.row].isCalorieChanged = false
                self.calculatedValues[indexPath.row].isStepsChanged = false
                
//                let text = textField.text! + string
                return true
//                let durationType = self.calculatedValues[indexPath.row].durationType
//                let durationLimit = (durationType == .mins) ? 60 : 99
//                let min = text.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
//                if !min.isEmpty, Int(min)! > 0 ,Int(min)! > durationLimit {
//                    let returnType = (text.count > (range.location + range.length)) ? false : true
//                    return returnType
//                }
            } else if textField === cell.distanceTextField {
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = true
                self.calculatedValues[indexPath.row].isCalorieChanged = false
                self.calculatedValues[indexPath.row].isStepsChanged = false
                
                let characterCount = textField.text?.count ?? 0
                if (range.length + range.location > characterCount) {
                    return false
                }
                
                let newLength = characterCount + string.count - range.length
                let text = textField.text! + string
                if newLength > 4, !text.isEmpty {
                    let returnType = (text.count > (range.location + range.length)) ? false : true
                    return returnType
                }
            } else if textField === cell.caloriestextField {
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = false
                self.calculatedValues[indexPath.row].isCalorieChanged = true
                self.calculatedValues[indexPath.row].isStepsChanged = false
                
                let characterCount = textField.text?.count ?? 0
                if (range.length + range.location > characterCount) {
                    return false
                }
                
                let newLength = characterCount + string.count - range.length
                let text = textField.text! + string
                if newLength > 4, !text.isEmpty {
                    let returnType = (text.count > (range.location + range.length)) ? false : true
                    return returnType
                }
            }else if textField === cell.stepsTextField {
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = false
                self.calculatedValues[indexPath.row].isCalorieChanged = false
                self.calculatedValues[indexPath.row].isStepsChanged = true
                
                let characterCount = textField.text?.count ?? 0
                if (range.length + range.location > characterCount) {
                    return false
                }
                
                let newLength = characterCount + string.count - range.length
                let text = textField.text! + string
                if newLength > 4, !text.isEmpty {
                    let returnType = (text.count > (range.location + range.length)) ? false : true
                    return returnType
                }
            }
        }
        return true
    }
}

//MARK:- Methods
//==============
extension AddActivityVC {
    
    fileprivate func setupUI(){
        
        self.addActivityDic["activity_date"] = Date()
        self.addActivityDic["activity_time"] = Date()
        
        self.floatBtn.isHidden = true
        
        self.addActivityTableView.dataSource = self
        self.addActivityTableView.delegate = self
        
        self.recentBtnLabel.text = K_MY_RECENT.localized
        self.recentBtnLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        self.recentBtnLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.myRecentArrowImage.image = #imageLiteral(resourceName: "icActivityplanGreendropdown")
        self.myRecentBtnOutlt.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.cancelBtnOutlt.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        self.cancelBtnOutlt.setTitle(K_CONFIRMATION_CANCEL_BUTTTON.localized, for: UIControlState.normal)
        self.cancelBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        self.saveBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.saveBtnOutlt.setTitle(K_SUBMIT_BUTTON.localized, for: UIControlState.normal)
        self.saveBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.calculatedValues.append(CalculatedValue())
        
        self.registerNibs()
    }
    
    //    MARK: Register Nibs
    //    =====================
    fileprivate func registerNibs(){
        let activityNib = UINib(nibName: "ActivityCell", bundle: nil)
        let addActivityNib = UINib(nibName: "AddActivityCell", bundle: nil)
        let selectDateNib = UINib(nibName: "SelectDateCell", bundle: nil)
        let durationCellnib = UINib(nibName: "DurationDistanceCaloriesUnitCell", bundle: nil)
        
        self.addActivityTableView.register(activityNib, forCellReuseIdentifier: "activityCellID")
        self.addActivityTableView.register(addActivityNib, forCellReuseIdentifier: "addActivityCellID")
        self.addActivityTableView.register(selectDateNib, forCellReuseIdentifier: "selectDateCellID")
        self.addActivityTableView.register(durationCellnib, forCellReuseIdentifier: "durationDistanceCaloriesUnitCellID")
    }
    
    //    MARK: Delete Button Tapped
    //    ==========================
    @objc fileprivate func deleteBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.addActivityTableView) else{
            return
        }
        self.calculatedValues.remove(at: indexPath.row)
        self.insertIdAt -= 1
        self.addActivityTableView.deleteRows(at: [indexPath], with: .top)
        self.calculateValues()
        self.addActivityTableView.reloadData()
    }
    
    //    MARK: Add Activity Button Tapped
    //    =================================
    @objc fileprivate func addActivityBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.addActivityTableView) else{
            return
        }
        
        if self.calculatedValues.last?.activity == 0 {
           showToastMessage("Please add the activity first")
            return
        }
        
        self.calculatedValues.append(CalculatedValue())
        self.addActivityTableView.insertRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .top)
        self.addActivityTableView.reloadData()
    }
    
    //    MARK:- Calculatevalues
    func calculateValues(){
        self.totalDuration = 0.0
        self.totalDistance = 0.0
        self.totalCalories = 0.0
        for (index, _) in self.calculatedValues.enumerated(){
            self.totalDuration = self.totalDuration + self.calculatedValues[index].duration
            self.totalDistance = self.totalDistance + self.calculatedValues[index].distance
            self.totalCalories = self.totalCalories + self.calculatedValues[index].calories
        }
    }
}

//MARK:- WebServices
//==================
extension AddActivityVC{
    
    fileprivate func getActivityFormData(){
        
        WebServices.getActivityFormData(success: {[weak self] (activityData: [ActivityFormModel]) in
            guard let addActivityVC = self else{
                return
            }
            
            if !activityData.isEmpty{
                addActivityVC.activityFormModel = activityData
                let activityName = addActivityVC.activityFormModel.map{(value) in
                    value.activityName
                }
                addActivityVC.activityName = activityName as! [String]
            }
            addActivityVC.addActivityTableView.reloadData()
        }) { (error) in
            self.addActivityTableView.reloadData()
        }
    }
    
    fileprivate func getRecentActivity(){
        
        let param = [String : Any]()
        
        WebServices.getRecentActivity(parameters: param, success: {[weak self](_ recentActivityData : [RecentActivityModel]) in
            
            guard let addActivityVC = self else{
                return
            }
            
            if !recentActivityData.isEmpty{
                addActivityVC.recentActivityData = recentActivityData
            }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func addActivity(parameters: JSONDictionary){
        
        self.transitionView.backgroundColor = UIColor.appColor
        self.cancelBtnOutlt.isHidden = true
        self.saveBtnOutlt.isHidden = true
        self.transitionView.startAnimation()
        WebServices.addActivity(parameters: parameters,
                                success: {[weak self](_ errorString : String ) in

            guard let addActivityVC = self else{
                return
            }
            addActivityVC.transitionView.stopAnimation(animationStyle: .normal, completion: {
               addActivityVC.transitionView.backgroundColor = UIColor.white
                addActivityVC.cancelBtnOutlt.isHidden = false
                addActivityVC.saveBtnOutlt.isHidden = false
                addActivityVC.navigationController?.popViewController(animated: true)
             })
        }) { (error) in
            self.cancelBtnOutlt.isHidden = false
            self.saveBtnOutlt.isHidden = false
            self.transitionView.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
}

extension AddActivityVC : EditActivityVCRemove {
    
    func removeActivityVC() {
        self.myRecentArrowImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
        self.myRecentBtnOutlt.isSelected = false
    }
    
    func recentActivityData(_ data : RecentActivityModel){
        self.myRecentArrowImage.image = #imageLiteral(resourceName: "icAppointmentDownarrow")
        self.myRecentBtnOutlt.isSelected = false
        let activity = self.addEditActivityValues(data: data)
        
        if self.calculatedValues.last?.activity == 0 {
           self.calculatedValues.remove(at: self.calculatedValues.count - 1)
        }
        self.calculatedValues.append(activity)
        self.totalDuration = 0.0
        self.calculateValues()
        self.addActivityTableView.reloadData()
    }
    
    func addEditActivityValues(data: RecentActivityModel) -> CalculatedValue{
        
        var values = CalculatedValue()
        
        if let activityID = data.activityID {
            values.activity = activityID
        }
        if let duration = data.activityDuration{
            values.duration = duration
            self.totalDuration = self.totalDuration + values.duration
        }
        if let distance = data.totalDistance{
            values.distance = distance
            self.totalDistance = self.totalDistance + values.distance
        }
        if let caloriesBurn = data.caloriesBurn{
            values.calories = Double(caloriesBurn)
            self.totalCalories = self.totalCalories + values.calories
        }
        if let steps = data.totalSteps{
            values.steps = steps
        }
        
        if let durationUnit = data.activityDistanceUnit{
            let durationUnit : DurationUnit = (durationUnit == DurationUnit.hours.rawValue) ? .hours : .mins
            values.durationType = durationUnit
        }
        
        if let distanceUnit = data.activityDistanceUnit {
            let distanceUnit : DistanceUnit = (distanceUnit == DistanceUnit.kms.rawValue) ? .kms : .miles
            values.distanceType = distanceUnit
        }
        return values
    }
}
