//
//  VitalInputCell.swift
//  Mutelcor
//
//  Created by on 19/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VitalInputCell: UITableViewCell {

//    MARK:- IBoutlets
//    =================
    @IBOutlet weak var vitalLabelOutlet: UILabel!
    @IBOutlet weak var verticalSeprator: UIView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var bottomSeprator: UIView!
    @IBOutlet weak var vitalUnitView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension VitalInputCell {
    
    fileprivate func setupUI(){
     
        self.vitalUnitView.layer.cornerRadius = 2.0
        self.vitalUnitView.clipsToBounds = true
        self.vitalUnitView.layer.borderWidth = 1.0
        self.vitalUnitView.layer.borderColor = UIColor.grayLabelColor.cgColor
        
        self.vitalLabelOutlet.font = AppFonts.sanProSemiBold.withSize(14)
        self.valueTextField.font = AppFonts.sansProRegular.withSize(14)
        self.valueTextField.borderStyle = UITextBorderStyle.none
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.unitTextField.font = AppFonts.sansProRegular.withSize(12)
        self.unitTextField.borderStyle = UITextBorderStyle.none
        
        self.verticalSeprator.dashLine(CGPoint(x: CGFloat(0), y: self.layer.frame.origin.y), CGPoint(x: 0, y: self.verticalSeprator.layer.frame.height - 20))
    }
    
     func populateData(_ measrementFormDataModel : [MeasurementFormDataModel], _ index : IndexPath){
        guard !measrementFormDataModel.isEmpty else{
            return
        }
        
        self.vitalLabelOutlet.text = measrementFormDataModel[index.row].vitalSubName
        self.unitTextField.text = measrementFormDataModel[index.row].mainUnit
    }
}
