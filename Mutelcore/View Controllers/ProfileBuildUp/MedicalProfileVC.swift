
import UIKit


class MedicalProfileVC: UIViewController {
    
    //    MARK:- Properties
    //========================
    let sectionTitleArray = ["",K_HYPERTENSION_PLACEHOLDER.localized, K_DIABETES_PLACEHOLDER.localized, K_SMOKING_PLACEHOLDER.localized, K_ADD_ALERGY_DETAILS_PLACEHOLDER.localized, K_FAMILY_HISTORY_PLACEHOLDER.localized,K_PREVIOUS_MEDICAL_HISTORY_PLACEHOLDER.localized,K_FOOD_CATEGORY_DETAILS_PLACEHOLDER.localized, K_ADD_HOSPITAL_DETAILS_PLACEHOLDER.localized, K_ADD_TREATMENT_DETAILS_PLACEHOLDER.localized]
    let headerImageArray = [#imageLiteral(resourceName: "medical_profile_add_allergy"),#imageLiteral(resourceName: "medical_profile_add_allergy"),#imageLiteral(resourceName: "medical_profile_add_allergy"), #imageLiteral(resourceName: "medical_profile_food_category"), #imageLiteral(resourceName: "medical_profile_add_hospital"), #imageLiteral(resourceName: "medical_profile_add_treatment")] as [UIImage]
    
    var heightSectionArray = [K_HEIGHT_PLACEHOLDER.localized, K_WEIGHT_PLACEHOLDER.localized, K_BLOOD_GROUP_PLACEHOLDER.localized]
    var hypertensionArrary = [K_HYPERTENSION_PLACEHOLDER.localized]
    var diabitiesArray = [K_DIABETES_PLACEHOLDER.localized]
    var smokingArray = [K_SMOKING_PLACEHOLDER.localized]
    
    let descriptionSectionArray =  [K_ADD_ALERGY_DETAILS_PLACEHOLDER.localized]
    let foodCategoryArray = [K_VEG_PLACEHOLDER.localized, K_NON_VEG_PLACEHOLDER.localized]
    let hospitalArray = [K_DOCTOR_NAME_PLACEHOLDER.localized, K_DOCTOR_ADDRESS_PLACEHOLDER.localized]
    let treatmentDetailArray = [K_SPECIALITY_PLACEHOLDER.localized,K_TYPE_OF_SURGERY_PLACEHOLDER.localized, K_DATE_OF_ADMISSION_PLACEHOLDER.localized, K_DATE_OF_SURGERY_PLACEHOLDER.localized, K_DATE_OF_DISCHARGE_PLACEHOLDER.localized]
    
    let heightUnitArray = [K_FEET_PLACEHOLDER.localized, K_CM_PLACEHOLDER.localized]
    let weightUnitArray = [K_KG_PLACEHOLDER.localized, K_LBS_PLACEHOLDER.localized]
    let bloodUnitType = [O_PLUS_PLACEHOLDER.localized, O_NEGATIVE_PLACEHOLDER.localized ,A_PLUS_PLACEHOLDER.localized, A_NEGATIVE_PLACEHOLDER.localized, B_PLUS_PLACEHOLDER.localized, B_NEGATIVE_PLACEHOLDER.localized, AB_PLUS_PLACEHOLDER.localized, AB_NEGATIVE_PLACEHOLDER.localized]
    
    
    var blankDictionary = [String : Any]()
    var userInfo : UserInfo!
    var usInfo = UserInfo()
    var hospInfo = [HospitalInfo]()
    var surgeryModel = [SurgeryModel]()
    var hospitalAddressArray = [String]()
    var hospitalID = [Int]()
    var surgeyName = [String]()
    var surgeyNameArray = [String]()
    var specialityArray = [String]()
    
    enum genderStatus : Int {
        
        case male, female
    }
    
    enum feetUnit : Int{
        
        case ft = 0
        case cm = 1
    }
    
    var feetunitState = feetUnit.ft
    var foodcategoryToggleState = true
    var hypertensiontoogleState = false
    var hypertensionFatherToogleState = false
    var hypertensionMotherToogleState = false
    var diabitiesToogleState = false
    var diabitiesFatherToogleState = false
    var diabitiesMotherToogleState = false
    var smokingtoogleBtnState = false
    
    //    MARK:- IBOutlets
    //    =================
    
    @IBOutlet weak var medicalProfileTableView: UITableView!
    
    //    MARK:- Viewcontroller Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for val in hospInfo{
            
            self.hospitalAddressArray.append(val.hospitalAddress!)
            self.hospitalID.append(val.hospitalId!)
            
        }
        
        self.medicalProfileTableView.delegate = self
        self.medicalProfileTableView.dataSource = self
        self.medicalProfileTableView.estimatedRowHeight = 100
        
        self.setUpViews()
        self.typeOfSugeryServiceHit()
        self.specialityService()
        self.hyperTensionBtnState()
        
        // Do any additional setup after loading the view.
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension MedicalProfileVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
            
        case 0: return heightSectionArray.count
        case 1: return hypertensionArrary.count
        case 2: return diabitiesArray.count
        case 3: return smokingArray.count
        case 4: return 1
        case 5: return 1
        case 6: return 1
        case 7: return foodCategoryArray.count
        case 8: return hospitalArray.count
        case 9: return treatmentDetailArray.count
        default: fatalError("Number Of rows in Section Count Not Found!")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            
        case 0:
            
            switch indexPath.row {
                
            case 0: guard let heightCell = tableView.dequeueReusableCell(withIdentifier: "heightCell", for: indexPath) as? HeightCell else{
                fatalError("HeightCell Not Found!")
            }
            heightCell.cellTitle.text = heightSectionArray[indexPath.row]
            
            let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
            heightCell.unitTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
            heightCell.unitTextField.textColor = UIColor.black
            heightCell.feetTextField.keyboardType = .numberPad
            heightCell.inchTextField.keyboardType = .numberPad
            heightCell.unitTextField.delegate = self
            heightCell.feetTextField.delegate = self
            heightCell.inchTextField.delegate = self
            
            UIView.animate(withDuration: 0.1, animations: {
                
                heightCell.inchTextField.isHidden  = self.feetunitState == .cm
                heightCell.inchTextFieldBottomView.isHidden = self.feetunitState == .cm
                
            })
            
            heightCell.populateData(self.userInfo, self.heightUnitArray)
            
            return heightCell
                
            case 1: guard let weightCell = tableView.dequeueReusableCell(withIdentifier: "weightCell", for: indexPath) as? WeightCell else{
                fatalError("WeigntCell Not Found!")
            }
            weightCell.cellTitle.text = heightSectionArray[indexPath.row]
            
            let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
            weightCell.unitTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
            weightCell.unitTextField.textColor = UIColor.black
            weightCell.measurementTextField.keyboardType = .numberPad
            weightCell.unitTextField.delegate = self
            weightCell.measurementTextField.delegate = self
            
            weightCell.populateData(self.userInfo, weightUnitArray: self.weightUnitArray)
            
            return weightCell
                
            case 2: guard let bloodgroupCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else{
                fatalError("BloodGroupCell Not Found!")
            }
            bloodgroupCell.cellBtnOutlt.isHidden = true
            
           bloodgroupCell.celltitleBtn.setTitle(heightSectionArray[indexPath.row], for: .normal)
            bloodgroupCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
            bloodgroupCell.celltextField.rightViewMode = .always
            
            let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
            bloodgroupCell.celltextField.rightView?.addGestureRecognizer(rightViewTapGesture)
            
            bloodgroupCell.celltextField.delegate = self
            
            bloodgroupCell.populateBloodData(self.userInfo)
            
            return bloodgroupCell
                
            default: fatalError("Cell in first Section Not Found!")
            }
            
        case 1: guard let hypertensionCell = tableView.dequeueReusableCell(withIdentifier: "hypertensionCell", for: indexPath) as? HypertensionCell else{
            fatalError("HypertensionCell Not Found!")
        }
        
        hypertensionCell.toogleBtn.addTarget(self, action: #selector(tappedToggleBtn(_:)), for: .touchUpInside)
        
        hypertensionCell.cellTitle.text = hypertensionArrary[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            
            if let hypertension = self.userInfo.medicalInfo[0].hypertension{
                
                if hypertension == 0 {
                    
                    hypertensionCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    
                }else{
                    
                    hypertensionCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                    
                }
            }
            
        case 1: if let fatherHypertension = self.userInfo.medicalInfo[0].patientHyperTensionFather{
            
            if fatherHypertension == 0 {
                
                hypertensionCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                
            }else{
                
                hypertensionCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                
            }
            }
            
        case 2: if let motherHypertension = self.userInfo.medicalInfo[0].patientHyperTensionMother{
            
            if motherHypertension == 0 {
                
                hypertensionCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                
            }else{
                
                hypertensionCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
            }
            }
            
        default : fatalError("Hypertension Section Cell Not Found!")
            
        }
        
        return hypertensionCell
            
        case 2: guard let diabitiesCell = tableView.dequeueReusableCell(withIdentifier: "hypertensionCell", for: indexPath) as? HypertensionCell else{
            fatalError("diabitiesCell Not Found!")
        }
        
        diabitiesCell.toogleBtn.addTarget(self, action: #selector(tappedToggleBtn(_:)), for: .touchUpInside)
        
        diabitiesCell.cellTitle.text = diabitiesArray[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            
            if let diabities = self.userInfo.medicalInfo[0].diabities {
                
                if diabities == 0 {
                    
                    diabitiesCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    
                }else{
                    
                    diabitiesCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                    
                }
            }
            
        case 1:
            
            if let fatherDiabities = self.userInfo.medicalInfo[0].patientDiabitiesFather {
                
                if fatherDiabities == 0 {
                    
                    diabitiesCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    
                }else{
                    
                    diabitiesCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                }
            }
            
        case 2: if let motherDiabities = self.userInfo.medicalInfo[0].patientDiabitiesMother {
            
            if motherDiabities == 0 {
                
                diabitiesCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                
            }else{
                
                diabitiesCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
            }
            }
            
        default: fatalError("Diabities Cell row not found!")
        }
        return diabitiesCell
            
        case 3: guard let smokingCell = tableView.dequeueReusableCell(withIdentifier: "hypertensionCell", for: indexPath) as? HypertensionCell else{
            fatalError("HypertensionCell Not Found!")
        }
        
        smokingCell.toogleBtn.addTarget(self, action: #selector(tappedToggleBtn(_:)), for: .touchUpInside)
        
        smokingCell.cellTitle.text = smokingArray[indexPath.row]
        
        if let smoking = self.userInfo.medicalInfo[0].smoking {
            
            if smoking == 0{
                
                smokingCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                
            }else{
                
                smokingCell.toogleBtn.setImage( #imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                
            }
        }
        
        return smokingCell
            
        case 4...6: guard let addDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "addDescriptionCell", for: indexPath) as? AddDescriptionCell else{
            fatalError("AddDescriptionCell Not Found!")
        }
        addDescriptionCell.descriptionTextField.delegate = self
        addDescriptionCell.descriptionTextField.placeholder = "Add Description"
        
        addDescriptionCell.populateData(indexPath, self.userInfo)
        
        return addDescriptionCell
            
        case 7: guard let vegCell = tableView.dequeueReusableCell(withIdentifier: "hypertensionCell", for: indexPath) as? HypertensionCell else{
            fatalError("nonVegCell Not Found!")
        }
        vegCell.cellTitle.text = foodCategoryArray[indexPath.row]
        vegCell.toogleBtn.addTarget(self, action: #selector(tappedToggleBtn(_:)), for: .touchUpInside)
        
        if let foodCategory = self.userInfo.medicalCategoryInfo[0].foodCategory {
            
            if foodCategory == 0 {
                
                self.foodcategoryToggleState = false
                
                if indexPath.row == 0 {
                    
                    vegCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                }else{
                    
                    vegCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                }
                
            }else{
                
                self.foodcategoryToggleState = true
                
                if indexPath.row == 0 {
                    
                    vegCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                }else{
                    
                    vegCell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                }
            }
        }
        
        return vegCell
            
        case 8: guard let hospitalDetailCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else{
            fatalError("hospitalDetailCell Not Found!")
        }
        hospitalDetailCell.cellBtnOutlt.isHidden = true
        hospitalDetailCell.celltextField.delegate = self
        hospitalDetailCell.celltitleBtn.setTitle(hospitalArray[indexPath.row], for: .normal)
        let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
        hospitalDetailCell.celltextField.rightView?.addGestureRecognizer(rightViewTapGesture)
        hospitalDetailCell.celltextField.delegate = self
        
        switch indexPath.row {
            
        case 0: hospitalDetailCell.celltextField.rightView?.isHidden = true
        hospitalDetailCell.celltextField.isEnabled = false
        
        hospitalDetailCell.celltextField.text = self.userInfo.doctorName
            
        case 1: hospitalDetailCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        hospitalDetailCell.celltextField.rightViewMode = .always
        
        if let hopitalID = self.hospInfo[0].hospitalId {
            
            hospitalDetailCell.celltextField.text = self.mapHospitalAddress(hopitalID, self.hospInfo)
        }else{
            
            hospitalDetailCell.celltextField.text = ""
            }
            
        default : break
        }
        
        return hospitalDetailCell
            
        case 9: guard let treatmentCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else{
            fatalError("dateOfAdmisionCell Not Found!")
        }
        
        treatmentCell.cellBtnOutlt.isHidden = true
        treatmentCell.celltitleBtn.setTitle(treatmentDetailArray[indexPath.row], for: .normal)
        let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
        treatmentCell.celltextField.rightView?.addGestureRecognizer(rightViewTapGesture)
        treatmentCell.celltextField.delegate = self
        
        if indexPath.row == 0 || indexPath.row == 1{
            
            treatmentCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
            treatmentCell.celltextField.rightViewMode = .always
            treatmentCell.celltextField.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            
        }else{
            
            treatmentCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_next_arrow"))
            treatmentCell.celltextField.rightViewMode = .always
            treatmentCell.celltextField.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            
        }
        
        switch indexPath.row {
            
        case 0: treatmentCell.celltextField.text = self.userInfo.patientSpeciality
            
        case 1:
            
            if !self.surgeyName.isEmpty{
                
                treatmentCell.celltextField.text = self.surgeyName.first
            }else{
                treatmentCell.celltextField.text = ""
            }
            
        case 2: if let date = self.userInfo.treatmentinfo[0].dateOfAdmission {
            
            treatmentCell.celltextField.text = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
        }else{
            
            treatmentCell.celltextField.text = ""
            
            }
            
        case 3: if let date = self.userInfo.treatmentinfo[0].dateOfSurgery {
            
            treatmentCell.celltextField.text = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        }else{
            
            treatmentCell.celltextField.text = ""
            
            }
            
        case 4: if let date = self.userInfo.treatmentinfo[0].dateofDischarge {
            
            treatmentCell.celltextField.text = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
        }else{
            
            treatmentCell.celltextField.text = ""
            
            }
            
        default: fatalError("Treatment section row not found!")
        }
        
        return treatmentCell
            
        default : fatalError("Section not Found!")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return sectionTitleArray.count
    }
}

//MARK:- UITableViewDelegate Methods
//====================================

extension MedicalProfileVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        switch section {
            
        case 0...3 : return nil
            
        case 4...(sectionTitleArray.count) : guard let headerView = tableView.dequeueReusableCell(withIdentifier: "headerView") as? HeaderView else{
            
            fatalError("HeaderView Not Found!")
        }
        
        headerView.headerImage.image = headerImageArray[section - 4]
        headerView.headerTitle.text = sectionTitleArray[section]
        
        return headerView
            
        default: fatalError("HedaerView Not Found!")
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        switch section {
            
        case 0...3: return 0
            
        case 4...sectionTitleArray.count: return 40
            
        default: fatalError("Section Height Not Found!")
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 50
    }
}

//MARK:- UITextFieldDelegate Methods
//===================================

extension MedicalProfileVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPathIn(medicalProfileTableView) else { return }
        
        MultiPicker.noOfComponent = 1
        
        switch indexPath.section{
        case 0:
            if indexPath.row == 0{
                guard let heightCell = textField.getTableViewCell as? HeightCell else { return }
                MultiPicker.openPickerIn(heightCell.unitTextField, firstComponentArray: heightUnitArray, secondComponentArray: [], firstComponent: heightCell.unitTextField.text, secondComponent: nil, titles: ["Choose Unit"]) { (firstValue, _,_,_) in
                    
                    heightCell.unitTextField.text = firstValue
                    
                    if firstValue == K_FEET_PLACEHOLDER.localized{
                        self.feetunitState = .ft
                        
                        self.userInfo.medicalInfo[0].patientHeightType = true.rawValue
                        
                    }
                    else{
                        
                        self.feetunitState = .cm
                        self.userInfo.medicalInfo[0].patientHeightType = false.rawValue
                    }
                    self.medicalProfileTableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }else if indexPath.row == 1{
                guard let weightCell = textField.getTableViewCell as? WeightCell else { return }
                
                MultiPicker.openPickerIn(weightCell.unitTextField, firstComponentArray: weightUnitArray, secondComponentArray: [], firstComponent: weightCell.unitTextField.text, secondComponent: nil, titles: ["Choose Unit"]) { (firstValue, _,_,_) in
                    weightCell.unitTextField.text = firstValue
                    
                    if firstValue == K_KG_PLACEHOLDER.localized{
                        
                        self.userInfo.medicalInfo[0].patientWeightType = false.rawValue
                        
                    }else{
                        
                        self.userInfo.medicalInfo[0].patientWeightType = true.rawValue
                    }
                }
            }else if indexPath.row == 2{
                guard let bloodGroupCell = textField.getTableViewCell as? DateOfBirthCell else { return }
                
                MultiPicker.openPickerIn(bloodGroupCell.celltextField, firstComponentArray: bloodUnitType, secondComponentArray: [], firstComponent: bloodGroupCell.celltextField.text, secondComponent: nil, titles: ["Choose Blood Group"]) { (firstValue, _,_,_) in
                    
                    bloodGroupCell.celltextField.text = firstValue
                    
                    self.userInfo.medicalInfo[0].patientBloodGroup = bloodGroupCell.celltextField.text ?? ""
                    
                }
            }
        case 1,3,4,5,6,7: break
            
        case 8: guard let hospitalDetailCell = textField.getTableViewCell as? DateOfBirthCell else{return}
        
        switch indexPath.row {
            
        case 0: break
            
        case 1: MultiPicker.openPickerIn(hospitalDetailCell.celltextField, firstComponentArray: hospitalAddressArray, secondComponentArray: [], firstComponent: hospitalDetailCell.celltextField.text, secondComponent: nil, titles: ["Choose Address"], doneBlock: { (firstValue, _,_,_) in
            
            hospitalDetailCell.celltextField.text = firstValue
            
            let hospitalAddressId = self.mapHospitalId(hospitalDetailCell.celltextField.text ?? "", self.hospInfo)
            
            self.hospInfo[0].hospitalId = hospitalAddressId
            
        })
        default: break
            
            }
        case 9: guard let treatmentCell = textField.getTableViewCell as? DateOfBirthCell else { return }
        
        switch indexPath.row{
            
        case 0:MultiPicker.openPickerIn(treatmentCell.celltextField, firstComponentArray: specialityArray, secondComponentArray: [], firstComponent: treatmentCell.celltextField.text, secondComponent: nil, titles: ["Choose Speciality"], doneBlock: { (firstValue, _,_,_) in
            
            treatmentCell.celltextField.text = firstValue
            
            self.userInfo.patientSpeciality = treatmentCell.celltextField.text ?? ""
            
        })
            
        case 1: MultiPicker.openPickerIn(treatmentCell.celltextField, firstComponentArray: surgeyNameArray, secondComponentArray: [], firstComponent: treatmentCell.celltextField.text, secondComponent: nil, titles: ["Type Of Surgery"], doneBlock: { (firstValue, _,_,_) in
            
            treatmentCell.celltextField.text = firstValue
            let surgeryId = self.mapSurgeryId(treatmentCell.celltextField.text ?? "", self.surgeryModel)
            
            self.surgeyName.insert(treatmentCell.celltextField.text!, at: 0)
            
            self.userInfo.surgeryId = surgeryId
            
        })
            
        case 2: DatePicker.openPicker(in: treatmentCell.celltextField, currentDate: nil, minimumDate: nil, maximumDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), pickerMode: .date, doneBlock: { (date) in
            printlnDebug("Date : \(date)")
            
            let dateInString = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
            treatmentCell.celltextField.text = dateInString
            
            self.userInfo.treatmentinfo[0].dateOfAdmission = date
            
        })
            
        case 3: DatePicker.openPicker(in: treatmentCell.celltextField, currentDate: nil, minimumDate: nil, maximumDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), pickerMode: .date, doneBlock: { (date) in
            printlnDebug("Date : \(date)")
            
            let dateInString = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
            treatmentCell.celltextField.text = dateInString
            self.userInfo.treatmentinfo[0].dateOfSurgery = date
            
        })
            
        case 4: DatePicker.openPicker(in: treatmentCell.celltextField, currentDate: nil, minimumDate: nil, maximumDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), pickerMode: .date, doneBlock: { (date) in
            printlnDebug("Date : \(date)")
            
            let dateInString = date.stringFormDate(DateFormat.yyyyMMdd.rawValue)
            
            treatmentCell.celltextField.text = dateInString
            self.userInfo.treatmentinfo[0].dateofDischarge = date
            
        })
            
        default: fatalError("Treatment Section Cell Not Found!")
            }
        default: fatalError("Section NOt Found!")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let indexpath = textField.tableViewIndexPathIn(medicalProfileTableView) else{return true}
        
        switch indexpath.section {
            
        case 0:
            
            switch indexpath.row {
                
            case 0: guard let heightCell = textField.getTableViewCell as? HeightCell else{return true}
            
            delay(0.1, closure: {
                
                if let height1 = heightCell.feetTextField.text{
                    
                    if !height1.isEmpty{
                        
                        self.userInfo.medicalInfo[0].patientHeight1 = Int(height1)
                        
                    }
                }
                if let height2 = heightCell.inchTextField.text{
                    
                    if !height2.isEmpty{
                        
                        self.userInfo.medicalInfo[0].patientHeight2 = Int(height2)
                    }
                }
            })
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 2
                
            case 1: guard let weightCell = textField.getTableViewCell as? WeightCell else{return true}
            
            delay(0.1, closure: {
                
                if let weightValue = weightCell.measurementTextField.text{
                    
                    if !weightValue.isEmpty{
                        
                        self.userInfo.medicalInfo[0].patientWeight = Int(weightValue)
                    } 
                }
            })
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 3
                
            default : return true
            }
            
        case 1,2,3: break
        case 4: guard let addDescriptionCell = textField.getTableViewCell as? AddDescriptionCell else{
            
            return true
        }
        
        delay(0.1, closure: {
            
            self.userInfo.medicalCategoryInfo[0].patientAllergy = addDescriptionCell.descriptionTextField.text ?? ""
            
        })
            
            
        case 5: guard let familyHistory = textField.getTableViewCell as? AddDescriptionCell else{
            
            return true
        }
        
        delay(0.1, closure: {
            
            self.userInfo.medicalCategoryInfo[0].familyAllergy = familyHistory.descriptionTextField.text ?? ""
        })
            
        case 6: guard let previousMedicalHistory = textField.getTableViewCell as? AddDescriptionCell else{
            
            return true
        }
        delay(0.1, closure: {
            
            self.userInfo.medicalCategoryInfo[0].previousAllergy = previousMedicalHistory.descriptionTextField.text ?? ""
            
        })
            
        case 7,8,9: break
            
        default: fatalError("Cell Not Found!")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        guard let indexPath = textField.tableViewIndexPathIn(medicalProfileTableView) else {return true}
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        
        
        switch indexPath.section{
            
        case 0:
            guard let heightCell = self.medicalProfileTableView.cellForRow(at: indexPath) as? HeightCell else{
                
                guard let weightCell = textField.getTableViewCell as? WeightCell else{return true}
                weightCell.measurementTextField.resignFirstResponder()
                return false
            }
            if indexPath.row == 0{
                if feetunitState == .ft{
                    if heightCell.feetTextField.isFirstResponder{
                        heightCell.inchTextField.becomeFirstResponder()
                    }
                    else if heightCell.inchTextField.isFirstResponder{
                        guard let weightCell = self.medicalProfileTableView.cellForRow(at: nextIndexPath) as? WeightCell else{return true}
                        
                        weightCell.measurementTextField.becomeFirstResponder()
                    }
                }
                else{
                    guard let weightCell = self.medicalProfileTableView.cellForRow(at: nextIndexPath) as? WeightCell else{return true}
                    
                    weightCell.measurementTextField.becomeFirstResponder()
                }
            }
            
        case 1,2,3: break
        case 4:
            let nextIndexpathSection = IndexPath(row: indexPath.row, section: 2)
            guard let familyHistoryCell = self.medicalProfileTableView.cellForRow(at: nextIndexpathSection) as? AddDescriptionCell
                
                else{return true}
            
            familyHistoryCell.descriptionTextField.becomeFirstResponder()
            
        case 5:
            let nextIndexpathSection = IndexPath(row: indexPath.row, section: 3)
            guard let previousMedicalhistoryCell = self.medicalProfileTableView.cellForRow(at: nextIndexpathSection) as? AddDescriptionCell
                
                else{return true}
            
            previousMedicalhistoryCell.descriptionTextField.becomeFirstResponder()
            
            
        case 6:
            let nextIndexpathSection = IndexPath(row: indexPath.row, section: 3)
            guard let previousMedicalHistoryCell = self.medicalProfileTableView.cellForRow(at: nextIndexpathSection) as? AddDescriptionCell
                
                else{return true}
            
            previousMedicalHistoryCell.descriptionTextField.resignFirstResponder()
            
        default: fatalError("Section Not Found!")
            
        }
        return true
    }
}

//MARK:- Methods
//==============
extension MedicalProfileVC {
    
    //    MARK: setUp The NibFiles
    //    =========================
    fileprivate func setUpViews(){
        
        let heightCellNib = UINib(nibName: "HeightCell", bundle: nil)
        medicalProfileTableView.register(heightCellNib, forCellReuseIdentifier: "heightCell")
        
        let weightCellNib = UINib(nibName: "WeightCell", bundle: nil)
        medicalProfileTableView.register(weightCellNib, forCellReuseIdentifier: "weightCell")
        
        let bloodGroupCellNib = UINib(nibName: "DateOfBirthCell", bundle: nil)
        medicalProfileTableView.register(bloodGroupCellNib, forCellReuseIdentifier: "dateOfBirthCell")
        
        let descriptionCellNib = UINib(nibName: "AddDescriptionCell", bundle: nil)
        medicalProfileTableView.register(descriptionCellNib, forCellReuseIdentifier: "addDescriptionCell")
        
        let hypertensionCellNib = UINib(nibName: "HypertensionCell", bundle: nil)
        medicalProfileTableView.register(hypertensionCellNib, forCellReuseIdentifier: "hypertensionCell")
        
        let headerView = UINib(nibName: "HeaderView", bundle: nil)
        medicalProfileTableView.register(headerView, forCellReuseIdentifier: "headerView")
        
    }
    
    //    MARK: ToogleBtn Action
    //    =======================
    func tappedToggleBtn(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.medicalProfileTableView) else{
            
            return
        }
        guard let cell = self.medicalProfileTableView.cellForRow(at: indexPath) as? HypertensionCell else{
            
            return
        }
        
        switch indexPath.section {
            
        case 0 : break
        case 1:
            
            switch indexPath.row{
                
            case 0:
                
                if self.hypertensiontoogleState {
                    
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    
                    self.hypertensiontoogleState = false
                    self.hypertensionFatherToogleState = false
                    self.hypertensionMotherToogleState = false
                    
                    hypertensionArrary.remove(at: 1)
                    hypertensionArrary.remove(at: 1)
                    
                    self.userInfo.medicalInfo[0].hypertension = false.rawValue
                    self.userInfo.medicalInfo[0].patientHyperTensionFather = false.rawValue
                    self.userInfo.medicalInfo[0].patientHyperTensionMother = false.rawValue
                    
                    
                    self.medicalProfileTableView.beginUpdates()
                    self.medicalProfileTableView.deleteRows(at: [[1,1]], with: .top)
                    self.medicalProfileTableView.deleteRows(at: [[1,2]], with: .top)
                    self.medicalProfileTableView.endUpdates()
                    
                }else{
                    
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                    
                    hypertensionArrary.insert(K_FATHER_PLACEHOLDER.localized, at: 1)
                    hypertensionArrary.insert(K_MOTHER_PLACEHOLDER.localized, at: 2)
                    
                    self.userInfo.medicalInfo[0].hypertension = true.rawValue
                    
                    self.hypertensiontoogleState = true
                    
                    self.medicalProfileTableView.beginUpdates()
                    self.medicalProfileTableView.insertRows(at: [[1,1]], with: .top)
                    self.medicalProfileTableView.insertRows(at: [[1,2]], with: .top)
                    self.medicalProfileTableView.endUpdates()
                    
                }
                
            case 1: if hypertensionFatherToogleState{
                
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                self.userInfo.medicalInfo[0].patientHyperTensionFather = false.rawValue
                hypertensionFatherToogleState = false
                
            }
            else{
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                self.userInfo.medicalInfo[0].patientHyperTensionFather = true.rawValue
                hypertensionFatherToogleState = true
                
                }
                
            case 2:
                
                if hypertensionMotherToogleState{
                    
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    self.userInfo.medicalInfo[0].patientHyperTensionMother = false.rawValue
                    hypertensionMotherToogleState = false
                    
                }
                else{
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                    self.userInfo.medicalInfo[0].patientHyperTensionMother = true.rawValue
                    hypertensionMotherToogleState = true
                    
                }
                
            default: fatalError("Hypertenaion Cell Section Not Found!")
                
            }
            
        case 2:
            
            switch indexPath.row {
                
            case 0: if diabitiesToogleState{
                
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                self.diabitiesFatherToogleState = false
                self.diabitiesMotherToogleState = false
                diabitiesArray.remove(at: 1)
                diabitiesArray.remove(at: 1)
                
                self.medicalProfileTableView.beginUpdates()
                self.medicalProfileTableView.deleteRows(at: [[2,1]], with: .top)
                self.medicalProfileTableView.deleteRows(at: [[2,2]], with: .top)
                self.medicalProfileTableView.endUpdates()
                
                self.userInfo.medicalInfo[0].diabities = false.rawValue
                diabitiesToogleState = false
                
                
            }else{
                
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                diabitiesArray.insert(K_FATHER_PLACEHOLDER.localized, at: 1)
                diabitiesArray.insert(K_MOTHER_PLACEHOLDER.localized, at: 2)
                
                self.medicalProfileTableView.beginUpdates()
                self.medicalProfileTableView.insertRows(at: [[2,1]], with: .top)
                self.medicalProfileTableView.insertRows(at: [[2,2]], with: .top)
                self.medicalProfileTableView.endUpdates()
                
                self.userInfo.medicalInfo[0].diabities = true.rawValue
                diabitiesToogleState = true
                
                }
            case 1: if diabitiesFatherToogleState{
                
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                self.userInfo.medicalInfo[0].patientDiabitiesFather = false.rawValue
                diabitiesFatherToogleState = false
                
            }
            else{
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                self.userInfo.medicalInfo[0].patientDiabitiesFather = true.rawValue
                diabitiesFatherToogleState = true
                
                }
                
            case 2:
                
                if diabitiesMotherToogleState{
                    
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                    self.userInfo.medicalInfo[0].patientDiabitiesMother = false.rawValue
                    diabitiesMotherToogleState = false
                    
                }
                else{
                    cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                    self.userInfo.medicalInfo[0].patientDiabitiesMother = true.rawValue
                    diabitiesMotherToogleState = true
                    
                }
                
            default: fatalError("Diabities Cell Section Not Found!")
                
            }
            
        case 3:
            
            if smokingtoogleBtnState{
                
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
                self.userInfo.medicalInfo[0].smoking = false.rawValue
                smokingtoogleBtnState = false
                
            }else{
                cell.toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_on_shift"), for: .normal)
                self.userInfo.medicalInfo[0].smoking = true.rawValue
                smokingtoogleBtnState =  true
                
            }
            
        case 4,5,6: break
        case 7: if foodcategoryToggleState {
            
            self.userInfo.medicalCategoryInfo[0].foodCategory = false.rawValue
            foodcategoryToggleState = false
        }
        else {
            
            self.userInfo.medicalCategoryInfo[0].foodCategory = true.rawValue
            foodcategoryToggleState = true
            
            }
            
        default: fatalError("Indexpath section not Found!")
            
        }
        self.medicalProfileTableView.reloadData()
    }
    
    
    //    MARK: Tap on icon of textfield
    //    ==============================
    func textFieldtap(_ sender : UITapGestureRecognizer){
        
        textFieldTapped(sender)
    }
    
    //    MARK: HIT Type OF SURGEY SERVICE
    //    ================================
    fileprivate func typeOfSugeryServiceHit(){
        
        WebServices.typeOfSurgery(parameters: blankDictionary, success: {[unowned self] (_ surgeryModel : [SurgeryModel]) in
            
            self.surgeryModel = surgeryModel
            
            for surgName in surgeryModel {
                
                self.surgeyNameArray.append(surgName.surgeryName!)
                
            }
            
            self.mapSurgeyName(self.userInfo.surgeryId!, surgeryModel)
            
        }) { (e : Error) in
            
            //            self.view.makeToast(e.localizedDescription)
            
        }
    }
    
    //    MARK: Hit Specitlity Service
    //    ============================
    
    fileprivate func specialityService(){
        
        WebServices.speciality(parameters: blankDictionary, success: {[unowned self] (_ specArr: [SpecialityModel]) in
            
            for speciality in specArr {
                
                self.specialityArray.append(speciality.specialityName)
            }
            
            printlnDebug(self.specialityArray)
            
        }) { (_ e: Error) in
            
            //            self.view.makeToast(e.localizedDescription)
            
        }
    }
    
    //    MARK: Map the HospitalAddress with UserHospitalId
    //    ==================================================
    fileprivate func mapHospitalAddress(_ userModelValue : Int, _ addressInfo : [HospitalInfo]) -> String{
        
        var hospAdd = [String]()
        hospAdd = addressInfo.map({ (value : HospitalInfo) -> String in
            
            if value.hospitalId == userModelValue{
                printlnDebug("value.hospitalId : \(value.hospitalId)")
                printlnDebug("userModelValue : \(userModelValue)")
                return value.hospitalAddress!
            }else{
                return ""
            }
        })
        printlnDebug("hospAdd : \(hospAdd.first)")
        
        return hospAdd.first ?? ""
    }
    
    //    MARK: Map the addressID with Selected Address
    //    =============================================
    fileprivate func mapHospitalId(_ userModelValue : String, _ addressInfo : [HospitalInfo]) -> Int{
        
        var hospitalID = [Int]()
        hospitalID = addressInfo.map({ (value : HospitalInfo) -> Int in
            
            if value.hospitalAddress == userModelValue {
                printlnDebug("value.hospitalId : \(value.hospitalAddress)")
                printlnDebug("userModelValue : \(userModelValue)")
                
            }
            return value.hospitalId!
        })
        
        printlnDebug("hospitalID : \(hospitalID)")
        return (hospitalID.first ?? nil)!
    }
    
    //    MARK: Map the SurgeyName and UserModel
    //    =======================================
    fileprivate func mapSurgeyName(_ userModelValue : Int, _ surgeryInfo : [SurgeryModel]){
        
        
        self.surgeyName = surgeryInfo.map({ (value : SurgeryModel) -> String in
            
            guard let surgeryId = value.surgeryId else{
                
                return ""
            }
            
            if surgeryId == userModelValue{
                
                printlnDebug("SurgeryID : \(surgeryId)")
                printlnDebug("userModelValue : \(userModelValue)")
                
                return value.surgeryName!
            }
            else{
                return ""
            }
        }).filter{(!$0.isEmpty == true)}
        
        printlnDebug("SurgeyName : \(self.surgeyName)")
    }
    
    //    MARK: Map the surgeryID with Selected Surgery
    //    =============================================
    fileprivate func mapSurgeryId(_ userModelValue : String, _ surgeryInfo : [SurgeryModel]) -> Int{
        
        var surgeryID = [Int]()
        surgeryID = surgeryInfo.map({ (value : SurgeryModel) -> Int in
            
            if value.surgeryName == userModelValue{
                
                printlnDebug("value.surgeryName : \(value.surgeryName)")
                printlnDebug("userModelValue : \(userModelValue)")
                
            }
            return value.surgeryId!
        })
        
        printlnDebug("surgeryID : \(surgeryID)")
        return (surgeryID.first ?? nil)!
    }
    
    //    MARK:- Toogle Btn State
    //    =======================
    fileprivate func hyperTensionBtnState(){
        
        if let hypertension = self.userInfo.medicalInfo[0].hypertension{
            
            if hypertension == 0 {
                
                self.hypertensiontoogleState = false
                
            }else{
                
                hypertensionArrary.insert(K_FATHER_PLACEHOLDER.localized, at: 1)
                hypertensionArrary.insert(K_MOTHER_PLACEHOLDER.localized, at: 2)
                
                self.hypertensiontoogleState = true
            }
        }
        
        if let fatherHypertension = self.userInfo.medicalInfo[0].patientHyperTensionFather{
            
            if fatherHypertension == 0 {
                self.hypertensionFatherToogleState = false
                
            }else{
                
                self.hypertensionFatherToogleState = true
            }
        }
        
        if let motherHypertension = self.userInfo.medicalInfo[0].patientHyperTensionFather{
            
            if motherHypertension == 0 {
                self.hypertensionMotherToogleState = false
                
            }else{
                
                self.hypertensionMotherToogleState = true
            }
        }
        
        if let diabities = self.userInfo.medicalInfo[0].diabities {
            
            if diabities == 0 {
                
                self.diabitiesToogleState = false
                
            }else{
                
                self.diabitiesArray.insert(K_FATHER_PLACEHOLDER.localized, at: 1)
                self.diabitiesArray.insert(K_MOTHER_PLACEHOLDER.localized, at: 2)
                
                self.diabitiesToogleState = true
                
            }
        }
        
        if let fatherDiabities = self.userInfo.medicalInfo[0].patientDiabitiesFather {
            
            if fatherDiabities == 0 {
                
                self.diabitiesFatherToogleState = false
                
            }else{
                
                self.diabitiesFatherToogleState = true
            }
        }
        
        if let motherDiabities = self.userInfo.medicalInfo[0].patientDiabitiesMother {
            
            if motherDiabities == 0 {
                
                self.diabitiesMotherToogleState = false
                
            }else{
                
                self.diabitiesMotherToogleState = true
            }
        }
        
        if let smoking = self.userInfo.medicalInfo[0].smoking {
            
            if smoking == 0{
                
                self.smokingtoogleBtnState = false
                
            }else{
                
                self.smokingtoogleBtnState = true
                
            }
        }
    }
}
