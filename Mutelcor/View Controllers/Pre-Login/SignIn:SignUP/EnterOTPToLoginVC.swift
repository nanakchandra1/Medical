//
//  EnterOTPToLoginVC.swift
//  Mutelcor
//
//  Created by on 09/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class EnterOTPToLoginVC: BaseViewController {
    
   enum ProceedToScreen {
        case loginWithOTP
        case signInWithOTP
        case changeMobileNumber
    }
    
    //    MARK:- Properties
    //    =================
    let numPadArray = ["1","2","3","4","5","6","7","8","9","0","0","X"]

    var userInfo: UserInfo?
    var phoneNumberDic = [String: Any]()
    var otpText = ""
    var procceedToScreenThrough: ProceedToScreen = .loginWithOTP
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var enterOtpCodeLabel: UILabel!
    
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    
    @IBOutlet weak var otpTextField5: UITextField!
    @IBOutlet weak var otpTextField6: UITextField!
    
    @IBOutlet weak var numberPadCollectionView: UICollectionView!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    @IBOutlet weak var resendButtonView: TransitionButton!
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var screenQuotation: UILabel!
    @IBOutlet weak var mutelCoreNamelabel: UILabel!
    @IBOutlet weak var outerSafeAreaView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    @IBOutlet weak var backBtnOutlt: UIButton!
    
    //MARK:- ViewController life cycle
    //=================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.floatBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.outerSafeAreaView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }

    //    MARK:- IBActions
    //    ================
    @IBAction func resendOtpBtnActn(_ sender: UIButton) {
 
        self.resendButtonView.backgroundColor = UIColor.appColor
        self.resendButtonView.startAnimation()
        self.resendCodeButton.isHidden = true
        WebServices.sendOtp(parameters: phoneNumberDic,
                            success: {[weak self]( message : String) in
                                
                                guard let strongSelf = self else{
                                    return
                                }
                                strongSelf.resendButtonView.stopAnimation(animationStyle: .normal, completion: {
                                    strongSelf.resendButtonView.backgroundColor = UIColor.white
                                    strongSelf.resendCodeButton.isHidden = false
                                })
                                showToastMessage(message)
        }) {[weak self] (error) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.resendButtonView.stopAnimation(animationStyle: .normal, completion: {
                strongSelf.resendButtonView.backgroundColor = UIColor.white
                strongSelf.resendCodeButton.isHidden = false
            })
            showToastMessage(error.localizedDescription)
        }
    }
    
    @IBAction func otpTextField1EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField2.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            otpTextField1.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField2EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField3.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            otpTextField1.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField3EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField4.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            otpTextField2.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField4EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField5.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            self.otpTextField3.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField5EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField6.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            otpTextField4.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField6EditingChanged(_ sender: UITextField) {
        if (sender.text?.count)! >= 1{
            otpTextField6.resignFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            otpTextField5.becomeFirstResponder()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//===================================================================================
extension EnterOTPToLoginVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return numPadArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let numPadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumPadCellID", for: indexPath) as? NumPadCell else{ fatalError("Cell Not Found")
        }
        
        numPadCell.layer.cornerRadius = numPadCell.frame.width/2
        numPadCell.layer.borderWidth = 1
        numPadCell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        //assigning number pad keys
        if indexPath.row == numPadArray.count{
            numPadCell.numPadLabel.text = "X"
        }else if indexPath.row == numPadArray.count - 3{
            numPadCell.layer.borderColor = UIColor.white.cgColor
            numPadCell.numPadLabel.text = ""
        }else{
            numPadCell.numPadLabel.text = numPadArray[indexPath.row]
        }
        return numPadCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let numPadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumPadCellID", for: indexPath) as? NumPadCell else{ fatalError("Cell Not Found")
        }
        
        if indexPath.item == self.numPadArray.count - 1{
            self.removeOTPFields(indexPath: indexPath)
        }
        else if indexPath.item == 9{
            numPadCell.isUserInteractionEnabled = false
        }
        else{
            self.setOTPFields(indexPath: indexPath)
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
//=========================================
extension EnterOTPToLoginVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let collectionViewWidth = 250 //0.67*UIDevice.getScreenWidth
        let collectiveItemWidth = collectionViewWidth - 20
        let signleItemWidth = collectiveItemWidth/3
        
        return CGSize(width: signleItemWidth-2, height: signleItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
}

extension EnterOTPToLoginVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK:- UICollectionViewCell
//===========================
class NumPadCell: UICollectionViewCell{
    
    //MARK:- IBoutlets
    //    =================
    @IBOutlet weak var numPadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.numPadLabel.text = ""
    }
}

//MARK:- Methods
//==============
extension EnterOTPToLoginVC {
    
    fileprivate func setOTPFields(indexPath : IndexPath)
    {
        let otpText = self.numPadArray[indexPath.row]
        
        if let text = otpTextField1.text, text.isEmpty {
            otpTextField1.text = otpText
            self.otpText.append(otpText)
        }
        else if let text = otpTextField2.text, text.isEmpty {
            otpTextField2.text = otpText
            self.otpText.append(otpText)
        }
        else if let text = otpTextField3.text, text.isEmpty{
            otpTextField3.text = otpText
            self.otpText.append(otpText)
        }
        else if let text = otpTextField4.text, text.isEmpty {
            otpTextField4.text = otpText
            self.otpText.append(otpText)
        }
        else if let text = otpTextField5.text, text.isEmpty {
            otpTextField5.text = otpText
            self.otpText.append(otpText)
        }
        else if let text = otpTextField6.text, text.isEmpty {
            otpTextField6.text = otpText
            self.otpText.append(otpText)
            
            //            HIT SignIn OTP Service
            //            ======================
            
            if procceedToScreenThrough == .loginWithOTP {
                self.login()
            }else if procceedToScreenThrough == .changeMobileNumber{
                self.chnageMobileNumber()
            }else{
                self.hitOtpVerificationService()
            }
        }
    }
    
    fileprivate func removeOTPFields(indexPath : IndexPath)
    {
        if let text = otpTextField6.text, !text.isEmpty {
            otpTextField6.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if let text = otpTextField5.text, !text.isEmpty {
            otpTextField5.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if let text = otpTextField4.text, !text.isEmpty {
            otpTextField4.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if let text = otpTextField3.text, !text.isEmpty {
            otpTextField3.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if let text = otpTextField2.text, !text.isEmpty {
            otpTextField2.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if let text = otpTextField1.text, !text.isEmpty {
            otpTextField1.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
            
        }
    }
    
    fileprivate func setupUI(){
        
        self.outerSafeAreaView.shadow(0.0, CGSize(width: 0.0, height: 1.0), UIColor.black)
        
        self.numberPadCollectionView.delegate = self
        self.numberPadCollectionView.dataSource = self
        
        self.appLogoImage.image = #imageLiteral(resourceName: "ic_login_module_logo")
        self.screenQuotation.text = K_SCREEN_TAG.localized
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
        
        self.mutelCoreNamelabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNamelabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNamelabel.font = AppFonts.sansProRegular.withSize(14)
        
        let screenTitle = self.procceedToScreenThrough == .signInWithOTP ? K_SIGN_WITH_OTP.localized : K_OTP_VERIFICATION.localized
        self.screenTitleLabel.text = screenTitle
        self.screenTitleLabel.textColor = UIColor.white
        
//        let font = DeviceType.IS_IPHONE_5 ? 15 : 16
        self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(CGFloat(16))
        
        for textField in [otpTextField1,otpTextField2, otpTextField3,otpTextField4,otpTextField5,otpTextField6]{
            textField?.layer.cornerRadius = 2
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.appColor.cgColor
            textField?.textColor = UIColor.appColor
            textField?.delegate = self
            textField?.font = AppFonts.sanProSemiBold.withSize(16)
        }
        
        let isBackBtnHidden = (self.procceedToScreenThrough == .changeMobileNumber) ? false : true
        self.backBtnOutlt.isHidden = isBackBtnHidden
        self.backBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentBack"), for: .normal)
        
        self.resendCodeButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        guard let mobileNumber = self.phoneNumberDic[DictionaryKeys.patientMobileNumber] as? String else{
            return
        }
        let index = mobileNumber.index(mobileNumber.endIndex, offsetBy: -3)
        let endThreeDigit = String(mobileNumber[index...])
        
        let phonNumberattributes = [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(16)]
        let textAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(13)]
        let otpTextString = K_ENTER_OTP_ON_YOUR_MOBILE_NUMBER.localized
        let attributedString = NSMutableAttributedString(string: otpTextString, attributes: textAttributes)
        let phonNumberAttributedString = NSAttributedString(string: "XXX\(endThreeDigit)", attributes: phonNumberattributes)
        attributedString.append(phonNumberAttributedString)
        
        self.enterOtpCodeLabel.attributedText = attributedString
        self.floatBtn.isHidden = true
    }

    //    MARK:- OTP Verification Service
    //    ================================
    fileprivate func hitOtpVerificationService(){
        
        self.phoneNumberDic[DictionaryKeys.otp] = self.otpText
        WebServices.otpVerification(parameters: phoneNumberDic, success: {[weak self] (_ str : String) in
            
            guard let enterOtpVC = self else{
                return
            }
            let userProfileScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            userProfileScene.userInfo = enterOtpVC.userInfo
            userProfileScene.proceedToScreen = .signUp
            guard let nvc = enterOtpVC.navigationController else{
                return
            }
            nvc.pushViewController(userProfileScene, animated: true)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func login(){
        
        self.phoneNumberDic[DictionaryKeys.password] = self.otpText
        WebServices.login(parameters: self.phoneNumberDic, success: { (_ userInfo : UserInfo) in
            AppDelegate.shared.goToHome()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func chnageMobileNumber(){
    self.phoneNumberDic[DictionaryKeys.otp] = self.otpText
        WebServices.changeMobileNumber(parameters: self.phoneNumberDic, success: {[weak self] (_ response: String) in
            
            showToastMessage(response)
            guard let enterOtpToLoginVC = self else{
                return
            }
            guard let nvc = enterOtpToLoginVC.navigationController else{
                return
            }
            nvc.popViewController(animated: true)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
