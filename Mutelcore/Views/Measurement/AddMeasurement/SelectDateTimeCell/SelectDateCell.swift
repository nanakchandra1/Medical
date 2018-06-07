//
//  SelectDateCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 19/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SelectDateCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var selectDateTextField: UITextField!
    @IBOutlet weak var selectTimeTextField: UITextField!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var selectTimeLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

//    MARK:- Cell Life Cycle
//    ======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SelectDateCell {
    
    fileprivate func setupUI(){
     
        self.selectDateLabel.font = AppFonts.sansProRegular.withSize(16)
        self.selectTimeLabel.font = AppFonts.sansProRegular.withSize(16)
        self.selectDateLabel.textColor = UIColor.appColor
        self.selectTimeLabel.textColor = UIColor.appColor
        
        self.selectDateTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.selectTimeTextField.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.selectDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        self.selectDateTextField.rightViewMode = UITextFieldViewMode.always
        
        self.selectTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        self.selectTimeTextField.rightViewMode = UITextFieldViewMode.always
        
    }
}
