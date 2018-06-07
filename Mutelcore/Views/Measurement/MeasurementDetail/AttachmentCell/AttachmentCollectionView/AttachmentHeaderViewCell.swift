//
//  HeaderView.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AttachmentHeaderViewCell: UITableViewHeaderFooterView {

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var headerLabelLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTitle.font  = AppFonts.sanProSemiBold.withSize(15.8)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dropDownBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}
