//
//  NutritionFoodTableCell.swift
//  Mutelcor
//
//  Created by on 21/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutritionFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var foodTextField: CustomTextField!
    @IBOutlet weak var quantityTextField: CustomTextField!
    @IBOutlet weak var unitTextField: CustomTextField!
    @IBOutlet weak var deleteButtonContainerView: UIView!
    @IBOutlet weak var deleteButtonOutlt: UIButton!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.foodTextField.tintColor = UIColor.white
        self.unitTextField.tintColor = UIColor.white
        
        for textField in [self.foodTextField, self.quantityTextField, self.unitTextField]{
            textField?.font = AppFonts.sanProSemiBold.withSize(16)
        }
        
        if #available(iOS 10.0, *) {
            quantityTextField.keyboardType = .asciiCapableNumberPad
        } else {
            quantityTextField.keyboardType = .numberPad
        }
        
        self.unitTextField.isUserInteractionEnabled = false
    }    
}
