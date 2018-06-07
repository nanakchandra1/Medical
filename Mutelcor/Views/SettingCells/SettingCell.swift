//
//  SettingCellTableViewCell.swift
//  Mutelcor
//
//  Created by on 13/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var CellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.CellTitle.font = AppFonts.sanProSemiBold.withSize(15)
        self.CellTitle.textColor = UIColor.textColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
