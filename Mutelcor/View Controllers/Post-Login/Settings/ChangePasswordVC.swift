//
//  ChangePasswordVC.swift
//  Mutelcor
//
//  Created by on 29/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import TransitionButton

enum ChangePasswordVCFor {
    
    case changePassword
    case changeMobileNumber
    
}

class ChangePasswordVC: BaseViewControllerWithBackButton {
    
//    MARK:- Proporties
//    =================
    fileprivate let changePasswordTitles = [K_OLD_PASSWORD.localized, K_NEW_PASSWORD.localized, K_CONFIRM_NEW_PASSWORD.localized, ""]
    fileprivate let changeMobileNumberTitles = [K_NEW_MOBILE_NUMBER.localized]
    fileprivate var changePasswordDic: [String: Any] = [:]
    fileprivate var changePhoneNumberDic: [String: Any] = [:]
    var proceedToScreenFor: ChangePasswordVCFor = .changePassword
    var screenName: String?
    
//    MARK:- IBOUtlets
//    ================
    @IBOutlet weak var changePasswordTableView: UITableView!
    @IBOutlet weak var changePasswordBtn: TransitionButton!
    
//    MARk:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.isNavigationBarButton = false
        self.addBtnDisplayedFor = .none
        self.floatBtn.isHidden = true
        
        self.screenName = (self.proceedToScreenFor == .changePassword) ? K_CHANGE_PASSWORD_TITLE.localized : K_CHANGE_PHONENUMBER_TITLE.localized
        self.setNavigationBar(screenTitle: self.screenName ?? "")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//    MARK:- IBActions
//    =================
    @IBAction func changePasswordBtnTapped(_ sender: UIButton) {
        if self.proceedToScreenFor == .changePassword {
            self.evaluateChangePassswordFields()
        }else{
            guard let _ = self.changePhoneNumberDic["country_code"] as? String else{
                showToastMessage(AppMessages.emptyCountryCode.rawValue.localized)
                return
            }
            guard let mobileNumber = self.changePhoneNumberDic["mobile_number"] as? String, !mobileNumber.isEmpty else{
                showToastMessage(AppMessages.emptyMobileNumber.rawValue.localized)
                return
            }
            
            guard mobileNumber.checkValidity(with: .MobileNumber) else{
                showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue.localized)
                return
            }
            self.changeMobileNumber()
        }
    }
}
//MARK:- UITableViewDataSource Methods
//====================================
extension ChangePasswordVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let rows = (self.proceedToScreenFor == .changePassword) ? self.changePasswordTitles.count : changeMobileNumberTitles.count
        return rows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
            
        case 0,1,2:
            switch self.proceedToScreenFor {
                
            case .changePassword :
                guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for: indexPath) as? DetailsCell else{
                    fatalError("Cell Not Found")
                }
                detailsCell.cellTitle.text = self.changePasswordTitles[indexPath.row]
                detailsCell.showPasswordButton.isHidden = false
                detailsCell.detailsTextField.delegate = self
                
                if indexPath.row == self.changePasswordTitles.count - 1 {
                    detailsCell.detailsTextField.returnKeyType = .done
                }
                
                return detailsCell
                
            case .changeMobileNumber :
                guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{
                    fatalError("Cell Not Found")
                }
                
                phoneDetailsCell.countryCodeTextField.delegate = self
                phoneDetailsCell.phoneNumberTextField.delegate = self
                phoneDetailsCell.countryCodeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
                phoneDetailsCell.countryCodeTextField.rightViewMode = .always
                phoneDetailsCell.phoneNumberTextField.keyboardType = .numberPad
                phoneDetailsCell.phoneNumberTextField.returnKeyType = .done
                phoneDetailsCell.countryCodeTextField.placeholder = K_COUNTRY_CODE_PLACEHOLDER.localized
                phoneDetailsCell.phoneNumberTextField.placeholder = K_MOBILE_NUMBER_PLACEHOLDER.localized

                
                phoneDetailsCell.cellTitle.text = self.changeMobileNumberTitles[indexPath.row]
                phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
                
                if let countryCode = self.changePhoneNumberDic["country_code"] as? String, !countryCode.isEmpty {
                    phoneDetailsCell.countryCodeTextField.text = countryCode
                }
                
                return phoneDetailsCell
            }
        case 3:
            guard let clickHereCell = tableView.dequeueReusableCell(withIdentifier: "clickHereCellID", for: indexPath) as? ClickHereCell else{
                fatalError("Cell Not Found")
            }
            clickHereCell.clickHereLabel.delegate = self
            clickHereCell.populateData()
            return clickHereCell
        default:
            fatalError("Cell Not Found")
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension ChangePasswordVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

//MARk:- UITextFieldDelegate Methods
//===================================
extension ChangePasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard let indexPath = textField.tableViewIndexPathIn(self.changePasswordTableView) else{
            return true
        }
        
        switch indexPath.row{
            
        case 0:
            delay(0.1, closure: {
                
                if self.proceedToScreenFor == .changePassword {
                    self.changePasswordDic["old_password"] = textField.text ?? ""
                }else{
                   self.changePhoneNumberDic["mobile_number"] = textField.text ?? ""
                }
            })
        case 1:
            delay(0.1, closure: {
                self.changePasswordDic["new_password"] = textField.text ?? ""
            })
        case 2:
            delay(0.1, closure: {
                self.changePasswordDic["confirmPassword"] = textField.text ?? ""
            })
        default:
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.changePasswordTableView) else{
            return true
        }
        let nextIndexPath = IndexPath(row: indexPath.row + 1, column: 0)
        
        switch indexPath.row {
        case 0,1:
            if self.proceedToScreenFor == .changePassword {
                guard let cell = self.changePasswordTableView.cellForRow(at: nextIndexPath) as? DetailsCell else{
                    return true
                }
                cell.detailsTextField.becomeFirstResponder()
            }else{
               textField.resignFirstResponder()
            }
        case 2:
            textField.resignFirstResponder()
        default:
            return true
        }
        return true
    }
}

//MARk- TTTAttributedLabelDelegate Methods
//========================================
extension ChangePasswordVC: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        self.passwordSendonEmail()
    }
}

//MARK:- Methods
//==============
extension ChangePasswordVC {
    
    fileprivate func setupUI(){
        
        self.changePasswordBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
        let btnTitle = (self.proceedToScreenFor == .changePassword) ? K_CHANGE_PASSWORD_TITLE : K_CHANGE_PHONENUMBER_TITLE
        self.changePasswordBtn.setTitle(btnTitle.localized.uppercased(), for: .normal)
        self.changePasswordBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15)
        self.changePasswordBtn.setTitleColor(UIColor.white, for: .normal)
        self.changePasswordTableView.dataSource = self
        self.changePasswordTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.removePopUp), name: .changePassNotification, object: nil)
        self.changePhoneNumberDic["country_code"] = "+91"
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.changePasswordTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        let clickHereCellNib = UINib(nibName: "ClickHereCell", bundle: nil)
        self.changePasswordTableView.register(clickHereCellNib, forCellReuseIdentifier: "clickHereCellID")
        
        let phoneDetailsCellNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        self.changePasswordTableView.register(phoneDetailsCellNib, forCellReuseIdentifier: "PhoneDetailsCellID")
    }
    
    fileprivate func evaluateChangePassswordFields(){
        
        guard let currentPassword = self.changePasswordDic["old_password"] as? String, !currentPassword.isEmpty else{
            showToastMessage(AppMessages.emptyOldPassword.rawValue.localized)
            return
        }
        guard currentPassword.count > 5 else{
            showToastMessage(AppMessages.currentPasswordCharaterLimit.rawValue.localized)
            return
        }
        guard let newPassword = self.changePasswordDic["new_password"] as? String, !newPassword.isEmpty else{
            showToastMessage(AppMessages.emptyNewPassword.rawValue.localized)
            return
        }
        guard newPassword.count > 5 else{
            showToastMessage(AppMessages.newPasswordLimit.rawValue.localized)
            return
        }
        guard let oldPassword = self.changePasswordDic["confirmPassword"] as? String, !oldPassword.isEmpty else{
            showToastMessage(AppMessages.emptyConfirmPassword.rawValue.localized)
            return
        }
        guard oldPassword.count > 5 else{
            showToastMessage(AppMessages.confirmPasswordLimit.rawValue.localized)
            return
        }
        guard newPassword == oldPassword else{
            showToastMessage(AppMessages.differentPassword.rawValue.localized)
            return
        }
        self.changePassword()
    }
    
    fileprivate func passwordSendonEmail(){
        
        var param = [String: Any]()
        param["type"] = false.rawValue
        param["email_id"] = AppUserDefaults.value(forKey: .email).stringValue
        WebServices.forgotPassword(parameters: param, success: { (_ messsage : String) in
            self.openPopupView(changePassState: .email)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func openPopupView( _ msg : String = "", changePassState: OpenTheConfirmationVCForChangePass){
        let confirmationScene = ConfirmationVC.instantiate(fromAppStoryboard: .AppointMent)
        let confirmationVCFor: OpenTheConfirmationVCFor = (self.proceedToScreenFor == .changePassword) ? .changePassword : .changeMobileNumber
        confirmationScene.openConfirmVCFor = confirmationVCFor
        confirmationScene.openConfirmVCForChangePass = changePassState
        confirmationScene.changePassMsg = msg
        if !self.view.subviews.contains(confirmationScene.view){
            confirmationScene.addAppointmentDic = self.changePhoneNumberDic
            AppDelegate.shared.window?.addSubview(confirmationScene.view)
            self.addChildViewController(confirmationScene)
        }
    }
    
    @objc fileprivate func countryCodeBtnTapped(){
        self.view.endEditing(true)
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
}

//MARK:- WebServices
//==================
extension ChangePasswordVC {
    
    fileprivate func changePassword(){
        
        self.changePasswordDic["id"] = AppUserDefaults.value(forKey: .userId).stringValue
        self.changePasswordBtn.startAnimation()
        WebServices.changePassword(parameters: self.changePasswordDic, success: {[weak self] (_ response: String) in
            //showToastMessage(response)
            guard let changePasswordVC = self else{
                return
            }
            changePasswordVC.changePasswordBtn.stopAnimation(animationStyle: .normal, completion: {
                changePasswordVC.openPopupView(response,changePassState: .mobile)
               
            })
        }) {[weak self] (error) in
            guard let changePasswordVC = self else{
                return
            }
            changePasswordVC.changePasswordBtn.stopAnimation(animationStyle: .normal, completion: {
                showToastMessage(error.localizedDescription)
            })
        }
    }
    
    fileprivate func changeMobileNumber(){
        self.changePasswordBtn.startAnimation()
        WebServices.changeMobileNumberOtp(parameters: self.changePhoneNumberDic, success: {[weak self] (_ response: String) in
            guard let changePasswordVC = self else{
                return
            }
            changePasswordVC.changePasswordBtn.stopAnimation(animationStyle: .normal,completion: {
                changePasswordVC.openPopupView(changePassState: .none)
            })
        }) { (error) in
            self.changePasswordBtn.stopAnimation(animationStyle: .normal, completion: {
                showToastMessage(error.localizedDescription)
            })
        }
    }
    
    @objc fileprivate func removePopUp(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- Protocol
//================
extension ChangePasswordVC : CountryCodeDelegate {
    func setCountry(_ country: CountryCode) {
        self.changePhoneNumberDic["country_code"] = country.countryCode
        self.changePasswordTableView.reloadData()
    }
}
