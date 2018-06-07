//
//  NoUpcomingAppointmentCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 09/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NoUpcomingAppointmentCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
    }

}
