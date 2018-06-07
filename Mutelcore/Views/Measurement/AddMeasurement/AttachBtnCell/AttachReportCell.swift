//
//  AttachReportCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AttachReportCell: UITableViewCell {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var attachReportBtnOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.attachReportBtnOutlt.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.attachReportBtnOutlt.setTitle("Attach Report", for: UIControlState.normal)
        self.attachReportBtnOutlt.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.attachReportBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
