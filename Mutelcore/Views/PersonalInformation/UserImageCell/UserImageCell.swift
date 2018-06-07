//
//  userImageCell.swift
//  Mutelcore
//
//  Created by Ashish on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class UserImageCell: UITableViewCell {
    

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var setUserImagebutton: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var celltextField: UITextField!
    @IBOutlet weak var genderStatusTextField: UITextField!
    @IBOutlet weak var borderBelowgenderSelecton: UIView!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var userprofileImage: UIImageView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUi()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.userprofileImage.layer.cornerRadius = self.userprofileImage.layer.frame.width / 2
        self.userprofileImage.clipsToBounds = true
        
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        celltextField.text  = ""
        genderStatusTextField.text = ""
        middleNameTextField.text = ""
        lastNameTextField.text = ""
        
    }
}

//MARK:- populate Data on Cell
//============================
extension UserImageCell {
    
    func setUi(){
        
         self.genderStatusTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
         self.genderStatusTextField.rightViewMode = .always
        
        self.genderStatusTextField.text = K_MR_PLACEHOLDER.localized
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.genderStatusTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.middleNameTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.lastNameTextField.font = AppFonts.sanProSemiBold.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        self.genderStatusTextField.textColor = UIColor.black
        
    }
    
    
    func populateData(_ userInfo : UserInfo, _ image : UIImage?){
        
        if !userInfo.patientPic!.isEmpty {
            
            let imageStr = userInfo.patientPic
            
            let percentageEncodingStr = imageStr?.replacingOccurrences(of: " ", with: "%20")

            let imgUrl = URL(string: percentageEncodingStr!)
            
            self.userprofileImage.af_setImage(withURL: imgUrl!)
            
        }
        else if image != nil{
            
            self.userprofileImage.image = image
            
        }else{
            
           self.userprofileImage.image = #imageLiteral(resourceName: "personal_info_place_holder")
            
        }

            self.genderStatusTextField.text = userInfo.patientTitle
            self.celltextField.text = userInfo.patientFirstname
            self.middleNameTextField.text = userInfo.patientMiddleName
            self.lastNameTextField.text = userInfo.patientLastName
    }
}
