//
//  NatureOFAppointmentTableViewCell.swift
//  Mutelcore
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NatureOfAppointmentCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var natureOfAppointmentLabel: UILabel!
    @IBOutlet weak var routineBtn: UIButton!
    @IBOutlet weak var emergencyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }    
}

//MARK:- Methods
//==============
extension NatureOfAppointmentCell{
    
    fileprivate func setupUI(){
        
        self.natureOfAppointmentLabel.textColor = UIColor.appColor
        self.natureOfAppointmentLabel.font = AppFonts.sansProRegular.withSize(16.0)
        self.routineBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(16.0)
        self.emergencyBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(16.0)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
}
