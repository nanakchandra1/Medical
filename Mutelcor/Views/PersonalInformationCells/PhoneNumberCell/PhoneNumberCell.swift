//
//  PhoneNumberCell.swift
//  Mutelcor
//
//  Created by  on 21/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PhoneNumberCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var cellTitleBtn: UIButton!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellTitleBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
        self.cellTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellTitleBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.sepratorView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    }
}

//MARK:- Populate Data on Cell
//=============================
extension PhoneNumberCell {
    
    func populateMobileNumber(_ userInfo : UserInfo?){
        self.cellTextField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.cellTextField.isEnabled = false
        
        guard let userData = userInfo else{
            return
        }
        self.cellTextField.text = userData.patientMobileNumber 
    }

    func populatePostalCode(_ userInfo : UserInfo?){
        
        guard let userData = userInfo else{
            return
        }

        let pincode = userData.patientPostalCode
        self.cellTextField.text = pincode
        
    }
}
