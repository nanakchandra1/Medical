//
//  appointmentListingSectionCell.swift
//  Mutelcore
//
//  Created by Ashish on 01/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AppointmentListingSectionCell: UICollectionReusableView {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTitle.textColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
        self.cellTitle.font = AppFonts.sanProSemiBold.withSize(13.5)
     
        self.addBtnOutlet.isHidden = true
    }
}
