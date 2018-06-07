//
//  UpcomingAppintmentCell.swift
//  Mutelcore
//
//  Created by Ashish on 01/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class UpcomingAppointmentsCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    
    
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
        // Initialization code
        
        self.setUi()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
}

extension UpcomingAppointmentsCell {
    
    func setUi(){
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.clipsToBounds = true
        
        self.appointmentTime.font = AppFonts.sanProSemiBold.withSize(11.5)
        
        self.appointmentStatus.font = AppFonts.sanProSemiBold.withSize(11.5)
        self.appointmentStatus.layer.cornerRadius =  self.appointmentStatus.frame.height / 2
        self.appointmentStatus.clipsToBounds = true
        
        self.doctorName.font = AppFonts.sanProSemiBold.withSize(14)
        
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(11.5)
        self.doctorSpeciality.textColor = #colorLiteral(red: 0.003921568627, green: 0, blue: 0, alpha: 1)
        
        self.symptoms.font = AppFonts.sanProSemiBold.withSize(11)
        self.symptoms.textColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        
        self.descriptionText.font = AppFonts.sansProRegular.withSize(11)
        
    }
}
extension UpcomingAppointmentsCell {
    
    func populateData(_ upcomingAppointment : [UpcomingAppointmentModel],_ index : IndexPath){
        
        self.cancelBtn.setTitle("Cancel", for: .normal)
        self.cancelBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancel"), for: .normal)
        self.cancelBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.5)
        self.cancelBtn.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1), for: .normal)
        
        self.rescheduleBtn.setTitle("Reschedule", for: .normal)
        self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentReschedule"), for: .normal)
        self.rescheduleBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.5)
        self.rescheduleBtn.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1), for: .normal)

        guard !upcomingAppointment.isEmpty else{
            
            return
        }
        if let date = upcomingAppointment[index.row].appointmentDate {
            
            if let dat = date.stringFormDate(DateFormat.DD.rawValue){
                
                let dateAttributes = [NSFontAttributeName : AppFonts.sansProBold.withSize(29.5)]
                self.appointmentDate.attributedText = NSAttributedString(string: dat, attributes: dateAttributes)
                
            }
            if let month  = date.stringFormDate(DateFormat.mmYYYY.rawValue){
                
                let monthAttributes = [NSFontAttributeName : AppFonts.sansProBold.withSize(12.5)]
                self.appointmentMonth.attributedText = NSAttributedString(string: month, attributes: monthAttributes)
                
            }
            
        }else{
            self.appointmentDate.text = ""
            self.appointmentMonth.text = ""
        }
        
        var startTime  = ""
        var endTime = ""
        
        if  let startTim  = upcomingAppointment[index.row].appointmentStartTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
        
            startTime = startTim
        }
        if let endTim = upcomingAppointment[index.row].appointmentEndTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
            
            endTime = endTim
            
        }
        
        if !startTime.isEmpty && !endTime.isEmpty {
            
            self.appointmentTime.text = "\(startTime) - \(endTime)"
        }
        else if !startTime.isEmpty && endTime.isEmpty{
            
            self.appointmentTime.text = "\(upcomingAppointment[index.row].appointmentStartTime)"
        }
        else if startTime.isEmpty && !endTime.isEmpty{
            
            self.appointmentTime.text = "\(upcomingAppointment[index.row].appointmentEndTime)"
        }
        else{
            
            self.appointmentTime.text = ""
            
        }
        
        if let appointmentSeverity = upcomingAppointment[index.row].appointmentSeverity{
            
            switch appointmentSeverity{
                
            case 0: self.appointmentStatus.text = "Normal"
            self.appointmentStatus.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
                
                
            case 1: self.appointmentStatus.text = "Urgent"
            self.appointmentStatus.backgroundColor = UIColor.appColor
                
            default: return
                
            }
        }
        
        if let appointmentType = upcomingAppointment[index.row].appointmentType{
            
            switch appointmentType{
                
            case 0: self.visitTypeImage.image = #imageLiteral(resourceName: "icAppointmentBlackPhysical")
                
            case 1: self.visitTypeImage.image = #imageLiteral(resourceName: "icAppointmentVideo")
                
            default: return
                
            }
        }
                
        self.doctorName.text = "Dr. \(AppUserDefaults.value(forKey: .doctorName).stringValue)"
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .specification).stringValue
        
        self.descriptionText.text = upcomingAppointment[index.row].appointmentSpecify
        
        if let symptoms = upcomingAppointment[index.row].appointmentSymptoms{
            
          self.symptoms.text = "Symptoms : \(symptoms)"
        }
    }
    
    func populatDataForHistoryCell(_ appointmentHistory : [UpcomingAppointmentModel], _ index : IndexPath){
        
        self.rescheduleBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
        
        guard !appointmentHistory.isEmpty else{
            
            return
        }
        if let date = appointmentHistory[index.row].appointmentDate {
            
            if let dat = date.stringFormDate(DateFormat.DD.rawValue){
                
                let dateAttributes = [NSFontAttributeName : AppFonts.sansProBold.withSize(29.5)]
                
                
                self.appointmentDate.attributedText = NSAttributedString(string: dat, attributes: dateAttributes)
                
            }
            if let month  = date.stringFormDate(DateFormat.mmYYYY.rawValue){
                
                let monthAttributes = [NSFontAttributeName : AppFonts.sansProBold.withSize(12.5)]
                
                self.appointmentMonth.attributedText = NSAttributedString(string: month, attributes: monthAttributes)
                
            }
        }else{
            
            self.appointmentMonth.text = ""
            self.appointmentDate.text = ""
        }
        
        var startTime  = ""
        var endTime = ""
        
        if  let startTim  = appointmentHistory[index.row].appointmentStartTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
            
            startTime = startTim
        }
        if let endTim = appointmentHistory[index.row].appointmentEndTime?.timeFromStringInHours(DateFormat.HHmm.rawValue){
            
            endTime = endTim
            
        }
        
        if !startTime.isEmpty && !endTime.isEmpty {
            
            self.appointmentTime.text = "\(startTime) - \(endTime)"
        }
        else if !startTime.isEmpty && endTime.isEmpty{
            
            self.appointmentTime.text = "\(startTime)"
        }
        else if startTime.isEmpty && !endTime.isEmpty{
            
            self.appointmentTime.text = "\(startTime)"
        }
        else{
            
            self.appointmentTime.text = ""
            
        }
        
        if let appointmentStatus = appointmentHistory[index.row].appointmentStatus{
            
            switch appointmentStatus {
                
            case 0: self.rescheduleBtn.setTitle("PENDING", for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            case 1: self.rescheduleBtn.setTitle("APPROVED", for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            case 2: self.rescheduleBtn.setTitle("ATTENDED", for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCompletedGreen"), for: .normal)
            self.rescheduleBtn.setTitleColor(UIColor.appColor, for: .normal)
                
            case 3: self.rescheduleBtn.setTitle("RESCHEDULED", for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentRescheduleBlue"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.9960784314, alpha: 1), for: .normal)
                
            case 4: self.rescheduleBtn.setTitle("CANCELLED", for: .normal)
            self.rescheduleBtn.setImage(#imageLiteral(resourceName: "icAppointmentCancelledRed"), for: .normal)
            self.rescheduleBtn.setTitleColor(#colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1), for: .normal)
                
            default: return
            }
        }
        
        if let appointmentSeverity = appointmentHistory[index.row].appointmentSeverity{
            
            switch appointmentSeverity{
                
            case 0: self.appointmentStatus.text = "Normal"
            self.appointmentStatus.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
                
            case 1: self.appointmentStatus.text = "Urgent"
            self.appointmentStatus.backgroundColor = UIColor.appColor
                
            default: return
                
            }
        }
        
        if let appointmentType = appointmentHistory[index.row].appointmentType{
            
            switch appointmentType{
                
            case 0: self.visitTypeImage.image = #imageLiteral(resourceName: "icAppointmentBlackPhysical")
                
            case 1: self.visitTypeImage.image = #imageLiteral(resourceName: "icAppointmentVideo")
                
            default: return
                
            }
        }
        
        self.doctorName.text = "Dr. \(AppUserDefaults.value(forKey: .doctorName).stringValue)"
        self.doctorSpeciality.text = AppUserDefaults.value(forKey: .specification).stringValue
        
        self.descriptionText.text = appointmentHistory[index.row].appointmentSpecify
        
        if let symptoms = appointmentHistory[index.row].appointmentSymptoms {
            
          self.symptoms.text = "Symptoms: \(symptoms)"
        }
    }
}
