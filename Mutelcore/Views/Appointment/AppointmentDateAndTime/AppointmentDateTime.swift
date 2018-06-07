//
//  AppointmentDateTime.swift
//  Mutelcore
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AppointmentDateTimeCell: UITableViewCell {

//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentDateTextField: UITextField!
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    @IBOutlet weak var apppointmentTimeTextField: UITextField!
    @IBOutlet weak var appointmentTimeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.appointmentTimeBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}

//MARK:- Methods
//==============
extension AppointmentDateTimeCell {
    
    fileprivate func setupUI(){
        
        self.appointmentDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        self.appointmentDateTextField.rightViewMode = .always
        self.apppointmentTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        self.apppointmentTimeTextField.rightViewMode = .always
        
        self.appointmentDateLabel.textColor = UIColor.appColor
        self.appointmentTimeLabel.textColor = UIColor.appColor
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
}
