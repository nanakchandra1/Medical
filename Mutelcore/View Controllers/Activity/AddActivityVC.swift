//
//  AddActivityVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AddActivityVC: BaseViewController {

//    MARK:- Proporties
//    ==================
    var editActivityScene : EditActivityVC!
    var addActivityDic = [String : Any]()
    let durationUnit = ["mins","Hours"]
    let distanceUnit = ["Kms","Miles"]
    let intensityValues = ["Low","Moderate","High"]
    var activityName = [String]()
    var totalDuration = 0.0
    var totalDistance = 0.0
    var totalCalories = 0.0
    
    enum DistanceUnit : String {
        
        case kms = "kms"
        case miles = "miles"
    }
    enum DurationUnit : String {
        
        case mins = "mins"
        case hours = "hours"
    }
    enum IntensityValue : String{
        
        case high = "intensity3"
        case moderate = "intensity2"
        case low = "intensity1"
    }
    
//    Calculate Data
    struct CalculatedValue {
        
        var distance : Double = 0.0
        var duration : Double = 0.0
        var steps : Int = 0
        var calories : Double = 0.0
        var distanceType : DistanceUnit = .kms
        var durationType : DurationUnit = .mins
        var intensityType : IntensityValue = .low
        var activity : Int = 0
        var index : Int = 0
        var isDistanceChanged : Bool = false
        var isDurationChanged : Bool = false
        var isCalorieChanged : Bool = false
        var isStepsChanged : Bool = false
        
        mutating func changeSteps(_ step : Int, _ activityFormModel : [ActivityFormModel]) {
            self.steps = step
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        mutating func changeDuration(_ duration : Double, _ activityFormModel : [ActivityFormModel]) {
            self.duration = duration
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        mutating func changeDistance(_ distance : Double, _ activityFormModel : [ActivityFormModel]) {
            
            self.distance = distance
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        mutating func changeCalories(_ calories : Double, _ activityFormModel : [ActivityFormModel]) {
            self.calories = calories
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        mutating func changeDistanceType(_ distanceType : DistanceUnit, _ activityFormModel : [ActivityFormModel]) {
            self.distanceType = distanceType

            if distanceType == .miles{
                
                self.distance = self.distance * (1.6)
                
            }else{
                
                self.distance = self.distance / (1.6)
            }
        }
        
        mutating func changeDurationType(_ durationType : DurationUnit, _ activityFormModel : [ActivityFormModel]) {
            self.durationType = durationType
            
            if durationType == .hours {
                
                self.duration = self.duration / 60
                
            }else{
                
                self.duration = self.duration * 60
            }
        }
        
        mutating func changeIntensityType(_ intensityType : IntensityValue, _ activityFormModel : [ActivityFormModel]) {
            self.intensityType = intensityType
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        mutating func changeActivity(_ changeActivity : Int, _ activityFormModel : [ActivityFormModel], _ index : Int) {
            self.activity = changeActivity
            
            printlnDebug(changeActivity)
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        mutating func isDistanceChanged(_ isDistanceChanged : Bool, _ activityFormModel : [ActivityFormModel]) {
            self.isDistanceChanged = isDistanceChanged
            
            calculatValues(distance, duration, steps, calories, distanceType, durationType, intensityType, activity, isDisChanged: isDistanceChanged, isDurChanged: isDurationChanged, isStepChanged: isStepsChanged, isCalChanged: isCalorieChanged, activityFormModel, index)
        }
        
        private mutating func calculatValues(_ distance : Double, _ duration : Double, _ steps : Int, _ calories : Double , _ distanceType : DistanceUnit, _ durationType : DurationUnit, _ intensityType : IntensityValue, _ activity : Int, isDisChanged : Bool, isDurChanged : Bool, isStepChanged : Bool, isCalChanged : Bool, _ activityFormModel : [ActivityFormModel],_ index : Int) {
            
            if isDurChanged{
                
                let calFromDuration : Double?
                let distanceFromCal : Double?
                let stepsFromDistance : Double?
                
                switch intensityType{
                    
                case .low :
                    
                    calFromDuration = activityFormModel[index].intensity1?.durationCalories
                    distanceFromCal = activityFormModel[index].intensity1?.caloriesDistance
                    stepsFromDistance = activityFormModel[index].intensity1?.distanceStep
                    
                case .moderate :
                    
                    calFromDuration = activityFormModel[index].intensity2?.durationCalories
                    distanceFromCal = activityFormModel[index].intensity2?.caloriesDistance
                    stepsFromDistance = activityFormModel[index].intensity2?.distanceStep
                    
                case .high :
                    
                    calFromDuration = activityFormModel[index].intensity3?.durationCalories
                    distanceFromCal = activityFormModel[index].intensity3?.caloriesDistance
                    stepsFromDistance = activityFormModel[index].intensity3?.distanceStep
                    
                }
                
                self.calories = duration * calFromDuration!
                
                let distance = self.calories * distanceFromCal!
                
                self.distance = distance.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero) / 1000
                self.steps = Int(distance) * Int(stepsFromDistance!)
                
            }else{
                
                
                
            }
            
            if isDisChanged {
                
                let calFromDistance : Double?
                let stepsFromDistance : Double?
                
                switch intensityType{
                    
                case .low :
                    
                    calFromDistance = activityFormModel[index].intensity1?.distanceCalories
                    stepsFromDistance = activityFormModel[index].intensity1?.distanceStep
                    
                case .moderate :
                    
                    calFromDistance = activityFormModel[index].intensity2?.distanceCalories
                    stepsFromDistance = activityFormModel[index].intensity2?.distanceStep
                    
                case .high :
                    
                    calFromDistance = activityFormModel[index].intensity3?.distanceCalories
                    stepsFromDistance = activityFormModel[index].intensity3?.distanceStep
                    
                }
                
                self.calories = distance * calFromDistance!
                self.steps = Int(distance) * Int(stepsFromDistance!)
                
            }else{
                
                
                
                
            }
            
            if isStepChanged {
                
                let calFromSteps : Double?
                let distanceFromSteps : Double?
                
                switch intensityType{
                    
                case .low :
                    
                    calFromSteps = activityFormModel[index].intensity1?.stepCalories
                    distanceFromSteps = activityFormModel[index].intensity1?.stepDistance
                    
                case .moderate :
                    
                    calFromSteps = activityFormModel[index].intensity2?.stepCalories
                    distanceFromSteps = activityFormModel[index].intensity2?.stepDistance
                    
                case .high :
                    
                    calFromSteps = activityFormModel[index].intensity3?.stepCalories
                    distanceFromSteps = activityFormModel[index].intensity3?.stepDistance
                    
                }
                
                self.calories = Double(steps) * calFromSteps!
                self.distance = Double(steps) * distanceFromSteps!
                
            }else{
                
                
            }
            
            if isCalChanged {
                
                let stepsFromCal : Double?
                let distanceFromCal : Double?
                
                switch intensityType{
                    
                case .low :
                    
                    stepsFromCal = activityFormModel[index].intensity1?.caloriesStep
                    distanceFromCal = activityFormModel[index].intensity1?.caloriesDistance
                    
                case .moderate :
                    
                    stepsFromCal = activityFormModel[index].intensity2?.caloriesStep
                    distanceFromCal = activityFormModel[index].intensity2?.caloriesDistance
                    
                case .high :
                    
                    stepsFromCal = activityFormModel[index].intensity3?.caloriesStep
                    distanceFromCal = activityFormModel[index].intensity3?.caloriesDistance
                    
                }
                
                self.steps = Int(calories) * Int(stepsFromCal!)
                self.distance = calories * distanceFromCal!
                
            }else{
                
                
                
            }
        }
    }
    
    var activityFormModel = [ActivityFormModel]()
    var recentActivityData = [RecentActivityModel]()
    var distanceValue = DistanceUnit.kms
    var durationValue = DurationUnit.mins
    var intensityValue = IntensityValue.moderate
    var calculatedValues = [CalculatedValue]()
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var myRecentBtnOutlt: UIButton!
    @IBOutlet weak var myRecentArrowImage: UIImageView!
    @IBOutlet weak var addActivityTableView: UITableView!
    @IBOutlet weak var cancelBtnOutlt: UIButton!
    @IBOutlet weak var saveBtnOutlt: UIButton!
    @IBOutlet weak var recentBtnLabel: UILabel!
    

//    MARK:- ViewController LifeCycle
//    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
        self.navigationControllerOn = .dashboard
        
        self.getActivityFormData()
        self.getRecentActivity()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Add Activity", 2, 3)

        
        
        self.cancelBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.saveBtnOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            self.myRecentArrowImage.image = #imageLiteral(resourceName: "icActivityplanGreendropdown")
            
            self.editActivityScene.view.frame = CGRect(x: 0, y: y, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - y)
            
        }else{
           
            self.myRecentArrowImage.image = #imageLiteral(resourceName: "icActivityplanGreendropdown")
            self.editActivityScene.view.removeFromSuperview()
            self.editActivityScene.removeFromParentViewController()

        }
    }
    
    @IBAction func CancelBtnTapped(_ sender: UIButton) {
     
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        var activityType = [Any]()
        var dic = [String : Any]()
        for calculatedValue in self.calculatedValues {

            dic["activity_id"]   = calculatedValue.activity
            
//            guard let activityID = "\(calculatedValue.activity)", !activityID.isEmpty else{
//                
//                showToastMessage("Please select the Activity")
//                
//                return
//            }
//            guard calculatedValue.duration == 0 else{
//                
//                showToastMessage("Please selsect the Activity")
//                
//                return
//            }
//            guard calculatedValue.calories == 0 else{
//                
//                showToastMessage("Please selsect the Activity")
//                return
//            }
//            guard calculatedValue.steps == 0 else {
//                
//                showToastMessage("Please enter the steps.")
//                return
//            }
//            guard calculatedValue.distance == 0 else{
//                
//                showToastMessage("Please enter the distance.")
//                return
//            }
            
            dic["duration_unit"]    = calculatedValue.durationType.rawValue
            dic["duration"]         = calculatedValue.duration
            dic["intensity"]        = calculatedValue.intensityType.rawValue
            dic["calories"]         = calculatedValue.calories
            dic["steps"]            = calculatedValue.steps
            dic["distance_unit"]    = calculatedValue.distanceType.rawValue
            dic["distance"]         = calculatedValue.distance
            
            activityType.append(dic)
        }
        
       self.typeJSONArray(activityType as! [[String : Any]])
       
        guard let date = self.addActivityDic["activity_date"] as? String, !date.isEmpty else{
            
            showToastMessage("Please select the date.")
            return
        }
        
        guard let time = self.addActivityDic["activity_time"] as? String, !time.isEmpty else{
            
            showToastMessage("Please select the time.")
            return
        }
        
        self.addActivity()
        
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension AddActivityVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0{
            
          return self.calculatedValues.count
            
        }else{
            
          return 3
        }
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
            
            let activityID = self.calculatedValues[indexPath.row].activity
            
            if !self.activityFormModel.isEmpty {
                
                var activityName = ""
                for value in self.activityFormModel{
                    if value.activityID == activityID {
                        activityName = value.activityName!
                    }
                }
                
               activityCell.selectActivityTextField.text = activityName
                
            }else{
                
                activityCell.selectActivityTextField.text = ""
            }
            
            let duration = self.calculatedValues[indexPath.row].duration
            
            let rounderDurationValue = duration.rounded(.toNearestOrAwayFromZero)
            
            activityCell.durationTextField.text = "\(Int(rounderDurationValue))"
            
            if self.calculatedValues[indexPath.row].durationType == .mins{
                
              activityCell.durationUnitTextField.text = self.durationUnit[0]
            }else{
                
                activityCell.durationUnitTextField.text = self.durationUnit[1]
            }

            if self.calculatedValues[indexPath.row].intensityType == .low{
                
                activityCell.intensityTextField.text = self.intensityValues[0]
                
            }else if self.calculatedValues[indexPath.row].intensityType == .moderate {
                
               activityCell.intensityTextField.text = self.intensityValues[1]
            }else{
                
              activityCell.intensityTextField.text = self.intensityValues[2]
            }
            
            let dist = self.calculatedValues[indexPath.row].distance
            
            activityCell.distanceTextField.text = String(describing: dist.rounded(.toNearestOrAwayFromZero))
            
            if self.calculatedValues[indexPath.row].distanceType == .kms {
                
                activityCell.distanceUnitTextField.text = self.distanceUnit[0]
            }else{
                
              activityCell.distanceUnitTextField.text = self.distanceUnit[1]
            }
            
            activityCell.stepsTextField.text = String(self.calculatedValues[indexPath.row].steps)
            
            let calories = self.calculatedValues[indexPath.row].calories
            
            let roundedValuesInCalorie = calories.rounded(.toNearestOrAwayFromZero)
            
            activityCell.caloriestextField.text = "\(Int(roundedValuesInCalorie))"
                        
            if indexPath.row == 0 {
                
                activityCell.deleteActivityBtnOutlet.isHidden = true
            }else{
                
               activityCell.deleteActivityBtnOutlet.isHidden = false
            }
            
            return activityCell
            
        }else{
            
            switch indexPath.row{
                
            case 0 : guard let addActivityCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "addActivityCellID", for: indexPath) as? AddActivityCell else{
                
                fatalError("AddActivityCell Cell Not Found!")
            }

            addActivityCell.addActivityBtn.addTarget(self, action: #selector(self.addActivityBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            if self.calculatedValues.count > 3 {
                
                addActivityCell.addActivityBtn.isHidden = true
            }else{
                
               addActivityCell.addActivityBtn.isHidden = false
            }
            
            return addActivityCell
                
            case 1: guard let selectDateCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "selectDateCellID", for: indexPath) as? SelectDateCell else{
                
                fatalError("selectDateCell Cell Not Found!")
            }
            
            
            selectDateCell.selectDateLabel.text  = "Date"
            selectDateCell.selectTimeLabel.text = "Time"
            selectDateCell.selectDateTextField.borderStyle = UITextBorderStyle.none
            selectDateCell.selectTimeTextField.borderStyle = UITextBorderStyle.none
            selectDateCell.selectDateTextField.delegate = self
            selectDateCell.selectTimeTextField.delegate = self
            
            return selectDateCell
                
            case 2: guard let durationDistanceCaloriesUnitCell = self.addActivityTableView.dequeueReusableCell(withIdentifier: "durationDistanceCaloriesUnitCellID", for: indexPath) as? DurationDistanceCaloriesUnitCell else{
                
                fatalError("AddActivityCell Cell Not Found!")
            }
            
            durationDistanceCaloriesUnitCell.populateData(self.totalDuration, self.totalDistance, self.totalCalories)
            
            return durationDistanceCaloriesUnitCell
                
            default : fatalError("Cell Not Found!")
  
            }
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension AddActivityVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return CGFloat(353)
            
        }else{
            
            switch indexPath.row {
                
            case 0 : printlnDebug(self.calculatedValues.count)
                
                return CGFloat(70)
                
            case 1 : return CGFloat(100)
                
            case 2 : return CGFloat(70)
                
            default : return CGFloat(0)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(0)
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
                    
                    if Index == 0 {
                        
                        self.calculatedValues[indexPath.row].changeDurationType(DurationUnit.mins, self.activityFormModel)
                        
                    }else{
                        
                        self.calculatedValues[indexPath.row].changeDurationType(DurationUnit.hours, self.activityFormModel)
                        
                    }
                    
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                    
                }
            }else if textField === cell.intensityTextField{
                
                MultiPicker.openPickerIn(cell.intensityTextField, firstComponentArray: self.intensityValues, secondComponentArray: [], firstComponent: cell.intensityTextField.text, secondComponent: "", titles: ["Intensity"]) { (value, i, Index, _) in
                    
                    if Index == 0{
                        
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.low, self.activityFormModel)
                        
                    }else if Index == 1{
                        
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.moderate, self.activityFormModel)
                        
                    }else{
                        
                        self.calculatedValues[indexPath.row].changeIntensityType(IntensityValue.high, self.activityFormModel)
                        
                    }
                    
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }else if textField === cell.distanceUnitTextField {
                
                MultiPicker.openPickerIn(cell.distanceUnitTextField, firstComponentArray: self.distanceUnit, secondComponentArray: [], firstComponent: cell.distanceUnitTextField.text, secondComponent: "", titles: ["Units"]) { (value, _, Index, _) in
                    
                    if Index == 0 {
                        
                        self.calculatedValues[indexPath.row].changeDistanceType(DistanceUnit.kms, self.activityFormModel)
                        
                    }else{
                        
                        self.calculatedValues[indexPath.row].changeDistanceType(DistanceUnit.miles, self.activityFormModel)
                        
                    }
                    
                    self.addActivityTableView.reloadRows(at: [indexPath], with: .automatic)
                    
                }
            }

        }else{
           
            guard let cell = self.addActivityTableView.cellForRow(at: indexPath) as? SelectDateCell else{
                
                return
            }
           
            if cell.selectDateTextField.isFirstResponder{
                
                DatePicker.openPicker(in: cell.selectDateTextField, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: UIDatePickerMode.date, doneBlock: { (date) in
                    
                    cell.selectDateTextField.text = date.stringFormDate(DateFormat.ddMMMYYYY.rawValue)
                    
                    self.addActivityDic["activity_date"] = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
                    self.addActivityTableView.reloadData()
                })

            }else{
                
                DatePicker.openPicker(in: cell.selectTimeTextField, currentDate: Date(), minimumDate: nil, maximumDate: nil, pickerMode: UIDatePickerMode.time, doneBlock: { (time) in
                    
                    cell.selectTimeTextField.text = time.stringFormDate(DateFormat.Hmm.rawValue)
                    self.addActivityDic["activity_time"] =  cell.selectTimeTextField.text!
                    self.addActivityTableView.reloadData()
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
                
                if !textField.text!.isEmpty{
                
                self.calculatedValues[indexPath.row].changeDuration(Double(textField.text!)!, self.activityFormModel)
                    
                    self.calculateValues()
                }
                
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
                
            } else if textField === cell.distanceTextField {
                
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = true
                self.calculatedValues[indexPath.row].isCalorieChanged = false
                self.calculatedValues[indexPath.row].isStepsChanged = false
                
            } else if textField === cell.caloriestextField {
                
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = false
                self.calculatedValues[indexPath.row].isCalorieChanged = true
                self.calculatedValues[indexPath.row].isStepsChanged = false
            }else if textField === cell.stepsTextField {
                
                self.calculatedValues[indexPath.row].isDurationChanged = false
                self.calculatedValues[indexPath.row].isDistanceChanged = false
                self.calculatedValues[indexPath.row].isCalorieChanged = false
                self.calculatedValues[indexPath.row].isStepsChanged = true
            }
        }
        return true
    }
}

//MARK:- Methods
//==============
extension AddActivityVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.addActivityTableView.dataSource = self
        self.addActivityTableView.delegate = self
        
        self.cancelBtnOutlt.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        
        self.recentBtnLabel.text = "My Recent"
        self.recentBtnLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
        self.recentBtnLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.myRecentArrowImage.image = #imageLiteral(resourceName: "icActivityplanGreendropdown")
        
        self.cancelBtnOutlt.setTitle("CANCEL", for: UIControlState.normal)
        self.cancelBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        self.saveBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.saveBtnOutlt.setTitle("SUBMIT", for: UIControlState.normal)
        self.saveBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        self.registerNibs()
        
        self.myRecentBtnOutlt.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.calculatedValues.append(CalculatedValue())
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
        self.addActivityTableView.deleteRows(at: [indexPath], with: .top)
        self.addActivityTableView.reloadData()
    
    }
    
//    MARK: Add Activity Button Tapped
//    =================================
    @objc fileprivate func addActivityBtnTapped(_ sender : UIButton){

        guard let indexPath = sender.tableViewIndexPathIn(self.addActivityTableView) else{
            
            return
        }
        
        printlnDebug(self.calculatedValues.count)
        
            printlnDebug(self.calculatedValues.count)
            
           self.calculatedValues.append(CalculatedValue())
            
           self.addActivityTableView.insertRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .top)
        
        self.addActivityTableView.reloadData()
    }
    
//    MARK:- Calculatevalues
    func calculateValues(){
        
        
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
        
        let param = [String : Any]()
        
        WebServices.getActivityFormData(parameters: param, success: { (activityData: [ActivityFormModel]) in

            printlnDebug("activityData ;\(activityData)")
            
            if !activityData.isEmpty{
                
                self.activityFormModel = activityData
                
                let activityName = self.activityFormModel.map{(value) in
                    
                    value.activityName
                }
                
                self.activityName = activityName as! [String]
                
                let activityID = self.activityFormModel.map{(value) in
                    
                    value.activityID
                }
                
                printlnDebug(activityID[0]!)
                
                self.calculatedValues[0].changeActivity(activityID[0]!, self.activityFormModel, 0)
            }

            self.addActivityTableView.reloadData()
            
        }) { (e) in
            
            printlnDebug(e.localizedDescription)
            
            self.addActivityTableView.reloadData()
        }
    }
    
    fileprivate func getRecentActivity(){
        
        let param = [String : Any]()
        
        WebServices.getRecentActivity(parameters: param, success: { (_ recentActivityData : [RecentActivityModel]) in
            
            if !recentActivityData.isEmpty{
                
                self.recentActivityData = recentActivityData
            }
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func addActivity(){
        
        printlnDebug("self.addActivityDic : \(self.addActivityDic)")
        
        WebServices.addActivity(parameters: self.addActivityDic, success: { (_ errorString : String ) in
        
            showToastMessage(errorString)
            
            self.navigationController?.popViewController(animated: true)
        
    }) { (error) in
        
        showToastMessage(error.localizedDescription)
        
        }
    }
    
    fileprivate func typeJSONArray(_ dic : [[String : Any]]){
        
        do {
            
            let typejsonArray = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
            
            self.addActivityDic["activity_type"] = typeJSONString as AnyObject?
            
        }catch{
            
            printlnDebug(error.localizedDescription)
        }
        
    }
}

extension AddActivityVC : EditActivityVCRemove {
    
    func removeActivityVC(_ remove: Bool) {
        
        self.myRecentBtnOutlt.isSelected = remove
    }
    
    func recentActivityData(_ data : RecentActivityModel){
        
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
            
            if durationUnit == "hours" {
                
                values.durationType = .hours
            }else{
                
                values.durationType = .mins
            }
        }
        
        if let distanceUnit = data.activityDistanceUnit {
            
            if distanceUnit == "kms" {
                
                values.distanceType = .kms
            }else{
                
                values.distanceType = .miles
            }
        }
        
        self.calculatedValues.append(values)
        self.totalDuration = 0.0
        self.calculateValues()
        self.addActivityTableView.reloadData()
    }
}
