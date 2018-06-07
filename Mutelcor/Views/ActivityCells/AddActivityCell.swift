//
//  AddActivityCell.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AddActivityCell: UITableViewCell {

    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var addActivityBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.addActivityBtn.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 2.0)
        self.addActivityBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.addActivityBtn.setTitle("Add Activity", for: UIControlState.normal)
        self.addActivityBtn.setImage(#imageLiteral(resourceName: "icActivityplanAdd"), for: UIControlState.normal)
        self.addActivityBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13)
    }
}
