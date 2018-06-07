//
//  TestNameSelectionCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 18/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class TestNameSelectionCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var selectTestNameTextField: UITextField!
    @IBOutlet weak var addMeasurementbtn: UIButton!
    @IBOutlet weak var selectTestNameTextFieldBtn: UIButton!

//    MARK;- Cell LifeCycle
//    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- METHODS
//===============
extension TestNameSelectionCell  {
    
    fileprivate func setupUI(){
     
        self.selectTestNameTextFieldBtn.isHidden = true
        self.selectTestNameTextField.font = AppFonts.sanProSemiBold.withSize(15.5)
        self.selectTestNameTextField.textColor = UIColor.textColor
        self.selectTestNameTextField.textAlignment = NSTextAlignment.left
        self.selectTestNameTextField.borderStyle = UITextBorderStyle.roundedRect
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.selectTestNameTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.selectTestNameTextField.rightViewMode = UITextFieldViewMode.always
        
        self.addMeasurementbtn.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: .normal)
        self.addMeasurementbtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
}
