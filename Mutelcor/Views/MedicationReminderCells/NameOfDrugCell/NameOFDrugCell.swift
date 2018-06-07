//
//  NameOFDrugCell.swift
//  Mutelcor
//
//  Created by on 29/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NameOFDrugCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitleOutlt: UILabel!
    @IBOutlet weak var cellTextField: CustomTextField!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var weeklyBtnOutlt: UIButton!
    @IBOutlet weak var monthlyBtnOutlt: UIButton!
    @IBOutlet weak var verticalSpacingbtwnTextFieldAndBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitleOutlt.textColor = UIColor.appColor
        self.cellTitleOutlt.font = AppFonts.sansProRegular.withSize(15.9)
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.cellTextField.font = AppFonts.sanProSemiBold.withSize(15.9)
        self.weeklyBtnOutlt.isHidden = true
        self.monthlyBtnOutlt.isHidden = true
        self.weeklyBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        self.monthlyBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        self.weeklyBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.monthlyBtnOutlt.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellTextField.text = ""
        self.weeklyBtnOutlt.isHidden = true
        self.monthlyBtnOutlt.isHidden = true
        self.sepratorView.isHidden = false
        self.cellTextField.isHidden = false
        self.cellTitleOutlt.isHidden = false
        self.cellTitleOutlt.isHidden = false
        self.verticalSpacingbtwnTextFieldAndBtn.constant = 5
    }
    
    func populateReminderTime(reminderDic: [String: Any], indexPath: IndexPath){
        switch indexPath.row{
        case 6:
            if let time = reminderDic["reminder_time"] as? Date{
                self.cellTextField.text = time.stringFormDate(.Hmm)
            }
        case 7:
            if let time = reminderDic["reminder_time2"] as? Date{
                self.cellTextField.text = time.stringFormDate(.Hmm)
            }
        case 8:
            if let time = reminderDic["reminder_time3"] as? Date{
                self.cellTextField.text = time.stringFormDate(.Hmm)
            }
        default:
            return
        }
    }
}
