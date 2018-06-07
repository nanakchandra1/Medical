//
//  SelectDateCell.swift
//  Mutelcor
//
//  Created by on 19/04/17.
//  Copyright © 2017. All rights reserved.
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
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectDateTextField.text = ""
        self.selectTimeTextField.text = ""
    }
}

extension SelectDateCell {
    
    fileprivate func setupUI(){
        
        self.selectDateTextField.tintColor = UIColor.white
        self.selectTimeTextField.tintColor = UIColor.white
        self.selectDateLabel.font = AppFonts.sansProRegular.withSize(16)
        self.selectTimeLabel.font = AppFonts.sansProRegular.withSize(16)
        self.selectDateLabel.textColor = UIColor.appColor
        self.selectTimeLabel.textColor = UIColor.appColor
        
        self.selectDateTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.selectTimeTextField.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.selectDateLabel.text  = K_DATE_TEXT.localized
        self.selectTimeLabel.text = K_TIME_TEXT.localized
        
        self.selectDateTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        self.selectDateTextField.rightViewMode = UITextFieldViewMode.always
        
        self.selectTimeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        self.selectTimeTextField.rightViewMode = UITextFieldViewMode.always
    }
    
    func populateTimelineData(timeLineData : AddTimelineData?){
       
        self.selectDateTextField.borderStyle = .none
        self.selectTimeTextField.borderStyle = .none
        
        guard let data = timeLineData else{
            return
        }
        
        self.selectDateTextField.text = data.date.stringFormDate(.ddMMMYYYY)
        self.selectTimeTextField.text = data.time.stringFormDate(.Hmm)
    }
    
    func populateActivityData(dic: [String: Any]){
        
        self.selectDateLabel.text  = K_DATE_TEXT.localized
        self.selectTimeLabel.text = K_TIME_TEXT.localized
        self.selectDateTextField.borderStyle = UITextBorderStyle.none
        self.selectTimeTextField.borderStyle = UITextBorderStyle.none
        
        if let date = dic["activity_date"] as? Date {
            self.selectDateTextField.text = date.stringFormDate(.ddMMMYYYY)
        }
        if let time = dic["activity_time"] as? Date {
            self.selectTimeTextField.text = time.stringFormDate(.Hmm)
        }
        
    }
}
