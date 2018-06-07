//
//  GenrateHealthReportVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

class GenrateHealthReportVC: BaseViewController {
    
//    MARK:- IBOUtlets
//    =================
    @IBOutlet weak var confirmationText: UILabel!
    @IBOutlet weak var sendBtn: TransitionButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_GENERATE_HEALTH_REPORT_TITLE.localized)
    }
//    MARK:- IBACtion
//    ===============
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        self.sendBtn.startAnimation()
        WebServices.genrateHealthReport(success: {[weak self] (_ message: String) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.sendBtn.stopAnimation(animationStyle: .normal, completion: nil)
            showToastMessage(message)
        }) { (error: Error) in
            self.sendBtn.stopAnimation(animationStyle: .normal, completion: {
                showToastMessage(error.localizedDescription)
            })
        }
    }
    
//    MARK:- Private Methods
//    ======================
    fileprivate func setupUI(){
        let email = AppUserDefaults.value(forKey: .email).stringValue
        let text = "Please tap on send button to send the Generated Report on your registered mail id "
        let mutableAttribute = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(16)])
        let emailAttr = NSAttributedString.init(string: email, attributes: [NSAttributedStringKey.font: AppFonts.sanProSemiBold.withSize(16),
                                                                            NSAttributedStringKey.foregroundColor: UIColor.appColor])
        mutableAttribute.append(emailAttr)
        self.confirmationText.attributedText = mutableAttribute
        self.sendBtn.gradient(withX: 0, withY: 0, cornerRadius: true)
        self.sendBtn.layer.cornerRadius = 2.2
        self.sendBtn.setTitleColor(UIColor.white, for: .normal)
        self.sendBtn.setTitle(K_GENERATE_HEALTH_REPORT_BUTTON_TITLE.localized.uppercased(), for: .normal)
        self.sendBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
    }
}
