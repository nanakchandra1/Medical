//
//  PhoneDetailsCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PhoneDetailsCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.countryCodeTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        self.countryCodeTextField.rightViewMode = .always
        
        self.cellTitle.textColor = UIColor.appColor
        self.countryCodeTextField.textColor = UIColor.black
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.countryCodeTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.phoneNumberTextField.font = AppFonts.sanProSemiBold.withSize(16)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
