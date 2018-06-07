//
//  ActivityPlanDateCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ActivityPlanDateCell: UITableViewHeaderFooterView {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var activityStatusLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.9254121184, green: 0.9255419374, blue: 0.9253712296, alpha: 1)
        self.activityDateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.activityDateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        self.activityStatusLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.activityStatusLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
    }
}
