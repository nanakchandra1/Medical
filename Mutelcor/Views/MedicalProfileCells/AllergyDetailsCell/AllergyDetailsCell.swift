//
//  AllergyDetailsCell.swift
//  Mutelcor
//
//  Created by on 05/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AllergyDetailsCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var cellTextFieldTitle: UILabel!
    @IBOutlet weak var celltextField: UITextField!
    @IBOutlet weak var severityTextFieldTitle: UILabel!
    @IBOutlet weak var severitytextField: UITextField!
    @IBOutlet weak var addSeverityButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTextFieldTitle.font = AppFonts.sansProRegular.withSize(16)
        self.severityTextFieldTitle.font = AppFonts.sansProRegular.withSize(16)
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.severitytextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellTextFieldTitle.textColor = UIColor.appColor
        self.severityTextFieldTitle.textColor = UIColor.appColor
        self.addSeverityButton.setImage(#imageLiteral(resourceName: "icAdd"), for: .normal)
        self.severitytextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "icAppointmentDownarrow"))
        self.severitytextField.rightViewMode = .always
    }
}
