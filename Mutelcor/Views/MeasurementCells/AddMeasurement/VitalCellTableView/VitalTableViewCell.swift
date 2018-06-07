//
//  VitalTableViewCell.swift
//  Mutelcor
//
//  Created by on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol FormDataDicDelegate : class{
    func formDataDic(_ formDataDic : [String : String])
}

class VitalTableViewCell: UITableViewCell {

//    MARK:- Proporties
//    =================
    var measurementFormData = [MeasurementFormDataModel]()
    var vitalDataDic: [String : String] = [:]
    var vitalValue = ""
    var addMeasurementTableViewHeight = 0
    
   weak var delegate : FormDataDicDelegate?
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainVitalTableView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var vitalsLabel: UILabel!
    @IBOutlet weak var valuesLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var vitalTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension VitalTableViewCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measurementFormData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let vitalInputCell = tableView.dequeueReusableCell(withIdentifier: "vitalInputCellID", for: indexPath) as? VitalInputCell else{
            
            fatalError("VitalInputCell Not Found!")
        }
        vitalInputCell.unitTextField.tintColor = UIColor.white
        vitalInputCell.populateData(self.measurementFormData, indexPath)
        
        if indexPath.row != self.measurementFormData.count - 1{
            vitalInputCell.bottomSeprator.dashLine(CGPoint(x: self.layer.frame.origin.x, y: CGFloat(0)), CGPoint(x: self.layer.frame.width, y: CGFloat(0)))
        }else{
            vitalInputCell.bottomSeprator.dashLine(CGPoint(x: self.layer.frame.origin.x, y: CGFloat(0)), CGPoint(x: self.layer.frame.width, y: CGFloat(0)), [7,4], UIColor.clear)
        }
        
        let mainUnit = self.measurementFormData[indexPath.row].mainUnit?.components(separatedBy: ",")

        convertDataIntoDic(self.measurementFormData[indexPath.row].id, mainUnit?.first)
        
        vitalInputCell.unitTextField.delegate = self
        
        vitalInputCell.valueTextField.delegate = self
        vitalInputCell.valueTextField.placeholder = "Enter Value"
        vitalInputCell.unitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementUnitdropdown"))
        vitalInputCell.unitTextField.rightViewMode = UITextFieldViewMode.always
        vitalInputCell.unitTextField.borderStyle = UITextBorderStyle.none
        vitalInputCell.unitTextField.delegate = self
        
        let isNoDataAvailiableHidden = !self.measurementFormData.isEmpty ? true : false
        self.noDataAvailiableLabel.isHidden = isNoDataAvailiableHidden
        
        let isbottomSepratorHidden = (indexPath.row == self.measurementFormData.count) ? true : false
        vitalInputCell.bottomSeprator.isHidden = isbottomSepratorHidden
        
        return vitalInputCell
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension VitalTableViewCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.addMeasurementTableViewHeight)
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension VitalTableViewCell : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.vitalTableView) else{
            return
        }
        guard let cell = self.vitalTableView.cellForRow(at: indexPath) as? VitalInputCell else{
            return
        }
        
        MultiPicker.noOfComponent = 1
        
        if !self.measurementFormData.isEmpty {
          
            if let unit = self.measurementFormData[indexPath.row].unit {
               
                let unitArray = unit.components(separatedBy: ",")
                
                MultiPicker.openPickerIn(cell.unitTextField, firstComponentArray: unitArray, secondComponentArray: [], firstComponent: cell.unitTextField.text, secondComponent: "", titles: ["Units"]) { (result, _,index,_) in
                    
                    cell.unitTextField.text = result
                    self.measurementFormData[indexPath.row].mainUnit = result
                    self.convertDataIntoDic(self.measurementFormData[indexPath.row].id! ,result)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.contentView.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let _ = textField.getTableViewCell as? VitalInputCell {
            let index = textField.tableViewIndexPathIn(self.vitalTableView)!
            delay(0.1){
                self.vitalValue = textField.text ?? ""
                self.convertDataIntoDic(self.measurementFormData[index.row].id!, self.measurementFormData[index.row].mainUnit!)
            }
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 4
        }
        return true
    }
}

//MARK:- Methods
//==============
extension VitalTableViewCell {
    
    fileprivate func setupUI(){
        
        self.viewContainVitalTableView.layer.cornerRadius = 2.2
        self.viewContainVitalTableView.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.vitalTableView.bounces = false
        
        self.vitalTableView.dataSource = self
        self.vitalTableView.delegate = self
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.headerView.gradient(withX: 0, withY: 0, cornerRadius: false)

        self.vitalsLabel.text = "Vitals"
        self.vitalsLabel.textColor = UIColor.white
        self.vitalsLabel.font = AppFonts.sanProSemiBold.withSize(15)
        
        self.valuesLabel.text = "Values"
        self.valuesLabel.textColor = UIColor.white
        self.valuesLabel.font = AppFonts.sanProSemiBold.withSize(15)
        
        self.unitsLabel.text = "Units"
        self.unitsLabel.textColor = UIColor.white
        self.unitsLabel.font = AppFonts.sanProSemiBold.withSize(15)
        
        self.noDataAvailiableLabel.text = "No Record Found!"
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.registerNib()
    }
    
    fileprivate func registerNib(){
        
        let vitalInputNib = UINib(nibName: "VitalInputCell", bundle: nil)
        self.vitalTableView.register(vitalInputNib, forCellReuseIdentifier: "vitalInputCellID")
        
    }
    
//    MARK:- Create Dic from TextField
//    =================================
    func convertDataIntoDic(_ vitalID : Int? ,_ vitalUnit : String?){
        //printlnDebug("vitalDic1 : \(self.vitalDataDic)")
        
        for (key, _) in self.vitalDataDic {
            if key.hasPrefix("\(vitalID!)"){
                self.vitalDataDic.removeValue(forKey: key)
            }
        }
      self.vitalDataDic["\(vitalID!)_\(vitalUnit!)"] = vitalValue
        //printlnDebug("vitalDic : \(self.vitalDataDic)")
        self.delegate?.formDataDic(self.vitalDataDic)
    }
}
