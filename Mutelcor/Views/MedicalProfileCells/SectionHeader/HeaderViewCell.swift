//
//  HeaderViewCell.swift
//  Mutelcor
//
//  Created by on 09/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class HeaderViewCell: UITableViewHeaderFooterView {
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var dateTextView: UIView!
    @IBOutlet weak var MessageDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateTextView.roundCorner(radius: 3, borderColor: UIColor.clear, borderWidth: 0.0)
        self.dateTextView.backgroundColor = UIColor.appColor
        self.dateTextView.shadow(2.0, CGSize.init(width: 1.0, height: 1.0), UIColor.navigationBarShadowColor, opacity: 1.0)
        self.MessageDateLabel.textColor = UIColor.white
        self.MessageDateLabel.font = AppFonts.sansProRegular.withSize(12)
        self.contentView.backgroundColor = UIColor.white
        self.dateTextView.isHidden = true
        self.MessageDateLabel.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dateTextView.isHidden = true
        self.MessageDateLabel.isHidden = true
    }
}
