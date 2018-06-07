//
//  SignInWithOTPVC.swift
//  Mutelcor
//
//  Created by on 08/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import TTTAttributedLabel
import TransitionButton

class SignInWithOTPVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var phoneNumberDic = [String : Any]()
    let countryCodeDic = [String : Any]()
    
    var countryCodeArray : [Any]!
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var sendOtpButton: TransitionButton!
    @IBOutlet weak var phoneDetailsTableView: UITableView!
    @IBOutlet weak var screenQuotation: UILabel!
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var mutelCoreNamelabel: UILabel!
    @IBOutlet weak var termsAndConditionText: TTTAttributedLabel!
    
    //MARK:- ViewController life cycle
    //=================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:setup sub views
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = NavigationControllerOn.login
        self.sideMenuBtnActn = .backBtn
        self.setNavigationBar(screenTitle: K_SIGN_WITH_OTP.localized)
        self.floatBtn.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.sendOtpButton.gradient(withX: 0, withY: 0, cornerRadius: true)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
//=================================================
extension SignInWithOTPVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{
            fatalError("Cell Not Found")
        }
        
        phoneDetailsCell.countryCodeTextField.delegate = self
        phoneDetailsCell.phoneNumberTextField.delegate = self
        
        phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
        
        if let countryCode = self.phoneNumberDic[DictionaryKeys.country_code] as? String, !countryCode.isEmpty {
            phoneDetailsCell.countryCodeTextField.text = countryCode
        }
        phoneDetailsCell.countryCodeTextField.placeholder = K_COUNTRY_CODE_PLACEHOLDER.localized
        phoneDetailsCell.cellTitle.text = K_MOBILE_NUMBER.localized
        phoneDetailsCell.countryCodeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        phoneDetailsCell.countryCodeTextField.rightViewMode = .always
        phoneDetailsCell.phoneNumberTextField.keyboardType = .numberPad
        
        return phoneDetailsCell
    }
}

//MARK:- UITextField Delegate Methods
//====================================
extension SignInWithOTPVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendOtpTapped()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let cell = textField.getTableViewCell as? PhoneDetailsCell else {
            return true
        }
        
        delay(0.1) {
            if cell.phoneNumberTextField.text?.first == "0" {
                cell.phoneNumberTextField.text?.removeFirst()
            }
            
            self.phoneNumberDic[DictionaryKeys.patientMobileNumber] = cell.phoneNumberTextField.text ?? ""
            self.phoneNumberDic[DictionaryKeys.type] = LoginType.mobileNumber.rawValue
        }
        
        return true
    }
}


//MARK: UITextViewDelegate
extension SignInWithOTPVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        //        UIApplication.shared.open(URL, options: [:])
        return true
    }
}

//MARK: Private functions
//=======================
extension SignInWithOTPVC{
    
    fileprivate func setupUI(){
        
        self.sendOtpButton.layer.cornerRadius = 2.2
        self.sendOtpButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.sendOtpButton.clipsToBounds = false
        self.sendOtpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.appLogoImage.image = #imageLiteral(resourceName: "ic_login_module_logo")
        self.screenQuotation.text = K_SCREEN_TAG.localized
        
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
        
        let phoneDetailsCellNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        phoneDetailsTableView.register(phoneDetailsCellNib, forCellReuseIdentifier: "PhoneDetailsCellID")
        
        phoneDetailsTableView.delegate = self
        phoneDetailsTableView.dataSource = self
        
        //adding target to buttons
        self.sendOtpButton.addTarget(self, action: #selector(sendOtpTapped), for: .touchUpInside)
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreNamelabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNamelabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNamelabel.font = AppFonts.sansProRegular.withSize(13)
        
        self.termsAndConditionText.delegate = self
        self.termsAndConditionText.font = AppFonts.sansProRegular.withSize(13)
        self.termsAndConditionText.textColor = UIColor.grayLabelColor
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
    
    @objc fileprivate func countryCodeBtnTapped(){
        
        self.view.endEditing(true)
        
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
    
    @objc fileprivate func sendOtpTapped(){
        
        self.view.endEditing(true)
        
        guard let _ = self.phoneNumberDic[DictionaryKeys.country_code] as? String else{
            showToastMessage(AppMessages.emptyCountryCode.rawValue.localized)
            return
        }
        guard let mobileNumber = self.phoneNumberDic[DictionaryKeys.patientMobileNumber] as? String, !mobileNumber.isEmpty else{
            showToastMessage(AppMessages.emptyMobileNumber.rawValue.localized)
            return
        }
        
        guard mobileNumber.checkValidity(with: .MobileNumber) else{
            showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue.localized)
            return
        }
        self.sendOtpButton.startAnimation()
        WebServices.sendOtp(parameters: phoneNumberDic,
                            success: { [weak self] ( message : String) in
                                
                                guard let signInWithOtpVC = self else{
                                    return
                                }
                                signInWithOtpVC.sendOtpButton.stopAnimation(animationStyle: .normal, completion: {
                                    showToastMessage(message)
                                    
                                    // MARK:- Proceed to enter OTP Screen
                                    // ==================================
                                    let enterOTPToLoginScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                                    signInWithOtpVC.navigationController?.pushViewController(enterOTPToLoginScene, animated: true)
                                    enterOTPToLoginScene.phoneNumberDic = signInWithOtpVC.phoneNumberDic
                                    //printlnDebug(signInWithOtpVC.phoneNumberDic)
                                    enterOTPToLoginScene.phoneNumberDic[DictionaryKeys.emailMobile] = signInWithOtpVC.phoneNumberDic[DictionaryKeys.country_code]
                                    enterOTPToLoginScene.phoneNumberDic[DictionaryKeys.loginType] = LoginType.otp.rawValue
                                    enterOTPToLoginScene.procceedToScreenThrough = .loginWithOTP
                                })
        }) { (error) in
            self.sendOtpButton.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- Protocol 
//================
extension SignInWithOTPVC : CountryCodeDelegate {
    
    func setCountry(_ country: CountryCode) {
        self.phoneNumberDic[DictionaryKeys.country_code] = country.countryCode
        self.phoneDetailsTableView.reloadData()
    }
}

//MARk- TTTAttributedLabelDelegate Methods
//========================================
extension SignInWithOTPVC: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.openWebViewVC = .termsAndCondition
        webViewScene.webViewUrl = url.absoluteString
        webViewScene.screenName = url.absoluteString.uppercased().contains("Privacy".uppercased()) ? K_PRIVACY_POLICY.localized : K_TERMS_AND_CONDITION_TITLE.localized
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}
