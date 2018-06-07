//
//  NutritionFoodTableCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 21/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutritionFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var deleteButtonOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 10.0, *) {
            quantityTextField.keyboardType = .asciiCapableNumberPad
        } else {
            quantityTextField.keyboardType = .numberPad
        }
        
        self.unitTextField.isUserInteractionEnabled = false
        
    }
    
}
