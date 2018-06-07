//
//  FatherNameCell.swift
//  Mutelcore
//
//  Created by Ashish on 31/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class FatherNameCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSelectTitle: UITextField!
    @IBOutlet weak var cellTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setui()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTextField.text = ""
        
    }
}
extension FatherNameCell {
    
   fileprivate func setui(){
        
        self.cellLabel.font = AppFonts.sansProRegular.withSize(16)
        self.cellLabel.textColor = UIColor.appColor
        self.cellTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellSelectTitle.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellSelectTitle.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        self.cellSelectTitle.rightViewMode = .always
    
    }
    
    func populateDataForFather(_ userInfo : UserInfo){
    
        self.cellSelectTitle.text = userInfo.patientFatherTitle
        self.cellTextField.text = userInfo.patientFathername
        
    }
    
    func populateDataForSpouse(_ userInfo : UserInfo){
        
        self.cellSelectTitle.text = userInfo.patientSpouseTitle
        self.cellTextField.text = userInfo.patientSpouseName
 
        }
    }
