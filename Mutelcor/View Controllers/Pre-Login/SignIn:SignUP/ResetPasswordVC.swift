//
//  ResetPasswordVC.swift
//  Mutelcor
//
//  Created by on 08/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class ResetPasswordVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    let passwordFieldArray = [K_PASSWORD.localized, CONFIRM_PASSWORD.localized]
    var resetPasswordDic = [String : Any]()
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var resetPasswordDetailsTabelView: UITableView!
    @IBOutlet weak var resetPasswordButton: TransitionButton!
    @IBOutlet var otpTextFields: [UITextField]!
    @IBOutlet weak var resendCodeOtpLabel: UILabel!
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
        self.setNavigationBar(screenTitle: K_RESET_PASSWORD.localized)
        self.floatBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.resetPasswordButton.gradient(withX: 0, withY: 0, cornerRadius: true)
    }
}

//MARK: Private Functions
extension ResetPasswordVC {
    
    fileprivate func setupUI(){
        
        self.resetPasswordButton.layer.cornerRadius = 2.2
        self.resetPasswordButton.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        
        self.resendCodeOtpLabel.font = AppFonts.sansProRegular.withSize(14)
        self.resendCodeOtpLabel.textColor = UIColor.grayLabelColor
        
        self.resetPasswordButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        self.resetPasswordButton.setTitle(K_RESET_PASSWORD.localized, for: .normal)
        
        //nib registery for resetPasswordDetailsTabelView
        let detailsCellNib = UINib(nibName: "DetailsCell", bundle: nil)
        self.resetPasswordDetailsTabelView.register(detailsCellNib, forCellReuseIdentifier: "DetailsCellID")
        
        //setting up delegate and datasource
        self.resetPasswordDetailsTabelView.delegate = self
        self.resetPasswordDetailsTabelView.dataSource = self
        
        //formatting otp textfields
        
        for textfield in self.otpTextFields {
            
            textfield.layer.cornerRadius = 4
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.appColor.cgColor
            textfield.textColor = UIColor.appColor
            textfield.font = AppFonts.sanProSemiBold.withSize(13)
            textfield.delegate = self
            textfield.text = "\u{200B}"
        }
        
        //adding target to buttons
        self.resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped(_:)),for: .touchUpInside)
        
        self.floatBtn.isHidden = true
        
        self.mutelCoreNameLabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNameLabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNameLabel.font = AppFonts.sansProRegular.withSize(13)
        
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
//================================================
extension ResetPasswordVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return passwordFieldArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCellID", for: indexPath) as? DetailsCell else{fatalError("Cell Not Found !")}
        
        detailsCell.cellTitle.text = passwordFieldArray[indexPath.row]
        detailsCell.detailsTextField.delegate = self
        
        switch indexPath.row {
            
        case 0:
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.returnKeyType = .next
            detailsCell.showPasswordButton.isSelected = false
            
        case 1:
            detailsCell.showPasswordButton.isHidden = false
            detailsCell.detailsTextField.isSecureTextEntry = true
            detailsCell.detailsTextField.returnKeyType = .done
            detailsCell.showPasswordButton.isSelected = false
            
        default: fatalError("Cell Not Found !")
            
        }
        return detailsCell
    }
}

//MARK:- UITextField Deleagtes
//==========================
extension ResetPasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.otpTextFields.contains(textField){
            
            if (textField == self.otpTextFields[0]) {
                if (range.length == 0) {
                    textField.text = string
                    self.otpTextFields[1].becomeFirstResponder()
                } else {
                    textField.text = "\u{200B}"
                }
            } else if (textField == self.otpTextFields[1]) {
                if (range.length == 0) {
                    textField.text = string
                    self.otpTextFields[2].becomeFirstResponder()
                } else {
                    textField.text = "\u{200B}"
                    self.otpTextFields[0].becomeFirstResponder()
                }
            } else if (textField == self.otpTextFields[2]) {
                if (range.length == 0) {
                    textField.text = string
                    self.otpTextFields[3].becomeFirstResponder()
                } else {
                    textField.text = "\u{200B}"
                    self.otpTextFields[1].becomeFirstResponder()
                }
            } else if (textField == self.otpTextFields[3]) {
                if (range.length == 0) {
                    textField.text = string
                    self.otpTextFields[4].becomeFirstResponder()
                } else {
                    textField.text = "\u{200B}"
                    self.otpTextFields[2].becomeFirstResponder()
                }
            } else if (textField == self.otpTextFields[4]) {
                if (range.length == 0) {
                    textField.text = string
                    self.otpTextFields[5].becomeFirstResponder()
                } else {
                    textField.text = "\u{200B}"
                    self.otpTextFields[3].becomeFirstResponder()
                }
            } else if (textField == self.otpTextFields[5]) {
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
        
        guard let indexPath = textField.tableViewIndexPathIn(self.resetPasswordDetailsTabelView) else{
            
            return false
        }
        guard let cell  = textField.getTableViewCell as? DetailsCell else{
            
            return true
        }
        
        if indexPath.row == 0{
            
            delay(0.1, closure: {
                self.resetPasswordDic[DictionaryKeys.newPassword] = cell.detailsTextField.text ?? ""
            })
            
        }else{
            
            delay(0.1, closure: {
                self.resetPasswordDic[DictionaryKeys.oldPassword] = cell.detailsTextField.text ?? ""
            })
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let indexPath = textField.tableViewIndexPathIn(self.resetPasswordDetailsTabelView)!
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        
        switch indexPath.row{
            
        case 0 : guard let cell  = self.resetPasswordDetailsTabelView.cellForRow(at: nextIndexPath) as? DetailsCell else{
            
            return true
        }
        cell.detailsTextField.becomeFirstResponder()
            
        case 1: guard let cell  = self.resetPasswordDetailsTabelView.cellForRow(at: indexPath) as? DetailsCell else{
            
            return true
        }
        cell.detailsTextField.resignFirstResponder()
            
        default: fatalError("DetailCell Not Found")
        }
        return true
    }
}

//MARK:- IBActions
//================
extension ResetPasswordVC{
    
    @objc func resetPasswordTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        var otpText = ""
        
        for otp in otpTextFields {
            guard let text = otp.text else { return }
            otpText = otpText + text
        }
        //printlnDebug(otpText)
        self.resetPasswordDic[DictionaryKeys.otp] = otpText
        
        guard let otp = self.resetPasswordDic[DictionaryKeys.otp] as? String, !otp.isEmpty else {
            showToastMessage(AppMessages.otpFieldEmpty.rawValue.localized)
            return
        }
        
        guard otp.count == 6 else{
            
            showToastMessage(AppMessages.otpLessThansixDigit.rawValue.localized)
            
            return
        }
        
        guard let password = self.resetPasswordDic[DictionaryKeys.newPassword] as? String, !password.isEmpty else {
            showToastMessage(AppMessages.emptyPassword.rawValue.localized)
            return
        }
        
        guard password.count > 6 else {
            showToastMessage(AppMessages.passwordMoreThanSixChar.rawValue.localized)
            return
        }
        guard let changePassword = self.resetPasswordDic[DictionaryKeys.oldPassword] as? String, !changePassword.isEmpty else {
            showToastMessage(AppMessages.otpFieldEmpty.rawValue.localized)
            return
        }
        
        guard changePassword == password else {
            showToastMessage(AppMessages.passAndConfirmPassMismatched.rawValue.localized)            
            return
        }
        self.resetPasswordButton.startAnimation()
        WebServices.resetPassword(parameters: resetPasswordDic,
                                  success: {[weak self] (userInfo : UserInfo) in
                                    
                                    guard let resetPasswordVC = self else{
                                        return
                                    }
                                    resetPasswordVC.resetPasswordButton.stopAnimation(animationStyle: .normal, completion: {
                                        let userProfileScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                                        userProfileScene.userInfo = userInfo
                                        userProfileScene.proceedToScreen = .signUp
                                        guard let nvc = resetPasswordVC.navigationController else{
                                            return
                                        }
                                        nvc.pushViewController(userProfileScene, animated: true)
                                    })
        }) { (error) in
            self.resetPasswordButton.stopAnimation()
            showToastMessage(error.localizedDescription)
        }
    }
}
