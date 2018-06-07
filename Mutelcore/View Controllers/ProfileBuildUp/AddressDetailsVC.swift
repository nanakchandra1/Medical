//
//  AddressDetailsVC.swift
//  Mutelcore
//
//  Created by Ashish on 23/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AddressDetailsVC: UIViewController {
    
    //    MARK:- Properties
    //    ==================
    enum ButtonTappedState {
        
        case countryBtn, stateBtn, cityBtn, none
    }
    
    
    let cellTitleArray = [K_COUNTRY_PLACEHOLDER.localized, K_ETHNICITY_PLACEHOLDER.localized, K_PIN_CODE_PLACEHOLDER.localized,K_STATE_PLACEHOLDER.localized, K_TOWN_PLACEHOLDER.localized,"Address Type", K_ADDRESS_DETAIL.localized,K_ADDRESS_LINE_2.localized]
    
    var userInfo : UserInfo!
    
    var btnTappedState = ButtonTappedState.none
    var countryListDic = [[String : Any]]()
    var countryCodeList = [CountryCodeModel]()
    var stateNameList = [StateNameModel]()
    var citynameList = [CityNameModel]()
    var countryArray = [String]()
    var countryCode : String?
    
    var stateListParam = [String : Any]()
    var stateListDic = [[String : Any]]()
    var stateArray = [String]()
    var stateCode : String?
    
    var cityListDic = [[String : Any]]()
    var townArray = [String]()
    
    var ethinicityListDic = [[String : Any]]()
    var ethinicityName = [EthinicityNameModel]()
    var ethinicityArray = [String]()
    var ethinicityNamee = [String]()
    var countryCodeScene : CountryCodeVC!
    var buildProfileVC : BuildProfileVC{
        
        return self.parent as! BuildProfileVC
    }
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var addressDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        fetchEthinicity()
        getCountry()
        
        addressDetailTableView.dataSource = self
        self.addressDetailTableView.delegate = self
    }
}

//MARK:- UITableViewDataSource Methods
//====================================

extension AddressDetailsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
            
        case 0...1: guard let countryCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else{
            fatalError("CountryCell Not Found!")
        }
        
        countryCell.celltitleBtn.addTarget(self, action: #selector(self.countryBtnTapped(_:)), for: .touchUpInside)
        countryCell.celltitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
        countryCell.celltextField.delegate = self
        countryCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_next_arrow"))
        countryCell.celltextField.rightViewMode = .always
        
        switch indexPath.row{
            
        case 0: countryCell.cellBtnOutlt.isHidden = false
            
            countryCell.cellBtnOutlt.addTarget(self, action: #selector(countryBtnTapped(_:)), for: .touchUpInside)
        
        if let code = self.userInfo.userAddressInfo[0].patientCountry, !code.isEmpty{
            
            if !self.countryCodeList.isEmpty{
                
                for count in 0..<self.countryCodeList.count{
                    
                    if self.countryCodeList[count].countryCode == code{
                        
                      countryCell.celltextField.text = self.countryCodeList[count].countryName
                    }
                }
            }
        }else{
            
            countryCell.celltextField.text = ""
        }
            
        case 1: countryCell.cellBtnOutlt.isHidden = true
            
            countryCell.celltitleBtn.addTarget(self, action: #selector(ethnicityBtnTapped(_:)), for: .touchUpInside)
        
        if let ethinicityId = self.userInfo.ethinicityId {
            
            if !self.ethinicityName.isEmpty{
                
                for count in 0..<self.ethinicityName.count {
                    
                    if self.ethinicityName[count].ethinicityID == ethinicityId{
                        
                       countryCell.celltextField.text = self.ethinicityName[count].ethinicityName
                    }
                }
            }
            
        }else{
            
            countryCell.celltextField.text = ""
        }

        default: fatalError("Country Cell Index Not Found!")
        }
        return countryCell
            
        case 2: guard let pinCodeCell = tableView.dequeueReusableCell(withIdentifier: "phoneNumberCell", for: indexPath) as? PhoneNumberCell else{
            fatalError("pinCodeCell Not Found!")
        }
        
        pinCodeCell.cellTitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
        pinCodeCell.cellTextField.delegate = self
        pinCodeCell.cellTextField.keyboardType = .numberPad
        
        if let pinCode = self.userInfo.userAddressInfo[0].patientPostalCode {
            
           pinCodeCell.cellTextField.text = "\(pinCode)"
        }else{
            
            pinCodeCell.cellTextField.text = ""
        }
        
        return pinCodeCell
            
        case 3...4: guard let stateCell = tableView.dequeueReusableCell(withIdentifier: "dateOfBirthCell", for: indexPath) as? DateOfBirthCell else{
            fatalError("StateCell Not Found!")
        }
        stateCell.celltitleBtn.setTitle(cellTitleArray[indexPath.row], for: .normal)
        stateCell.celltextField.delegate = self
        stateCell.cellBtnOutlt.isHidden = false
        stateCell.celltextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_next_arrow"))
        stateCell.celltextField.rightViewMode = .always
        
        stateCell.celltitleBtn.addTarget(self, action: #selector(self.countryBtnTapped(_:)), for: .touchUpInside)
        stateCell.cellBtnOutlt.addTarget(self, action: #selector(self.countryBtnTapped(_:)), for: .touchUpInside)
        
        switch indexPath.row {
            
        case 3: if let stateCode = self.userInfo.userAddressInfo[0].patientState{
            
            if !self.stateNameList.isEmpty{
                
                for count in 0..<self.stateNameList.count{
                    
                    if self.stateNameList[count].stateCode == "\(stateCode)" {
                        
                      stateCell.celltextField.text = self.stateNameList[count].stateName
                    }
                }
            }
            
        }else{
            
            stateCell.celltextField.text = ""
        }
            
        case 4: if let cityCode = self.userInfo.userAddressInfo[0].patientCity{
            
            if !self.citynameList.isEmpty{
                
                for count in 0..<self.citynameList.count{
                    
                    if self.citynameList[count].id == cityCode{
                        
                      stateCell.celltextField.text = self.citynameList[count].cityName
                        
                }
              }
            }
        }else{
            
            stateCell.celltextField.text = ""
            }
            
        default: fatalError("State Cell Not Found!")
        }
        
        return stateCell
            
        case 5: guard let addressTypeCell = tableView.dequeueReusableCell(withIdentifier: "natureOfAppointmentCellID", for: indexPath) as? NatureOfAppointmentCell else{
           
            fatalError("addressTypeCell Not Found!")
            }
        
        addressTypeCell.natureOfAppointmentLabel.text = self.cellTitleArray[indexPath.row]
        addressTypeCell.routineBtn.setTitle("Current", for: UIControlState.normal)
        addressTypeCell.routineBtn.setTitle("Current", for: UIControlState.selected)
        addressTypeCell.emergencyBtn.setTitle("Permanent", for: UIControlState.normal)
        addressTypeCell.emergencyBtn.setTitle("Permanent", for: UIControlState.selected)
        addressTypeCell.routineBtn.addTarget(self, action: #selector(self.currentBtnTapped), for: UIControlEvents.touchUpInside)
        addressTypeCell.emergencyBtn.addTarget(self, action: #selector(self.permanentBtnTapped), for: UIControlEvents.touchUpInside)
        
        if let addressType = self.userInfo.userAddressInfo[0].addressType{
            
            if addressType == true.rawValue {
                
                addressTypeCell.emergencyBtn.isSelected = true
                addressTypeCell.routineBtn.isSelected = false
                
            }else{
                
                addressTypeCell.routineBtn.isSelected = true
                addressTypeCell.emergencyBtn.isSelected = false
                
            }
        }

            return addressTypeCell
            
        case 6...7: guard let addressCell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as? AddressCell else{
            fatalError("StateCell Not Found!")
        }
        
        addressCell.addressLineTextField.delegate = self
        addressCell.addressLineTextField.placeholder = cellTitleArray[indexPath.row]

        return addressCell
            
        default: fatalError("Cell Not Found!")
        }
    }
}

//MARK;- UITableViewDelegate Methods
//==================================
extension AddressDetailsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5{
            
          return CGFloat(70)
        }else{
            
           return CGFloat(43)
        }
    }
}

//MARK:- TextField Delegate Methods
//==================================

extension AddressDetailsVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let indexPath = textField.tableViewIndexPathIn(self.addressDetailTableView)! as IndexPath
        
        MultiPicker.noOfComponent = 1
        
        switch indexPath.row{
            
        case 1: guard let countryCell = textField.getTableViewCell as? DateOfBirthCell else{return}
        
        MultiPicker.openPickerIn(countryCell.celltextField, firstComponentArray: ethinicityArray, secondComponentArray: [], firstComponent: countryCell.celltextField.text, secondComponent: nil, titles: ["Choose Ethinicity"], doneBlock: { (firstValue, _,_,_) in
            
            countryCell.celltextField.text = firstValue
            let ethinicityCode = self.mapValues(countryCell.celltextField.text as AnyObject, self.ethinicityListDic, "ethi_name", "ethin_id")

            self.userInfo.ethinicityId = Int(ethinicityCode)
            
        })
            
        case 2: break
            
        case 3: guard let stateCell = textField.getTableViewCell as? DateOfBirthCell else{return}
        
        MultiPicker.openPickerIn(stateCell.celltextField, firstComponentArray: stateArray, secondComponentArray: [], firstComponent: stateCell.celltextField.text, secondComponent: nil, titles: ["Choose Country"], doneBlock: { (firstValue, _,_,_) in
            
            stateCell.celltextField.text = firstValue
            self.stateListParam[state_Code] = self.mapValues(stateCell.celltextField.text as AnyObject, self.stateListDic, state_Name, state_Code)
            let stateCode = self.mapValues(stateCell.celltextField.text as AnyObject, self.stateListDic, state_Name, state_Code)
            
            self.userInfo.userAddressInfo[0].patientState = Int(stateCode)
            
            self.getTownListing(stateCode)
            
        })
            
        case 4: guard let townCell = textField.getTableViewCell as? DateOfBirthCell else{return}
        
        MultiPicker.openPickerIn(townCell.celltextField, firstComponentArray: townArray, secondComponentArray: [], firstComponent: townCell.celltextField.text, secondComponent: nil, titles: ["Choose Country"], doneBlock: { (firstValue, _,_,_) in
            
            townCell.celltextField.text = firstValue
            
            let cityCode = self.mapValues(townCell.celltextField.text as AnyObject, self.cityListDic, "city_name", "id")
            
            self.userInfo.userAddressInfo[0].patientCity = Int(cityCode)
            
        })
            
        case 5: break
            
        case 6: break
            
        default: return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let indexPath = textField.tableViewIndexPathIn(self.addressDetailTableView)! as IndexPath
        
        switch indexPath.row{
            
        case 0,1: break
        case 2: guard let pinCodeCell = textField.getTableViewCell as? PhoneNumberCell else{
        
            return true
        }
        if let pincode = pinCodeCell.cellTextField.text {
            
            if !pincode.isEmpty{
                
               self.userInfo.userAddressInfo[0].patientPostalCode = Int(pincode)
            }
        }
        
        case 3,4,5: break
        
        case 6: guard let addressCell = textField.getTableViewCell as? AddressCell else{
            
            return true
        }
        
        self.userInfo.userAddressInfo[0].patientAddress = addressCell.addressLineTextField.text ?? ""
            
        case 7: guard let optionalAddressCell = textField.getTableViewCell as? AddressCell else{return true}
            
            self.userInfo.userAddressInfo[0].patientAddress?.append(optionalAddressCell.addressLineTextField.text!)
            
        default: return true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let indexPath = textField.tableViewIndexPathIn(self.addressDetailTableView)! as IndexPath
        let nextindexpath = IndexPath(row: indexPath.row + 1, section: 0)
        
        if indexPath.row == 2{
            guard let phoneNumberCell = textField.getTableViewCell as? PhoneNumberCell else{return true}
            phoneNumberCell.cellTextField.resignFirstResponder()
        }
        else if indexPath.row == 6{
            guard let descriptionCell = self.addressDetailTableView.cellForRow(at: nextindexpath) as? AddDescriptionCell else{return true}
            descriptionCell.descriptionTextField.becomeFirstResponder()
        }
        else if indexPath.row == 7 {
            guard let descriptionCell = self.addressDetailTableView.cellForRow(at: nextindexpath) as? AddDescriptionCell else{return true}
            descriptionCell.descriptionTextField.resignFirstResponder()
        }
        return true
    }
}

//MARK:- METHODS
//================

extension AddressDetailsVC {
    
    //    MARK: Register Nib Files
    //    ==========================
    fileprivate func registerNibs(){
        
        let countryNib = UINib(nibName: "DateOfBirthCell", bundle: nil)
        addressDetailTableView.register(countryNib, forCellReuseIdentifier: "dateOfBirthCell")
        
        let pincodeNib = UINib(nibName: "PhoneNumberCell", bundle: nil)
        addressDetailTableView.register(pincodeNib, forCellReuseIdentifier: "phoneNumberCell")
        
        let addressCell = UINib(nibName: "AddressCell", bundle: nil)
        addressDetailTableView.register(addressCell, forCellReuseIdentifier: "addressCell")
        
        let addressTypeCell = UINib(nibName: "NatureOfAppointmentCell", bundle: nil)
        addressDetailTableView.register(addressTypeCell, forCellReuseIdentifier: "natureOfAppointmentCellID")
        
    }
    
    //    MARK: Button Methods
    //    ====================
    
    func countryBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.addressDetailTableView) else{
            
            return
        }
        
        self.countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        self.countryCodeScene.countryDataDelegate = self
        
        if indexPath.row == 0{
            
            self.countryCodeScene.navigateToScreenBy = .countryBtnTapped
            self.btnTappedState = .countryBtn
            
            if !self.countryCodeList.isEmpty{
                
              self.countryCodeScene.countryCodeModel = self.countryCodeList
              self.navigationController?.pushViewController(self.countryCodeScene, animated: true)
            }else{
                
                showToastMessage("Country List is empty")
            }
            
        }else if indexPath.row == 3{
            
          self.countryCodeScene.navigateToScreenBy = .stateBtnTapped
          self.btnTappedState = .stateBtn
            if !self.stateNameList.isEmpty{
                
                self.countryCodeScene.stateList = self.stateNameList
                self.navigationController?.pushViewController(self.countryCodeScene, animated: true)
            }else{
                
                showToastMessage("State List is empty")
            }
            
        }else if indexPath.row == 4 {
            
          self.countryCodeScene.navigateToScreenBy = .townBtntapped
            self.btnTappedState = .cityBtn
            
            if !self.citynameList.isEmpty{
                
                self.countryCodeScene.cityList = self.citynameList
                self.navigationController?.pushViewController(self.countryCodeScene, animated: true)
            }else{
                
                showToastMessage("City List is empty")
            }
        }
    }
    
    func ethnicityBtnTapped(_ sender : UIButton){
        
        guard let ethinicityCell = sender.getTableViewCell as? DateOfBirthCell else{return}
        ethinicityCell.celltextField.becomeFirstResponder()
        
    }
    
    func sateBtnTapped(_ sender : UIButton){
        
        guard let stateCell = sender.getTableViewCell as? DateOfBirthCell else{return}
        stateCell.celltextField.becomeFirstResponder()
        
    }
    
    func townBtnTapped(_ sender : UIButton){
        
        guard let townCell = sender.getTableViewCell as? DateOfBirthCell else{return}
        townCell.celltextField.becomeFirstResponder()
        
    }
    
    @objc fileprivate func currentBtnTapped(_ sender : UIButton){
        
            guard let indexPath = sender.tableViewIndexPathIn(self.addressDetailTableView) else{
                
                return
            }
            guard let natureOfAppointmentCell = self.addressDetailTableView.cellForRow(at: indexPath) as? NatureOfAppointmentCell else{
                
                return
            }
            
            if sender.isSelected { return }
            natureOfAppointmentCell.emergencyBtn.isSelected = sender.isSelected
            sender.isSelected = !sender.isSelected
        
            self.userInfo.userAddressInfo[0].addressType = sender.isSelected ? false.rawValue : true.rawValue

        self.addressDetailTableView.reloadRows(at: [indexPath], with: .automatic)
        
        }
    
    @objc fileprivate func permanentBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.addressDetailTableView) else{
            
            return
        }
        guard let addressTypeCell = self.addressDetailTableView.cellForRow(at: indexPath) as? NatureOfAppointmentCell else{
            
            return
        }
        if sender.isSelected { return }
        addressTypeCell.routineBtn.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        
        self.userInfo.userAddressInfo[0].addressType = sender.isSelected ? true.rawValue : false.rawValue
        
        self.addressDetailTableView.reloadRows(at: [indexPath], with: .automatic)
        
    }

    //    MARK: SERVICES METHODS
    //    ======================
    
    fileprivate func getCountry(){
        
        let param = [String : Any]()
        
        WebServices.getCountryList(parameters: param, success: { [unowned self] (_ countryData: [CountryCodeModel]) in
            
            printlnDebug(countryData)
            
            self.countryCodeList = countryData
//            self.countryListDic = countryData as! [[String : Any]]
            
//            let countryList = self.countryListDic.map{(value) in
//
//                value[country_Name]
//            }
            
//            self.countryArray = countryList as! [String]
            
            if let countryCode = self.userInfo.userAddressInfo[0].patientCountry, !countryCode.isEmpty{
//
                self.getStateList(countryCode)
                
//                let code = self.countryCodeList.filter({ (countryCod) -> Bool in
//
//                    return countryCod.countryName == patientCountry
//                })
//
//                self.getStateList(code[0].countryCode)
//
            }
            
            
//            if !(self.userInfo.userAddressInfo[0].patientCountry?.isEmpty)!{
            
//                countryCode = self.countryListDic.filter({ (a : [String : Any]) -> Bool in
//                    return a["country_name"] as? String == self.userInfo.userAddressInfo[0].patientCountry
//                })[0]["country_code"] as! String
                
//            }
                
//            if let patientCountry = self.userInfo.userAddressInfo[0].patientCountry{
//
//                if !patientCountry.isEmpty{
//
//                   self.getStateList(patientCountry)
//                }
//            }
            
        }) { (e: Error) in
            
            showToastMessage(e.localizedDescription)
        }
    }
    
    fileprivate func getStateList(_ countryCode : String?){
        
        if self.stateListParam["country_code"] == nil{
            
            self.stateListParam["country_code"] = countryCode
        }
        
        printlnDebug("slp : \(stateListParam)")
        
        WebServices.getStateList(parameters: stateListParam,
                                 success: {[unowned self](_ statedata : [StateNameModel]) in
                                    
                                    printlnDebug(statedata)
                                    
                                    self.stateNameList = statedata
                                    
                                    if let stateCode = self.userInfo.userAddressInfo[0].patientState{
                                        
                                        self.getTownListing("\(stateCode)")
                                        
                                    }
                                    
        }) { (e : Error) in
            
            showToastMessage(e.localizedDescription)
            
        }
    }
    
    fileprivate func getTownListing(_ stateCode : String){
        
            self.stateListParam["state_code"] = stateCode
        
        printlnDebug("sp : \(stateListParam)")
        
        WebServices.getTownList(parameters: stateListParam, success: {[unowned self](_ cityData : [CityNameModel]) in
            
            printlnDebug(cityData)
            
            self.citynameList = cityData
            
//            self.cityListDic = cityData as! [[String : Any]]
//
//            let cityList = self.cityListDic.map{(value) in
//
//                value[city_name]
//            }
//
//            self.townArray = cityList as! [String]
            
        }) { (e : Error) in
            
            showToastMessage(e.localizedDescription)
            
        }
    }
    
    fileprivate func fetchEthinicity(){
        
        WebServices.getEthinicityList(parameters: stateListParam, success: { [unowned self](_ ethinicityData : [EthinicityNameModel]) in
            
            printlnDebug(ethinicityData)
            
//            self.ethinicityListDic = ethinicityData as! [[String : Any]]
            self.ethinicityName = ethinicityData
            
            for ethinicity in ethinicityData {
                
                self.ethinicityArray.append(ethinicity.ethinicityName!)
            }
            
            self.addressDetailTableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
            
        }) { (e : Error) in
            
            showToastMessage(e.localizedDescription)
            
        }
    }
    
    fileprivate func mapValues(_ textValue : AnyObject, _ dic : [[String : Any]],_ dicKey1 : String, _ dickey2 : String ) -> String{
        
        var storedVariable = ""
        
        for i in 0..<dic.count{
            
            if "\(textValue)" == "\(dic[i][dicKey1]!)" {
                
                if let dictionaryValue = dic[i][dickey2]{
                    
                    storedVariable = "\(dictionaryValue)"
                    
                }
            }
            
            printlnDebug("StoredVariable : \(storedVariable)")
        }
        return storedVariable
    }
}
//MARK:- Protocol
//===============
extension AddressDetailsVC : CountryDataDelegate {
    
    func setCountryData(_ code: String, name: String) {
        
        if self.btnTappedState == .countryBtn {
            
            self.stateListParam[country_Code] = code
            self.userInfo.userAddressInfo[0].patientCountry = code
            self.getStateList(code)
            
            let indexPath = IndexPath(row: 0, column: 0)
            self.addressDetailTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }else if self.btnTappedState == .stateBtn {
            
            self.userInfo.userAddressInfo[0].patientState = Int(code)
            
            self.getTownListing(code)
            let indexPath = IndexPath(row: 3, column: 0)
            self.addressDetailTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }else if self.btnTappedState == .cityBtn {
            
            self.userInfo.userAddressInfo[0].patientCity = Int(code)
            
            let indexPath = IndexPath(row: 4, column: 0)
            self.addressDetailTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
}
