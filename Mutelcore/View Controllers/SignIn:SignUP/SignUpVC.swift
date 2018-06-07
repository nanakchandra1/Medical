//
//  SignUpVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 06/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit


class SignUpVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    let signUpFieldArray = [K_EMAIL_ADDRESS_PLACEHOLDER.localized, K_PASSWORD.localized,K_CONFIRM_PASSWORD.localized,K_MOBILE_NUMBER_PLACEHOLDER.localized]
    
    var authorizationCodeArray = [String]()
    let countryCodeDic = [String : Any]()
    var countryCodeArray = [String]()
    
    var signUpDic = [String : Any]()
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet var otpTextFields: [UITextField]!
    @IBOutlet weak var authorizationView: UIView!
    
    @IBOutlet weak var EnterOnlineAuthorizationCodeLabel: UILabel!
    @IBOutlet weak var enterAuthorizationCodeLabel: UILabel!
    @IBOutlet weak var signUpDetailsTableView: UITableView!
    @IBOutlet weak var signUpDetailsTableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var mutelCoreNameLabel: UILabel!
    
    //MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupSubViews
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = NavigationControllerOn.login
        self.sideMenuBtnActn = SidemenuBtnAction.BackBtn
        self.floatBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        self.setNavigationBar(K_SIGNUP_SCREEN_TITLE.localized, 0, 0)
        self.signUpButton.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.authorizationView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
}

//MARK: Private functions
extension SignUpVC{
    
    fileprivate func setupUI(){
        
        self.signUpButton.layer.cornerRadius = 2.2
        self.signUpButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        signUpDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        let phoneDetailsCellNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        signUpDetailsTableView.register(phoneDetailsCellNib, forCellReuseIdentifier: "PhoneDetailsCellID")
        
        self.signUpDetailsTableView.delegate = self
        self.signUpDetailsTableView.dataSource = self
        
        self.signUpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
  
        self.mutelCoreNameLabel.font = AppFonts.sansProRegular.withSize(14)
        self.mutelCoreNameLabel.textColor = UIColor.grayLabelColor
        
        self.authorizationView.backgroundColor = UIColor.appColor
        
        if DeviceType.IS_IPHONE_5 {
            self.enterAuthorizationCodeLabel.font = AppFonts.sanProSemiBold.withSize(15)
        }else{
          self.enterAuthorizationCodeLabel.font = AppFonts.sanProSemiBold.withSize(16)
        }
    
        self.enterAuthorizationCodeLabel.text = K_AUTH_TEXT.localized
        self.enterAuthorizationCodeLabel.textColor = UIColor.white
        
        helpButton.addTarget(self, action: #selector(helpButtonTapped(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        
        for textfield in self.otpTextFields{
            
            textfield.backgroundColor = UIColor.clear
            textfield.roundCorner(radius: 2.2, borderColor: UIColor.white, borderWidth: 1.0)
            textfield.font = AppFonts.sanProSemiBold.withSize(16)
            textfield.delegate = self
            textfield.text = "\u{200B}"
        }
        
        self.floatBtn.isHidden = true
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
//=================================================
extension SignUpVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return signUpFieldArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        switch indexPath.row {
        case 0...(signUpFieldArray.count - 2): guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for:    indexPath) as? DetailsCell else{
            
            fatalError("Cell Not Found")
            
        }
        
        detailsCell.cellTitle.text = signUpFieldArray[indexPath.row]
  
        detailsCell.showPasswordButton.addTarget(self, action: #selector(showPasswordBtnActn(_:)), for: .touchUpInside)
        
        detailsCell.detailsTextField.delegate = self
        
        if indexPath.row == 0{
            
            detailsCell.showPasswordButton.isHidden = true
            detailsCell.detailsTextField.keyboardType = .emailAddress
            detailsCell.detailsTextField.isSecureTextEntry = false
            
            detailsCell.detailsTextField.text = self.signUpDic[email_Id] as? String ?? ""
        }else if indexPath.row == 1{
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.keyboardType = .default
            detailsCell.detailsTextField.text = self.signUpDic[password] as? String ?? ""
            
        }else if indexPath.row == 2 {
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.keyboardType = .default
            detailsCell.detailsTextField.text = self.signUpDic[confirm_Password] as? String ?? ""
            
        }
        
        return detailsCell
            
        case 3: guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{ fatalError("Cell Not Found")
        }

        phoneDetailsCell.cellTitle.text = self.signUpFieldArray[indexPath.row]
        phoneDetailsCell.countryCodeTextField.font = AppFonts.sanProSemiBold.withSize(13)
        
        phoneDetailsCell.countryCodeTextField.delegate = self
        phoneDetailsCell.phoneNumberTextField.delegate = self
        phoneDetailsCell.countryCodeTextField.placeholder = "CODE"
        phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
        
        phoneDetailsCell.countryCodeTextField.text = self.signUpDic[country_code] as? String ?? ""
        phoneDetailsCell.phoneNumberTextField.text = self.signUpDic[mobile_number] as? String ?? ""
        
        phoneDetailsCell.phoneNumberTextField.keyboardType = .numberPad
        
        return phoneDetailsCell
            
        default: fatalError("IndexPath Not found")
        }
    }
}

//MARK:- UITextFieldDelegate
//==========================

extension SignUpVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if self.otpTextFields.contains(textField){
                
                if (textField === self.otpTextFields[0]) {
                    if (range.length == 0) {
                        textField.text = string
                        self.otpTextFields[1].becomeFirstResponder()
                    } else {
                        textField.text = "\u{200B}"
                    }
                } else if (textField === self.otpTextFields[1]) {
                    if (range.length == 0) {
                        textField.text = string
                        self.otpTextFields[2].becomeFirstResponder()
                    } else {
                        textField.text = "\u{200B}"
                        self.otpTextFields[0].becomeFirstResponder()
                    }
                } else if (textField === self.otpTextFields[2]) {
                    if (range.length == 0) {
                        textField.text = string
                        self.otpTextFields[3].becomeFirstResponder()
                    } else {
                        textField.text = "\u{200B}"
                        self.otpTextFields[1].becomeFirstResponder()
                    }
                } else if (textField === self.otpTextFields[3]) {
                    if (range.length == 0) {
                        textField.text = string
                        self.otpTextFields[4].becomeFirstResponder()
                    } else {
                        textField.text = "\u{200B}"
                        self.otpTextFields[2].becomeFirstResponder()
                    }
                } else if (textField === self.otpTextFields[4]) {
                    if (range.length == 0) {
                        textField.text = string
                        self.otpTextFields[5].becomeFirstResponder()
                    } else {
                        textField.text = "\u{200B}"
                        self.otpTextFields[3].becomeFirstResponder()
                    }
                } else if (textField === self.otpTextFields[5]) {
                    if (range.length == 0) {
                        textField.text = string
                        textField.resignFirstResponder()
                        self.view.endEditing(true)
                    } else {
                        textField.text = "\u{200B}"
                        self.otpTextFields[4].becomeFirstResponder()
                    }
                }
            }
        
        guard let indexPath = textField.tableViewIndexPathIn(self.signUpDetailsTableView) else{
            
            return false
        }
        
        switch indexPath.row {
            
        case 0...(signUpFieldArray.count - 2): guard let cell = textField.getTableViewCell as? DetailsCell else{return true}
        
        if indexPath.row == 0{
            delay(0.1, closure: {
                self.signUpDic[email_Id] = cell.detailsTextField.text ?? ""
            })
        }else if indexPath.row == 1{

            delay(0.1, closure: {
                self.signUpDic[password] = cell.detailsTextField.text ?? ""
                
            })
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 16
            
        }else{
            
            delay(0.1, closure: {
                self.signUpDic[confirm_Password] = cell.detailsTextField.text ?? ""
            })
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 16
            
            }
            
        case 3:   guard let phoneNumberCell = textField.getTableViewCell as? PhoneDetailsCell else{return true}
        
        delay(0.1, closure: {
            
            if phoneNumberCell.phoneNumberTextField.text?.characters.first == "0" {
                
                phoneNumberCell.phoneNumberTextField.text?.characters.removeFirst()
                
            }
            
            self.signUpDic[mobile_number]  = phoneNumberCell.phoneNumberTextField.text ?? ""
        })
            
        default : return true
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.signUpDetailsTableView) else{
            
            return true
        }
        
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        
        switch indexPath.row{
            
        case 0: guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? DetailsCell else{ return true }
        
        cell.detailsTextField.becomeFirstResponder()
            
        case 1: guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? DetailsCell else{ return true }
        
        cell.detailsTextField.becomeFirstResponder()
            
        case 2: guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? PhoneDetailsCell else{ return true }
        
        cell.phoneNumberTextField.becomeFirstResponder()
            
        case 3: guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? PhoneDetailsCell else{ return true }
        
        cell.phoneNumberTextField.resignFirstResponder()
            
        default: fatalError("Cell Not Found!")
            
        }
        
        return true
    }
}

//MARK:- IBActions
//=================
extension SignUpVC{
    
    //helpButtonTapped
    @objc fileprivate func helpButtonTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: HELP_POP_UP_TITLE.localized,
                                      message: HELP_POP_UP_MESSAGE.localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        alert.view.tintColor = UIColor(red: 0.0/255.0, green: 176.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func countryCodeBtnTapped(){
      
        self.view.endEditing(true)
        
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
        
    }
    
    //signUpButtonTapped
    @objc fileprivate func signUpButtonTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        var authCode = ""
        
        for otp in otpTextFields {
            guard let text = otp.text else { return }
            authCode = authCode + text
        }

        signUpDic[authorization_Code] = authCode
        
        printlnDebug(authCode)
        
        guard let authorizeCode = signUpDic[authorization_Code] as? String, !authorizeCode.isEmpty else{
            
            showToastMessage(AppMessages.validAuthorizationCode.rawValue)
            
            return
        }

        guard authorizeCode.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 5 else{
            
            showToastMessage(AppMessages.validAuthorizationCode.rawValue)
            
            return
        }
        guard let email = signUpDic[email_Id] as? String, !email.isEmpty else{
            
            showToastMessage(AppMessages.emptyEmail.rawValue)
            
            return
        }

        guard email.checkValidity(with: .Email) else {
            
            showToastMessage(AppMessages.validEmail.rawValue)
            
            return
        }
        guard let password = signUpDic[password] as? String, !password.isEmpty else{
            
            showToastMessage(AppMessages.emptyPassword.rawValue)
            
            return
            
        }

        guard password.characters.count > 5 else{
            
            showToastMessage(AppMessages.passwordMoreThanSixChar.rawValue)
            
            return
        }
        guard let confirmPassword = signUpDic[confirm_Password] as? String, !confirmPassword.isEmpty else{
            
            showToastMessage(AppMessages.emptyConfirmMessage.rawValue)
            
            return
        }

        guard confirmPassword == password else{
            
            showToastMessage(AppMessages.passAndConfirmPassMismatched.rawValue)
            
            return
        }
        guard let _ = signUpDic[country_code] as? String else{
            
            showToastMessage(AppMessages.emptyCountryCode.rawValue)
            
            return
        }
        guard let phoneNumber = signUpDic[mobile_number] as? String, !phoneNumber.isEmpty else {
            
            showToastMessage(AppMessages.emptyMobileNumber.rawValue)
            
            return
        }

        guard phoneNumber.checkValidity(with: .MobileNumber) else{
            
            showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue)
            
            return
        }

        
          signUpDic["device_token"] = UIDevice.UDID

        
        signUpDic["device_type"] = UIDevice.deviceType
        signUpDic["device_model"] = UIDevice.current.modelName
        signUpDic["os_version"] = UIDevice.osType
        
        WebServices.signUp(parameters: signUpDic, success: { [unowned self](userModel, hospInfo) in
            
            printlnDebug(userModel)
            printlnDebug(hospInfo)
            
            if userModel.mobileVerified == 0 {
                
                let otpVerificationScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(otpVerificationScene, animated: true)
                otpVerificationScene.phoneNumberDic[id] = userModel.patientID
                otpVerificationScene.phoneNumberDic[mobile_number] = userModel.patientMobileNumber
                otpVerificationScene.procceedToScreenThrough = .signInWithOTP
                otpVerificationScene.userInfo = userModel
                otpVerificationScene.hospitalAddressInfoModel = [hospInfo]
                
            }else{
                
                let buildProfileScene = BuildProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                self.navigationController?.pushViewController(buildProfileScene, animated: true)
                
                buildProfileScene.userInfo = userModel
                buildProfileScene.hospitalAddressInfoModel = [hospInfo]
                
            }
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    @objc fileprivate func showPasswordBtnActn(_ sender : UIButton) {
        
        guard let cell = sender.getTableViewCell as? DetailsCell else{
            
            fatalError("Cell Not Found!")
        }
        cell.showPasswordButton.isHidden = !cell.showPasswordButton.isEnabled
    }
}

//MARK:- Protocol
extension SignUpVC : CountryCodeDelegate {
    
    func setCountry(_ country: CountryCode) {
        
        printlnDebug(country)
        printlnDebug(country.countryCode)
     self.signUpDic[country_code] = country.countryCode
        
        self.signUpDetailsTableView.reloadData()
    }
}
