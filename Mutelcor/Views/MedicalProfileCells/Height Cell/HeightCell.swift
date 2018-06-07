//
//  HeightCell.swift
//  Mutelcor
//
//  Created by  on 24/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class HeightCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var feetTextField: UITextField!
    @IBOutlet weak var inchTextField: UITextField!
    @IBOutlet weak var inchTextFieldBottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        unitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "personal_info_down_arrow"))
        unitTextField.rightViewMode = .always
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
    }
}

extension HeightCell {
    
    func populateData(_ userInfo : UserInfo?, _ heightUnit : [String], feetUnitState: FeetUnit){
        
        self.inchTextField.placeholder = heightUnit[1]
        self.unitTextField.textColor = UIColor.black
        self.feetTextField.keyboardType = .numberPad
        self.inchTextField.keyboardType = .numberPad
        
        guard let userData = userInfo else{
            return
        }
        guard !userData.medicalInfo.isEmpty else{
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.inchTextField.isHidden = feetUnitState == .cm
            self.inchTextFieldBottomView.isHidden = feetUnitState == .cm
            let placeHolderText = feetUnitState == .ft ? heightUnit[0] : heightUnit[1]
            self.feetTextField.placeholder = placeHolderText
        })

        if let height = userData.medicalInfo.first?.patientHeight1{
            let feetHeight = "\(height)"
            self.feetTextField.text = feetHeight
        }
        if let patientHeightInInch = userData.medicalInfo.first?.patientHeight2{
            let inchHeight = "\(patientHeightInInch)"
            self.inchTextField.text = inchHeight
        }
        let heightType = feetUnitState == .cm ? heightUnit[1] : heightUnit[0]
        self.unitTextField.text = heightType
    }
}
