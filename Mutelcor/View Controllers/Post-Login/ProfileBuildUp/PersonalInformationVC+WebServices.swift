//
//  PersonalInformationVC+WebServices.swift
//  Mutelcor
//
//  Created by on 06/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

extension PersonalInformationVC {
    
    //MARK: getPatientDetail on edit Profile
    //======================================
    func getPatientDetail(){
        
        WebServices.getPatientDetail(success: {[weak self] (_ userInfo: UserInfo, treatmentInfo: [TreatmentDetailInfo]) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.userInfo = userInfo
            strongSelf.treatmentDetailInfo = treatmentInfo
            strongSelf.addAllergyDetails()
            strongSelf.addOtherDoctorInArray()
            strongSelf.addOtherTreatmentInArray()
            strongSelf.getCalculatedIdealWeight(isServiceHit: true)
            
            strongSelf.profileInformationTableView.reloadData()
            //            strongSelf.setUserImageonSideMenu()
        }) { (error: Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func addOtherDoctorInArray(){
        if let userData = self.userInfo, let hospitalInfo = userData.hospitalInfo.first {
            if hospitalInfo.isOtherDoctor {
                if !self.hospitalDetail.contains((K_OTHERS_DOCTOR.localized)) {
                    self.hospitalDetail.append(K_OTHERS_DOCTOR.localized)
                }
            }else{
                if self.hospitalDetail.contains((K_OTHERS_DOCTOR.localized)){
                    self.hospitalDetail.remove(at: self.hospitalDetail.count-1)
                }
            }
        }
    }
    
    func addOtherTreatmentInArray(){
        if !self.treatmentDetailInfo.isEmpty {
            for value in self.treatmentDetailInfo{
                self.typesOfUserDetails.append(K_TREATMENT_DETAILS.localized)
                if value.isRevision, value.isOtherReasonOfRevision,!self.treatmentDetail.contains(K_PLEASE_SPECIFY.localized) {
                    self.treatmentDetail.insert(K_PLEASE_SPECIFY.localized, at: 2)
                }
            }
        }        
    }
    
    //    MARK:- Get Country List
    //    =======================
    func getCountry(){
        
        let param = [String : Any]()
        
        WebServices.getCountryList(parameters: param,
                                   success: { [weak self] (_ countryData: [CountryCodeModel]) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.countryCodeList = countryData
                                    
            if let userData = strongSelf.userInfo, !userData.country.isEmpty{
                strongSelf.getStateList(userData.country)
            }
        }) { (e: Error) in
            showToastMessage(e.localizedDescription)
        }
    }
    
    
    
    //    MARK:- Get State List
    //    ======================
    func getStateList(_ countryCode : String?){
        
        if self.stateListParam["country_code"] == nil{
            self.stateListParam["country_code"] = countryCode
        }

        WebServices.getStateList(parameters: stateListParam,
                                 success: {[weak self](_ statedata : [StateNameModel]) in
                                    guard let strongSelf = self else{
                                        return
                                    }
                                    
                                    strongSelf.stateNameList = statedata
                                    if let userData = strongSelf.userInfo, userData.state != 0 {
                                        strongSelf.getTownListing(userData.state)
                                    }
                                    let indexPath = IndexPath(row: 9, section: 0)
                                    strongSelf.profileInformationTableView.reloadRows(at: [indexPath], with: .automatic)
        }){ (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    
    //    MARK:- Get City List
    //    ======================
    func getTownListing(_ stateCode : Int){
        self.stateListParam["state_code"] = stateCode
        WebServices.getTownList(parameters: stateListParam, success: {[weak self](_ cityData : [CityNameModel]) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.citynameList = cityData
            let indexPath1 = IndexPath(row: 8, section: 0)
            let indexPath2 = IndexPath(row: 9, section: 0)
            let indexPath3 = IndexPath(row: 10, section: 0)
            strongSelf.profileInformationTableView.reloadRows(at: [indexPath1, indexPath2, indexPath3], with: .automatic)
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
//    MARK:- Fetch Ethinicity Data
//    ============================
    func fetchEthinicity(){
        
        WebServices.getEthinicityList(parameters: stateListParam, success: { [weak self](_ ethinicityData : [EthinicityNameModel]) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.ethinicityModel = ethinicityData
            for ethinicity in ethinicityData {
                strongSelf.ethinicityArray.append(ethinicity.ethinicityName ?? "")
            }
            strongSelf.profileInformationTableView.reloadRows(at: [IndexPath.init(row: 11, section: 0)], with: .none)
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func saveUserData(){
        
        guard let data = self.userInfo else{
            return
        }
        let params: JSONDictionary = data.toDictionary
        var imgData : Data?
        
        if let image = self.userImage {
            imgData = UIImageJPEGRepresentation(image, 0.5)
        }else{
            if !data.patientPic.isEmpty{
                let image = data.patientPic.replacingOccurrences(of: " ", with: "%20")
                imgData = Data(base64Encoded: image)
            }
        }
        var img: JSONDictionary = [:]
        if let imageData = imgData {
            img["user_image"] = imageData
        }
        self.saveButton.startAnimation()
        WebServices.personalInfo(parameters: params, imageData: img, success: {[weak self] (userData: UserInfo) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.saveButton.stopAnimation(animationStyle: .normal, completion: {
                if strongSelf.proceedToScreen == .signUp {
                    strongSelf.addConfirmationIdPopup()
                }else{
                    strongSelf.setUserImageonSideMenu()
                    
                    let dashBoardScene = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
                    AppDelegate.shared.goFromSideMenu(nextViewController: dashBoardScene)
                }
            })
        }) {[weak self](error: Error) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.saveButton.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func addConfirmationIdPopup(){
        let patientIDPopUpScene = PatientIDPopUpVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
        patientIDPopUpScene.userInfo = self.userInfo
        AppDelegate.shared.window?.addSubview(patientIDPopUpScene.view)
        self.addChildViewController(patientIDPopUpScene)
    }
    
    fileprivate func setUserImageonSideMenu(){
        guard let sideMenuScene = AppDelegate.shared.slideMenu.leftViewController as? SideMenuVC else{
            return
        }
        sideMenuScene.setUserImage()
    }
    
//    MARK:- Add allergy,Drug,Food Collection Cell in collectionView
    
    fileprivate func addAllergyDetails(){
        
        guard let userData = userInfo else{
            return
        }
        guard !userData.medicalCategoryInfo.isEmpty else{
            return
        }
        if let environmentalEnery = userData.medicalCategoryInfo.first?.environmentalAllergy, !environmentalEnery.isEmpty {
            let energy = environmentalEnery.components(separatedBy: "/")
            self.addEnvironmentalAllergy = energy
            let indexPath = IndexPath(row: 0, column: 2)
            self.environmentalAllergyDetails.insert("CollectionView", at: 1)
            self.profileInformationTableView.beginUpdates()
            self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
            self.profileInformationTableView.endUpdates()
        }
        if let foodEnery = userData.medicalCategoryInfo.first?.foodAllergy, !foodEnery.isEmpty {
            let energy = foodEnery.components(separatedBy: "/")
            self.addFoodAllergy = energy
            let indexPath = IndexPath(row: 0, column: 3)
            self.foodAllergyDetails.insert("CollectionView", at: 1)
            self.profileInformationTableView.beginUpdates()
            self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
            self.profileInformationTableView.endUpdates()
        }
        if let drugEnery = userData.medicalCategoryInfo.first?.drugAllergy, !drugEnery.isEmpty {
            let energy = drugEnery.components(separatedBy: "/")
            self.addDrugAllergy = energy
            let indexPath = IndexPath.init(row: 0, section: 4)
            self.drugAllergyDetails.insert("CollectionView", at: 1)
            self.profileInformationTableView.beginUpdates()
            self.profileInformationTableView.insertRows(at: [indexPath], with: .bottom)
            self.profileInformationTableView.endUpdates()
        }
    }
}
