//
//  VisittypeCell.swift
//  Mutelcore
//
//  Created by Ashish on 27/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.visitTypeTextFieldBtn.isHidden = true
        self.cellTitle.textColor = UIColor.appColor
        self.cellTitle.font = AppFonts.sanProSemiBold.withSize(16)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
