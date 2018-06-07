//
//  PersonalInformationVC+UITableViewDataSource+UITableViewDelegate.swift
//  Mutelcor
//
//  Created by  on 04/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

//MARK:- UITableViewDataSource Methods
//       =============================
extension PersonalInformationVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.typesOfUserDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.selectedIndex.contains(section){
            return 0
        }else{
            switch section {
            case 0:
                return self.patientDemographicList.count
            case 1:
                return self.presentMedicalCompiants.count
            case 2:
                return self.environmentalAllergyDetails.count
            case 3:
                return self.foodAllergyDetails.count
            case 4:
                return self.drugAllergyDetails.count
            case 5:
                return self.activityDetail.count
            case 6:
                return self.hospitalDetail.count
            default:
                return self.treatmentDetail.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                
            case 0:
                guard let userImageCell = tableView.dequeueReusableCell(withIdentifier: "userImageCell", for: indexPath) as? UserImageCell else {
                    fatalError("UserImageCell Not Found !")
                }
                userImageCell.celltextField.delegate = self
                userImageCell.genderStatusTextField.delegate = self
                userImageCell.middleNameTextField.delegate = self
                userImageCell.lastNameTextField.delegate = self
                userImageCell.cellTitle.text = self.patientDemographicList[indexPath.row]
                userImageCell.populateData(self.userInfo, self.userImage, genderStatus: self.genderStatus)
                userImageCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                userImageCell.middleNameTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                userImageCell.lastNameTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(_:)))
                userImageCell.genderStatusTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
                userImageCell.setUserImagebutton.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
                
                return userImageCell
                
            case 1:
                guard let dateOfBirthCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else {
                    fatalError("DateOfBirthCell Not Found !")
                }
                dateOfBirthCell.cellBtnOutlt.isHidden = true
                dateOfBirthCell.celltextField.delegate = self
                dateOfBirthCell.celltextField.tintColor = UIColor.white
                dateOfBirthCell.cellTitle.text = self.patientDemographicList[indexPath.row]
                let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(_:)))
                dateOfBirthCell.celltextField.rightView?.addGestureRecognizer(rightViewTapGesture)
                dateOfBirthCell.populateDateOfBirth(self.userInfo)
                
                return dateOfBirthCell
                
            case 2:
                guard let genderDetailCell = tableView.dequeueReusableCell(withIdentifier: "genderDetailCell", for: indexPath) as? GenderDetailCell else {
                    fatalError("GenderDetailCell Not Found !")
                }
                
                genderDetailCell.cellTitle.text = self.patientDemographicList[indexPath.row]
                genderDetailCell.maleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.femaleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.othersBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.populateButtonSelectionStatus(self.userInfo, indexPath: indexPath)
                
                return genderDetailCell
                
            case 3,5...(self.patientDemographicList.count - 2) :
                guard let emailAddressCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else {
                    fatalError("EmailAddressCell Not Found !")
                }
                emailAddressCell.celltextField.delegate = self
                emailAddressCell.cellTitle.text = self.patientDemographicList[indexPath.row]
                let tintColor: UIColor = (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11) ? UIColor.white : UIColor.blue
                emailAddressCell.celltextField.tintColor = tintColor
                
                emailAddressCell.populateData(self.userInfo, indexPath: indexPath, addressTypeArray: self.addressType, occupation: self.patientOccupation, maritalStatus: self.maritalStatus)
                emailAddressCell.populateCountryRelatedInfo(self.userInfo, indexPath: indexPath, countryList: self.countryCodeList, stateNameList: self.stateNameList, cityNameList: self.citynameList, ethinicityList: self.ethinicityModel)
                emailAddressCell.cellButtonOutlt.addTarget(self, action: #selector(countryTextFieldButtonTapped(sender:)), for: .touchUpInside)
                emailAddressCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                
                return emailAddressCell
                
            case self.patientDemographicList.count - 1, 4:
                guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{
                    fatalError("Cell Not Found")
                }
                
                phoneDetailsCell.cellTitle.text = self.patientDemographicList[indexPath.row]
                phoneDetailsCell.stackViewLeadingConstant.constant = 22
                phoneDetailsCell.stackViewTrailingConstant.constant = 22
                phoneDetailsCell.countryCodeTextField.delegate = self
                phoneDetailsCell.phoneNumberTextField.delegate = self
                phoneDetailsCell.phoneNumberTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                if indexPath.row == self.patientDemographicList.count - 1 {
                    phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped(sender:)), for: .touchUpInside)
                }else{
                    phoneDetailsCell.countryCodeBtn.removeTarget(self, action: nil, for: .allEvents)
                }
                phoneDetailsCell.populateMobileNumber(self.userInfo, indexPath: indexPath)
                
                return phoneDetailsCell
            default:
                fatalError("")
            }
        case 1:
            switch indexPath.row {
            case 1:
                guard let genderDetailCell = tableView.dequeueReusableCell(withIdentifier: "genderDetailCell", for: indexPath) as? GenderDetailCell else {
                    fatalError("GenderDetailCell Not Found !")
                }
                
                genderDetailCell.cellTitle.text = self.presentMedicalCompiants[indexPath.row]
                genderDetailCell.maleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.femaleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.othersBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.populateButtonSelectionStatus(self.userInfo, indexPath: indexPath)
                
                return genderDetailCell
                
            case 2:
                guard let heightCell = tableView.dequeueReusableCell(withIdentifier: "heightCell", for: indexPath) as? HeightCell else{
                    fatalError("HeightCell Not Found!")
                }
                heightCell.cellTitle.text = self.presentMedicalCompiants[indexPath.row]
                
                let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
                heightCell.unitTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
                heightCell.feetTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                heightCell.inchTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                
                heightCell.unitTextField.delegate = self
                heightCell.feetTextField.delegate = self
                heightCell.inchTextField.delegate = self
                
                if let userData = self.userInfo, let medicalData = userData.medicalInfo.first {
                    let feetUnit = medicalData.patientHeightType
                    self.feetunitState = feetUnit == 1 ? FeetUnit.ft : FeetUnit.cm
                }

                heightCell.populateData(userInfo, self.heightUnitArray, feetUnitState: self.feetunitState)
                
                return heightCell
                
            case 3,4,5,6,7,9,10:
                guard let weightCell = tableView.dequeueReusableCell(withIdentifier: "weightCell", for: indexPath) as? WeightCell else{
                    fatalError("Cell Not Found")
                }

                if [4, 5].contains(indexPath.row) {
                    weightCell.measurementTextField.isUserInteractionEnabled = false
                }

                weightCell.cellTitle.text = self.presentMedicalCompiants[indexPath.row]

                let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldtap(_:)))
                weightCell.unitTextField.rightView?.addGestureRecognizer(rightViewTapGesture)
                weightCell.unitTextField.delegate = self
                weightCell.measurementTextField.delegate = self
                
                weightCell.measurementTextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                weightCell.populateData(userInfo: self.userInfo, weightUnitArray: self.weightUnitArray, waistUnitArray: self.waistUnitArray, indexPath: indexPath)
                
                return weightCell

            case 0,8,11...(self.presentMedicalCompiants.count - 1):
                guard let emailAddressCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else {
                    fatalError("EmailAddressCell Not Found !")
                }
                emailAddressCell.celltextField.delegate = self
                
                emailAddressCell.cellTitle.text = self.presentMedicalCompiants[indexPath.row]
                emailAddressCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                emailAddressCell.populateData(self.userInfo, indexPath: indexPath)
                
                return emailAddressCell
            default:
                fatalError("")
            }
        case 2...4:
            switch indexPath.row {
            case 0:
                guard let allergyDetailsCell = tableView.dequeueReusableCell(withIdentifier: "allergyDetailsCellID", for: indexPath) as? AllergyDetailsCell else{
                    fatalError("allergyDetailsCell Not Found!")
                }
                
                allergyDetailsCell.severityTextFieldTitle.text = K_STRENGTH.localized
                allergyDetailsCell.celltextField.placeholder = K_ENTER_ALLERGIES_DETAIL.localized
                allergyDetailsCell.severitytextField.placeholder = K_STRENGTH.localized
                allergyDetailsCell.addSeverityButton.addTarget(self, action: #selector(self.addAllergyBtnTapped(_:)), for: .touchUpInside)
                allergyDetailsCell.celltextField.delegate = self
                allergyDetailsCell.severitytextField.delegate = self

                allergyDetailsCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                switch indexPath.section {
                    
                case 2:
                    allergyDetailsCell.cellTextFieldTitle.text = self.environmentalAllergyDetails[0]
                    allergyDetailsCell.celltextField.text = self.environmentalAllergy
                    allergyDetailsCell.severitytextField.text = self.environmentalSeverity
                    
                    let isAddbtnDisabled = (!self.environmentalAllergy.isEmpty && !self.environmentalSeverity.isEmpty) ? true : false
                    allergyDetailsCell.addSeverityButton.isEnabled = isAddbtnDisabled
                case 3:
                    allergyDetailsCell.cellTextFieldTitle.text = self.foodAllergyDetails[0]
                    allergyDetailsCell.celltextField.text = self.foodAllergy
                    allergyDetailsCell.severitytextField.text = self.foodSeverity
                    
                    let isAddbtnDisabled = (!self.foodAllergy.isEmpty && !self.foodSeverity.isEmpty) ? true : false
                    allergyDetailsCell.addSeverityButton.isEnabled = isAddbtnDisabled
                case 4:
                    allergyDetailsCell.cellTextFieldTitle.text = self.drugAllergyDetails[0]
                    allergyDetailsCell.celltextField.text = self.drugAllergy
                    allergyDetailsCell.severitytextField.text = self.drugSeverity
                    let isAddbtnDisabled = (!self.drugAllergy.isEmpty && !self.drugSeverity.isEmpty) ? true : false
                    allergyDetailsCell.addSeverityButton.isEnabled = isAddbtnDisabled
                    
                default:
                    fatalError("Allergies Section Not Found!")
                }
                
                return allergyDetailsCell
            case 1:
                guard let addAllergyDeatilCell = tableView.dequeueReusableCell(withIdentifier: "addAllergyCollectionViewID", for: indexPath) as? AddAllergyCollectionView else{
                    fatalError("addAllergyDeatilCell Not Found!")
                }
                                addAllergyDeatilCell.allergyCollectionView.delegate = self
                                addAllergyDeatilCell.allergyCollectionView.dataSource = self
                                addAllergyDeatilCell.allergyCollectionView.outerIndexPath = indexPath
                                addAllergyDeatilCell.allergyCollectionView.heightDelegate = self
                if let layout = addAllergyDeatilCell.allergyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
                
                addAllergyDeatilCell.collectionViewHeight.isActive = true
                
                switch indexPath.section {
                    
                case 2:
                    addAllergyDeatilCell.allergyCollectionView.collectionViewUseFor = .environmentalSurgery
                    if !self.addEnvironmentalAllergy.isEmpty {
                        addAllergyDeatilCell.allergyCollectionView.reloadData()
                    }
                case 3:
                    addAllergyDeatilCell.allergyCollectionView.collectionViewUseFor = .foodSurgery
                    if !self.addFoodAllergy.isEmpty {
                        addAllergyDeatilCell.allergyCollectionView.reloadData()
                    }
                case 4:
                    addAllergyDeatilCell.allergyCollectionView.collectionViewUseFor = .drugSurgery
                    if !self.addDrugAllergy.isEmpty {
                        addAllergyDeatilCell.allergyCollectionView.reloadData()
                    }
                default:
                    fatalError("Allergies Section Not Found!")
                }
                return addAllergyDeatilCell
            default:
                fatalError("Allergy details Rows not Found!")
            }
            
        case 5:
            switch indexPath.row {
            case 0,8,9:
                guard let genderDetailCell = tableView.dequeueReusableCell(withIdentifier: "genderDetailCell", for: indexPath) as? GenderDetailCell else {
                    fatalError("GenderDetailCell Not Found !")
                }
                
                genderDetailCell.cellTitle.text = self.activityDetail[indexPath.row]
                genderDetailCell.maleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.femaleBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.othersBtn.addTarget(self, action: #selector(genderButtonTapped(sender:)), for: .touchUpInside)
                genderDetailCell.populateButtonSelectionStatus(self.userInfo, indexPath: indexPath)
                
                return genderDetailCell
                
            case activityDetail.count - 4:
                guard let junkFoodPerWeekCell = tableView.dequeueReusableCell(withIdentifier: "junkFoodPerWeekCell", for: indexPath) as? JunkFoodPerWeekCell else {
                    fatalError("GenderDetailCell Not Found !")
                }
                
                junkFoodPerWeekCell.cellTitle.text = self.activityDetail[indexPath.row]
                junkFoodPerWeekCell.populateData(userInfo: self.userInfo, indexPath: indexPath)
                junkFoodPerWeekCell.presentJunkFood.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                junkFoodPerWeekCell.pastJunkFood.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                
                return junkFoodPerWeekCell
            case 1,3,5,6,10,11,13,15,18,19:
                guard let familyHistoryOfObesityCell = tableView.dequeueReusableCell(withIdentifier: "familyHistoryOfObesity", for: indexPath) as? FamilyHistoryOfObesity else {
                    fatalError("GenderDetailCell Not Found !")
                }
                
                familyHistoryOfObesityCell.cellTitle.text = self.activityDetail[indexPath.row]
                familyHistoryOfObesityCell.populateData(userInfo: self.userInfo, indexPath: indexPath)
                familyHistoryOfObesityCell.yesButton.addTarget(self, action: #selector(self.activityButtonTapped(sender:)), for: .touchUpInside)
                familyHistoryOfObesityCell.noButton.addTarget(self, action: #selector(self.activityButtonTapped(sender:)), for: .touchUpInside)
                return familyHistoryOfObesityCell
                
            case 2,4,7,12,14,16,20:
                guard let emailAddressCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else {
                    fatalError("EmailAddressCell Not Found !")
                }
                emailAddressCell.cellTitle.isHidden = true
                emailAddressCell.sepratorView.isHidden = true
                emailAddressCell.celltextField.delegate = self
                
                emailAddressCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
                emailAddressCell.activityData(userInfo: self.userInfo, indexPath: indexPath)
                return emailAddressCell
            default:
                fatalError("cell not found!")
            }
            
        default:
            guard let doctorDetailCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else {
                fatalError("EmailAddressCell Not Found !")
            }
            doctorDetailCell.populateHositalAndTreatmentData(userInfo: self.userInfo, indexPath: indexPath, hospitalDetail: self.hospitalDetail, treatmentData: self.treatmentDetail, sections: self.typesOfUserDetails, treatmentDetailInfo: self.treatmentDetailInfo)
            doctorDetailCell.celltextField.addTarget(self, action: #selector(self.textFieldClicked(textField:)), for: UIControlEvents.editingChanged)
            return doctorDetailCell
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension PersonalInformationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 2:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 40
        case 5:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 10
        case 3,4:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 2
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                
            case 0:
                return 128
            case 1:
                return 50
            case 2:
                return 90
            case 4,(self.patientDemographicList.count - 1):
                return 70
            default:
                return 65
            }
        case 1:
            switch indexPath.row {
            case 2...7,9,10:
                return 70
            case 1:
                return 90
            default:
                return 65
            }
        case 2...4:
            var collectionViewCellHeight : CGFloat?
            switch indexPath.section {
            case 2:
                collectionViewCellHeight = (!self.addEnvironmentalAllergy.isEmpty) ? 10 + self.environmentalSurgeryCollectionHeight : CGFloat.leastNormalMagnitude
            case 3:
                collectionViewCellHeight = (!self.addFoodAllergy.isEmpty) ? 10 + self.foodSurgeryCollectionHeight : CGFloat.leastNormalMagnitude
            case 4:
                collectionViewCellHeight = (!self.addDrugAllergy.isEmpty) ? 10 + self.drugSurgeryCollectionHeight : CGFloat.leastNormalMagnitude
            default:
                return UITableViewAutomaticDimension
            }
            let height = (indexPath.row == 1) ? collectionViewCellHeight : 80
            return height!
        case 5:
            switch indexPath.row {
            case 0,8,9:
                return 90
            case 1,3,5,6,10,11,13,15,17,18,19:
                return 80
            case 2,4,7,12,14,16,20:
                guard let userData = self.userInfo, let activityData = userData.activityInfo.first else{
                    return CGFloat.leastNormalMagnitude
                }
                switch indexPath.row {
                    
                case 2:
                    let height: CGFloat = activityData.familiyHistoryObesity == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 4:
                    let height: CGFloat = activityData.familyHistoryOfMedicalDiseases == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 7:
                    let height: CGFloat = activityData.excessiveApetite == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 12:
                    let height: CGFloat = activityData.alcohol == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 14:
                    let height: CGFloat = activityData.tobacco == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 16:
                    let height: CGFloat = activityData.illegalDrug == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                case 20:
                    let height: CGFloat = activityData.treatmentForObesity == 1 ? 50 : CGFloat.leastNormalMagnitude
                    return height
                default:
                    return CGFloat.leastNormalMagnitude
                }
            default:
                return CGFloat.leastNormalMagnitude
            }
        default:
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 20
        case 2:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 10
        case 3:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 10
        case 4:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 10
        case 5:
            if self.selectedIndex.contains(section){
                return CGFloat.leastNormalMagnitude
            }
            return 20
        default:
            return 20
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "personalInfoHeaderCell") as? PersonalInfoHeaderCell else {
            fatalError("HeaderView Not Found!")
        }
        headerView.expandButtonOutlt.addTarget(self, action: #selector(self.headerButtonTapped(_:)), for: .touchUpInside)
        let image = self.selectedIndex.contains(section) ? #imageLiteral(resourceName: "icAppointmentDownarrow") : #imageLiteral(resourceName: "icLogbookUparrowGreen")
        headerView.expandButtonOutlt.setImage(image, for: .normal)
        headerView.populateDataInHeader(titles: self.typesOfUserDetails, section: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let foooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "personalInfoHeaderCell") as? PersonalInfoHeaderCell else {
            fatalError("HeaderView Not Found!")
        }
        foooterView.populateFooterView(section: section)
    return foooterView
    }
}

//MARk:- CollectionView Height Update
//===================================
extension PersonalInformationVC: AutoResizingCollectionViewDelegate {
    
    func didUpdateCollectionHeight(_ collectionView: UICollectionView, height: CGFloat,
                                   _ collectionViewFor : CollectionViewFor) {
        
        switch collectionViewFor {
            
        case .environmentalSurgery:
            self.environmentalSurgeryCollectionHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
            
        case .foodSurgery:
            self.foodSurgeryCollectionHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
            
        case .drugSurgery:
            self.drugSurgeryCollectionHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
            
        default:
            return
        }
    }
    
    @objc func reloadTable() {
        self.profileInformationTableView.reloadData()
//        self.profileInformationTableView.beginUpdates()
//        self.profileInformationTableView.endUpdates()
    }
}
