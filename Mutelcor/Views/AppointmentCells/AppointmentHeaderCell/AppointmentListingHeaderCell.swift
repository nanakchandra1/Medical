//
//  AppointmentListingHeaderCell.swift
//  Mutelcor
//
//  Created by on 31/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AppointmentListingHeaderCell: UICollectionReusableView {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitle.textColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
        self.cellTitle.font = AppFonts.sanProSemiBold.withSize(13.5)
        self.backgroundColor = UIColor.headerColor
        self.addBtnOutlet.isHidden = true
    }
}
