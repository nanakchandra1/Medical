//
//  AppointmentBookSuccessfullyVC.swift
//  Mutelcore
//
//  Created by Ashish on 30/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol RemoveFromSuperView {
    
    func removeFromSuperView(_ remove : Bool)
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
    var delegate : RemoveFromSuperView!
    
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
        
        self.setui()
        printlnDebug("\(selectedDate)")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK:- IBAcions
//    ===============
    @IBAction func okBtnActn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
            }) { (true) in
            
//                let appointmentListingScene = AppointmentListingVC.instantiate(fromAppStoryboard: .AppointMent)
//                
//                self.navigationController?.pushViewController(appointmentListingScene, animated: false)
                
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.delegate.removeFromSuperView(true)
//                self.parent?.removeFromParentViewController()
                
        }
    }
}

//MARK:- Methods
//==============
extension AppointmentBookSuccessfullyVC {
    
//    MARK:- SetUi
//    ============
    func setui(){
        
        self.floatBtn.isHidden = true
        
        self.appointmentSuccessfullyPopUp.layer.cornerRadius = 4.2
        self.appointmentSuccessfullyPopUp.clipsToBounds = true
        
        self.appointDoc = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.patientEmail = AppUserDefaults.value(forKey: .email).stringValue
        self.patientContactNumber = AppUserDefaults.value(forKey: .patientContact).stringValue
        
        self.bookedSuccessfullyLabel.textColor = UIColor.appColor
        self.bookedSuccessfullyLabel.text = "Appointment Booked Successfully !"
        self.bookedSuccessfullyLabel.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.emailConfirmationLabel.textColor = #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
        self.emailConfirmationLabel.text = "A notification has been sent to your Email address \(self.patientEmail) and mobile \(self.patientContactNumber)."
        self.emailConfirmationLabel.font = AppFonts.sansProRegular.withSize(14)
        
        self.okBtnOutlet.layer.cornerRadius = 2.5
        self.okBtnOutlet.clipsToBounds = true
        self.okBtnOutlet.setTitle("OK, THANKS", for: .normal)
        self.okBtnOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.okBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(14)
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        
        let str1 = "Your Appointment with "
        
        var dayString = ""
        
        if let date1 = self.selectedDate.stringFormDate(DateFormat.ddmmyy.rawValue) {
            
            dayString = "\(self.selectedDay) \(date1) \(self.selectedTime)"
        }
        
        let str2 = " has been successfully booked on "
        let normalStringAttributes = [NSFontAttributeName : AppFonts.sansProRegular.withSize(14)]
        let docStringAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(14),
                                   NSForegroundColorAttributeName : UIColor.appColor]
        let appointmentTimeStringAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(14)]
        
        let firstAttributedString = NSMutableAttributedString(string: str1, attributes: normalStringAttributes)
        let docAttributedString = NSAttributedString(string: self.appointDoc, attributes: docStringAttributes)
        let thirdAttributedString = NSAttributedString(string: str2, attributes: normalStringAttributes)
        let datAttributedString = NSAttributedString(string: dayString, attributes: appointmentTimeStringAttributes)
        
        firstAttributedString.append(docAttributedString)
        firstAttributedString.append(thirdAttributedString)
        firstAttributedString.append(datAttributedString)
        
        self.appointmentWithDocLabel.attributedText = firstAttributedString
        
    }
}
