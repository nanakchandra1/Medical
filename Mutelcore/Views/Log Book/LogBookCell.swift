//
//  LogBookCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 03/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class LogBookCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageOult: UIImageView!
    @IBOutlet weak var logsAmmountOutlt: UILabel!
    @IBOutlet weak var logsNameLabelOutlt: UILabel!
    @IBOutlet weak var dateLabelOutlt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.logsNameLabelOutlt.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.logsNameLabelOutlt.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        self.dateLabelOutlt.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.dateLabelOutlt.textColor = UIColor.grayLabelColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
