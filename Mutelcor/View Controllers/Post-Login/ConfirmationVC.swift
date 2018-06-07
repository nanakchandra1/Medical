//
//  ConfirmationVC.swift
//  Mutelcor
//
//  Created by  on 30/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol AppointmentCancellationDelegate : class {
    func appointmentCancellation()
}

protocol DeleteReminderDelegate: class {
    func deleteReminder(_ indexPath: IndexPath)
}

enum OpenTheConfirmationVCFor {
    case appointmentConfirmation
    case appointmentCancellation
    case rescheduleAppointment
    case changePassword
    case changeMobileNumber
    case deleteReminder
    case logout
    case icloudPermission
}

enum OpenTheConfirmationVCForChangePass {
    case email
    case mobile
    case none
}


class ConfirmationVC: UIViewController {
    
    //    MARK:- Proporties
    //    =================
    var confirmText = ""
    var selectedDay = ""
    var selectedDate : Date!
    var selectedTime = ""
    var changePassMsg = ""
    var addAppointmentDic = [String : Any]()
    var cancelAppointmentDic = [String : Any]()
    var openConfirmVCFor : OpenTheConfirmationVCFor = .appointmentCancellation
    var openConfirmVCForChangePass : OpenTheConfirmationVCForChangePass = .none
    var indexPath: IndexPath?
    weak var delegate : AppointmentCancellationDelegate?
    weak var deleteReminderDelegate: DeleteReminderDelegate?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var confirmationPopUpView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationText: UILabel!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.animatePopUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.confirmationPopUpView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.confirmationPopUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: nil)
    }
    
    //    MARK:- IBActions
    //    =================
    @IBAction func cancelBtnActn(_ sender: UIButton) {
        self.removePopupView(isCancelButtonTapped: false)
    }
    
    @IBAction func confirmBtnActn(_ sender: UIButton) {
        if self.openConfirmVCFor == .appointmentCancellation {
            self.cancelAppointment()
        }else if self.openConfirmVCFor == .appointmentConfirmation{
            self.addAppointment()
        }else if self.openConfirmVCFor == .changePassword{
            self.removePopupView()
        }else if self.openConfirmVCFor == .changeMobileNumber{
            self.removePopupView()
        }else if self.openConfirmVCFor == .logout{
            self.logout()
        }else if self.openConfirmVCFor == .deleteReminder{
            self.deleteReminderDelegate?.deleteReminder(indexPath!)
            self.removePopupView()
        }else if self.openConfirmVCFor == .icloudPermission{
            self.removePopupView()
        }else{
            self.rescheduleAppointment()
        }
    }
}

//MARK:- Methods
//==============
extension ConfirmationVC {
    
    fileprivate func setupUI(){
        
        self.confirmationPopUpView.layer.cornerRadius = 4.3
        self.confirmationPopUpView.clipsToBounds = true
        
        self.confirmationLabel.textColor = UIColor.appColor
        self.confirmationLabel.text = K_CONFIRMATION_BUTTON.localized.capitalized
        self.confirmationLabel.font = AppFonts.sansProBold.withSize(15.7)
        
        self.cancelBtnOutlet.backgroundColor = #colorLiteral(red: 0.5137254902, green: 0.5137254902, blue: 0.5137254902, alpha: 1)
        self.cancelBtnOutlet.setTitle(K_CONFIRMATION_CANCEL_BUTTTON.localized, for: .normal)
        self.cancelBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.8)
        self.cancelBtnOutlet.layer.cornerRadius = 2.5
        self.cancelBtnOutlet.clipsToBounds = true
        
        self.confirmBtnOutlet.backgroundColor = UIColor.appColor
        self.confirmBtnOutlet.setTitle(K_CONFIRM_BUTTON.localized, for: .normal)
        self.confirmBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.8)
        self.confirmBtnOutlet.layer.cornerRadius = 2.5
        self.confirmBtnOutlet.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        
        switch self.openConfirmVCFor {
            
        case .appointmentConfirmation:
            self.appointmentConfirmationText(attributeString: K_BOOK_APPOINTMENT_CONFIRMATION.localized)
        
        case .rescheduleAppointment:
            let text = K_BOOK_APPOINTMENT_CONFIRMATION.localized.replacingOccurrences(of: "book", with: K_RESCHEDULE_STATUS.localized.lowercased())
            self.appointmentConfirmationText(attributeString: text)
            
        case .changePassword:
            
            if self.openConfirmVCForChangePass == .email{
                self.confirmationText.text = K_CHANGE_PASSWORD_CONFIRMATION_TEXT.localized
            }else if self.openConfirmVCForChangePass == .mobile{
                self.confirmationText.text = self.changePassMsg.localized
            }
            
            self.confirmationText.font = AppFonts.sansProRegular.withSize(15.7)
            self.confirmationLabel.isHidden = false
            self.confirmationLabel.text = K_CONFIRMATION.localized.capitalized
            self.cancelBtnOutlet.isHidden = true
            self.confirmBtnOutlet.setTitle(K_OK_TITLE.localized, for: .normal)
        case .changeMobileNumber:
            self.confirmationText.text = K_OTP_SEND_OLD_NUMBER.localized
            self.cancelBtnOutlet.isHidden = true
            self.confirmBtnOutlet.setTitle(K_OK_TITLE.localized, for: .normal)
        case .logout:
            self.confirmationText.text = K_LOG_OUT_CONFIRMATION.localized
            self.cancelBtnOutlet.isHidden = false
            self.confirmBtnOutlet.setTitle(K_OK_TITLE.localized, for: .normal)
            
        case .deleteReminder:
            self.confirmationText.text = K_DELETE_REMINDER_CONFIRMATION.localized
            self.cancelBtnOutlet.isHidden = false
            self.confirmBtnOutlet.setTitle(K_OK_TITLE.localized, for: .normal)
            
        case .icloudPermission:
            self.cancelBtnOutlet.isHidden = true
            self.confirmationText.text = "Tap on OK button to enable the iCloud Permision from device settings."
            self.confirmBtnOutlet.setTitle(K_OK_TITLE.localized, for: .normal)
            
        default:
            self.confirmationText.font = AppFonts.sansProRegular.withSize(15.7)
            self.confirmationText.text = self.confirmText
        }
    }
    
    fileprivate func appointmentConfirmationText(attributeString: String){

        var dayString = ""
        let date = self.selectedDate.stringFormDate(.dMMMyyyy)
        dayString = "\(self.selectedDay) \(date) \(self.selectedTime)?"
        
        let attributes = [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(15.7)]
        let dayAttributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(13.5)]
        let attributedString = NSMutableAttributedString(string: attributeString, attributes: attributes)
        let datAttributedString = NSAttributedString(string: dayString, attributes: dayAttributes)
        attributedString.append(datAttributedString)
        self.confirmationText.attributedText = attributedString
    }
    
    fileprivate func animatePopUpView(){
        self.confirmationPopUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.confirmationPopUpView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    fileprivate func removePopupView(isCancelButtonTapped: Bool = false){
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmationPopUpView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: { (true) in
            self.view.removeFromSuperview()
            if self.openConfirmVCFor == .appointmentCancellation {
                if isCancelButtonTapped{
                    self.delegate?.appointmentCancellation()
                }
                self.removeFromParentViewController()
            }else if self.openConfirmVCFor == .changeMobileNumber{
                let enterOtpScene = EnterOTPToLoginVC.instantiate(fromAppStoryboard: .Main)
                enterOtpScene.procceedToScreenThrough = .changeMobileNumber
                enterOtpScene.phoneNumberDic["country_code"] = self.addAppointmentDic["country_code"]
                enterOtpScene.phoneNumberDic["mobile_number"] = AppUserDefaults.value(forKey: .patientMobileNumber).stringValue
                guard let parentVC = self.parent else{
                    return
                }
                guard let nvc = parentVC.navigationController else{
                    return
                }
                nvc.pushViewController(enterOtpScene, animated: true)
                self.removeFromParentViewController()
            }else{
                self.removeFromParentViewController()
                NotificationCenter.default.post(name: .changePassNotification, object: nil)
            }
        })
    }
}
//MARk:- WebServices
//==================
extension ConfirmationVC {
    fileprivate func addAppointment(){
        
        self.addAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        WebServices.addAppointment(parameters: self.addAppointmentDic,
                                   success: {[weak self] (_ str : String) in
                                    
                                    guard let confirmationVC = self else {
                                        return
                                    }
                                    
                                    let appointmentBookedScene = AppointmentBookSuccessfullyVC.instantiate(fromAppStoryboard: .AppointMent)
                                    appointmentBookedScene.selectedDate = confirmationVC.selectedDate
                                    appointmentBookedScene.selectedTime = confirmationVC.selectedTime
                                    appointmentBookedScene.selectedDay = confirmationVC.selectedDay
                                    appointmentBookedScene.delegate = confirmationVC.parent as! AddAppointmentVC
                                    AppDelegate.shared.window?.addSubview(appointmentBookedScene.view)
                                    confirmationVC.parent?.addChildViewController(appointmentBookedScene)
                                    confirmationVC.removePopupView()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func cancelAppointment(){
        
        self.cancelAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        WebServices.cancelAppointment(parameters: self.cancelAppointmentDic,
                                      success: {[weak self] (str : String) in
                                        
                                        guard let confirmationVC = self else {
                                            return
                                        }
                                        confirmationVC.removePopupView(isCancelButtonTapped: true)
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func rescheduleAppointment(){
        self.addAppointmentDic["id"] = AppUserDefaults.value(forKey: .userId)
        
        WebServices.rescheduleAppointment(parameters: self.addAppointmentDic,
                                          success: {[weak self] (str : String) in
                                            
                                            guard let confirmationVC = self else {
                                                return
                                            }
                                            
                                            let appointmentBookedScene = AppointmentBookSuccessfullyVC.instantiate(fromAppStoryboard: .AppointMent)
                                            appointmentBookedScene.selectedDate = confirmationVC.selectedDate
                                            appointmentBookedScene.selectedTime = confirmationVC.selectedTime
                                            appointmentBookedScene.selectedDay = confirmationVC.selectedDay
                                            appointmentBookedScene.delegate = confirmationVC.parent as! AddAppointmentVC
                                            AppDelegate.shared.window?.addSubview(appointmentBookedScene.view)
                                            confirmationVC.parent?.addChildViewController(appointmentBookedScene)
                                            confirmationVC.removePopupView()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func logout(){
        
        var param = [String: Any]()
        param["id"] = AppUserDefaults.value(forKey: .userId).stringValue
        WebServices.logout(parameters: param, success: {[weak self](_ message: String) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.removePopupView()
            AppDelegate.shared.goToLoginOption()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
