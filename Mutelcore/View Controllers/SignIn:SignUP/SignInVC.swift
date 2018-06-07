//
//  SignInVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 03/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInVC: BaseViewController {
    
    //    MARK:- Propoerties
    //    ===================
    let emailArray = [K_EMAIL_OR_MOBILE_NUMBER.localized, K_PASSWORD.localized]
    var signInDictionary = [String : Any]()
    
    
    
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var screenQuotation: UILabel!
    
    @IBOutlet weak var signInDetailsTableView: UITableView!
    @IBOutlet weak var loginWithOTPButton: UIButton!
    
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var secureLoginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termaAndConditionText: UILabel!
    
    @IBOutlet weak var mutelCoreName: UILabel!
    
    //MARK:- ViewController life cycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupSubViews
        self.setUi()
        
        #if DEBUG
            signInDictionary[login_Type] = loginType.mobileNumber.rawValue
            signInDictionary[email] = /*"taruna.sharma121@appinventiv.com"*/"9810211463"///*"ashish08ece@gmail.com""9810211463"*/"iostesting@yopmail.com"
            signInDictionary[password] = /*"1234567890""123456"*/"123456"
        #endif
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.floatBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.secureLoginButton.gradient(withX: 0, withY: 0, cornerRadius: true)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
//================================================
extension SignInVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for: indexPath) as? DetailsCell else{ fatalError("Cell Not Found")
        }
        
        detailsCell.cellTitle.text = self.emailArray[indexPath.row]
        detailsCell.detailsTextField.delegate = self
        
        switch indexPath.row {
            
        case 0:
            
            detailsCell.detailsTextField.font = AppFonts.sanProSemiBold.withSize(16)
            detailsCell.detailsTextField.keyboardType = .emailAddress
            detailsCell.showPasswordButton.isHidden = true
            detailsCell.detailsTextField.isSecureTextEntry = false
            
        case 1:
            
            detailsCell.detailsTextField.keyboardType = .namePhonePad
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.returnKeyType = .done
            
        default: printlnDebug("Default")
            
        }
        
        return detailsCell
    }
}

//MARK: UITextViewDelegate
extension SignInVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        //        UIApplication.shared.open(URL, options: [:])
        return true
    }
}

//MARK:- UITextFieldDelegate
//==========================
extension SignInVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let indexpath = textField.tableViewIndexPathIn(self.signInDetailsTableView)!
        guard let cell = self.signInDetailsTableView.cellForRow(at: indexpath) as? DetailsCell else{return true}
        
        switch indexpath.row{
            
        case 0: if (cell.detailsTextField.text?.checkValidity(with: .MobileNumber))!{
            signInDictionary[login_Type] = loginType.mobileNumber.rawValue
        }
        else{
            signInDictionary[login_Type] = loginType.email.rawValue
        }
        
        delay(0.1, closure: {
            self.signInDictionary[email] = cell.detailsTextField.text ?? ""
        })
            
        case 1:
            
            delay(0.1, closure: {
                self.signInDictionary[password] = cell.detailsTextField.text ?? ""
            })
            
        default: return true
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        let indexpath = textField.tableViewIndexPathIn(self.signInDetailsTableView)!
        let nextIndexpath = IndexPath(row: indexpath.row + 1, section: 0)
        
        switch indexpath.row{
            
        case 0: guard let cell = self.signInDetailsTableView.cellForRow(at: nextIndexpath) as? DetailsCell else {return true}
        
        cell.detailsTextField.becomeFirstResponder()
            
        case 1: guard let cell = self.signInDetailsTableView.cellForRow(at: indexpath) as? DetailsCell else {return true}
        
        cell.detailsTextField.resignFirstResponder()
            
        default: return true
            
        }
        return true
    }
}

//MARK:- IBActions
//================
extension SignInVC {
    
    //signUpTapped
    func signUpTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let signUpScene = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signUpScene, animated: true)
        
    }
    
    //forgotPasswordTapped
    func forgotPasswordTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let forgotPasswordScene = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(forgotPasswordScene, animated: true)
    }
    
    //secureLoginTapped
    func secureLoginTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        self.secureLoginButtonTapped()
        
    }
    
    func loginWithOtpTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let signInWithOtpPage = SignInWithOTPVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signInWithOtpPage, animated: true)
    }
}

//MARK:- Methods
//==============
extension SignInVC {
    
    fileprivate func setUi(){
        
        //nib registery for signInDetailsTableView
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.signInDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        //setting up delegates and datasource
        self.signInDetailsTableView.delegate = self
        self.signInDetailsTableView.dataSource = self
        
        self.screenQuotation.text = K_SCREEN_TAG.localized
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
        self.secureLoginButton.layer.cornerRadius = 2.2
        self.secureLoginButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        
        self.secureLoginButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.secureLoginButton.setTitle("SECURE LOGIN", for: .normal)
        
        self.secureLoginButton.titleLabel?.font  = AppFonts.sanProSemiBold.withSize(16)
        
        self.signUpButton.setTitleColor(UIColor.appColor, for: .normal)
        self.signUpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.forgotPassword.titleLabel?.textColor = UIColor.grayLabelColor
        self.forgotPassword.titleLabel?.font = AppFonts.sansProRegular.withSize(13)
        
        self.loginWithOTPButton.titleLabel?.textColor = UIColor.grayLabelColor
        self.loginWithOTPButton.titleLabel?.font = AppFonts.sansProRegular.withSize(13)
        
        //attributed string for Terms & conditions
        
        //        let str = K_TERMS_AND_CONDITION.localized
        
        //adding targets to buttons
        self.signUpButton.addTarget(self, action: #selector(signUpTapped(_:)), for: .touchUpInside)
        self.forgotPassword.addTarget(self, action: #selector(forgotPasswordTapped(_:)), for: .touchUpInside)
        self.secureLoginButton.addTarget(self, action: #selector(secureLoginTapped(_:)), for: .touchUpInside)
        self.loginWithOTPButton.addTarget(self, action: #selector(loginWithOtpTapped(_:)), for: .touchUpInside)
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreName.font = AppFonts.sansProRegular.withSize(14)
        self.mutelCoreName.textColor = UIColor.grayLabelColor
        
    }
    
    fileprivate func secureLoginButtonTapped(){
        
        guard let emailAndMobile = signInDictionary[email] as? String, !emailAndMobile.isEmpty else{
            
            showToastMessage(AppMessages.emptyEmailAndMobileNumber.rawValue)
            
            return
        }
        
        guard emailAndMobile.checkValidity(with: .Email) || emailAndMobile.checkValidity(with: .MobileNumber) else{
            
            showToastMessage(AppMessages.validEmailOrMobile.rawValue)
            
            return
        }
        guard let password = signInDictionary[password] as? String, !password.isEmpty else{
            
            showToastMessage(AppMessages.emptyPassword.rawValue)
            
            return
        }
        guard password.characters.count > 5 else{
            
            showToastMessage(AppMessages.passwordMoreThanSixChar.rawValue)
            
            return
        }
        
        //        MARK:- HIT Login Service
        //        =========================
        
        printlnDebug("Dic : \(signInDictionary)")
        
        WebServices.login(parameters: signInDictionary, success: { [unowned self](userInfo, hospInfo) in
            
            
            if userInfo.mobileVerified == 0 {
                
                let otpVerificationScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                otpVerificationScene.phoneNumberDic[mobile_number] = userInfo.patientMobileNumber
                otpVerificationScene.phoneNumberDic[id] = userInfo.patientID
                otpVerificationScene.userInfo = userInfo
                otpVerificationScene.hospitalAddressInfoModel = hospInfo
                otpVerificationScene.procceedToScreenThrough = .signInWithOTP
                self.navigationController?.pushViewController(otpVerificationScene, animated: true)
                
            }else  {
                
                let userProfileScene = BuildProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                self.navigationController?.pushViewController(userProfileScene, animated: true)
                
                userProfileScene.userInfo = userInfo
                
                userProfileScene.hospitalAddressInfoModel = hospInfo

                for addr in hospInfo{
                    
                    userProfileScene.hospAddr = addr.hospitalAddress
                    
                }
            }
            
        }) { (error) in
            
            //                MARK:- Show toast message
            showToastMessage(error.localizedDescription)
            
        }
    }
}
