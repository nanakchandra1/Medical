//
//  SignInWithOTPVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInWithOTPVC: BaseViewController {
    
//    MARK:- Proporties
//    =================
    var phoneNumberDic = [String : Any]()
    let countryCodeDic = [String : Any]()
    
    var countryCodeArray : [Any]!
    
    //    MARK:- IBOutlets
    //    =================
//    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var phoneDetailsTableView: UITableView!
    @IBOutlet weak var screenQuotation: UILabel!
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var mutelCoreNamelabel: UILabel!
    
    //MARK:- ViewController life cycle
    //    =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:setup sub views
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
     
        self.setNavigationBar(K_SIGN_WITH_OTP.localized, 0, 0)
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
        
        guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{ fatalError("Cell Not Found")
        }
        
        phoneDetailsCell.countryCodeTextField.delegate = self
        phoneDetailsCell.phoneNumberTextField.delegate = self
        phoneDetailsCell.countryCodeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
        
        if let countryCode = self.phoneNumberDic[country_code] as? String, !countryCode.isEmpty {
            
          phoneDetailsCell.countryCodeTextField.text = countryCode
        }
        phoneDetailsCell.countryCodeTextField.placeholder = "CODE"
        phoneDetailsCell.cellTitle.text = K_MOBILE_NUMBER.localized
        phoneDetailsCell.countryCodeTextField.rightViewMode = .always
        phoneDetailsCell.phoneNumberTextField.keyboardType = .numberPad
        
        return phoneDetailsCell
    }
}

//MARK:- UITextField Delegate Methods
//====================================
extension SignInWithOTPVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let cell = textField.getTableViewCell as? PhoneDetailsCell else {
            return true
        }
        
        delay(0.1) {
            
            if cell.phoneNumberTextField.text?.characters.first == "0" {
                
                cell.phoneNumberTextField.text?.characters.removeFirst()
                
            }
            
            self.phoneNumberDic[mobile_number] = cell.phoneNumberTextField.text ?? ""
            self.phoneNumberDic[type] = loginType.mobileNumber.rawValue
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

        self.sendOtpButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.appLogoImage.image = #imageLiteral(resourceName: "ic_prelogin_login_logo")
        self.screenQuotation.text = K_SCREEN_TAG.localized
        
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
                
        //attributed string for Terms & conditions
        let attributedString = NSMutableAttributedString(string: K_TERMS_AND_CONDITION.localized)
        
        attributedString.addAttribute(NSLinkAttributeName, value: "http://google.com", range: NSRange(location: 32, length: 18))
        attributedString.addAttribute(NSLinkAttributeName, value: "http://facebook.com", range: NSRange(location: 78, length: 15))
        

        
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
        
    }
    
    @objc fileprivate func countryCodeBtnTapped(){
        
        self.view.endEditing(true)
        
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
        
    }
    
    @objc fileprivate func sendOtpTapped(){
        
        self.view.endEditing(true)
        
        guard let _ = self.phoneNumberDic[country_code] as? String else{
            
            showToastMessage(AppMessages.emptyCountryCode.rawValue)
            
            return
        }
        guard let mobileNumber = self.phoneNumberDic[mobile_number] as? String, !mobileNumber.isEmpty else{
            
            showToastMessage(AppMessages.emptyMobileNumber.rawValue)
            
            return
        }

        guard mobileNumber.checkValidity(with: .MobileNumber) else{
            
            showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue)

            return
        }

        WebServices.sendOtp(parameters: phoneNumberDic,
                            success: { [unowned self] ( message : String) in
                                
                                showToastMessage(message)
                                
                                // MARK:- Proceed to enter OTP Screen
                                // ==================================
                                let enterOTPToLoginScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                                self.navigationController?.pushViewController(enterOTPToLoginScene, animated: true)
                                enterOTPToLoginScene.phoneNumberDic = self.phoneNumberDic
                                printlnDebug(self.phoneNumberDic)
                                enterOTPToLoginScene.phoneNumberDic["email_mobile"] = self.phoneNumberDic[mobile_number]
                                enterOTPToLoginScene.phoneNumberDic[login_Type] = loginType.otp.rawValue
                                enterOTPToLoginScene.procceedToScreenThrough = .loginWithOTP
                                
        }) { (error) in

            showToastMessage(error.localizedDescription)
            
        }
    }
}

//MARK:- Protocol 
//================
extension SignInWithOTPVC : CountryCodeDelegate {
    
    func setCountry(_ country: CountryCode) {
        
        self.phoneNumberDic[country_code] = country.countryCode
        self.phoneDetailsTableView.reloadData()
        
    }
}
