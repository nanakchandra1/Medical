//
//  NatureOFAppointmentTableViewCell.swift
//  Mutelcor
//
//  Created by  on 26/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NatureOfAppointmentCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var natureOfAppointmentLabel: UILabel!
    @IBOutlet weak var routineBtn: UIButton!
    @IBOutlet weak var emergencyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }    
}

//MARK:- Methods
//==============
extension NatureOfAppointmentCell{
    
    fileprivate func setupUI(){
        self.natureOfAppointmentLabel.textColor = UIColor.appColor
        self.natureOfAppointmentLabel.font = AppFonts.sansProRegular.withSize(16.0)
        self.routineBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16.0)
        self.emergencyBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16.0)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
//    func populateAddressTypeData(_ userInfo: UserInfo?){
//        
//        var addressType: Int?
//        guard let userData = userInfo else{
//            return
//        }
//            guard !userData.userAddressInfo.isEmpty else{
//                return
//            }
//            if let type = userData.userAddressInfo.first?.addressType {
//                addressType = type
//            }
//        
//        let type = (addressType != nil) ? addressType : 0
//        let typOfAddress = (type == true.rawValue) ? true : false
//        self.routineBtn.isSelected = typOfAddress
//        self.emergencyBtn.isSelected = !typOfAddress
//    }
}
