//
//  EnterOTPToLoginVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 09/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class EnterOTPToLoginVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    let numPadArray = ["1","2","3","4","5","6","7","8","9","0","0","X"]
    var timer = Timer()
    var counter = 59
    var isTimmingRunning = false
    var userInfo : UserInfo!
    var hospitalAddressInfoModel  = [HospitalInfo]()
    var isTimerRunning = false
    
    var phoneNumberDic = [String : Any]()
    
    var otpText = ""
    
    enum ProceedToScreen {
        
        case loginWithOTP, signInWithOTP
    }
    
    var procceedToScreenThrough : ProceedToScreen = .loginWithOTP
    
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
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var screenQuotation: UILabel!
    @IBOutlet weak var mutelCoreNamelabel: UILabel!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    
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
        
        self.navigationBarView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
    
    //    MARK:- IBActions
    //    ================
    
    @IBAction func resendOtpBtnActn(_ sender: UIButton) {
        
        printlnDebug(phoneNumberDic)
        self.resendButtonTapped()
        
        printlnDebug(phoneNumberDic)
        WebServices.sendOtp(parameters: phoneNumberDic,
                            success: {( message : String) in
                                
                                showToastMessage(message)
                                
                                
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    @IBAction func otpTextField1EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField2.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            
            otpTextField1.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField2EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField3.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            
            otpTextField1.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField3EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField4.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            
            otpTextField2.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField4EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField5.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            
            self.otpTextField3.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField5EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField6.becomeFirstResponder()
        }
        if (sender.text?.isEmpty)!{
            
            otpTextField4.becomeFirstResponder()
        }
    }
    @IBAction func otpTextField6EditingChanged(_ sender: UITextField) {
        if (sender.text?.characters.count)! >= 1{
            
            otpTextField6.resignFirstResponder()
            
        }
        if (sender.text?.isEmpty)!{
            
            otpTextField5.becomeFirstResponder()
        }
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
            
            printlnDebug("skip")
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
        
        if indexPath.item == self.numPadArray.count - 1
        {
            self.removeOTPFields(indexPath: indexPath)
        }
        else if indexPath.item == 9{
            
            numPadCell.isUserInteractionEnabled = false
        }
        else
        {
            self.setOTPFields(indexPath: indexPath)
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
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
    
    //outlet
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
        
        if otpTextField1.text?.isEmpty == true
        {
            otpTextField1.text = otpText
            self.otpText.append(otpText)
        }
        else if otpTextField2.text?.isEmpty == true
        {
            otpTextField2.text = otpText
            self.otpText.append(otpText)
        }
        else if otpTextField3.text?.isEmpty == true
        {
            otpTextField3.text = otpText
            self.otpText.append(otpText)
        }
        else if otpTextField4.text?.isEmpty == true
        {
            otpTextField4.text = otpText
            self.otpText.append(otpText)
        }
        else if otpTextField5.text?.isEmpty == true
        {
            otpTextField5.text = otpText
            self.otpText.append(otpText)
        }
        else if otpTextField6.text?.isEmpty == true
        {
            otpTextField6.text = otpText
            self.otpText.append(otpText)
            
            //            HIT SignIn OTP Service
            //            ======================
            
            if procceedToScreenThrough == .loginWithOTP {
                
                self.login()
                
            }else{
                
                self.hitOtpVerificationService()
                
            }
        }
    }
    
    fileprivate func removeOTPFields(indexPath : IndexPath)
    {
        if otpTextField6.text?.isEmpty == false
        {
            otpTextField6.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
            
        }
        else if otpTextField5.text?.isEmpty == false
        {
            otpTextField5.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if otpTextField4.text?.isEmpty == false
        {
            otpTextField4.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if otpTextField3.text?.isEmpty == false
        {
            otpTextField3.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if otpTextField2.text?.isEmpty == false
        {
            otpTextField2.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
        }
        else if otpTextField1.text?.isEmpty == false
        {
            otpTextField1.text = ""
            self.otpText.remove(at: self.otpText.index(before: self.otpText.endIndex))
            
        }
    }
    
    fileprivate func setupUI(){
        
        self.navigationBarView.shadow(0.0, CGSize(width: 0.0, height: 1.0), UIColor.black)
        
        self.numberPadCollectionView.delegate = self
        self.numberPadCollectionView.dataSource = self
        
        self.appLogoImage.image = #imageLiteral(resourceName: "ic_prelogin_login_logo")
        self.screenQuotation.text = K_SCREEN_TAG.localized
        self.screenQuotation.textColor = UIColor.appColor
        self.screenQuotation.font = AppFonts.sansProRegular.withSize(16)
        
        self.mutelCoreNamelabel.text = K_APP_LABEL_ATBOTTOM.localized
        self.mutelCoreNamelabel.textColor = UIColor.grayLabelColor
        self.mutelCoreNamelabel.font = AppFonts.sansProRegular.withSize(14)
        
        self.screenTitleLabel.text = K_SIGN_WITH_OTP.localized
        self.screenTitleLabel.textColor = UIColor.white
        
        if DeviceType.IS_IPHONE_5{
            
            self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(15)
        }else{
            
            self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(16)
        }
        
        for textField in [otpTextField1,otpTextField2, otpTextField3,otpTextField4,otpTextField5,otpTextField6]{
            
            textField?.layer.cornerRadius = 2
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.appColor.cgColor
            textField?.textColor = UIColor.appColor
            textField?.delegate = self
            textField?.font = AppFonts.sanProSemiBold.withSize(16)
            
        }
        
        //add attributes to string        
        self.runTimer()
        
        self.resendCodeButton.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        guard let mobileNumber = self.phoneNumberDic[mobile_number] as? String else{
            
            return
        }
        let endThreeDigit = mobileNumber.substring(from: mobileNumber.index(mobileNumber.endIndex, offsetBy: -3))
        
        let phonNumberattributes = [NSFontAttributeName : AppFonts.sansProBold.withSize(16)]
        let textAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(13)]
        
        let otpTextString = "Please enter the OTP send on your mobile number ending with "
        
        let attributedString = NSMutableAttributedString(string: otpTextString, attributes: textAttributes)
        let phonNumberAttributedString = NSAttributedString(string: "XXX\(endThreeDigit)", attributes: phonNumberattributes)
        attributedString.append(phonNumberAttributedString)
        
        self.enterOtpCodeLabel.attributedText = attributedString
        self.floatBtn.isHidden = true
        
    }
    
    func runTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counterAction), userInfo: nil, repeats: true)
    }
    
    //counter action on timer
    @objc fileprivate func counterAction(){
        
        if counter < 60 && counter >= 10{
            
            counter -= 1
            timerLabel.text = "00:\(counter) Remaining"
            
        }else if counter < 10 && counter > 0{
            
            counter -= 1
            timerLabel.text = "00:0\(counter) Remaining"
            
        }else if counter == 0{
            
            timer.invalidate()
        }
    }
    
    func resendButtonTapped(){
        
        timer.invalidate()
        
        self.counter = 59
        
        self.runTimer()
    }
    
    
    //    MARK:- OTP Verification Service
    //    ================================
    fileprivate func hitOtpVerificationService(){
        
        self.phoneNumberDic[otp] = self.otpText
        
        printlnDebug("\(self.phoneNumberDic)")
        
        WebServices.otpVerification(parameters: phoneNumberDic, success: {[unowned self] (_ str : String) in
            
            showToastMessage(str)
            
            let userProfileScene = BuildProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            self.navigationController?.pushViewController(userProfileScene, animated: true)
            
            userProfileScene.userInfo = self.userInfo
            userProfileScene.hospitalAddressInfoModel = self.hospitalAddressInfoModel
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    fileprivate func login(){
        
        self.phoneNumberDic[password] = self.otpText
        
        printlnDebug(self.phoneNumberDic)
        
        WebServices.login(parameters: self.phoneNumberDic, success: { (_ userInfo : UserInfo, hospitalInfo : [HospitalInfo]) in
            
            let userProfileScene = BuildProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            self.navigationController?.pushViewController(userProfileScene, animated: true)
            
            userProfileScene.userInfo = userInfo
            userProfileScene.hospitalAddressInfoModel = hospitalInfo
            
            for addr in hospitalInfo{
                
                userProfileScene.hospAddr = addr.hospitalAddress
                
            }
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
}
