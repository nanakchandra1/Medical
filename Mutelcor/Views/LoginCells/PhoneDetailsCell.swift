//
//  PhoneDetailsCell.swift
//  Mutelcor
//
//  Created by on 08/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PhoneDetailsCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var stackViewLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    func populateMobileNumber(_ userInfo : UserInfo?, indexPath: IndexPath){
        
        self.phoneNumberTextField.keyboardType = .numberPad
        self.countryCodeTextField.placeholder = K_COUNTRY_CODE_PLACEHOLDER.localized
        self.phoneNumberTextField.placeholder = K_PHONE_NUMBER_PLACEHOLDER.localized
        let isTextFieldEnabled = (indexPath.section == 0 && indexPath.row == 4) ? false : true
        let textColor = (indexPath.section == 0 && indexPath.row == 4) ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.black

        self.phoneNumberTextField.textColor = textColor
        self.phoneNumberTextField.isEnabled = isTextFieldEnabled
        self.countryCodeTextField.isEnabled = isTextFieldEnabled
        self.countryCodeBtn.isEnabled = isTextFieldEnabled
        self.countryCodeTextField.textColor = textColor
        guard let userData = userInfo else{
            return
        }
        let countryCode = (indexPath.section == 0 && indexPath.row == 4) ? userData.countryCode : userData.emergencyCountryCode
        let phoneNumber = (indexPath.section == 0 && indexPath.row == 4) ? userData.patientMobileNumber : userData.emergencyConatctNumber
        self.countryCodeTextField.text = countryCode
        self.phoneNumberTextField.text = phoneNumber
    }
}
