//
//  HeightCell.swift
//  Mutelcor
//
//  Created by  on 21/03/17.
//  Copyright © 2017. All rights reserved.
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
        
        
        self.unitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        self.unitTextField.rightViewMode = .always
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        measurementTextField.isUserInteractionEnabled = true
    }
}

extension WeightCell {
    
    func populateData(userInfo : UserInfo?, weightUnitArray : [String], waistUnitArray: [String], indexPath: IndexPath){
        
        self.unitTextField.textColor = UIColor.black
        self.measurementTextField.keyboardType = .numberPad
        self.measurementTextField.placeholder = "\(false.rawValue)"
        let isTextFieldEnabled = (indexPath.row == 4 || indexPath.row == 5) ? false : true
        self.unitTextField.isEnabled = isTextFieldEnabled
        let placeholder = (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) ? K_KG_PLACEHOLDER.localized : K_FEET_PLACEHOLDER.localized
        self.unitTextField.placeholder = placeholder
        
        guard let userData = userInfo else{
            return
        }
        guard let userMedicalInfo = userData.medicalInfo.first, !userData.medicalInfo.isEmpty else{
            return
        }

        var unit = ""
        var value = ""
        switch indexPath.row{
        case 3:
            let weightType = userMedicalInfo.patientWeightType ?? 0
            unit = (weightType == false.rawValue) ? weightUnitArray[0] : weightUnitArray[1]
            if let weight = userMedicalInfo.patientWeight {
                value = "\(weight)"
            }
        case 4:
            
            let weightType = userMedicalInfo.idealWeightType ?? 0
            unit = (weightType == false.rawValue) ? weightUnitArray[0] : weightUnitArray[1]
            if let weight = userMedicalInfo.patientIdealWeight, weight != 0 {
                value = "\(weight)"
            }
        case 5:
            let weightType = userMedicalInfo.excessWeightType ?? 0
            unit = (weightType == false.rawValue) ? weightUnitArray[0] : weightUnitArray[1]
            if let weight = userMedicalInfo.patientExcessWeight {
                value = "\(weight)"
            }
        case 6:
            let weightType = userMedicalInfo.patientMaximumWeightAchievedType ?? 0
            unit = (weightType == true.rawValue) ? weightUnitArray[0] : weightUnitArray[1]
            if let weight = userMedicalInfo.patientMaximumWeightAchieved {
                value = "\(weight)"
            }
        case 7:
            let weightType = userMedicalInfo.maximumWeightLossType ?? 0
            unit = (weightType == true.rawValue) ? weightUnitArray[0] : weightUnitArray[1]
            if let weight = userMedicalInfo.patientMaximumWeightLoss {
                value = "\(weight)"
            }
        case 9:
            let weightType = userMedicalInfo.waistCircumference ?? 0
            unit = (weightType == false.rawValue) ? waistUnitArray[0] : waistUnitArray[1]
            if let weight = userMedicalInfo.waistCircumferenceValue {
                value = "\(weight)"
            }
        case 10:
            let weightType = userMedicalInfo.hipCircumference ?? 0
            unit = (weightType == false.rawValue) ? waistUnitArray[0] : waistUnitArray[1]
            if let weight = userMedicalInfo.hipCircumferenceValue {
                value = "\(weight)"
            }
        default:
            return
        }
        self.unitTextField.text = unit
        self.measurementTextField.text = value
    }
}
