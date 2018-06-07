//
//  HeaderView.swift
//  Mutelcor
//
//  Created by on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AttachmentHeaderViewCell: UITableViewHeaderFooterView {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var headerLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerTitle.font  = AppFonts.sanProSemiBold.withSize(15.8)
        self.contentView.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.dropDownBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}
