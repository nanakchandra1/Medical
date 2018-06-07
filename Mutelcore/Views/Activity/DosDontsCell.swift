//
//  DosDontsCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DosDontsCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var bulletsView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DosDontsCell {
    
    fileprivate func setupUI(){
        
        self.bulletsView.roundCorner(radius: self.bulletsView.frame.width / 2, borderColor: UIColor.clear, borderWidth: CGFloat(0))
        self.bulletsView.backgroundColor = UIColor.appColor
        self.cellTitleLabel.font = AppFonts.sanProSemiBold.withSize(13.6)
    }
}
