//
//  SymptomsCell.swift
//  Mutelcor
//
//  Created by on 13/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SymptomsCell: UITableViewCell {
    
//    MARk:- IBOutlets
//    =================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var symptoms: UILabel!
    @IBOutlet weak var addSymptomsBtn: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.symptoms.text = ""
        self.cellTitle.textColor = UIColor.appColor
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.symptoms.font = AppFonts.sanProSemiBold.withSize(16)
    }
}
