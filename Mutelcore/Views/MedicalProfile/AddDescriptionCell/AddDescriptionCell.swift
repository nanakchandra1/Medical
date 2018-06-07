//
//  AddDescriptionCell.swift
//  Mutelcore
//
//  Created by Ashish on 21/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AddDescriptionCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
}
extension AddDescriptionCell {
    
    func populateData(_ index : IndexPath , _ userInfo : UserInfo){

        guard !userInfo.medicalInfo.isEmpty else{
            
            return
        }
        
        switch index.section{
            
        case 4: self.descriptionTextField.text = userInfo.medicalCategoryInfo[0].patientAllergy
            
        case 5: self.descriptionTextField.text = userInfo.medicalCategoryInfo[0].familyAllergy
            
        case 6: self.descriptionTextField.text = userInfo.medicalCategoryInfo[0].previousAllergy
            
        default: fatalError("Cell Not Found!")
            
        }
    }
}
