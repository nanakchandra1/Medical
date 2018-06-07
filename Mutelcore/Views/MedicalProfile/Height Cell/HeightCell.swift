//
//  HeightCell.swift
//  Mutelcore
//
//  Created by Ashish on 24/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class HeightCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var feetTextField: UITextField!
    @IBOutlet weak var inchTextField: UITextField!
    @IBOutlet weak var inchTextFieldBottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        unitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        unitTextField.rightViewMode = .always
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
    }
    
}

extension HeightCell {
    
    func populateData(_ userInfo : UserInfo, _ heightUnit : [String]){
        
        guard !userInfo.medicalInfo.isEmpty else{
            
            return
        }
        
        if let patientHeightType = userInfo.medicalInfo[0].patientHeightType {
            
            if let patientHeight1 = userInfo.medicalInfo[0].patientHeight1 {
                
                self.feetTextField.text = "\(patientHeight1)"
                
            }else{
                
                self.feetTextField.text = ""
            }
            
            if patientHeightType == 0 {
                
                self.unitTextField.text = heightUnit[1]
                
            }else{
                
                self.unitTextField.text = heightUnit[0]
                
                if let height2 = userInfo.medicalInfo[0].patientHeight2 {
                    
                    self.inchTextField.text = "\(height2)"
                    
                }else{
                    
                    self.inchTextField.text = ""
                }
            }
            
        }else{
            
            self.feetTextField.text = ""
            
        }
    }
}
