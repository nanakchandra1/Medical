//
//  EmailCellTableViewCell.swift
//  Mutelcore
//
//  Created by Ashish on 22/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    
    @IBOutlet weak var cellTitle: UIButton!
    @IBOutlet weak var celltextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        self.cellTitle.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        celltextField.text = ""
    }
}

//MARK:- Data Populate on Cell
//============================
extension EmailCell {
    
    func populateData(_ userInfo : UserInfo){
        
        if !(userInfo.patientEmail?.isEmpty)! {
            
            self.celltextField.text = userInfo.patientEmail ?? ""
            self.celltextField.textColor = #colorLiteral(red: 0.003921568627, green: 0, blue: 0, alpha: 1)
            
        }
    }
}
