//
//  SettingCellTableViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 13/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var CellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.CellTitle.font = AppFonts.sanProSemiBold.withSize(15)
        self.CellTitle.textColor = UIColor.textColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
