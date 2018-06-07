//
//  ForgotPasswordVC.swift
//  Mutelcor
//
//  Created by on 07/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class ForgotPasswordVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    var forgotPasswordDic = [String : Any]()
    
    //    MARK:- Outlets
    //    ==============
    @IBOutlet weak var forgotPasswordDetailsTableView: UITableView!
    @IBOutlet weak var submitButton: TransitionButton!
    @IBOutlet weak var screenTitleView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var mutelCoreNameLabel: UILabel!
    @IBOutlet weak var emailBtnOutlt: UIButton!
    @IBOutlet weak var mobileBtnOutlt: UIButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupSubViews
        self.setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .login
        self.setNavigationBar(screenTitle: K_FORGOTPASSWORD_SCREEN_TITLE.localized)
        self.floatBtn.isHidden = true
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.submitButton.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.screenTitleView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
}

//MARK: Private Functions
extension ForgotPasswordVC {
    
    fileprivate func setupUi(){
        
        self.forgotPasswordDic[DictionaryKeys.country_code] = "+91"
        self.submitButton.layer.cornerRadius = 2.2
        self.submitButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.submitButton.clipsToBounds = false
        self.emailBtnOutlt.layer.cornerRadius = 2.2
        self.emailBtnOutlt.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.mobileBtnOutlt.layer.cornerRadius = 2.2
        self.mobileBtnOutlt.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.emailBtnOutlt.backgroundColor = UIColor.appColor
        self.mobileBtnOutlt.backgroundColor = UIColor.gray
        
        //nib registery for forgotPasswordDetailsTableView
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.forgotPasswordDetailsTableView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        let phoneDetailsCellNib = UINib(nibName: "PhoneDetailsCell", bundle: nil)
        self.forgotPasswordDetailsTableView.register(phoneDetailsCellNib, forCellReuseIdentifier: "PhoneDetailsCellID")
        
        //setting up delegate and datasource
        self.forgotPasswordDetailsTableView.delegate = self
        self.forgotPasswordDetailsTableView.dataSource = self
        
        //adding target to buttons
        self.submitButton.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        self.submitButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.screenTitleLabel.font = AppFonts.sansProRegular.withSize(14)
        self.screenTitleLabel.text = K_FORGOTPASSWORD_SCREEN_LABEL.localized
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreNameLabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNameLabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNameLabel.font = AppFonts.sansProRegular.withSize(14)
        
        self.emailBtnOutlt.isSelected = true
        self.emailBtnOutlt.setTitle(K_EMAIL_ADDRESS_PLACEHOLDER.localized.uppercased(), for: .normal)
        self.mobileBtnOutlt.setTitle(K_MOBILE_NUMBER_PLACEHOLDER.localized.uppercased(), for: .normal)
        self.emailBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.mobileBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.emailBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.mobileBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.emailBtnOutlt.addTarget(self, action: #selector(self.emailBtnTapped(sender:)), for: .touchUpInside)
        self.mobileBtnOutlt.addTarget(self, action: #selector(self.mobileBtnTapped(sender:)), for: .touchUpInside)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ForgotPasswordVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if self.emailBtnOutlt.isSelected {
            
            guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for: indexPath) as? DetailsCell else{ fatalError("Cell Not Found")
            }
            
            detailsCell.populateForgotPasswordData()
            detailsCell.detailsTextField.delegate = self
            
            return detailsCell
        }else{
            guard let phoneDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PhoneDetailsCellID", for: indexPath) as? PhoneDetailsCell else{
                fatalError("Cell Not Found")
            }
            
            phoneDetailsCell.cellTitle.text = K_MOBILE_NUMBER_PLACEHOLDER.localized
            phoneDetailsCell.countryCodeTextField.font = AppFonts.sanProSemiBold.withSize(13)
            
            phoneDetailsCell.countryCodeTextField.delegate = self
            phoneDetailsCell.phoneNumberTextField.delegate = self
            phoneDetailsCell.countryCodeTextField.placeholder = K_COUNTRY_CODE_PLACEHOLDER.localized
            phoneDetailsCell.phoneNumberTextField.placeholder = K_MOBILE_NUMBER_PLACEHOLDER.localized

            phoneDetailsCell.countryCodeBtn.addTarget(self, action: #selector(self.countryCodeBtnTapped), for: .touchUpInside)
            
            phoneDetailsCell.countryCodeTextField.text = self.forgotPasswordDic[DictionaryKeys.country_code] as? String ?? ""
            phoneDetailsCell.phoneNumberTextField.text = self.forgotPasswordDic[DictionaryKeys.patientMobileNumber] as? String ?? ""
            phoneDetailsCell.phoneNumberTextField.keyboardType = .numberPad
            return phoneDetailsCell
        }
    }
}

//MARK:- TextField Delegates
//==========================

extension ForgotPasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.emailBtnOutlt.isSelected {
            guard let cell = textField.getTableViewCell as? DetailsCell else {
                return true
            }
            self.forgotPasswordDic[DictionaryKeys.patientMobileNumber] = ""
            self.forgotPasswordDic[DictionaryKeys.type] = LoginType.email.rawValue
            delay(0.1) {
                self.forgotPasswordDic[DictionaryKeys.emailID] = cell.detailsTextField.text ?? ""
            }
            
        }else{
            
            guard let cell = textField.getTableViewCell as? PhoneDetailsCell else {
                return true
            }
            self.forgotPasswordDic[DictionaryKeys.type] = LoginType.mobileNumber.rawValue
            self.forgotPasswordDic[DictionaryKeys.emailID] = ""
            delay(0.1) {
                self.forgotPasswordDic[DictionaryKeys.patientMobileNumber] = cell.phoneNumberTextField.text ?? ""
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.submitButtonTapped()
        return true
    }
}

//MARK:- IBActions
//=================
extension ForgotPasswordVC{
    
    //submitTapped
    @objc func submitTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
       self.submitButtonTapped()
    }
    
    fileprivate func submitButtonTapped(){
        let isVerified =  self.checkValidations(isEmailSelected: self.emailBtnOutlt.isSelected)
        guard isVerified else{
            return
        }
        self.submitButton.startAnimation()
        //printlnDebug("params : \(self.forgotPasswordDic)")
        WebServices.forgotPassword(parameters: forgotPasswordDic, success: {[weak self](_ str : String) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.submitButton.stopAnimation(animationStyle: .normal, completion: {
                let confirmationScene = PatientIDPopUpVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                confirmationScene.forgotPasswordDic = strongSelf.forgotPasswordDic
                confirmationScene.proceedToScreen = .forgotPasswordVC
                AppDelegate.shared.window?.addSubview(confirmationScene.view)
                strongSelf.addChildViewController(confirmationScene)
            })
        }) { (error) in
            self.submitButton.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func checkValidations(isEmailSelected: Bool) -> Bool{
        
        if let email = forgotPasswordDic[DictionaryKeys.emailID] as? String, !email.isEmpty {
            guard email.checkValidity(with: .Email) else{
                showToastMessage(AppMessages.validEmail.rawValue.localized)
                return false
            }
            return true
        }else if let mobileNumber = forgotPasswordDic[DictionaryKeys.patientMobileNumber] as? String, !mobileNumber.isEmpty {
            guard mobileNumber.checkValidity(with: .MobileNumber) else{
                showToastMessage(AppMessages.validMobilNumber.rawValue.localized)
                return false
            }
            return true
        }else{
            let message = isEmailSelected ? AppMessages.emptyEmail.rawValue : AppMessages.emptyMobileNumber.rawValue
            showToastMessage(message.localized)
            return false
        }
    }
    
    @objc fileprivate func countryCodeBtnTapped(){
        
        self.view.endEditing(true)
        
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .Main)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }

    @objc func emailBtnTapped(sender: UIButton){
        guard !sender.isSelected else{
            return
        }
        sender.isSelected = !sender.isSelected
        let color = sender.isSelected ? UIColor.appColor : UIColor.gray
        sender.backgroundColor = color
        self.mobileBtnOutlt.backgroundColor = UIColor.gray
        self.mobileBtnOutlt.isSelected = false
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.forgotPasswordDetailsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    @objc func mobileBtnTapped(sender: UIButton){
        guard !sender.isSelected else{
            return
        }
        sender.isSelected = !sender.isSelected
        let color = sender.isSelected ? UIColor.appColor : UIColor.gray
        sender.backgroundColor = color
        self.emailBtnOutlt.backgroundColor = UIColor.gray
        self.emailBtnOutlt.isSelected = false
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.forgotPasswordDetailsTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//MARK:- Protocol
extension ForgotPasswordVC: CountryCodeDelegate {
    
    func setCountry(_ country: CountryCode) {
        if !self.emailBtnOutlt.isSelected {
            self.forgotPasswordDic[DictionaryKeys.country_code] = country.countryCode
            let indexPath = IndexPath(row: 0, section: 0)
            self.forgotPasswordDetailsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
