//
//  UpcomingAppintmentCell.swift
//  Mutelcor
//
//  Created by  on 01/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class UpcomingAppointmentsCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet weak var appointmentDate: UILabel!
    @IBOutlet weak var appointmentMonth: UILabel!
    @IBOutlet weak var appointmentTime: UILabel!
    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var visitTypeImage: UIImageView!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var symptoms: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var rescheduleBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        rescheduleBtn.removeTarget(nil, action: nil, for: .allEvents)
        cancelBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}

extension UpcomingAppointmentsCell {
    
   fileprivate func setupUI(){
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.contentView.backgroundColor = UIColor.headerColor
        
        self.appointmentTime.font = AppFonts.sanProSemiBold.withSize(12.5)
        
        self.appointmentStatus.font = AppFonts.sanProSemiBold.withSize(12.5)
        self.appointmentStatus.layer.cornerRadius =  self.appointmentStatus.frame.height / 2
        self.appointmentStatus.clipsToBounds = true
        
        self.doctorName.font = AppFonts.sanProSemiBold.withSize(15)
        
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(12.5)
        self.doctorSpeciality.textColor = #colorLiteral(red: 0.003921568627, green: 0, blue: 0, alpha: 1)
        
        self.symptoms.font = AppFonts.sanProSemiBold.withSize(12)
        self.symptoms.textColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        
        self.descriptionText.font = AppFonts.sansProRegular.withSize(12)
        
    }
}
extension UpcomingAppointmentsCell {
    
    func populateData(_ upcomingAppointment : [UpcomingAppointmentModel],_ index : IndexPath){
        guard !upcomingAppointment.isEmpty else{
            return
        }
        self.cancelBtn.setTitle(K_CANCEL_BUTTON.localized.uppercased(), for: .normal)
        self.cancelBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancel"), for: .normal)
        self.cancelBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.5)
        self.cancelBtn.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1), for: .normal)
        
        self.rescheduleBtn.setTitle(K_RESCHEDULE_STATUS.localized.uppercased(), for: .normal)
        self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentReschedule"), for: .normal)
        self.rescheduleBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.5)
        self.rescheduleBtn.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1), for: .normal)
        if let date = upcomingAppointment[index.row].appointmentDate {
            let dat = date.stringFormDate(.DD)
            let dateAttributes = [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(29.5)]
            self.appointmentDate.attributedText = NSAttributedString(string: dat, attributes: dateAttributes)
            
            let month  = date.stringFormDate(.mmYYYY)
            let monthAttributes = [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(13.5)]
            self.appointmentMonth.attributedText = NSAttributedString(string: month, attributes: monthAttributes)
        }else{
            self.appointmentDate.text = ""
            self.appointmentMonth.text = ""
        }
        
        let startTime  = upcomingAppointment[index.row].appointmentStartTime ?? ""
        let endTime = upcomingAppointment[index.row].appointmentEndTime ?? ""
        
        if !startTime.isEmpty && !endTime.isEmpty {
            self.appointmentTime.text = "\(startTime) - \(endTime)"
        }else if !startTime.isEmpty && endTime.isEmpty{
            self.appointmentTime.text = startTime
        }else if startTime.isEmpty && !endTime.isEmpty{
            self.appointmentTime.text = endTime
        }else{
            self.appointmentTime.text = ""
        }
        
        if let appointmentSeverity = upcomingAppointment[index.row].appointmentSeverity{
            switch appointmentSeverity{
            case 0:
            self.appointmentStatus.text = K_ROUTINE_STATUS.localized
            self.appointmentStatus.backgroundColor = UIColor.appColor
            case 1:
            self.appointmentStatus.text = K_EMERGENCY_STATUS.localized
            self.appointmentStatus.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
            default:
                return
                
            }
        }
        
        if let appointmentType = upcomingAppointment[index.row].appointmentType{
            let image = (appointmentType == 0) ? #imageLiteral(resourceName: "ic_routine") : #imageLiteral(resourceName: "ic_emergency")
            self.visitTypeImage.image = image
        }
                
        self.doctorName.text = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        
        self.descriptionText.text = upcomingAppointment[index.row].appointmentSpecify
        
        if let symptoms = upcomingAppointment[index.row].appointmentSymptoms{
          self.symptoms.text = K_SYMPTOMS_TITLE.localized + ": " + symptoms
        }
    }
    
    func populatDataForHistoryCell(_ appointmentHistory : [UpcomingAppointmentModel], _ index : IndexPath){
        
        self.rescheduleBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
        
        guard !appointmentHistory.isEmpty else{
            return
        }
        if let date = appointmentHistory[index.row].appointmentDate {
            
            let dat = date.stringFormDate(.DD)
            let dateAttributes = [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(29.5)]
            self.appointmentDate.attributedText = NSAttributedString(string: dat, attributes: dateAttributes)
            
            let month  = date.stringFormDate(.mmYYYY)
            let monthAttributes = [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(13.5)]
            self.appointmentMonth.attributedText = NSAttributedString(string: month, attributes: monthAttributes)
        }else{
            self.appointmentMonth.text = ""
            self.appointmentDate.text = ""
        }
        
        let startTime = appointmentHistory[index.row].appointmentStartTime ?? ""
        let endTime = appointmentHistory[index.row].appointmentEndTime ?? ""
        
        if !startTime.isEmpty && !endTime.isEmpty {
            self.appointmentTime.text = "\(startTime) - \(endTime)"
        }else if !startTime.isEmpty && endTime.isEmpty{
            self.appointmentTime.text = startTime
        }else if startTime.isEmpty && !endTime.isEmpty{
            self.appointmentTime.text = endTime
        }else{
            self.appointmentTime.text = ""
        }
        
        if let appointmentStatus = appointmentHistory[index.row].appointmentStatus{
            
            switch appointmentStatus {
                
            case 0: self.rescheduleBtn.setTitle(K_PENDING_STATUS.localized.uppercased(), for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            case 1: self.rescheduleBtn.setTitle(K_APPROVED_STATUS.localized.uppercased(), for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            case 2: self.rescheduleBtn.setTitle(K_ATTENDED_STATUS.localized.uppercased(), for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCompletedGreen"), for: .normal)
            self.rescheduleBtn.setTitleColor(UIColor.appColor, for: .normal)
                
            case 3: self.rescheduleBtn.setTitle(K_RESCHEDULED_STATUS.localized.uppercased(), for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentRescheduleBlue"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.9960784314, alpha: 1), for: .normal)
                
            case 4: self.rescheduleBtn.setTitle(K_CANCELLED_STATUS.localized.uppercased(), for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            default: return
            }
        }
        
        if let appointmentSeverity = appointmentHistory[index.row].appointmentSeverity{
            switch appointmentSeverity{
            case 0:
                self.appointmentStatus.text = K_ROUTINE_STATUS.localized
                self.appointmentStatus.backgroundColor = UIColor.appColor
            case 1:
                self.appointmentStatus.text = K_EMERGENCY_STATUS.localized
                self.appointmentStatus.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
            default:
                return
            }
        }
        
        if let appointmentType = appointmentHistory[index.row].appointmentType{
            let image = (appointmentType == 0) ? #imageLiteral(resourceName: "ic_routine") : #imageLiteral(resourceName: "ic_emergency")
            self.visitTypeImage.image = image
        }
        self.doctorName.text = AppUserDefaults.value(forKey: .doctorName).stringValue
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        self.descriptionText.text = appointmentHistory[index.row].appointmentSpecify
        if let symptoms = appointmentHistory[index.row].appointmentSymptoms {
            self.symptoms.text = K_SYMPTOMS_TITLE.localized + ": " + symptoms
        }
    }
}
