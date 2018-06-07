//
//  PhoneNumberCell.swift
//  Mutelcore
//
//  Created by Ashish on 21/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PhoneNumberCell: UITableViewCell {
    
    var adhaarNumber = ""
    
    
//    MARK:- IBOutlets
//    =================
    
    @IBOutlet weak var cellTitleBtn: UIButton!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellTitleBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
        self.cellTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellTitleBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.sepratorView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

    }
}

//MARK:- Populate Data on Cell
//=============================
extension PhoneNumberCell {
    
    func populateDataForNumber(_ userInfo : UserInfo){
        
        guard !(userInfo.patientMobileNumber?.isEmpty)! else{
            
            self.cellTextField.text = ""
            return
        }
        self.cellTextField.text = userInfo.patientMobileNumber
        self.cellTextField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.cellTextField.isEnabled = false
        
    }
    
    func populateDataForAdhaarCardNumber(_ userInfo : UserInfo) {
        
        if let adhaarnumber = userInfo.patientNationalId {
            
            if !adhaarnumber.isEmpty {
                
                self.adhaarNumber = adhaarnumber
               
//                self.adhaarNumber.insert("-", at: adhaarnumber.index(adhaarNumber.startIndex, offsetBy: 4))
//                printlnDebug(self.adhaarNumber)
//                self.adhaarNumber.insert("-", at: adhaarnumber.index(adhaarnumber.startIndex, offsetBy: 8))
//                printlnDebug(self.adhaarNumber)
                self.cellTextField.text = self.adhaarNumber
                
            }else{
                
              self.cellTextField.text = ""
            }
        }
    }
}
