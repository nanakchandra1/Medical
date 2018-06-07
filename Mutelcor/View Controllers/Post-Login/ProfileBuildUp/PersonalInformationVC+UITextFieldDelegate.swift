//
//  PersonalInformationVC+UITextFieldDelegate.swift
//  Mutelcor
//
//  Created by on 05/01/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

//MARK:- UITextFieldDelegate Method
//=================================
extension PersonalInformationVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectOptionFromDropDown(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.profileInformationTableView) else{
            return true
        }
        
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 2:
                guard let text = textField.text else { return true }
                let newLength = text.count + string.count - range.length
                let length = feetunitState == .cm ? 3 : 2
                return newLength <= length
                
            case 3...7,9,10:
                guard let text = textField.text else { return true }
                let newLength = text.count + string.count - range.length
                return newLength <= 3
            default:
                return true
            }
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.profileInformationTableView) else {
            return true
        }
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                
            case 0:
                guard let userImageCell = self.profileInformationTableView.cellForRow(at: indexPath) as? UserImageCell else{
                    return true
                }
                
                if userImageCell.celltextField.isFirstResponder{
                    userImageCell.middleNameTextField.becomeFirstResponder()
                }else if userImageCell.middleNameTextField.isFirstResponder{
                    userImageCell.lastNameTextField.becomeFirstResponder()
                }else if userImageCell.lastNameTextField.isFirstResponder{
                    guard let dateOfBirthCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? DateOfBirthCell else {
                        return true
                    }
                    dateOfBirthCell.celltextField.becomeFirstResponder()
                }
                
            case 6,7,14...19:
                guard let emailCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? EmailCell else{
                    return true
                }
                emailCell.celltextField.becomeFirstResponder()
                
            case 14...19:
                guard let emailCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? EmailCell else{
                    return true
                }
                
                if indexPath.row == 19 {
                    emailCell.celltextField.resignFirstResponder()
                }else{
                    emailCell.celltextField.becomeFirstResponder()
                }
                
            default:
                return true
            }
            
        case 1:
            switch indexPath.row {
                
            case 2:
                guard let heightCell = self.profileInformationTableView.cellForRow(at: indexPath) as? HeightCell else{
                    guard let weightCell = textField.getTableViewCell as? WeightCell else{return true}
                    weightCell.measurementTextField.resignFirstResponder()
                    return false
                }
                if indexPath.row == 2{
                    if feetunitState == .ft{
                        if heightCell.feetTextField.isFirstResponder{
                            heightCell.inchTextField.becomeFirstResponder()
                        }else if heightCell.inchTextField.isFirstResponder{
                            guard let weightCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? WeightCell else{
                                return true
                            }
                            weightCell.measurementTextField.becomeFirstResponder()
                        }
                    }else{
                        guard let weightCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? WeightCell else{
                            return true
                        }
                        weightCell.measurementTextField.becomeFirstResponder()
                    }
                }
                
            case 3...5:
                guard let weightCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? WeightCell else{
                    return true
                }
                if indexPath.row == 5{
                    guard let emailCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? EmailCell else{
                        return true
                    }
                    emailCell.celltextField.becomeFirstResponder()
                }else{
                    weightCell.measurementTextField.becomeFirstResponder()
                }
                
            case 6,7:
                guard let weightCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? WeightCell else{
                    return true
                }
                weightCell.measurementTextField.becomeFirstResponder()
                
            case 8...18:
                guard let emailCell = self.profileInformationTableView.cellForRow(at: nextIndexPath) as? EmailCell else{
                    return true
                }
                if indexPath.row == 18 {
                    emailCell.celltextField.resignFirstResponder()
                }else{
                    emailCell.celltextField.becomeFirstResponder()
                }
            default:
                return true
            }
        default:
            return true
        }
        return true
    }
    
    
    
    //perform action when textFieldDidBeginEditing
    fileprivate func selectOptionFromDropDown(textField: UITextField){

        textField.inputView = nil
        
        guard let indexPath = textField.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        
        MultiPicker.noOfComponent = 1
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let userImageCell = self.profileInformationTableView.cellForRow(at: indexPath) as? UserImageCell else{
                    return
                }
                
                MultiPicker.openPickerIn(userImageCell.genderStatusTextField, firstComponentArray: genderStatus, secondComponentArray: [], firstComponent: userImageCell.genderStatusTextField.text, secondComponent: nil, titles: ["Choose Gender"]) { (firstValue, _,_,_) in
                    userImageCell.genderStatusTextField.text = firstValue
                    self.userInfo?.patientTitle = userImageCell.genderStatusTextField.text ?? ""
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                }
                
            case 1:
                let currentDate = (self.userInfo?.patientDob != nil) ? self.userInfo?.patientDob : Date()
                DatePicker.openPicker(in: textField, currentDate: currentDate, minimumDate: nil, maximumDate: Date(), pickerMode: .date, doneBlock: { (Date) in
                    let dateInString = Date.stringFormDate(.ddMMMYYYY)
                    textField.text = dateInString
                    self.userInfo?.patientDob = Date
                })
            case 5:
                MultiPicker.openPickerIn(textField, firstComponentArray: self.addressType, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: ["Address Type"]) { (firstValue, _,index,_) in
                    
                    textField.text = firstValue
                    self.userInfo?.addressType = (index ?? 0) + 1
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                }
            case 11:
                MultiPicker.openPickerIn(textField, firstComponentArray: self.ethinicityArray, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: ["Choose Ethinicity"]) { (firstValue, _,_,_) in
                    
                    textField.text = firstValue
                    let ethinicityCode = self.mapValues(textField.text ?? "")
                    if let code = ethinicityCode {
                        self.userInfo?.ethinicityId = code
                    }
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                }
            case 13:
                MultiPicker.openPickerIn(textField, firstComponentArray: self.patientOccupation, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: ["Occupation"], doneBlock: { (value, _, index, _) in
                    textField.text = value
                    self.userInfo?.occupation = "\((index ?? 0) + 1)"
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                })
                
            case 14:
                MultiPicker.openPickerIn(textField, firstComponentArray: self.maritalStatus, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: ["Material Status"], doneBlock: { (value, _, index, _) in
                    textField.text = value
                    self.userInfo?.maritalStatus = "\((index ?? 0) + 1)"
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                })
            default:
                return
            }
        case 1:
            
            switch indexPath.row {
                
            case 0:
                MultiPicker.openPickerIn(textField, firstComponentArray: bloodUnitType, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: ["Choose Blood Group"]) { (firstValue, _,_,_) in
                    
                    textField.text = firstValue
                    self.userInfo?.medicalInfo[0].patientBloodGroup = textField.text ?? ""
                }
                
            case 2:
                guard let heightCell = self.profileInformationTableView.cellForRow(at: indexPath) as? HeightCell else {
                    return
                }
                MultiPicker.openPickerIn(heightCell.unitTextField, firstComponentArray: heightUnitArray, secondComponentArray: [], firstComponent: heightCell.unitTextField.text, secondComponent: nil, titles: ["Choose Unit"]) { (firstValue, _,_,_) in
                    
                    heightCell.unitTextField.text = firstValue
                    let heightType = (firstValue == K_FEET_PLACEHOLDER.localized) ? true : false
                    let feetUnitSate: FeetUnit = (heightType) ? FeetUnit.ft : FeetUnit.cm
                    self.feetunitState = feetUnitSate
                    self.userInfo?.medicalInfo[0].patientHeightType = feetUnitSate.rawValue
                    self.getCalculatedIdealWeight(isServiceHit: false)
                    self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
                }
                
            case 3,4,5,6,7:
                guard let weightCell = self.profileInformationTableView.cellForRow(at: indexPath) as? WeightCell else {
                    return
                }
                
                MultiPicker.openPickerIn(weightCell.unitTextField, firstComponentArray: weightUnitArray, secondComponentArray: [], firstComponent: weightCell.unitTextField.text, secondComponent: nil, titles: ["Choose Unit"]) { (firstValue, _,_,_) in
                    weightCell.unitTextField.text = firstValue
                    
                    let weightType = (firstValue == K_KG_PLACEHOLDER.localized) ? false : true
                    let weightUnit = weightType ? 2 : 1
                    
                    if let userData = self.userInfo, let medicalInfo = userData.medicalInfo.first {
                        switch indexPath.row {
                            
                        case 3:
                            medicalInfo.patientWeightType = weightType.rawValue
                            self.getCalculatedIdealWeight(isServiceHit: false)
                        case 4:
                            medicalInfo.idealWeightType = weightType.rawValue
                        case 5:
                            medicalInfo.excessWeightType = weightType.rawValue
                        case 6:
                            medicalInfo.patientMaximumWeightAchievedType = weightUnit//weightType.rawValue
                        case 7:
                            medicalInfo.maximumWeightLossType = weightUnit//weightType.rawValue
                        default:
                            return
                        }
                    }
                }
                
            case 9,10:
                guard let weightCell = self.profileInformationTableView.cellForRow(at: indexPath) as? WeightCell else {
                    return
                }
                
                MultiPicker.openPickerIn(weightCell.unitTextField, firstComponentArray: self.waistUnitArray, secondComponentArray: [], firstComponent: weightCell.unitTextField.text, secondComponent: nil, titles: ["Choose Unit"]) { (firstValue, _,_,_) in
                    weightCell.unitTextField.text = firstValue
                    
                    let weightType = (firstValue == K_INCH_UNIT_PLACEHOLDER.localized) ? false : true
                    if let userData = self.userInfo, let medicalInfo = userData.medicalInfo.first {
                        switch indexPath.row {
                        case 9:
                            medicalInfo.waistCircumference = weightType.rawValue
                        default:
                            medicalInfo.hipCircumference = weightType.rawValue
                        }
                    }
                }
            default:
                return
            }
        case 2...4:
            guard let allergyDetailCell = self.profileInformationTableView.cellForRow(at: indexPath) as? AllergyDetailsCell else{
                return
            }
            
            MultiPicker.openPickerIn(allergyDetailCell.severitytextField, firstComponentArray: self.severityType, secondComponentArray: [], firstComponent: allergyDetailCell.severitytextField.text, secondComponent: nil, titles: ["Severity"], doneBlock: { (value,_, index, _) in
                switch indexPath.section {
                    
                case 2:
                    self.environmentalSeverity = value
                case 3:
                    self.foodSeverity = value
                case 4:
                    self.drugSeverity = value
                default:
                    return
                }
                self.profileInformationTableView.reloadRows(at: [indexPath], with: .none)
            })
        default:
            return
        }
    }
    
//    MARK:- TextField clicked
//    ========================
    @objc func textFieldClicked(textField: UITextField){
        
        guard let text = textField.text else{
            return
        }
        guard let indexPath = textField.tableViewIndexPathIn(self.profileInformationTableView) else{
            return
        }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = self.profileInformationTableView.cellForRow(at: indexPath) as? UserImageCell else{
                    return
                }
                self.userInfo?.patientFirstname = cell.celltextField.text ?? ""
                self.userInfo?.patientMiddleName = cell.middleNameTextField.text ?? ""
                self.userInfo?.patientLastName = cell.lastNameTextField.text ?? ""
            case 6:
                self.userInfo?.patientPostalCode = text
            case 7:
                self.userInfo?.address = text
            case 12:
                self.userInfo?.referredBy = text
            case 15:
                self.userInfo?.fathername = text
            case 16:
                self.userInfo?.motherName = text
            case 17:
                self.userInfo?.spouseName = text
            case 18:
                self.userInfo?.emergencyContactPerson = text
            case 19:
                self.userInfo?.patientEmergencyRelationShip = text
            case 20:
                self.userInfo?.emergencyConatctNumber = text
            default:
                return
            }
            
        case 1:
            switch indexPath.row {
            case 2:
                guard let heightCell = textField.getTableViewCell as? HeightCell else{
                    return
                }
                if let height1 = heightCell.feetTextField.text, !height1.isEmpty{
                    self.userInfo?.medicalInfo[0].patientHeight1 = Int(height1)
                }
                if let height2 = heightCell.inchTextField.text, !height2.isEmpty{
                    self.userInfo?.medicalInfo[0].patientHeight2 = Int(height2)
                }
                
                self.getCalculatedIdealWeight(isServiceHit: false)

            case 3...7,9,10:
                guard let weightCell = textField.getTableViewCell as? WeightCell else{
                    return
                }
                
                switch indexPath.row {
                    
                case 3...7,9,10:
                    switch indexPath.row {
                    case 3:
                        if let weightValue = weightCell.measurementTextField.text, !weightValue.isEmpty{
                            self.userInfo?.medicalInfo[0].patientWeight = Int(weightValue)
                            self.getCalculatedIdealWeight(isServiceHit: false)
                        }
                    case 6:
                        if let weightValue = weightCell.measurementTextField.text, !weightValue.isEmpty{
                            self.userInfo?.medicalInfo[0].patientMaximumWeightAchieved = Int(weightValue)
                        }
                    case 7:
                        if let weightValue = weightCell.measurementTextField.text, !weightValue.isEmpty{
                            self.userInfo?.medicalInfo[0].patientMaximumWeightLoss = Int(weightValue)
                        }
                    case 9:
                        if let weightValue = weightCell.measurementTextField.text, !weightValue.isEmpty{
                            self.userInfo?.medicalInfo[0].waistCircumferenceValue = Int(weightValue)
                        }
                    case 10:
                        if let weightValue = weightCell.measurementTextField.text, !weightValue.isEmpty{
                            self.userInfo?.medicalInfo[0].hipCircumferenceValue = Int(weightValue)
                        }
                    default:
                        return
                    }
                default:
                    return
                }
            case 8:
                self.userInfo?.medicalInfo[0].maximumLossWeight = text
            case 11:
                self.userInfo?.medicalInfo[0].pastMedicalCompliants = text
            case 12:
                self.userInfo?.medicalInfo[0].neurological = text
            case 13:
                self.userInfo?.medicalInfo[0].respiratory = text
            case 14:
                self.userInfo?.medicalInfo[0].cardiac = text
            case 15:
                self.userInfo?.medicalInfo[0].abdominal = text
            case 16:
                self.userInfo?.medicalInfo[0].jointsAndBones = text
            case 17:
                self.userInfo?.medicalInfo[0].hormonal = text
            case 18:
                self.userInfo?.medicalInfo[0].physhological = text
            case 19:
                self.userInfo?.medicalInfo[0].others = text
            case 20:
                self.userInfo?.medicalInfo[0].presentMedicalTreatment = text
            default:
                return
            }
            
        case 2...4:
            switch indexPath.section {
            case 2:
                self.environmentalAllergy = text
            case 3:
                self.foodAllergy = text
            case 4:
                self.drugAllergy = text
            default:
                return
            }
        case 5:
            if let userData = self.userInfo, let activityInfo = userData.activityInfo.first {
                switch indexPath.row {
                    
                case 2:
                    activityInfo.familiyHistoryObesityReason = text
                case 4:
                    activityInfo.familyHistoryOfMedicalDiseasesReason = text
                case 7:
                    activityInfo.excessiveApetiteReason = text
                case 12:
                    activityInfo.alcoholReason = text
                case 14:
                    activityInfo.tobaccoReason = text
                case 16:
                    activityInfo.illegalDrugReason = text
                case 17:
                    guard let junkFoodCell = textField.getTableViewCell as? JunkFoodPerWeekCell else{
                        return
                    }
                    if junkFoodCell.presentJunkFood.isFirstResponder {
                        activityInfo.presentJunkFood = text
                    }else if junkFoodCell.pastJunkFood.isFirstResponder{
                        activityInfo.pastJunkFood = text
                    }
                case 20:
                    activityInfo.treatmentForObesityReason = text
                default:
                    return
                }
            }
        default:
            return
        }
        return
    }
}
