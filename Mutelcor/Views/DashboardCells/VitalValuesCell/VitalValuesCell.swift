//
//  VitalValuesCell.swift
//  Mutelcor
//
//  Created by on 26/12/17.
//  Copyright © 2017 "" All rights reserved.
//

import Foundation

protocol MeasurementVitalDataDicDelegate : class{
    func measurementVitalDataDic(_ measurementVitalData : [[TextReportModel]])
}

class VitalValuesCell: UITableViewCell {
    
    //    MARK:- Proporties
    //    =================
    var vitalData: [[TextReportModel]] = []
    weak var delegate: MeasurementVitalDataDicDelegate?
    
    //    MARK:- IBoutlets
    //    ================
    @IBOutlet weak var vitalNameTextField: UITextField!
    @IBOutlet weak var vitalvalueTextField: UITextField!
    @IBOutlet weak var vitalUnitTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vitalUnitTextField.isUserInteractionEnabled = false
        
        for textField in [self.vitalNameTextField,self.vitalvalueTextField,self.vitalUnitTextField] {
            textField?.textColor = UIColor.black
            textField?.font = AppFonts.sansProRegular.withSize(13)
            textField?.delegate = self
        }
    }
    
    func populateData(indexPath: IndexPath, vitalData: [String: [TextReportModel]], vitalDickeys: [String]){
        
        let keys = vitalDickeys[indexPath.section]
        if let report = vitalData[keys] {
            self.vitalData.append(report)
            let reportValue = report[indexPath.row - 1]
            self.vitalNameTextField.text = reportValue.vitalSubName
            self.vitalvalueTextField.text = String(reportValue.value)
            self.vitalUnitTextField.text = reportValue.unit
        }
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension VitalValuesCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let cell = textField.getTableViewCell as? VitalValuesCell else{
            return true
        }
        
        let tableView = cell.getTableView

        guard tableView != nil  else{
            return true
        }
        
        guard let indexPath = cell.tableViewIndexPathIn(tableView!) else{
            return true
        }

        if textField === self.vitalvalueTextField {
            delay(0.1){
            self.vitalData[indexPath.section][indexPath.row - 1].value = Double.init(textField.text ?? "0.0") ?? 0.0
            }
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 4
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.measurementVitalDataDic(self.vitalData)
    }
}

