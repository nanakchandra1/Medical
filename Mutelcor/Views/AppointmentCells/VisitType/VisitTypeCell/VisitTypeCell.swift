//
//  VisittypeCell.swift
//  Mutelcor
//
//  Created by  on 27/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VisitTypeCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var apppointmentScheduleLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var visitTypeTextFieldBtn: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.visitTypeTextFieldBtn.isHidden = true
        self.cellTitle.textColor = UIColor.appColor
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
    }
    func populateApppointmentTypeData(_ appointmentType : Int, visitTypeArray : [[Any]]){
        
        switch appointmentType {
        case 0:
            self.cellTextField.text = visitTypeArray[1][1] as? String
        case 1:
            self.cellTextField.text = visitTypeArray[0][1] as? String
        default :
            return
        }
    }
    
    func populateAppointmentScheduleData(_ proceedToScreen : AppointmentScreenThrough, upcomingAppointment : [UpcomingAppointmentModel]){
        
        switch proceedToScreen {
        case .addAppointment :
            self.apppointmentScheduleLabel.isHidden = true
        case .reschedule :
            self.apppointmentScheduleLabel.isHidden = false
            guard !upcomingAppointment.isEmpty else{
                return
            }
            
            if let appointmentDate = upcomingAppointment[0].appointmentDate{
                let date = appointmentDate.stringFormDate(.dMMMyyyy)
                let startTime = upcomingAppointment[0].appointmentStartTime ?? ""
                self.apppointmentScheduleLabel.text = "Appointment already schedule for \(date) at \(startTime)"
            }else{
                self.apppointmentScheduleLabel.isHidden = true
            }
        }
    }
}

