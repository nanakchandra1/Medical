//
//  AddressCell.swift
//  Mutelcore
//
//  Created by Ashish on 23/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    
    @IBOutlet weak var addressLineTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
