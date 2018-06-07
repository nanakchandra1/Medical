//
//  HeightCell.swift
//  Mutelcore
//
//  Created by Ashish on 21/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class WeightCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var measurementTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        unitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        unitTextField.rightViewMode = .always
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
    }
}

extension WeightCell {
    
    func populateData(_ userInfo : UserInfo, weightUnitArray : [String]){
        
        guard !userInfo.medicalInfo.isEmpty else{
            
            return
        }
        
        if let patientWeightType = userInfo.medicalInfo[0].patientWeightType {
            
            if patientWeightType == 0{
                
                self.unitTextField.text = weightUnitArray[1]
            }else{
                
                self.unitTextField.text = weightUnitArray[0]
            }
        }
        else {
            self.unitTextField.text = ""
        }
     
        if let patientWeight = userInfo.medicalInfo[0].patientWeight {
            
            self.measurementTextField.text = "\(patientWeight)"
        }else{
            
            self.measurementTextField.text = ""
        }
    }
}
