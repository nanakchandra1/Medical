//
//  SignInVC.swift
//  Mutelcor
//
//  Created by on 03/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import TTTAttributedLabel
import TransitionButton

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
    @IBOutlet weak var secureLoginButton: TransitionButton!
    @IBOutlet weak var secureLoginButtonContainerView: UIView!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsAndConditionText: TTTAttributedLabel!
    
    
    @IBOutlet weak var mutelCoreName: UILabel!
    
    //MARK:- ViewController life cycle
    //===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.floatBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
            detailsCell.detailsTextField.keyboardType = .alphabet
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.returnKeyType = .done
        default:
            fatalError("Cell Not Found!")
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
        guard let cell = self.signInDetailsTableView.cellForRow(at: indexpath) as? DetailsCell else{
            return true
        }
        
        switch indexpath.row{
            
        case 0:
            let loginType: String = (textField.text?.checkValidity(with: .MobileNumber))! ? LoginType.mobileNumber.rawValue : LoginType.email.rawValue
            signInDictionary[DictionaryKeys.loginType] = loginType

        delay(0.1, closure: {
            self.signInDictionary[DictionaryKeys.emailMobile] = cell.detailsTextField.text ?? ""
        })
            
        case 1:
            
            delay(0.1, closure: {
                self.signInDictionary[DictionaryKeys.password] = cell.detailsTextField.text ?? ""
            })
            
        default: return true
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        let indexpath = textField.tableViewIndexPathIn(self.signInDetailsTableView)!
        let nextIndexpath = IndexPath(row: indexpath.row + 1, section: 0)
        
        switch indexpath.row{
        case 0:
            guard let cell = self.signInDetailsTableView.cellForRow(at: nextIndexpath) as? DetailsCell else {
                return true
            }
            cell.detailsTextField.becomeFirstResponder()
        case 1:
            guard let cell = self.signInDetailsTableView.cellForRow(at: indexpath) as? DetailsCell else {
                return true
            }
            cell.detailsTextField.resignFirstResponder()
            self.secureLoginButton.startAnimation()
            self.secureLoginButtonTapped()
        default: return true
        }
        return true
    }
}

//MARK:- IBActions
//================
extension SignInVC {
    
    //signUpTapped
    @objc func signUpTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let signUpScene = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signUpScene, animated: true)
    }
    
    //forgotPasswordTapped
    @objc func forgotPasswordTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let forgotPasswordScene = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(forgotPasswordScene, animated: true)
    }
    
    //secureLoginTapped
    @objc func secureLoginTapped(_ sender: TransitionButton){
        self.view.endEditing(true)
        guard self.isDataValid else{
            return
        }
        sender.startAnimation()
        self.secureLoginButtonTapped()
    }
    
    @objc func loginWithOtpTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let signInWithOtpPage = SignInWithOTPVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signInWithOtpPage, animated: true)
    }
}

//MARK:- Methods
//==============
extension SignInVC {
    
    fileprivate func setupUI(){
        
        //nib registery for signInDetailsTableView
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.signInDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        //setting up delegates and datasource
        self.signInDetailsTableView.delegate = self
        self.signInDetailsTableView.dataSource = self
        
        self.screenQuotation.text = K_SCREEN_TAG.localized
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
       // self.secureLoginButton.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.secureLoginButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.secureLoginButton.clipsToBounds = false
        
        self.secureLoginButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.secureLoginButton.setTitle(K_SECURE_LOGIN.localized, for: .normal)
        
        self.secureLoginButton.titleLabel?.font  = AppFonts.sanProSemiBold.withSize(16)
        
        self.signUpButton.setTitleColor(UIColor.appColor, for: .normal)
        self.signUpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.forgotPassword.titleLabel?.textColor = UIColor.grayLabelColor
        self.forgotPassword.titleLabel?.font = AppFonts.sansProRegular.withSize(13)
        
        self.loginWithOTPButton.titleLabel?.textColor = UIColor.grayLabelColor
        self.loginWithOTPButton.titleLabel?.font = AppFonts.sansProRegular.withSize(13)
        self.termsAndConditionText.delegate = self
        self.termsAndConditionText.font = AppFonts.sansProRegular.withSize(13)
        self.termsAndConditionText.textColor = UIColor.grayLabelColor
        
        //adding targets to buttons
        self.signUpButton.addTarget(self, action: #selector(signUpTapped(_:)), for: .touchUpInside)
        self.forgotPassword.addTarget(self, action: #selector(forgotPasswordTapped(_:)), for: .touchUpInside)
        self.secureLoginButton.addTarget(self, action: #selector(secureLoginTapped(_:)), for: .touchUpInside)
        self.loginWithOTPButton.addTarget(self, action: #selector(loginWithOtpTapped(_:)), for: .touchUpInside)
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreName.font = AppFonts.sansProRegular.withSize(14)
        self.mutelCoreName.textColor = UIColor.grayLabelColor
        var text1 = K_BY_LOGGIN_IN.localized
        let text2 = K_TERMS_AND_CONDITION_TITLE.localized
        let text3 = K_THAT_YOU_HAVE.localized
        let text4 = K_PRIVACY_POLICY.localized
        
        self.termsAndConditionText.text = K_TERMS_AND_CONDITION.localized
        self.termsAndConditionText.linkAttributes = [NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(14),
                                     NSAttributedStringKey.foregroundColor: UIColor.linkLabelColor,
                                     NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let location1 = text1.count
        text1 = text1 + text2 + text3
        let location2 = text1.count
        
        let range1 = NSRange.init(location: location1, length: text2.count)
        let range2 = NSRange.init(location: location2, length: text4.count)
        self.termsAndConditionText.addLink(to: URL.init(string: WebServices.EndPoint.termsCondition.url), with: range1)
        self.termsAndConditionText.addLink(to: URL.init(string: WebServices.EndPoint.privacyPolicy.url), with: range2)
    }
    
    fileprivate func secureLoginButtonTapped(){

        //        MARK:- HIT Login Service
        //        =========================
        signInDictionary[DictionaryKeys.deviceToken] = AppUserDefaults.value(forKey: .deviceToken).stringValue
        signInDictionary[DictionaryKeys.deviceType] = true.rawValue
        //printlnDebug("Dic : \(signInDictionary)")
        WebServices.login(parameters: signInDictionary, success: {[weak self](userInfo) in
            guard let loginVC = self else{
                return
            }
            loginVC.secureLoginButton.stopAnimation(animationStyle: .normal, completion: {

                guard let nvc = loginVC.navigationController else {
                    return
                }
                
                if userInfo.mobileVerified == 0 {
                    let otpVerificationScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                    otpVerificationScene.phoneNumberDic[DictionaryKeys.patientMobileNumber] = userInfo.patientMobileNumber
                    otpVerificationScene.phoneNumberDic[DictionaryKeys.cmsId] = userInfo.patientID
                    otpVerificationScene.userInfo = userInfo
                    otpVerificationScene.procceedToScreenThrough = .signInWithOTP
                    nvc.pushViewController(otpVerificationScene, animated: true)
                }else {
                    AppDelegate.shared.goToHome()
                }
            })
        }) {(error) in
            self.secureLoginButton.stopAnimation()
            showToastMessage(error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
    }
}

//MARk- TTTAttributedLabelDelegate Methods
//========================================
extension SignInVC: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.openWebViewVC = .termsAndCondition
        webViewScene.webViewUrl = url.absoluteString
        webViewScene.screenName = url.absoluteString.uppercased().contains("Privacy".uppercased()) ? K_PRIVACY_POLICY.localized : K_TERMS_AND_CONDITION_TITLE.localized
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}

//MARK:- Validation
//================
extension SignInVC {
    
    var isDataValid: Bool {
        
        guard let emailAndMobile = signInDictionary[DictionaryKeys.emailMobile] as? String, !emailAndMobile.isEmpty else{
            showToastMessage(AppMessages.emptyEmailAndMobileNumber.rawValue.localized)
            return false
        }
        
        guard emailAndMobile.checkValidity(with: .Email) || emailAndMobile.checkValidity(with: .MobileNumber) else{
            showToastMessage(AppMessages.validEmailOrMobile.rawValue.localized)
            return false
        }
        guard let password = signInDictionary[DictionaryKeys.password] as? String, !password.isEmpty else{
            showToastMessage(AppMessages.emptyPassword.rawValue.localized)
            return false
        }
        guard password.count > 5 else{
            showToastMessage(AppMessages.passwordMoreThanSixChar.rawValue.localized)
            return false
        }
        return true
    }
}

