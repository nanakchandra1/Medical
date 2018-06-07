//
//  GenderDetailCell.swift
//  Mutelcore
//
//  Created by Ashish on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class GenderDetailCell: UITableViewCell {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        self.maleLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.femaleLabel.font = AppFonts.sanProSemiBold.withSize(16)
        
    }
}


