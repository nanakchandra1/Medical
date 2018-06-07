//
//  DetailsCell.swift
//  Mutelcor
//
//  Created by on 06/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    //outlets
    
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    
    //MARK: nib life cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        self.showPasswordButton.addTarget(self, action: #selector(showPasswordTapped(_:)), for: .touchUpInside)
        self.detailsTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.detailsTextField.text = ""
        self.showPasswordButton.isHidden = true
        self.showPasswordButton.isSelected = false
    }
    
}

//MARK: IBActions
extension DetailsCell{
    
    @objc func showPasswordTapped(_ sender: UIButton){
        showPasswordButton.isSelected = !showPasswordButton.isSelected
        detailsTextField.isSecureTextEntry = !detailsTextField.isSecureTextEntry
    }
    
    func populateForgotPasswordData(){
        self.cellTitle.text = K_EMAIL_ADDRESS_PLACEHOLDER.localized
        self.detailsTextField.keyboardType = .emailAddress
        self.detailsTextField.returnKeyType = .done
        self.showPasswordButton.isHidden = true
        self.detailsTextField.isSecureTextEntry = false
    }
}
