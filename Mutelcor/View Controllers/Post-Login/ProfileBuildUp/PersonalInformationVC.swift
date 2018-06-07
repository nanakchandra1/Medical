//
//  PersonalInformationVC.swift
//  Mutelcor
//
//  Created by  on 20/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AlamofireImage
import TransitionButton

//MARk:- Enum for Gender representation
//====================================
enum Gender : Int{
    case male = 0
    case female = 1
    case others = 2
}

//MARk:- Enum for Patient Occupation
//==================================
enum PatientOccupation: String {
    case services = "1"
    case business = "2"
    case others = "3"
}
//MARk:- Enum for Marital Status
//==============================
enum MaritalStatus: String {
    case single = "1"
    case married = "2"
    case seprated = "3"
}

enum NavigateToProfileBuild {
    case sideMenu
    case signUp
}

enum FeetUnit : Int{
    case ft = 1
    case cm = 0
}

enum FoodCategoryType: Int {
    case veg = 1
    case nonVeg = 2
    case both = 3
}

enum ActivityType: Int {
    case active = 1
    case moderate = 2
    case sedentary = 3
    case none = 0
}

enum AllergiesOptionSelection: Int {
    case yes = 1
    case no = 2
    case dontknow = 3
    case none = 0
}

enum EatingVolumes: Int {
    case large = 1
    case moderate = 2
    case small = 3
    case none = 0
}

enum CountryButtonTapped {
    case countryBtn
    case stateBtn
    case cityBtn
    case none
}

enum SectionButtonTapped {
    
    case patientDemographic
    case patientMedicalCompliants
    case hospitalDetail
    case treatmentDetail
    case none
}

class PersonalInformationVC: BaseViewController  {
    
    //    MARK:- Properties
    //    ================
    var userInfo: UserInfo?
    var treatmentDetailInfo: [TreatmentDetailInfo] = []
    
    var userDetails: [String: [String: Any]] = [:]
    var typesOfUserDetails = [K_PERSONAL_INFORMATION.localized, K_MEDICAL_PROFILE.localized, K_ALLERGIES.localized,"","","",
                              K_HOSPITAL_DETAILS.localized]
    
    var patientDemographicList = [K_PATIENT_NAME_PLACEHOLDER.localized,K_DATE_OF_BIRTH_PLACEHOLDER.localized,K_GENDER_PLACEHOLDER.localized,K_EMAIL_ADDRESS_PLACEHOLDER.localized,K_MOBILE_NUMBER_PLACEHOLDER.localized,K_ADDRESS_TYPE.localized,K_PIN_CODE_PLACEHOLDER.localized,K_ADDRESS_DETAIL.localized,K_COUNTRY_PLACEHOLDER.localized,K_STATE_PLACEHOLDER.localized, K_TOWN_PLACEHOLDER.localized,K_ETHNICITY_PLACEHOLDER.localized,K_REFFERED_PLACEHOLDER.localized,K_PATIENT_OCCUPATION.localized,K_MARITAL_STATUS.localized,K_FATHERS_NAME_PLACEHOLDER.localized,K_MOTHER_NAME_PLACEHOLDER.localized,K_SPOUSE_NAME_PLACEHOLDER.localized, K_EMERGENCY_CONTACT_PERSON.localized, K_RELATIONSHIP_PLACEHOLDER.localized, K_EMERGENCY_CONSTACT_PLACEHOLDER.localized]
    
    var presentMedicalCompiants = [K_BLOOD_GROUP_PLACEHOLDER.localized, K_FOOD_CATEGORY_DETAILS_PLACEHOLDER.localized, K_HEIGHT_PLACEHOLDER.localized, K_WEIGHT_PLACEHOLDER.localized, K_IDEAL_WEIGHT_PLACEHOLDER.localized,K_EXCESS_WEIGHT_PLACEHOLDER.localized,K_WEIGHT_MAXIMUM_ACHIEVED.localized,K_WEIGHT_MAXIMUM_LOSS.localized, K_MAXIMUM_LOSS_PLACEHOLDER.localized,K_WAIST_CIRCUMFRENCE_PLACEHOLDER.localized, K_HIP_CIRCUMFRENCE_PLACEHOLDER.localized, K_PAST_MEDICAL_COMPLIANTS_PLACEHOLDER.localized, K_NEUROLOGICAL_PLACEHOLDER.localized, K_RESPIRATORY_PLACEHOLDER.localized, K_CARDIAC_PLACEHOLDER.localized, K_ABDOMINAL_PLACEHOLDER.localized, K_JOINTS_AND_BONES_PLACEHOLDER.localized, K_HORMONAL_PLACEHOLDER.localized, K_PHYCHOLOGICAL_PLACEHOLDER.localized, K_OTHERS_PLACEHOLDER.localized, K_PRESENT_MEDICAL_TREATMENT_PLACEHOLDER.localized]
    
    var environmentalAllergyDetails = [K_ENVIRONMENTAL_PLACEHOLDER.localized]
    var foodAllergyDetails = [K_FOOD_PLACEHOLDER.localized]
    var drugAllergyDetails = [K_DRUG_PLACEHOLDER.localized]
    
    let activityDetail = [K_ACTIVITY_SCREEN_TITLE.localized, K_FAMILY_HISTORY_OBESITY.localized,K_FAMILY_HISTORY_OBESITY_REASON.localized, K_FAMILY_HISTORY_MEDICAL_DISEASES.localized,K_FAMILY_HISTORY_MEDICAL_DISEASES_REASON.localized, K_DO_YOU_LOVE_TO_EAT.localized, K_DO_YOU_HAVE_AN_EXCESSIVE_APPETITE.localized,K_EXCESS_APETITE_REASON.localized, K_DO_YOU_HAVE_AN_ERRATIC_TIMMING.localized, K_EATING_VOLUMES.localized, K_AFFINITY_FOR_SWEETS.localized, K_ALCOHOL.localized,K_ALCOHOL_REASON.localized, K_TOBACCO.localized,K_TOBACOO_REASON.localized, K_ILLEGA_DRUGS.localized,K_ILLEGAL_DRUG_REASON.localized, K_JUNK_FOOD_PER_WEEK.localized, K_ARE_YOU_OBESE.localized, K_TREATMENT_SO_FAR_FOR_OBESITY.localized,K_TREATMENT_FOR_OBESITY.localized]

    var hospitalDetail = [K_DOCTOR_NAME_PLACEHOLDER.localized,K_DOCTOR_ADDRESS_PLACEHOLDER.localized,K_ASSOSIATED_DOCTOR.localized,K_OTHERS_DOCTOR.localized]

    var treatmentDetail = [K_TYPE_OF_SURGERY_PLACEHOLDER.localized,K_REASON_OF_REVISION_PLACEHOLDER.localized,K_OPERATIVE_APPROACH_PLACEHOLDER.localized,K_DATE_OF_ADMISSION_PLACEHOLDER.localized,K_DATE_OF_SURGERY_PLACEHOLDER.localized,]
    
    let heightUnitArray = [K_FEET_PLACEHOLDER.localized, K_CM_PLACEHOLDER.localized]
    let weightUnitArray = [K_KG_PLACEHOLDER.localized, K_LBS_PLACEHOLDER.localized]
    let waistUnitArray = [K_INCH_UNIT_PLACEHOLDER.localized, K_CM_PLACEHOLDER.localized]
    let bloodUnitType = [O_PLUS_PLACEHOLDER.localized, O_NEGATIVE_PLACEHOLDER.localized ,A_PLUS_PLACEHOLDER.localized, A_NEGATIVE_PLACEHOLDER.localized, B_PLUS_PLACEHOLDER.localized, B_NEGATIVE_PLACEHOLDER.localized, AB_PLUS_PLACEHOLDER.localized, AB_NEGATIVE_PLACEHOLDER.localized]
    
    let severityType = [K_MILD_SEVERITIY.localized, K_MODERATE_SEVERITIY.localized, K_SEVERE_SEVERITIY.localized]
    let addressType = [K_CURRENT_ADDRESS_TYPE.localized, K_PERMANENT_ADDRESS_TYPE.localized]
    
    let patientOccupation = [K_SERVICE_TEXT.localized, K_BUSINESS_TEXT.localized, K_OTHERS_TEXT.localized]
    let genderStatus = [K_MR_PLACEHOLDER.localized, K_MRS_PLACEHOLDER.localized, K_MS_PLACEHOLDER.localized, K_DR_PLACEHOLDER.localized]
    let maritalStatus = [K_SINGLE_TEXT.localized, K_MARRIED_TEXT.localized, K_SEPRATE_TEXT.localized]
    
    var selectedIndex: [Int] = []
    
    var feetunitState = FeetUnit.ft
    
    var addEnvironmentalAllergy = [String]()
    var addFoodAllergy = [String]()
    var addDrugAllergy = [String]()
    var environmentalAllergy = ""
    var environmentalSeverity = ""
    var foodAllergy = ""
    var foodSeverity = ""
    var drugAllergy = ""
    var drugSeverity = ""
    var environmentalSurgeryCollectionHeight: CGFloat = 0
    var foodSurgeryCollectionHeight: CGFloat = 0
    var drugSurgeryCollectionHeight: CGFloat = 0
    
    var ethinicityModel = [EthinicityNameModel]()
    var ethinicityArray = [String]()
    var ethinicityName = [String]()
    var ethinicityListDic = [[String : Any]]()
    
    var countryListDic = [[String : Any]]()
    var countryCodeList = [CountryCodeModel]()
    var stateNameList = [StateNameModel]()
    var citynameList = [CityNameModel]()
    var countryArray = [String]()
    var countryCode : String?
    
    var stateListParam = [String : Any]()
    var stateListDic = [[String : Any]]()
    var stateArray = [String]()
    var stateCode: String?
    
    var cityListDic = [[String : Any]]()
    var townArray = [String]()
    
    var btnTapped: CountryButtonTapped = .none

    fileprivate var isMale: Bool = true
    var userImage: UIImage?
    var proceedToScreen: NavigateToProfileBuild = .signUp
    var sectionButtonTapped: SectionButtonTapped = .none

    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var profileInformationTableView: UITableView!
    @IBOutlet weak var saveButton: TransitionButton!
    
    //    MARK:- Viewcontroller Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.proceedToScreen == .sideMenu {
            self.floatBtn.isHidden = false
            self.isSideMenuBtnHidden = false
            self.sideMenuBtnActn = .sideMenuBtn
            self.navigationControllerOn = .dashboard
            self.addBtnDisplayedFor = .none
            self.setNavigationBar(screenTitle: K_UPDATE_PROFILE_TITLE.localized)
        }else{
            self.floatBtn.isHidden = true
            self.navigationControllerOn = .login
            self.isSideMenuBtnHidden = true
            self.setNavigationBar(screenTitle: BUILD_PROFILE_SCREEN_TITLE.localized)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.saveButton.gradient(withX: 0, withY: 0, cornerRadius: true)
    }
    
//    MARK:- IBActions
//    ================
    @IBAction func saveButtonTapped(_ sender: TransitionButton) {
        self.saveUserData()
    }
    
    // UIIMagePickerController Delegate Methods
//    =========================================
    override func getSelectedImage(capturedImage image: UIImage){
        super.getSelectedImage(capturedImage: image)
        dismiss(animated: true, completion: nil)
        Cropper.shared.openCropper(withImage: image, mode: .circle, on: self)
    }
    
    override func imagePickerControllerDidCancel(){
        super.imagePickerControllerDidCancel()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Croper Delegate Method
    //=============================
    override func imageCropperDidCancelCrop() {
        //printlnDebug("Crop cancelled")
    }
    
    override func imageCropper(didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.userImage = croppedImage
        self.profileInformationTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
}

//MARK:- Methods
//==============
extension PersonalInformationVC {
    
    fileprivate func setupUI(){
        
        self.profileInformationTableView.dataSource = self
        self.profileInformationTableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.saveButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.saveButton.clipsToBounds = false
        self.saveButton.setTitle(K_SAVE_BUTTON_TITLE.localized.uppercased(), for: .normal)
        self.saveButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        if self.proceedToScreen == .sideMenu {
            self.getPatientDetail()
        }

        self.registerNibs()
        self.fetchEthinicity()
        self.getCountry()
    }
    
    //    MARK:- register NibFiles
    //    =========================
    fileprivate func registerNibs(){
        
        let userImageNib = UINib(nibName: "UserImageCell", bundle: nil)
        profileInformationTableView.register(userImageNib, forCellReuseIdentifier: "userImageCell")
        
        let emailNib = UINib(nibName: "EmailCell", bundle: nil)
        profileInformationTableView.register(emailNib, forCellReuseIdentifier: "emailCell")
        
        let dateOfBirthNib = UINib(nibName: "DateOfBirthCell", bundle: nil)
        profileInformationTableView.register(dateOfBirthNib, forCellReuseIdentifier: "dateOfBirthCell")
        
        let genderDetailNib = UINib(nibName: "GenderDetailCell", bundle: nil)
        profileInformationTableView.register(genderDetailNib, forCellReuseIdentifier: "genderDetailCell")
        
        let phoneNumberNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        profileInformationTableView.register(phoneNumberNib, forCellReuseIdentifier: "PhoneDetailsCellID")
        
        let phoneNumberCellNib = UINib(nibName: "PhoneNumberCell", bundle: nil)
        profileInformationTableView.register(phoneNumberCellNib, forCellReuseIdentifier: "phoneNumberCell")
        
        let heightCellNib = UINib(nibName: "HeightCell", bundle: nil)
        self.profileInformationTableView.register(heightCellNib, forCellReuseIdentifier: "heightCell")
        
        let weightCellNib = UINib(nibName: "WeightCell", bundle: nil)
        self.profileInformationTableView.register(weightCellNib, forCellReuseIdentifier: "weightCell")
        
        let allergyDetailCellNib = UINib(nibName: "AllergyDetailsCell", bundle: nil)
        self.profileInformationTableView.register(allergyDetailCellNib, forCellReuseIdentifier: "allergyDetailsCellID")

        let addAllergyCollectionViewNib = UINib(nibName: "AddAllergyCollectionView", bundle: nil)
        self.profileInformationTableView.register(addAllergyCollectionViewNib, forCellReuseIdentifier: "addAllergyCollectionViewID")
        
        let junkFoodPerWeekCellNib = UINib(nibName: "JunkFoodPerWeekCell", bundle: nil)
        self.profileInformationTableView.register(junkFoodPerWeekCellNib, forCellReuseIdentifier: "junkFoodPerWeekCell")
        
        let FamilyHistoryOfObesityNib = UINib(nibName: "FamilyHistoryOfObesity", bundle: nil)
        self.profileInformationTableView.register(FamilyHistoryOfObesityNib, forCellReuseIdentifier: "familyHistoryOfObesity")
        
        let personalInfoHeaderCellnib = UINib.init(nibName: "PersonalInfoHeaderCell", bundle: nil)
        self.profileInformationTableView.register(personalInfoHeaderCellnib, forHeaderFooterViewReuseIdentifier: "personalInfoHeaderCell")
    }
    //    MARK:- ActionSheet To Open the Camera
    //    =====================================
    @objc func textFieldtap(_ sender : UITapGestureRecognizer){
        textFieldTapped(sender)
    }
    
    @objc func openActionSheet(){
        ImagePicker.shared.imagePickerDelegate = self
        ImagePicker.shared.captureImage(on: self)
    }

    //    MARK: Tap on icon of textfield
    //    ==============================
    @objc func textFieldTapped(_ sender : UITapGestureRecognizer) {
        textFieldTapped(sender)
    }
    
    // For map values
    func mapValues(_ textValue :String) -> Int?{

        let etinicity = self.ethinicityModel.filter { (ethinicity) -> Bool in
            return ethinicity.ethinicityName?.uppercased() == textValue.uppercased()
        }
        return etinicity.first?.ethinicityID ?? nil
    }
}
