//
//  PatientIDPopUp.swift
//  Mutelcore
//
//  Created by Ashish on 23/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PatientIDPopUpVC: UIViewController {
    
    //    MARK:- Proporties
    
    var forgotPasswordDic = [String : Any]()
    
    var userInfo : UserInfo!
    
    enum proceedToScreenThrough {
        
        case forgotPasswordVC, addressDetailVC
        
    }
    
    var proceedToScreen : proceedToScreenThrough = .addressDetailVC
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var okBtnOulet: UIButton!
    @IBOutlet weak var patientIDLabel: UILabel!
    @IBOutlet weak var okBtnHeightConstraintOutlt: NSLayoutConstraint!
    
    //    Mark:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    
    //    MARK:- IBActions
    //    ================
    @IBAction func okButtonActn(_ sender: UIButton) {
        
        if self.proceedToScreen == .addressDetailVC{
            
            sharedAppDelegate.goToHome()
            
            AppUserDefaults.save(value: 1, forKey: .isproceedToLogIn)
            
        }else{
            
            let resetPasswordScene = ResetPasswordVC.instantiate(fromAppStoryboard: .Main)
            resetPasswordScene.resetPasswordDic = self.forgotPasswordDic
            self.navigationController?.pushViewController(resetPasswordScene, animated: true)
            
        }

        self.view.removeFromSuperview()
    }
}

//MARK:- Method
//=============
extension PatientIDPopUpVC {
    
    func setupUI(){
        
        self.popUpView.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)

        self.popUpTitle.font = AppFonts.sansProBold.withSize(12)
        self.okBtnOulet.setTitle("OK", for: .normal)
        self.okBtnOulet.setTitleColor(UIColor.appColor, for: .normal)
        
        if self.proceedToScreen == .addressDetailVC {
            
            self.popUpTitle.text = "Your Patient ID is:"
            self.patientIDLabel.textColor = #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
            self.patientIDLabel.font = AppFonts.sansProRegular.withSize(20)
            if let patientId = self.userInfo.patientID{
                
                self.patientIDLabel.text = "MCUID\(patientId)"
                
            }else{
                
                self.patientIDLabel.text = ""
            }
        }else{
            
            self.popUpTitle.isHidden = true
            self.patientIDLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.patientIDLabel.text = K_email_Confirmation_Message.localized
            self.patientIDLabel.font = AppFonts.sansProRegular.withSize(13)
            self.okBtnHeightConstraintOutlt.constant = 30
        }
    }
}
