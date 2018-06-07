//
//  EmailCellTableViewCell.swift
//  Mutelcor
//
//  Created by  on 22/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var celltextField: UITextField!
    @IBOutlet weak var cellButtonOutlt: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellButtonOutlt.isHidden = true
        self.cellTitle.isHidden = false
        self.sepratorView.isHidden = false
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.celltextField.isEnabled = true
        self.celltextField.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.cellTitle.isHidden = false
//        self.sepratorView.isHidden = false
        self.cellButtonOutlt.isHidden = true
        self.cellButtonOutlt.isEnabled = false
        self.celltextField.textColor = UIColor.black
        self.celltextField.text = ""
    }
}

//MARK:- Data Populate on Cell
//============================
extension EmailCell {
    
    func populateData(_ userInfo : UserInfo?, indexPath: IndexPath, addressTypeArray: [String] = [], occupation: [String] = [], maritalStatus: [String] = []) {

        let firstSectionRightViewImage = (indexPath.section == 0 && (indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 13 || indexPath.row == 14))
        let secondSectionRightViewImage = (indexPath.section == 1 && (indexPath.row == 0))
        let image = (firstSectionRightViewImage || secondSectionRightViewImage) ? #imageLiteral(resourceName: "personal_info_down_arrow") : nil
        self.celltextField.rightView = UIImageView(image: image)
        self.celltextField.rightViewMode = .always
        let cellButtonEnabled = (indexPath.section == 0 && (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10)) ? true : false
        self.cellButtonOutlt.isEnabled = cellButtonEnabled
        self.cellButtonOutlt.isHidden = !cellButtonEnabled

        guard let userData = userInfo else{
            return
        }
        
        switch indexPath.section {
            
        case 0:
            self.cellTitle.isHidden = false
            self.sepratorView.isHidden = false
            let isTextFieldEnabled = indexPath.row == 3 ? false : true
            let textFieldColor = indexPath.row == 3 ? #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) : UIColor.black
            let keyboardType: UIKeyboardType = indexPath.row == 3 ? .emailAddress : .default
            self.celltextField.isEnabled = isTextFieldEnabled
            self.celltextField.textColor = textFieldColor
            self.celltextField.keyboardType = keyboardType
            
            switch indexPath.row {
            case 3:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_EMAIL_ADDRESS_PLACEHOLDER.localized
                self.celltextField.text = userData.patientEmail
            case 5:
                let addressType = userData.addressType == 1 ? addressTypeArray[0] : addressTypeArray[1]
                self.celltextField.text = addressType
            case 6:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_PIN_CODE_PLACEHOLDER.localized
                self.celltextField.text = userData.patientPostalCode
            case 7:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_YOUR_ADDRESS_PLACEHOLDER.localized
                self.celltextField.text = userData.address
            case 12:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_PERSON_NAME_PLACEHOLDER.localized
                self.celltextField.text = userData.referredBy
            case 13:
                self.celltextField.placeholder = K_SELECT_OCCUPATION_PLACEHOLDER.localized
                switch userData.occupation {
                case PatientOccupation.services.rawValue :
                    self.celltextField.text = occupation[0]
                case PatientOccupation.business.rawValue :
                    self.celltextField.text = occupation[1]
                case PatientOccupation.others.rawValue:
                    self.celltextField.text = occupation[2]
                default:
                   self.celltextField.text = ""
                }
            case 14:
                self.celltextField.placeholder = K_SELECT_MARITAL_PLACEHOLDER.localized
                switch userData.maritalStatus {
                case MaritalStatus.single.rawValue :
                    self.celltextField.text = maritalStatus[0]
                case MaritalStatus.married.rawValue :
                    self.celltextField.text = maritalStatus[1]
                case MaritalStatus.seprated.rawValue:
                    self.celltextField.text = maritalStatus[2]
                default:
                    self.celltextField.text = ""
                }
            case 15:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.rightViewMode = .never
                self.celltextField.placeholder = K_ENTER_YOUR_FATHER_NAME_PLACEHOLDER.localized
                self.celltextField.text = userData.fathername
            case 16:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_YOUR_MOTHER_NAME_PLACEHOLDER.localized
                self.celltextField.text = userData.motherName
            case 17:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_YOUR_SPOUSE_NAME_PLACEHOLDER.localized
                self.celltextField.text = userData.spouseName
            case 18:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_EMERGENCY_CONTACT_PERSON_PLACEHOLDER.localized
                self.celltextField.text = userData.emergencyContactPerson
            case 19:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.placeholder = K_ENTER_YRELATION_PLACEHOLDER.localized
                self.celltextField.text = userData.patientEmergencyRelationShip
            default:
                return
            }
        case 1:
            self.cellTitle.isHidden = false
            self.sepratorView.isHidden = false
            
            guard let medicalData = userData.medicalInfo.first else{
                return
            }
            let placeholder = indexPath.row == 0 ? K_SELECT_PLACEHOLDER.localized : K_WRITE_HERE.localized
            self.celltextField.placeholder = placeholder
            
            switch indexPath.row {
                
            case 0:
                self.celltextField.text = medicalData.patientBloodGroup
            case 8:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.maximumLossWeight
            case 11:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.pastMedicalCompliants
            case 12:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.neurological
            case 13:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.respiratory
            case 14:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.cardiac
            case 15:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.abdominal
            case 16:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.jointsAndBones
            case 17:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.hormonal
            case 18:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.physhological
            case 19:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.others
            case 20:
                self.celltextField.inputView = nil
                self.celltextField.inputAccessoryView = nil
                self.celltextField.text = medicalData.presentMedicalTreatment
            default:
                return
            }
        default:
            return
        }
    }
    
    func populateCountryRelatedInfo(_ userInfo : UserInfo?, indexPath: IndexPath, countryList : [CountryCodeModel], stateNameList: [StateNameModel],cityNameList: [CityNameModel], ethinicityList : [EthinicityNameModel]){
        
        self.cellTitle.isHidden = false
        self.sepratorView.isHidden = false
        guard let userData = userInfo else{
            return
        }
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 8:
                self.celltextField.placeholder = K_SELECT_COUNTRY_PLACEHOLDER.localized
                guard !countryList.isEmpty else{
                    return
                }
                let countryData = countryList.filter({ (code) -> Bool in
                    return code.countryCode == userData.country
                })
                let countryName = (!countryData.isEmpty) ? countryData.first?.countryName : ""
                self.celltextField.text = countryName
                
            case 9:
                self.celltextField.placeholder = K_SELECT_STATE_PLACEHOLDER.localized
                guard !stateNameList.isEmpty else{
                    return
                }
                
                if userData.state != 0 {
                    let stateData = stateNameList.filter({ (stateData) -> Bool in
                        return stateData.stateCode == userData.state
                    })
                    self.celltextField.text = stateData.first?.stateName ?? ""
                }
            case 10:
                self.celltextField.placeholder = K_SELECT_CITY_PLACEHOLDER.localized
                guard !cityNameList.isEmpty else{
                    return
                }
                
                if !userData.city.isEmpty {
                    let cityData = cityNameList.filter({ (cityData) -> Bool in
                        return cityData.id == userData.city
                    })
                    self.celltextField.text = cityData.first?.cityName
                }
            case 11:
                self.celltextField.placeholder = K_SELECT_ETHINICITY_PLACEHOLDER.localized
                guard !ethinicityList.isEmpty else{
                    return
                }
                let ethinicityID = userData.ethinicityId
                
                var ethinicityData = [EthinicityNameModel]()
                if let id = ethinicityID {
                    ethinicityData = ethinicityList.filter({ (ethinicityData) -> Bool in
                        return ethinicityData.ethinicityID == id
                    })
                }
                let ethinicityName = !ethinicityData.isEmpty ? ethinicityData.first?.ethinicityName : ""
                self.celltextField.text  = ethinicityName
            default:
                return
            }
        default:
            return
        }
    }
    
    func populateHositalAndTreatmentData(userInfo: UserInfo?, indexPath: IndexPath, hospitalDetail: [String], treatmentData: [String], sections: [String], treatmentDetailInfo: [TreatmentDetailInfo]){
        
        self.celltextField.placeholder = ""
        self.celltextField.isEnabled = false
        self.cellButtonOutlt.isEnabled = false
        self.cellTitle.isHidden = false
        self.sepratorView.isHidden = false
        self.celltextField.textColor = UIColor.grayLabelColor
        switch indexPath.section {
        case 6:
            self.cellTitle.text = hospitalDetail[indexPath.row]
        default:
            self.cellTitle.text = treatmentData[indexPath.row]
        }
        
        guard let userData = userInfo else{
            return
        }
        
        switch indexPath.section {
        case 6:
            guard let hospitalData = userData.hospitalInfo.first else{
                return
            }
            switch indexPath.row {
            case 0:
                self.celltextField.text = hospitalData.doctorName
            case 1:
                self.celltextField.text = hospitalData.hospitalAddress
            case 2:
                self.celltextField.text = hospitalData.associatedDoctor
            default:
                if hospitalData.isOtherDoctor {
                    self.celltextField.text = hospitalData.otherDoctor
                }else{
                    return
                }
            }
        default:
            guard !treatmentDetailInfo.isEmpty else{
                return
            }
            let treatmentDetail = treatmentDetailInfo[sections.count - indexPath.section - 1]
            switch indexPath.row {
            case 0:
                self.celltextField.text = treatmentDetail.surgeryType
            case 1:
               self.celltextField.text = treatmentDetail.reasonOfRevision
            case treatmentData.count - 1:
                self.celltextField.text = treatmentDetail.dateOfSurgery?.stringFormDate(.yyyyMMdd)
            case treatmentData.count - 2:
                self.celltextField.text = treatmentDetail.dateOfAdmission?.stringFormDate(.yyyyMMdd)
            case treatmentData.count - 3:
                self.celltextField.text = treatmentDetail.operativeApproach
            default:
                if treatmentDetail.isRevision, treatmentDetail.isOtherReasonOfRevision {
                    self.celltextField.text = treatmentDetail.pleaseSpecify
                }else{
                    return
                }
            }
        }
    }
    
    func activityData(userInfo: UserInfo?, indexPath: IndexPath){
        self.celltextField.isEnabled = true
        guard let userData = userInfo else{
            return
        }
        
        switch indexPath.section {
        case 5:
            self.cellTitle.text = ""
            self.cellTitle.isHidden = true
            self.sepratorView.isHidden = true
            guard let activityData = userData.activityInfo.first else{
                return
            }
            switch indexPath.row {
            case 2:
                self.celltextField.placeholder = K_IF_YES_WHO_ALL.localized
                self.celltextField.text = activityData.familiyHistoryObesityReason
            case 4:
                self.celltextField.placeholder = K_IF_YES_WHO_ALL.localized
                self.celltextField.text = activityData.familyHistoryOfMedicalDiseasesReason
            case 7:
                self.celltextField.placeholder = K_IF_HOW_OFTEN_TO_EAT.localized
                self.celltextField.text = activityData.excessiveApetiteReason
            case 12:
                self.celltextField.placeholder = K_IF_QTY_AND_PERIOD.localized
                self.celltextField.text = activityData.alcoholReason
            case 14:
                self.celltextField.placeholder = K_IF_QTY_AND_PERIOD.localized
                self.celltextField.text = activityData.tobaccoReason
            case 16:
                self.celltextField.placeholder = K_IF_QTY_AND_PERIOD.localized
                self.celltextField.text = activityData.illegalDrugReason
            case 20:
                self.celltextField.placeholder = K_IF_ADD_DESCRIPTION.localized
                self.celltextField.text = activityData.treatmentForObesityReason
            default:
                return
            }
        default:
            return
        }
    }
}
