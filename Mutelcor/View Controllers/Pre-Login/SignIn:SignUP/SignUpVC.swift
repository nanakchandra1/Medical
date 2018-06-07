//
//  SignUpVC.swift
//  Mutelcor
//
//  Created by on 06/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class SignUpVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
   fileprivate let signUpFieldArray = [K_EMAIL_ADDRESS_PLACEHOLDER.localized, K_PASSWORD.localized,K_CONFIRM_PASSWORD.localized,K_MOBILE_NUMBER_PLACEHOLDER.localized]
   fileprivate var authorizationCodeArray = [String]()
    let countryCodeDic = [String : Any]()
    var countryCodeArray = [String]()
    var signUpDic = [String : Any]()
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet var otpTextFields: [UITextField]!
    
    @IBOutlet weak var authorizationView: UIView!
    
    @IBOutlet weak var enterOnlineAuthorizationCodeLabel: UILabel!
    @IBOutlet weak var enterAuthorizationCodeLabel: UILabel!
    @IBOutlet weak var signUpDetailsTableView: UITableView!
    @IBOutlet weak var signUpDetailsTableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signUpButton: TransitionButton!
    @IBOutlet weak var mutelCoreNameLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = NavigationControllerOn.login
        self.sideMenuBtnActn = .backBtn
        self.setNavigationBar(screenTitle: K_SIGNUP_SCREEN_TITLE.localized)
        self.floatBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.signUpButton.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.authorizationView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
}

//MARK: Methods
//==============
extension SignUpVC{
    
    fileprivate func setupUI(){
        
        self.signUpButton.layer.cornerRadius = 2.2
        self.signUpButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.signUpButton.clipsToBounds = false
        
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.signUpDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        let phoneDetailsCellNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        self.signUpDetailsTableView.register(phoneDetailsCellNib, forCellReuseIdentifier: "PhoneDetailsCellID")
        
        self.signUpDetailsTableView.delegate = self
        self.signUpDetailsTableView.dataSource = self
        
        self.signUpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.mutelCoreNameLabel.font = AppFonts.sansProRegular.withSize(14)
        self.mutelCoreNameLabel.textColor = UIColor.grayLabelColor
        
        self.authorizationView.backgroundColor = UIColor.appColor
        
        self.enterAuthorizationCodeLabel.font = AppFonts.sanProSemiBold.withSize(CGFloat(16))        
        self.enterAuthorizationCodeLabel.text = K_ENTER_AUTHORIZATION_CODE.localized
        self.enterAuthorizationCodeLabel.textColor = UIColor.white
        
        self.enterOnlineAuthorizationCodeLabel.text = K_AUTH_TEXT.localized
        
        self.helpButton.addTarget(self, action: #selector(helpButtonTapped(_:)), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        
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
        return self.signUpFieldArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
        case 0...(signUpFieldArray.count - 2):
            guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for:    indexPath) as? DetailsCell else{
            fatalError("Cell Not Found")
        }
        
        detailsCell.cellTitle.text = signUpFieldArray[indexPath.row]
        
        detailsCell.showPasswordButton.addTarget(self, action: #selector(showPasswordBtnActn(_:)), for: .touchUpInside)
        detailsCell.detailsTextField.delegate = self
        
        if indexPath.row == 0{
            detailsCell.showPasswordButton.isHidden = true
            detailsCell.detailsTextField.keyboardType = .emailAddress
            detailsCell.detailsTextField.isSecureTextEntry = false
            
            detailsCell.detailsTextField.text = self.signUpDic[DictionaryKeys.emailID] as? String ?? ""
        }else if indexPath.row == 1{
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.keyboardType = .default
            detailsCell.detailsTextField.text = self.signUpDic[DictionaryKeys.password] as? String ?? ""
            
        }else if indexPath.row == 2 {
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.keyboardType = .default
            detailsCell.detailsTextField.text = self.signUpDic[DictionaryKeys.confirmPassword] as? String ?? ""
        }
        
        return detailsCell
            
        case 3:
            guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{
                fatalError("Cell Not Found")
        }
        
        phoneDetailsCell.cellTitle.text = self.signUpFieldArray[indexPath.row]
        phoneDetailsCell.countryCodeTextField.delegate = self
        phoneDetailsCell.phoneNumberTextField.delegate = self
        phoneDetailsCell.countryCodeTextField.placeholder = "Code"
        phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
        
        phoneDetailsCell.countryCodeTextField.text = self.signUpDic[DictionaryKeys.country_code] as? String ?? ""
        phoneDetailsCell.phoneNumberTextField.text = self.signUpDic[DictionaryKeys.patientMobileNumber] as? String ?? ""
        
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
            
        case 0...(signUpFieldArray.count - 2): guard let cell = textField.getTableViewCell as? DetailsCell else{
            return true
        }
        
        if indexPath.row == 0{
            delay(0.1, closure: {
                self.signUpDic[DictionaryKeys.emailID] = cell.detailsTextField.text ?? ""
            })
        }else if indexPath.row == 1{
            
            delay(0.1, closure: {
                self.signUpDic[DictionaryKeys.password] = cell.detailsTextField.text ?? ""
            })
            
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 16
            
        }else{
            
            delay(0.1, closure: {
                self.signUpDic[DictionaryKeys.confirmPassword] = cell.detailsTextField.text ?? ""
            })
            
            guard let text = textField.text else {
                return true
            }
            let newLength = text.count + string.count - range.length
            return newLength <= 16
            }
        case 3:
            guard let phoneNumberCell = textField.getTableViewCell as? PhoneDetailsCell else{
                return true
            }
        
        delay(0.1, closure: {
            if phoneNumberCell.phoneNumberTextField.text?.first == "0" {
                phoneNumberCell.phoneNumberTextField.text?.removeFirst()
                
            }
            self.signUpDic[DictionaryKeys.patientMobileNumber]  = phoneNumberCell.phoneNumberTextField.text ?? ""
        })
            
        default :
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.signUpDetailsTableView) else{
            return true
        }
        
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        
        switch indexPath.row{
            
        case 0:
            guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? DetailsCell else{ return true }
        cell.detailsTextField.becomeFirstResponder()
            
        case 1:
            guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? DetailsCell else{ return true }
        cell.detailsTextField.becomeFirstResponder()
            
        case 2:
            guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? PhoneDetailsCell else{ return true }
        cell.phoneNumberTextField.becomeFirstResponder()
            
        case 3:
            guard let cell = self.signUpDetailsTableView.cellForRow(at: nextIndexPath) as? PhoneDetailsCell else{ return true }
        cell.phoneNumberTextField.resignFirstResponder()
            self.signupValidation()
        default:
            return false
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
        
        alert.addAction(UIAlertAction(title: K_OK_TITLE.localized, style: .cancel, handler: nil))
        
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
        self.signupValidation()
        
    }
    
    fileprivate func signupValidation(){
        
        var authCode = ""
        
        for otp in otpTextFields {
            guard let text = otp.text else { return }
            authCode = authCode + text
        }
        
        signUpDic[DictionaryKeys.authorizationCode] = authCode
        
        //printlnDebug(authCode)
        
        guard let authorizeCode = signUpDic[DictionaryKeys.authorizationCode] as? String, !authorizeCode.isEmpty else{
            showToastMessage(AppMessages.validAuthorizationCode.rawValue.localized)
            return
        }
        
        guard authorizeCode.trimmingCharacters(in: .whitespacesAndNewlines).count > 5 else{
            showToastMessage(AppMessages.validAuthorizationCode.rawValue.localized)
            return
        }
        guard let email = signUpDic[DictionaryKeys.emailID] as? String, !email.isEmpty else{
            showToastMessage(AppMessages.emptyEmail.rawValue.localized)
            return
        }
        
        guard email.checkValidity(with: .Email) else {
            showToastMessage(AppMessages.validEmail.rawValue.localized)
            return
        }
        guard let password = signUpDic[DictionaryKeys.password] as? String, !password.isEmpty else{
            showToastMessage(AppMessages.emptyPassword.rawValue.localized)
            return
        }
        
        guard password.count > 5 else{
            showToastMessage(AppMessages.passwordMoreThanSixChar.rawValue.localized)
            return
        }
        guard let confirmPassword = signUpDic[DictionaryKeys.confirmPassword] as? String, !confirmPassword.isEmpty else{
            showToastMessage(AppMessages.emptyConfirmPassword.rawValue.localized)
            return
        }
        
        guard confirmPassword == password else{
            showToastMessage(AppMessages.passAndConfirmPassMismatched.rawValue.localized)
            return
        }
        guard let _ = signUpDic[DictionaryKeys.country_code] as? String else{
            showToastMessage(AppMessages.emptyCountryCode.rawValue.localized)
            return
        }
        guard let phoneNumber = signUpDic[DictionaryKeys.patientMobileNumber] as? String, !phoneNumber.isEmpty else {
            showToastMessage(AppMessages.emptyMobileNumber.rawValue.localized)
            return
        }
        
        //        guard phoneNumber.checkValidity(with: .MobileNumber) else{
        //            showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue.localized)
        //            return
        //        }
        
        
        signUpDic[DictionaryKeys.deviceToken] = AppUserDefaults.value(forKey: .deviceToken).stringValue
        signUpDic[DictionaryKeys.deviceType] = true.rawValue
        signUpDic[DictionaryKeys.deviceModel] = UIDevice.current.modelName
        signUpDic[DictionaryKeys.osVersion] = UIDevice.osType
        
        self.signUpButton.startAnimation()
        WebServices.signUp(parameters: signUpDic, success: { [weak self](userModel) in
            
            guard let signUpVC = self else{
                return
            }
            signUpVC.signUpButton.stopAnimation(animationStyle: .normal, completion: {
                if userModel.mobileVerified == 0 {
                    let otpVerificationScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                    otpVerificationScene.phoneNumberDic[DictionaryKeys.cmsId] = userModel.patientID
                    otpVerificationScene.phoneNumberDic[DictionaryKeys.patientMobileNumber] = userModel.patientMobileNumber
                    otpVerificationScene.procceedToScreenThrough = .signInWithOTP
                    otpVerificationScene.userInfo = userModel
                    guard let nvc = signUpVC.navigationController else{
                        return
                    }
                    nvc.pushViewController(otpVerificationScene, animated: true)
                }else{
                    
                    let personalInformationScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                    personalInformationScene.userInfo = userModel
                    personalInformationScene.proceedToScreen = .signUp
                    guard let nvc = signUpVC.navigationController else{
                        return
                    }
                    nvc.pushViewController(personalInformationScene, animated: true)
                }
            })
        }) { (error,errorCode) in
            self.signUpButton.stopAnimation()
            if let code = errorCode, code == 105 {
                let text = error.localizedDescription + " Please login with same email/mobile Number"
                let alertController = UIAlertController.init(title: "", message: text, preferredStyle: .alert)
                let loginButtonAction = UIAlertAction.init(title: "Login", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                let cancelButton = UIAlertAction.init(title: "cancel", style: .cancel, handler: nil)
                alertController.addAction(loginButtonAction)
                alertController.addAction(cancelButton)
                self.present(alertController, animated: true, completion: nil)
            }else{
               showToastMessage(error.localizedDescription)
            }
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
        self.signUpDic[DictionaryKeys.country_code] = country.countryCode
        self.signUpDetailsTableView.reloadData()
    }
}
