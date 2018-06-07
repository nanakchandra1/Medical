//
//  BuildProfileVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import AlamofireImage

class BuildProfileVC: UIViewController {
    
    //    MARK:- Properties
    //    =================
    var userPersonaldetail = [String : Any]()
    var userInfo : UserInfo!
    var userMedicalDetail = [String : Any]()
    var userAddressDetail = [String : Any]()
    var userImage : UIImage?
    var hospitalAddressInfoModel  = [HospitalInfo]()
    var hospAddr : String?
    
    var personalInformationScene : PersonalInformationVC!
    var medicalProfileScene : MedicalProfileVC!
    var addressProfileScene : AddressDetailsVC!
    
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var tabBartopViewBorder: UIView!
    
    @IBOutlet weak var personalinformationSeprator: UIView!
    @IBOutlet weak var personalInformationBottomView: UIView!
    @IBOutlet weak var personalInformationImage: UIImageView!
    @IBOutlet weak var personalInformationLabel: UILabel!
    @IBOutlet weak var personalInformationView: UIView!
    @IBOutlet weak var oneLabelOnPersonalInfoBtn: UILabel!
    
    @IBOutlet weak var medicalProfileSeprator: UIView!
    @IBOutlet weak var medicalInformationBottomView: UIView!
    @IBOutlet weak var twoLabelOnMedicalProfilebtn: UILabel!
    @IBOutlet weak var medicalInformationView: UIView!
    @IBOutlet weak var medicalInformationImage: UIImageView!
    @IBOutlet weak var medicalInformationLabel: UILabel!
    
    @IBOutlet weak var threeLabelOnAddressDetailBtn: UILabel!
    @IBOutlet weak var addressDetailBottomView: UIView!
    @IBOutlet weak var addressDetailImage: UIImageView!
    @IBOutlet weak var addressdetailLabel: UILabel!
    @IBOutlet weak var addressDetailView: UIView!
    
    @IBOutlet weak var saveAndContinueBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var skipBtnView: UIView!
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var backBtnOult: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    //    MARK:- Maintain the Tabbar State
    //    =================================
    enum Tabbar {
        
        case PersonlInformation, MedicalProfile, AddressDetails
        
    }
    
    var tabbarState : Tabbar = .PersonlInformation {
        
        willSet{
            
            switch newValue {
                
            case .PersonlInformation:
                
                self.personalInformationView.backgroundColor = UIColor.white
                self.personalInformationImage.isHidden = true
                self.personalInformationLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.personalInformationBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.personalinformationSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.oneLabelOnPersonalInfoBtn.isHidden = false
                
                self.twoLabelOnMedicalProfilebtn.isHidden = false
                self.medicalInformationView.backgroundColor = UIColor.white
                self.medicalInformationImage.isHidden = true
                self.medicalInformationLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.medicalInformationBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.medicalProfileSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                
                self.threeLabelOnAddressDetailBtn.isHidden = false
                self.addressDetailImage.isHidden = true
                self.addressdetailLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.addressDetailBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.addressDetailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.backBtnOult.isHidden = true
                
            case .MedicalProfile:
                
                self.personalInformationImage.isHidden = false
                self.personalInformationLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.personalInformationView.backgroundColor = UIColor.appColor
                self.personalInformationBottomView.backgroundColor = UIColor.appColor
                self.personalinformationSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.oneLabelOnPersonalInfoBtn.isHidden = true
                
                self.medicalInformationImage.isHidden = true
                self.twoLabelOnMedicalProfilebtn.isHidden = false
                self.medicalInformationView.backgroundColor = UIColor.white
                self.medicalInformationLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.medicalInformationBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.medicalProfileSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                
                self.threeLabelOnAddressDetailBtn.isHidden = false
                self.addressDetailImage.isHidden = true
                self.addressdetailLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.addressDetailBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.addressDetailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.backBtnOult.isHidden = false
                
            case .AddressDetails:
                
                self.personalInformationView.backgroundColor = UIColor.appColor
                self.personalInformationImage.image = #imageLiteral(resourceName: "personal_info_checkmark")
                self.personalInformationLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.personalInformationBottomView.backgroundColor = UIColor.appColor
                self.personalinformationSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.oneLabelOnPersonalInfoBtn.isHidden = true
                
                self.twoLabelOnMedicalProfilebtn.isHidden = true
                self.medicalInformationView.backgroundColor = UIColor.appColor
                self.medicalInformationImage.image = #imageLiteral(resourceName: "personal_info_checkmark")
                self.medicalInformationImage.isHidden = false
                self.medicalInformationLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.medicalInformationBottomView.backgroundColor = UIColor.appColor
                self.medicalProfileSeprator.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                
                self.addressDetailImage.isHidden = true
                self.threeLabelOnAddressDetailBtn.isHidden = false
                self.addressdetailLabel.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                self.addressDetailBottomView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.addressDetailView.backgroundColor = UIColor.white
                self.backBtnOult.isHidden = false
                
            }
        }
    }
    
    //    MARK:- ViewController Life Cycle
    //    =================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUi()
        stepVerifiedScreens()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationBarView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.saveAndContinueBtn.gradient(withX: 0, withY: 0, cornerRadius: true)
        
    }
    
    @IBAction func saveAndContinueBtn(_ sender: UIButton) {
        
        //        validate user personal detail
        if tabbarState == .PersonlInformation {
            
            guard !self.userInfo.patientFirstname!.isEmpty else{
                
                showToastMessage(AppMessages.emptyFirstName.rawValue)
                
                return
            }
            guard let email = self.userInfo.patientEmail else{
                
                showToastMessage(AppMessages.emptyEmail.rawValue)
                
                return
            }
            guard email.checkValidity(with: .Email) else{
                
                showToastMessage(AppMessages.validEmail.rawValue)
                
                return
            }
            guard let mobileNumber = self.userInfo.patientMobileNumber else{
                
                showToastMessage(AppMessages.emptyMobileNumber.rawValue)
                
                return
            }
            guard mobileNumber.checkValidity(with: .MobileNumber) else{
                
                showToastMessage(AppMessages.mobileNumberLessThanTenDigits.rawValue)
                
                
                return
            }
            guard let adhaardCardNumber = self.userInfo.patientNationalId,!adhaardCardNumber.isEmpty  else{
                
                showToastMessage(AppMessages.emptyAdhaarCardnumber.rawValue)
                
                
                return
            }
            
            
            //           MARK:- HIT Medical Profile Service
            //           ==================================
            
            var imgData : Data?
            
            if let image = self.userImage {
                
                imgData = UIImageJPEGRepresentation(image, 0.5)
                
            }
            else{
                
                if !self.userInfo.patientPic!.isEmpty{
                    
                    let image = self.userInfo.patientPic?.replacingOccurrences(of: " ", with: "%20")
                    
                    imgData = Data(base64Encoded: image!)
                }
            }
            
            printlnDebug(userInfo.toDictionary)
            
            WebServices.personalInfo(parameters: userInfo.toDictionary, imageData: imgData, imageKey: user_image, success: {[unowned self] (userInfo) in
                
                self.medicalProfileScene = MedicalProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                
                self.medicalProfileScene.userInfo = self.userInfo
                self.medicalProfileScene.hospInfo = self.hospitalAddressInfoModel
                
                self.addViewOfSubViewController(self, self.medicalProfileScene, x: 0, y: 108, width: self.view.frame.width, height: self.medicalProfileScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
                
                self.tabbarState = .MedicalProfile
                
                }, failure: { (error) in
                    
                    showToastMessage(error.localizedDescription)
                    
            })
        }
            //            validate user medical detail
        else if tabbarState == .MedicalProfile {
            
            
            //            HIT:- Address detail Service
            
            printlnDebug(userInfo.toDictionary)
            
            WebServices.medicalInfo(parameters: userInfo.toDictionary,
                                    success: {[unowned self] (_ userInfo : UserInfo) in
                                        
                                        printlnDebug("params :\(self.userMedicalDetail)")
                                        printlnDebug("model : \(userInfo)")
                                        
                                        self.addressProfileScene = AddressDetailsVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                                        self.addressProfileScene .userInfo = userInfo
                                        
                                        self.addViewOfSubViewController(self, self.addressProfileScene , x: 0, y: 108, width: self.view.frame.width, height: self.addressProfileScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
                                        
                                        self.tabbarState = .AddressDetails
                                        
                },
                                    failure: { (error) in
                                        
                                        showToastMessage(error.localizedDescription)
                                        
            })
        }
        else{
            
            //        MARK:- Hit Medical Information Service
            //        ======================================
            WebServices.userAddressInfo(parameters: userInfo.toDictionary, success: {[unowned self] (_ userInfo : UserInfo) in
                
                printlnDebug("params :\(self.userMedicalDetail)")
                printlnDebug("model : \(userInfo)")
                
                let patientIDPopUpScene = PatientIDPopUpVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
                
                patientIDPopUpScene.userInfo = self.userInfo
                
                sharedAppDelegate.window?.addSubview(patientIDPopUpScene.view)
                self.addChildViewController(patientIDPopUpScene)
                
                patientIDPopUpScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
                UIView.animate(withDuration: 0.3) {
                    
                    patientIDPopUpScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                    
                }
                self.tabbarState = .AddressDetails
                
                }, failure: { (error) in
                    
                    showToastMessage(error.localizedDescription)
            })
        }
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        
        sharedAppDelegate.goToHome()
        AppUserDefaults.save(value: 1, forKey: .isproceedToLogIn)
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if self.tabbarState == .MedicalProfile {
            
            self.tabbarState = .PersonlInformation
            self.personalInformationScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            self.personalInformationScene.userInfo = self.userInfo
            self.addViewOfSubViewController(self, self.personalInformationScene, x: 0, y: 108, width: self.view.frame.width, height: self.personalInformationScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
            
        }else if self.tabbarState == .AddressDetails{
            
            self.tabbarState = .MedicalProfile
            
            self.medicalProfileScene = MedicalProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            self.medicalProfileScene.userInfo = self.userInfo
            self.medicalProfileScene.hospInfo = self.hospitalAddressInfoModel
            self.addViewOfSubViewController(self, self.medicalProfileScene, x: 0, y: 108, width: self.view.frame.width, height: self.medicalProfileScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
            
        }
    }
    
    //    MARK:- Methods
    //    ===============
    
    private func setUi(){
        
        self.saveAndContinueBtn.layer.cornerRadius = 2.2
        self.saveAndContinueBtn.shadow(2.2, CGSize(width: 0.7, height: 1.0), UIColor.navigationBarShadowColor)
        self.skipBtn.setTitleColor(UIColor.grayLabelColor, for: UIControlState.normal)
        self.skipBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(14)
        
        self.personalInformationLabel.text = K_PERSONAL_INFORMATION.localized
        self.personalInformationLabel.font = AppFonts.sansProRegular.withSize(11)
        self.medicalInformationLabel.text = K_MEDICAL_PROFILE.localized
        self.medicalInformationLabel.font = AppFonts.sansProRegular.withSize(11)
        self.addressdetailLabel.text = K_ADDRESS_DETAIL.localized
        self.addressdetailLabel.font = AppFonts.sansProRegular.withSize(11)
        
        twoLabelOnMedicalProfilebtn.clipsToBounds = true
        threeLabelOnAddressDetailBtn.clipsToBounds = true
        
        tabBartopViewBorder.backgroundColor = UIColor.appColor
        
        self.tabBartopViewBorder.shadow(1.2, CGSize(width: 1.0, height: 1.5))
        
        self.saveAndContinueBtn.setTitle(K_SAVE_AND_CONTINUE_PLACEHOLDER.localized, for: .normal)
        self.saveAndContinueBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.screenTitleLabel.text = BUILD_PROFILE_SCREEN_TITLE.localized
        self.screenTitleLabel.textColor = UIColor.white
        
        if DeviceType.IS_IPHONE_5 {
            
            self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(15)
            
        }else{
            
            self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(16)
        }
        
        self.backBtnOult.isHidden = true
        self.navigationBarView.shadow(0, CGSize(width: 0, height: 1.5), UIColor.navigationBarShadowColor)
        
        for label in [self.oneLabelOnPersonalInfoBtn, self.twoLabelOnMedicalProfilebtn, self.threeLabelOnAddressDetailBtn] {
            
            label?.layer.cornerRadius = (label?.frame.width)! / 2
            label?.layer.borderWidth = 1.0
            label?.layer.borderColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1).cgColor
            label?.font = AppFonts.sansProRegular.withSize(10.2)
            label?.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
        }
        
        self.oneLabelOnPersonalInfoBtn.text = "1."
        self.twoLabelOnMedicalProfilebtn.text = "2."
        self.threeLabelOnAddressDetailBtn.text = "3."
        
        for imageView in [self.personalInformationImage, self.medicalInformationImage, self.addressDetailImage] {
            
            imageView?.image = #imageLiteral(resourceName: "personal_info_checkmark")
        }
    }
    
    private func stepVerifiedScreens(){
        
        if self.userInfo.stepVerified == 0{
            
            self.tabbarState = .PersonlInformation
            
            self.personalInformationScene = PersonalInformationVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            
            self.personalInformationScene.userInfo = self.userInfo
            
            addViewOfSubViewController(self, self.personalInformationScene, x: 0, y: 108, width: self.view.frame.width, height: self.personalInformationScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
            
        }
        else if self.userInfo.stepVerified == 1{
            
            self.tabbarState = .MedicalProfile
            
            self.medicalProfileScene = MedicalProfileVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            
            self.medicalProfileScene.userInfo = self.userInfo
            self.medicalProfileScene.hospInfo = self.hospitalAddressInfoModel
            
            self.addViewOfSubViewController(self, self.medicalProfileScene, x: 0, y: 108, width: self.view.frame.width, height: self.medicalProfileScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
            
        }
        else if self.userInfo.stepVerified == 2{
            
            self.tabbarState = .AddressDetails
            
            self.addressProfileScene = AddressDetailsVC.instantiate(fromAppStoryboard: .ProfileBuildUp)
            self.addressProfileScene.userInfo = userInfo
            
            self.addViewOfSubViewController(self, self.addressProfileScene, x: 0, y: 108, width: self.view.frame.width, height: self.addressProfileScene.view.frame.height - 188, self.saveAndContinueBtn.superview)
            
        }else{
            
            sharedAppDelegate.goToHome()
            
        }
    }
    
    //MARK:- AddSubView
    //==================
    private func addViewOfSubViewController(_ mainController : UIViewController, _ subViewController : UIViewController, x: CGFloat, y: CGFloat, width : CGFloat, height : CGFloat, _ bringToFront : UIView?){
        
        subViewController.view.frame = CGRect(x: x, y: y, width: width, height: height)
        mainController.addChildViewController(subViewController)
        mainController.view.addSubview(subViewController.view)
        
        if let front = bringToFront {
            mainController.view.bringSubview(toFront: front)
        }
        
        subViewController.willMove(toParentViewController: mainController)
        
//        for childVC in mainController.childViewControllers{
//
//            if childVC === subViewController{
//
//            } else {
//
//                childVC.view.removeFromSuperview()
//                childVC.removeFromParentViewController()
//            }
//        }
    }
}
