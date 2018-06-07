//
//  ConfirmationVC.swift
//  Mutelcore
//
//  Created by Ashish on 30/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol AppointmentCancellationDelegate {
    
    func apointmentCancellation(_ isAppointmentCancelled : Bool)
    
}

class ConfirmationVC: UIViewController {

//    MARK:- Proporties
//    =================
    enum openTheConfirmationVCFor {
        
        case appointmentConfirmation, appointmentCancellation, rescheduleAppointment
        
    }
    
    var confirmText = ""
    var selectedDay = ""
    var selectedDate : Date!
    var selectedTime = ""
    var addAppointmentDic = [String : Any]()
    var cancelAppointmentDic = [String : Any]()
    var openConfirmVCFor : openTheConfirmationVCFor = .appointmentCancellation
    
    var delegate : AppointmentCancellationDelegate!
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var confirmationPopUpView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationText: UILabel!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUi()

    }

//    MARK:- IBActions
//    =================
    @IBAction func cancelBtnActn(_ sender: UIButton) {
        
        if self.openConfirmVCFor == .appointmentCancellation{
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
            }) { (true) in
                
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
            }
            
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
            }) { (true) in
                
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
            }
        }
    }
    
    @IBAction func confirmBtnActn(_ sender: UIButton) {
    
        if self.openConfirmVCFor == .appointmentCancellation {
            
            self.cancelAppointment()
            
        }else if self.openConfirmVCFor == .appointmentConfirmation{
            
             self.addAppointment()
        }else{
            
            self.rescheduleAppointment()
        }
    }
}

//MARK:- Methods
//==============
extension ConfirmationVC {
    
    fileprivate func setUi(){
    
        self.confirmationPopUpView.layer.cornerRadius = 4.3
        self.confirmationPopUpView.clipsToBounds = true
        
        self.confirmationLabel.textColor = UIColor.appColor
        self.confirmationLabel.text = "CONFIRMATION!"
        self.confirmationLabel.font = AppFonts.sansProBold.withSize(15.7)
        
        self.cancelBtnOutlet.backgroundColor = #colorLiteral(red: 0.5137254902, green: 0.5137254902, blue: 0.5137254902, alpha: 1)
        self.cancelBtnOutlet.setTitle("CANCEL", for: .normal)
        self.cancelBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.8)
        self.cancelBtnOutlet.layer.cornerRadius = 2.5
        self.cancelBtnOutlet.clipsToBounds = true
        
        self.confirmBtnOutlet.backgroundColor = UIColor.appColor
        self.confirmBtnOutlet.setTitle("CONFIRM", for: .normal)
        self.confirmBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.8)
        self.confirmBtnOutlet.layer.cornerRadius = 2.5
        self.confirmBtnOutlet.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        
        if self.openConfirmVCFor == .appointmentConfirmation  || self.openConfirmVCFor == .rescheduleAppointment{
        
        let attributeString = "Are you sure you want to book appointment on "
            
            var dayString = ""
            
            if let date = self.selectedDate.stringFormDate(DateFormat.ddmmyy.rawValue) {
                printlnDebug(date)
               dayString = "\(self.selectedDay) \(date) \(self.selectedTime)"
            }
        
        let attributes = [NSFontAttributeName : AppFonts.sansProRegular.withSize(15.7)]
        let dayAttributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(13.5)]
        
        let attributedString = NSMutableAttributedString(string: attributeString, attributes: attributes)
        let datAttributedString = NSAttributedString(string: dayString, attributes: dayAttributes)
        
        attributedString.append(datAttributedString)
        
        self.confirmationText.attributedText = attributedString
            
        }else{
          
        self.confirmationText.font = AppFonts.sansProRegular.withSize(15.7)
          self.confirmationText.text = self.confirmText
  
        }
    }
    
    
    //   Add Appointment service
    func addAppointment(){
        
        self.addAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        
        WebServices.addAppointment(parameters: self.addAppointmentDic, success: { (_ str : String) in
            
            
            UIView.animate(withDuration: 0.3) {
                
                self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: 0)
                
            }
            
            let appointmentBookedScene = AppointmentBookSuccessfullyVC.instantiate(fromAppStoryboard: .AppointMent)
            
            appointmentBookedScene.selectedDate = self.selectedDate
            appointmentBookedScene.selectedTime = self.selectedTime
            appointmentBookedScene.selectedDay = self.selectedDay
            
            appointmentBookedScene.delegate = self.parent as! AddAppointmentVC
            
            sharedAppDelegate.window?.addSubview(appointmentBookedScene.view)
            self.parent?.addChildViewController(appointmentBookedScene)
            
            self.view.removeFromSuperview()
            
            appointmentBookedScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
            UIView.animate(withDuration: 0.3) {
                
                appointmentBookedScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                
            }
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    //Cancel UpComing Appointment Service
    
    func cancelAppointment(){
        
        self.cancelAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        WebServices.cancelAppointment(parameters: self.cancelAppointmentDic,
                                      success: { (str : String) in
                                    
                                        UIView.animate(withDuration: 0.3, animations: {
                                            
                                            self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                                            
                                            self.view.removeFromSuperview()
                                            self.removeFromParentViewController()
                                            
                                            }, completion: { (true) in
                                            
                                                showToastMessage(str)
                                                
                                                self.delegate.apointmentCancellation(true)
                                                
                                        })
                                        
        }) { (e : Error) in
            
            printlnDebug(e)
        }
    }
    
    fileprivate func rescheduleAppointment(){
        
        self.addAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        
        WebServices.rescheduleAppointment(parameters: self.addAppointmentDic,
                                          success: { (str : String) in
                                            
                                            let appointmentBookedScene = AppointmentBookSuccessfullyVC.instantiate(fromAppStoryboard: .AppointMent)
                                            
                                            appointmentBookedScene.selectedDate = self.selectedDate
                                            
                                            appointmentBookedScene.selectedTime = self.selectedTime
                                            appointmentBookedScene.selectedDay = self.selectedDay
                                            
                                            
                                            sharedAppDelegate.window?.addSubview(appointmentBookedScene.view)
                                            self.parent?.addChildViewController(appointmentBookedScene)
                                            
                                            self.view.removeFromSuperview()
                                            
                                            appointmentBookedScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                                            
                                            UIView.animate(withDuration: 0.3) {
                                                
                                                appointmentBookedScene.view.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
                                                
                                            }
                                            showToastMessage(str)
                                           
        }) { (error) in
            
           showToastMessage(error.localizedDescription)

        }
    }
}
