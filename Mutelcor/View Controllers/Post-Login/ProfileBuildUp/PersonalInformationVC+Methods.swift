//
//  PersonalInformationVC+Methods.swift
//  Mutelcor
//
//  Created by  on 05/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

extension PersonalInformationVC {
    
    //    MARK:- Gender Selection
    //     =======================
    @objc func genderButtonTapped(sender: IndexedButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        guard let cell = self.profileInformationTableView.cellForRow(at: indexPath) as? GenderDetailCell else{
            return
        }
        guard let index = sender.outerIndex else{
            return
        }
        sender.isSelected = true
        var selectedData: Int = 0
        switch index {
        case 0:
            //In section 0 by default male should be selected so male raw value is 0 but in other cases 0 should should be counted as none of the button is selected
            selectedData = indexPath.section == 0 ? Gender.male.rawValue : FoodCategoryType.veg.rawValue
            cell.femaleBtn.isSelected = false
            cell.othersBtn.isSelected = false
        case 1:
            selectedData = indexPath.section == 0 ? Gender.female.rawValue : FoodCategoryType.nonVeg.rawValue
            cell.maleBtn.isSelected = false
            cell.othersBtn.isSelected = false
        default:
            selectedData = indexPath.section == 0 ? Gender.others.rawValue : FoodCategoryType.both.rawValue
            cell.femaleBtn.isSelected = false
            cell.maleBtn.isSelected = false
        }
        switch indexPath.section {
            
        case 0:
            if let userData = self.userInfo{
                userData.patientGender = selectedData
            }
        case 1:
            if let userData = self.userInfo, let medicalData = userData.medicalInfo.first {
                medicalData.foodCategory = selectedData
            }
            
        case 5:
            switch indexPath.row {
                
            case 0:
                if let userData = self.userInfo, let activityData = userData.activityInfo.first {
                    activityData.activity = selectedData
                }
            case 8:
                if let userData = self.userInfo, let activityData = userData.activityInfo.first {
                    activityData.erracticTimming = selectedData
                }
            case 9:
                if let userData = self.userInfo, let activityData = userData.activityInfo.first {
                    activityData.eatingVolume = selectedData
                }
            default:
                return
            }
        default:
            return
        }
        self.getCalculatedIdealWeight(isServiceHit: false)
        self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    @objc func activityButtonTapped(sender: IndexedButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        var row: Int?
        guard let cell = self.profileInformationTableView.cellForRow(at: indexPath) as? FamilyHistoryOfObesity else{
            return
        }
        guard let index = sender.outerIndex else{
            return
        }
        if sender.isSelected{
            return
        }else{
            sender.isSelected = true
        }
        var selectedData: Int = 0
        switch index {
        case 0:
            // Female rawVlue is 1 and other RawValue is 2 and buttonType value other than this when no button is selected
            selectedData = Gender.female.rawValue
            cell.noButton.isSelected = false
        case 1:
            selectedData = Gender.others.rawValue
            cell.yesButton.isSelected = false
        default:
            selectedData = Gender.male.rawValue
            cell.yesButton.isSelected = false
            cell.noButton.isSelected = false
        }
        
        switch indexPath.section {
        case 5:
            switch indexPath.row {
            case 1:
                self.userInfo?.activityInfo.first?.familiyHistoryObesity = selectedData
                if cell.noButton.isSelected{
                   self.userInfo?.activityInfo.first?.treatmentForObesityReason = ""
                }
                row = indexPath.row + 1
            case 3:
                self.userInfo?.activityInfo.first?.familyHistoryOfMedicalDiseases = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.familyHistoryOfMedicalDiseasesReason = ""
                }
            case 5:
                self.userInfo?.activityInfo.first?.loveToEat = selectedData
            case 6:
                self.userInfo?.activityInfo.first?.excessiveApetite = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.excessiveApetiteReason = ""
                }
            case 10:
                self.userInfo?.activityInfo.first?.afinitySweets = selectedData
            case 11:
                self.userInfo?.activityInfo.first?.alcohol = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.alcoholReason = ""
                }
            case 13:
                self.userInfo?.activityInfo.first?.tobacco = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.tobaccoReason = ""
                }
            case 15:
                self.userInfo?.activityInfo.first?.illegalDrug = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.illegalDrugReason = ""
                }
            case 18:
                self.userInfo?.activityInfo.first?.obese = selectedData
            case 19:
                self.userInfo?.activityInfo.first?.treatmentForObesity = selectedData
                row = indexPath.row + 1
                if cell.noButton.isSelected{
                    self.userInfo?.activityInfo.first?.treatmentForObesityReason = ""
                }
            default:
                return
            }
        default:
            return
        }
        if let nextRow = row {
            let nextIndexPath = IndexPath.init(row: nextRow, section: indexPath.section)
            self.profileInformationTableView.reloadRows(at: [indexPath,nextIndexPath], with: .none)
        }else{
            self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //    MARK:- Delete Alleries Button Tapped
    //    ====================================
    @objc func deleteAllergyBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        guard let tableViewCell = self.profileInformationTableView.cellForRow(at: indexPath) as? AddAllergyCollectionView else{
            return
        }
        
        guard let index = sender.collectionViewIndexPathIn(tableViewCell.allergyCollectionView) else{
            return
        }
        
        switch indexPath.section {
        case 2:
            //printlnDebug(self.addEnvironmentalAllergy)
            self.addEnvironmentalAllergy.remove(at: index.item)
            //printlnDebug(self.addEnvironmentalAllergy)
            if self.addEnvironmentalAllergy.isEmpty {
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
            }else{
                tableViewCell.allergyCollectionView.reloadData()
            }
            guard let userData = self.userInfo else{
                return
            }
            userData.medicalCategoryInfo[0].environmentalAllergy = ""
            
            var envirAllergy = ""
            
            for (index, allergy) in self.addEnvironmentalAllergy.enumerated() {
                
                if self.addEnvironmentalAllergy.count == (index + 1) {
                    envirAllergy.append(allergy)
                }else{
                    envirAllergy.append(allergy + "/")
                }
            }
            userData.medicalCategoryInfo[0].environmentalAllergy = envirAllergy
            
        case 3:
            //printlnDebug(self.addFoodAllergy)
            self.addFoodAllergy.remove(at: index.item)
            //printlnDebug(self.addFoodAllergy)
            if self.addFoodAllergy.isEmpty {
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
            }else{
                tableViewCell.allergyCollectionView.reloadData()
            }
            guard let userData = self.userInfo else{
                return
            }
            userData.medicalCategoryInfo[0].foodAllergy = ""
            
            var foodAllergy = ""
            
            for (index, allergy) in self.addFoodAllergy.enumerated() {
                if self.addFoodAllergy.count == (index + 1) {
                    foodAllergy.append(allergy)
                }else{
                    foodAllergy.append(allergy + "/")
                }
            }
            userData.medicalCategoryInfo[0].foodAllergy = foodAllergy
            
        case 4:
            //printlnDebug(self.addDrugAllergy)
            self.addDrugAllergy.remove(at: index.item)
            //printlnDebug(self.addDrugAllergy)
            if self.addDrugAllergy.isEmpty {
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
            }else{
                tableViewCell.allergyCollectionView.reloadData()
            }
            guard let userData = self.userInfo else{
                return
            }
            
            userData.medicalCategoryInfo[0].drugAllergy = ""
            
            var drugAllergy = ""
            
            for (index, allergy) in self.addDrugAllergy.enumerated() {
                if self.addDrugAllergy.count == (index + 1) {
                    drugAllergy.append(allergy)
                }else{
                    drugAllergy.append(allergy + "/")
                }
            }
            userData.medicalCategoryInfo[0].drugAllergy = drugAllergy
        default:
            return
        }
    }
    
    //    MARK:- Country Code Button Tapped
    //    =================================
    @objc func countryCodeBtnTapped(sender: UIButton){
        self.view.endEditing(true)
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
    
    //Maked Click on the country Code
    @objc func countryTextFieldButtonTapped(sender: UIButton){
        self.view.endEditing(true)
        guard let indexPath = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.countryDataDelegate = self
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row{
            case 8:
                guard !self.countryCodeList.isEmpty else{
                    showToastMessage(AppMessages.emptyCountryList.rawValue.localized)
                    return
                }
                countryCodeScene.navigateToScreenBy = .countryBtnTapped
                self.btnTapped = .countryBtn
                
                countryCodeScene.countryCodeModel = self.countryCodeList
            case 9:
                guard !self.stateNameList.isEmpty else{
                    showToastMessage(AppMessages.emptyStateList.rawValue.localized)
                    return
                }
                countryCodeScene.navigateToScreenBy = .stateBtnTapped
                self.btnTapped = .stateBtn
                
                countryCodeScene.stateList = self.stateNameList
            case 10:
                guard !self.citynameList.isEmpty else{
                    showToastMessage(AppMessages.emptyCityList.rawValue.localized)
                    return
                }
                countryCodeScene.navigateToScreenBy = .townBtntapped
                self.btnTapped = .cityBtn
                countryCodeScene.cityList = self.citynameList
            default:
                return
            }
        default:
            return
        }
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
    
    //    MARK: ADD ALERGY BTN TAPPED
    //    ============================
    @objc func addAllergyBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        guard let cell = self.profileInformationTableView.cellForRow(at: indexPath) as? AllergyDetailsCell else{
            return
        }
        
        switch indexPath.section {
            
        case 2:
            if self.environmentalAllergyDetails.count < 2 {
                self.environmentalAllergyDetails.insert("CollectionView", at: 1)
                self.profileInformationTableView.beginUpdates()
                self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
                self.profileInformationTableView.endUpdates()
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addEnvironmentalAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    userData.medicalCategoryInfo[0].environmentalAllergy.append(text)
                }
            }else{
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addEnvironmentalAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    
                    userData.medicalCategoryInfo[0].environmentalAllergy.append("/" + text)
                }
            }
            self.environmentalAllergy = ""
            self.environmentalSeverity = ""
        case 3:
            if self.foodAllergyDetails.count < 2 {
                self.foodAllergyDetails.insert("CollectionView", at: 1)
                self.profileInformationTableView.beginUpdates()
                self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
                self.profileInformationTableView.endUpdates()
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addFoodAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    userData.medicalCategoryInfo[0].foodAllergy.append(text)
                }
            }else{
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addFoodAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    userData.medicalCategoryInfo[0].foodAllergy.append("/" + text)
                }
            }
            self.foodAllergy = ""
            self.foodSeverity = ""
        case 4:
            if self.drugAllergyDetails.count < 2 {
                self.drugAllergyDetails.insert("CollectionView", at: 1)
                self.profileInformationTableView.beginUpdates()
                self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
                self.profileInformationTableView.endUpdates()
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addDrugAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    userData.medicalCategoryInfo[0].drugAllergy.append(text)
                }
            }else{
                if let allergy = cell.celltextField.text, let severity = cell.severitytextField.text{
                    let text = allergy + "-" + severity
                    self.addDrugAllergy.append(text)
                    guard let userData = self.userInfo else{
                        return
                    }
                    userData.medicalCategoryInfo[0].drugAllergy.append("/" + text)
                }
            }
            self.drugAllergy = ""
            self.drugSeverity = ""
        default:
            return
        }
        self.profileInformationTableView.reloadData()
    }
    
    @objc func headerButtonTapped(_ sender: IndexedButton){
        guard let outerIndex = sender.outerIndex else{
            return
        }
        if self.selectedIndex.contains(outerIndex){
            if outerIndex == 1{
                self.selectedIndex = self.selectedIndex.filter({$0 != 2})
                self.selectedIndex = self.selectedIndex.filter({$0 != 3})
                self.selectedIndex = self.selectedIndex.filter({$0 != 4})
                self.selectedIndex = self.selectedIndex.filter({$0 != 5})
            }
            self.selectedIndex = self.selectedIndex.filter({$0 != outerIndex})
        }else{
            if outerIndex == 1{
               self.selectedIndex.append(contentsOf: [2,3,4,5])
            }
            self.selectedIndex.append(outerIndex)
        }
        let index: IndexSet = [outerIndex,2,3,4,5]
        self.profileInformationTableView.reloadSections(index, with: .top)
    }
}

////MARK:- Protocols
////===============
extension PersonalInformationVC : CountryDataDelegate {
    
    func setCountryData(_ code: String, name: String) {
        if !code.isEmpty {
            switch self.btnTapped {
            case .countryBtn :
                self.stateListParam["country_code"] = code
                self.userInfo?.country = code
                self.getStateList(code)
                let indexPath = IndexPath(row: 8, section: 0)
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
                
            case .stateBtn :
                self.userInfo?.state = Int(code)!
                self.getTownListing((self.userInfo?.state)!)
                let indexPath = IndexPath(row: 9, section: 0)
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
                
            case .cityBtn :
                self.userInfo?.city = code
                let indexPath = IndexPath(row: 10, section: 0)
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
            case .none :
                return
            }
        }
    }
}

//MARK:- Select Country Code Protocol
//====================================
extension PersonalInformationVC : CountryCodeDelegate {
    
    func setCountry(_ country: CountryCode) {
        self.userInfo?.emergencyCountryCode = country.countryCode
        let indexPath = IndexPath.init(row: self.patientDemographicList.count - 1, section: 0)
        self.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
