//
//  AppointmentDateTime.swift
//  Mutelcor
//
//  Created by  on 26/04/17.
//  Copyright © 2017. All rights reserved.
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
        self.appointmentDateTextField.tintColor = UIColor.white
        self.apppointmentTimeTextField.tintColor = UIColor.white
        self.appointmentDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        self.appointmentDateTextField.rightViewMode = .always
        self.apppointmentTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        self.apppointmentTimeTextField.rightViewMode = .always
        
        self.appointmentDateLabel.textColor = UIColor.appColor
        self.appointmentTimeLabel.textColor = UIColor.appColor
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
