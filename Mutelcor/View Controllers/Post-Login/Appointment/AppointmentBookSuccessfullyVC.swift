//
//  AppointmentBookSuccessfullyVC.swift
//  Mutelcor
//
//  Created by  on 30/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol RemoveFromSuperView : class {
    func removeFromSuperView()
}

class AppointmentBookSuccessfullyVC: BaseViewController {
    
    //    MARK:- Proporties
    //======================
    var selectedDay = ""
    var selectedTime = ""
    var selectedDate : Date!
    var appointDoc = ""
    var patientEmail = ""
    var patientContactNumber = ""
    weak var delegate : RemoveFromSuperView?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var appointmentSuccessfullyPopUp: UIView!
    @IBOutlet weak var bookedSuccessfullyLabel: UILabel!
    @IBOutlet weak var appointmentWithDocLabel: UILabel!
    @IBOutlet weak var emailConfirmationLabel: UILabel!
    @IBOutlet weak var okBtnOutlet: UIButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.animatePopUpView()
    }
    
    //    MARK:- IBAcions
    //    ===============
    @IBAction func okBtnActn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.appointmentSuccessfullyPopUp.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }) { (true) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.delegate?.removeFromSuperView()
        }
    }
}

//MARK:- Methods
//==============
extension AppointmentBookSuccessfullyVC {
    
    //    MARK:- SetUpUI
    //    ===============
   fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.appointmentSuccessfullyPopUp.layer.cornerRadius = 4.2
        self.appointmentSuccessfullyPopUp.clipsToBounds = true
        self.appointDoc = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.patientEmail = AppUserDefaults.value(forKey: .email).stringValue
        self.patientContactNumber = AppUserDefaults.value(forKey: .patientMobileNumber).stringValue
        self.bookedSuccessfullyLabel.textColor = UIColor.appColor
        self.bookedSuccessfullyLabel.text = K_APPOINTMENT_BOOKED.localized + "\n" + K_SUCCESSFULLY.localized
        self.bookedSuccessfullyLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.emailConfirmationLabel.textColor = #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
        self.emailConfirmationLabel.text = "A notification has been sent to your Email address \(self.patientEmail) and mobile \(self.patientContactNumber)."
        self.emailConfirmationLabel.font = AppFonts.sansProRegular.withSize(14)
        self.okBtnOutlet.layer.cornerRadius = 2.5
        self.okBtnOutlet.clipsToBounds = true
        self.okBtnOutlet.setTitle(K_OK_THANKS_TITLE.localized, for: .normal)
        self.okBtnOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.okBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(14)
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        let str1 = "Your Appointment with "
        var dayString = ""
        let date1 = self.selectedDate.stringFormDate(.dMMMyyyy)
        dayString = "\(self.selectedDay) \(date1) \(self.selectedTime)"
        let str2 = " has been successfully booked on "
        let normalStringAttributes = [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(14)]
        let docStringAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14),
                                   NSAttributedStringKey.foregroundColor : UIColor.appColor]
        let appointmentTimeStringAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(14)]
        let firstAttributedString = NSMutableAttributedString(string: str1, attributes: normalStringAttributes)
        let docAttributedString = NSAttributedString(string: self.appointDoc, attributes: docStringAttributes)
        let thirdAttributedString = NSAttributedString(string: str2, attributes: normalStringAttributes)
        let datAttributedString = NSAttributedString(string: dayString, attributes: appointmentTimeStringAttributes)
        firstAttributedString.append(docAttributedString)
        firstAttributedString.append(thirdAttributedString)
        firstAttributedString.append(datAttributedString)
        self.appointmentWithDocLabel.attributedText = firstAttributedString
    }
    
    fileprivate func animatePopUpView(){
        
        self.appointmentSuccessfullyPopUp.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.appointmentSuccessfullyPopUp.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
