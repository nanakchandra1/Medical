//
//  VisittypeCell.swift
//  Mutelcore
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class VisitTypeSelectionCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.sepratorView.isHidden = true
        self.sepratorView.backgroundColor = UIColor.sepratorColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

