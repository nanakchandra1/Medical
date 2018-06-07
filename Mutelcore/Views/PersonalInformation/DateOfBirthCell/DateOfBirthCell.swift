//
//  DateOfBirthCell.swift
//  Mutelcore
//
//  Created by Ashish on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DateOfBirthCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    
    @IBOutlet weak var celltitleBtn: UIButton!
    @IBOutlet weak var celltextField: UITextField!
    @IBOutlet weak var cellBtnOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.celltitleBtn.titleLabel?.font = AppFonts.sansProRegular.withSize(16)
        self.celltitleBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.celltextField.font = AppFonts.sanProSemiBold.withSize(16)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.celltextField.removeTarget(self, action: nil, for: .allEvents)
    }
}

//MARK:- Data Populate on Cell
//============================
extension DateOfBirthCell {
    
     func populateData(_ userInfo : UserInfo){
        
        let date = userInfo.patientDob?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if date != nil , !(date?.isEmpty)!{
                        
            self.celltextField.text = date
        }else{
            
            self.celltextField.text = ""
        }
    }
    
    func populateBloodData(_ userInfo : UserInfo) {
        
        guard !userInfo.medicalInfo.isEmpty else{
            
            return
        }
        
        if  !userInfo.medicalInfo[0].patientBloodGroup!.isEmpty{
            
            self.celltextField.text = userInfo.medicalInfo[0].patientBloodGroup
        
        }else{
            
            self.celltextField.text = ""
        }
    }
}
