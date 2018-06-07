//
//  HypertensionCell.swift
//  Mutelcore
//
//  Created by Ashish on 24/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class HypertensionCell: UITableViewCell {
    
//    MARK:- IBOutlets
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var toogleBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        toogleBtn.setImage(#imageLiteral(resourceName: "personal_info_switch_off"), for: .normal)
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        
    }
}
