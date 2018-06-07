//
//  NameOFDrugCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 29/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NameOFDrugCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitleOutlt: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTitleOutlt.textColor = UIColor.appColor
        self.cellTitleOutlt.font = AppFonts.sansProRegular.withSize(15.9)
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
