//
//  PatientIDPopUp.swift
//  Mutelcor
//
//  Created by  on 23/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PatientIDPopUpVC: UIViewController {
    
    enum proceedToScreenThrough {
        case forgotPasswordVC
        case addressDetailVC
    }
    
    //    MARK:- Proporties
    //    ======================
    var forgotPasswordDic = [String : Any]()
    
    var userInfo : UserInfo?
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
        self.animatePopupView()
    }
    
    //    MARK:- IBActions
    //    ================
    @IBAction func okButtonActn(_ sender: UIButton) {
           self.removePopupView()
        if self.proceedToScreen == .addressDetailVC{
            AppDelegate.shared.goToHome()
        }else{
            let resetPasswordScene = ResetPasswordVC.instantiate(fromAppStoryboard: .Main)
            resetPasswordScene.resetPasswordDic = self.forgotPasswordDic
            self.parent?.navigationController?.pushViewController(resetPasswordScene, animated: true)
        }
    }
}

//MARK:- Method
//=============
extension PatientIDPopUpVC {
    
    func setupUI(){
        
        self.popUpView.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)
        self.popUpTitle.font = AppFonts.sansProBold.withSize(12)
        self.okBtnOulet.setTitle(K_OK_TITLE.localized, for: .normal)
        self.okBtnOulet.setTitleColor(UIColor.appColor, for: .normal)
        
        if self.proceedToScreen == .addressDetailVC {
            self.popUpTitle.text = "Your Patient ID is:"
            self.patientIDLabel.textColor = #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
            self.patientIDLabel.font = AppFonts.sansProRegular.withSize(20)
            if let userData = self.userInfo {
                self.patientIDLabel.text = userData.patientUniqueId
            }
        }else{
            self.popUpTitle.isHidden = true
            self.patientIDLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.patientIDLabel.text = K_EMAIL_CONFIRMATION_MESSAGE.localized
            self.patientIDLabel.font = AppFonts.sansProRegular.withSize(13)
            self.okBtnHeightConstraintOutlt.constant = 30
        }
    }
    
    fileprivate func animatePopupView(){
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.popUpView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    fileprivate func removePopupView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: { (true) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
}
