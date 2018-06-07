//
//  MatchedMeasurementTextVC.swift
//  Mutelcor
//
//  Created by on 21/12/17.
//  Copyright © 2017 "" All rights reserved.
//

import UIKit
import TransitionButton

protocol RemoveViewDelegate: class {
    func removeView()
}

class MatchedMeasurementTextVC: UIViewController {
    
//    MARK:- Proporties
//    =================
    var measurementListDic: [String: [TextReportModel]] = [:]
    var measurementDicKeys: [String] = []
    var measurementVitalData: [[TextReportModel]] = []
    var addMeasurementDic: [String: Any] = [:]
    weak var delegate: RemoveViewDelegate?
    
    //    MARK:- IBoutlets
    //    =================
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var vitalListingTableView: UITableView!
    @IBOutlet weak var dateTimeBackgroundView: UIView!
    @IBOutlet weak var buttonBackgroundView: TransitionButton!
    @IBOutlet weak var cancelButtonOutlt: UIButton!
    @IBOutlet weak var doneButtonOutlt: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextFieldOult: UITextField!
    @IBOutlet weak var dateSepratorView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextFieldOult: UITextField!
    @IBOutlet weak var timeSepratorView: UIView!
    @IBOutlet weak var popupBottomConstraintOult: NSLayoutConstraint!
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.keyBoardMgr()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.doneButtonOutlt.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.view.layoutIfNeeded()
    }
}

//MARK:- UITableViewDataSource Method
//===================================
extension MatchedMeasurementTextVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.measurementDicKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.measurementDicKeys[section]
        var tableRows = 0
        
        if let textReportRows = self.measurementListDic[key], !textReportRows.isEmpty {
            tableRows = textReportRows.count + 1
        }
        return tableRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VitalHeaderCell", for: indexPath) as? VitalHeaderCell else{
                fatalError("cell not found!")
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VitalValuesCell", for: indexPath) as? VitalValuesCell else{
                fatalError("cell not found!")
            }

            let keys = self.measurementDicKeys[indexPath.section]
            if let report = self.measurementListDic[keys] {
                self.measurementVitalData.append(report)
            }
            cell.delegate = self
            cell.populateData(indexPath: indexPath, vitalData: self.measurementListDic, vitalDickeys: self.measurementDicKeys)
            
            return cell//7678139531
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MeasurementSectionCellID") as? MeasurementSectionCell else{
            fatalError("cell not found!")
        }
        
        cell.populateData(section: section, vitalDicKeys: self.measurementDicKeys)
        
        return cell
    }
}

//MARK:- UITableViewDelegate Method
//=================================
extension MatchedMeasurementTextVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
}

//MARK:- UITextFieldDelegate Method
//==================================
extension MatchedMeasurementTextVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        MultiPicker.noOfComponent = 1
        
        let selectedTextField = textField === self.dateTextFieldOult ? self.dateTextFieldOult : self.timeTextFieldOult
        let datePickerMode: UIDatePickerMode = textField === self.dateTextFieldOult ? .date : .time
        
        DatePicker.openPicker(in: selectedTextField!, currentDate: Date(), minimumDate: nil, maximumDate: Date(), pickerMode: datePickerMode) { (date) in
            
            let selectedValue = textField === self.dateTextFieldOult ? date.stringFormDate(.ddMMMYYYY) : date.stringFormDate(.Hmm)
            if textField === self.dateTextFieldOult {
                self.addMeasurementDic["measurement_date"] = date
            }else{
               self.addMeasurementDic["measurement_time"] = date
            }

            textField.text = selectedValue
        }
    }
}
//    MARK:- Private Methods
//    ======================
extension MatchedMeasurementTextVC {

    fileprivate func setupUI(){
        
        self.popUpView.layer.cornerRadius = 2.2
        self.popUpView.clipsToBounds = true
        
        self.vitalListingTableView.dataSource = self
        self.vitalListingTableView.delegate = self
        self.cancelButtonOutlt.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        self.cancelButtonOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.cancelButtonOutlt.setTitle(K_CANCEL_BUTTON.localized.uppercased(), for: UIControlState.normal)
        self.cancelButtonOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.doneButtonOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        self.doneButtonOutlt.setTitle(K_SAVE_BUTTON_TITLE.localized.uppercased(), for: UIControlState.normal)
        self.doneButtonOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.cancelButtonOutlt.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        self.doneButtonOutlt.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.dateLabel.text = "Select Date"
        self.dateLabel.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.dateLabel.textColor = UIColor.appColor
        
        self.addMeasurementDic["measurement_date"] = Date()
        self.dateTextFieldOult.text = Date().stringFormDate(.ddMMMYYYY)
        self.dateTextFieldOult.font = AppFonts.sansProRegular.withSize(13)
        self.dateTextFieldOult.borderStyle = UITextBorderStyle.none
        self.dateTextFieldOult.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentCalendar"))
        self.dateTextFieldOult.rightViewMode = .always
        
        self.timeLabel.text = K_SELECT_TIME_TITLE.localized
        self.timeLabel.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.timeLabel.textColor = UIColor.appColor
        
        self.addMeasurementDic["measurement_time"] = Date()
        self.timeTextFieldOult.text = Date().stringFormDate(.Hmm)
        self.timeTextFieldOult.font = AppFonts.sansProRegular.withSize(13)
        self.timeTextFieldOult.rightView = UIImageView(image: #imageLiteral(resourceName: "icAppointmentClock"))
        self.timeTextFieldOult.rightViewMode = .always
        self.timeTextFieldOult.borderStyle = UITextBorderStyle.none
        
        self.dateTextFieldOult.delegate = self
        self.timeTextFieldOult.delegate = self
        
        let measurementSectionCellNib = UINib(nibName: "MeasurementSectionCell", bundle: nil)
        self.vitalListingTableView.register(measurementSectionCellNib, forHeaderFooterViewReuseIdentifier: "MeasurementSectionCellID")
    }
    
    @objc fileprivate func cancelButtonTapped(_ sender : UIButton){
        self.viewRemoveFromSuperView()
    }
    
    @objc fileprivate func doneButtonTapped(_ sender : UIButton){

        for (index, vitalData) in self.measurementVitalData.enumerated() {
            var dic: [String: Any] = [:]
            var selectedDate: Date?
            var selectedTime: Date?
            for subVitalData in vitalData {
                
                guard subVitalData.vitalID != nil else{
                    showToastMessage(AppMessages.allValuesOfVitals.rawValue.localized)
                    return
                }
                guard subVitalData.value != 0.0 else{
                    showToastMessage(AppMessages.allValuesOfVitals.rawValue.localized)
                    return
                }
                
                guard let date = self.addMeasurementDic["measurement_date"] as? Date else{
                    showToastMessage(AppMessages.measurementDate.rawValue.localized)
                    return
                }
                selectedDate = date
                guard let time = self.addMeasurementDic["measurement_time"] as? Date else{
                    showToastMessage(AppMessages.measurementTime.rawValue.localized)
                    return
                }
                selectedTime = time
                
                dic = self.convertDataIntoDic(subVitalData.vitalID, subVitalData.unit, subVitalData.value)
            }
            self.convertDataIntoJSONDictionary(dic as! [String : String])
            self.addMeasurementDic["vital_super_id"] = self.measurementVitalData[index][0].vitalSuperID
            if let date = selectedDate, let time = selectedTime {
                self.addMeasurement(selectedDate: date, selectedTime: time)
            }
        }
    }
    
    fileprivate func viewRemoveFromSuperView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.delegate?.removeView()
        }) {(true) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    //Keyboard Manager to hide and show
//    =================================
    func keyBoardMgr(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if self.dateTextFieldOult.isFirstResponder || self.timeTextFieldOult.isFirstResponder {
            
            if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.33, animations: {
                    self.popupBottomConstraintOult.constant = keyboardSize.height + 10
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        if self.timeTextFieldOult.resignFirstResponder() || self.dateTextFieldOult.resignFirstResponder() {
            UIView.animate(withDuration: 0.33, animations: {
                self.popupBottomConstraintOult.constant = 20
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func convertDataIntoJSONDictionary(_ formDataDic: [String : String]){
        
        do {
            let typejsonArray = try JSONSerialization.data(withJSONObject: formDataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let typeJSONString = String(data: typejsonArray, encoding: String.Encoding.utf8) else { return }
            self.addMeasurementDic["vital_dic"] = typeJSONString as String
        }catch{
            //printlnDebug(error.localizedDescription)
        }
    }
}

//MARK:- WebServices
//===================
extension MatchedMeasurementTextVC {
    
    fileprivate func addMeasurement(selectedDate: Date, selectedTime: Date){
        
        var parameters: JSONDictionary = self.addMeasurementDic
        parameters["measurement_date"] = selectedDate.stringFormDate(.yyyyMMdd)
        parameters["measurement_time"] = selectedTime.stringFormDate(.Hmm)
        parameters["id"] = AppUserDefaults.value(forKey: .userId)
        parameters["doc_id"] = AppUserDefaults.value(forKey: .doctorId).stringValue
        
        self.buttonBackgroundView.backgroundColor = UIColor.appColor
        self.cancelButtonOutlt.isHidden = true
        self.doneButtonOutlt.isHidden = true
        self.buttonBackgroundView.startAnimation()
        WebServices.addMeasurement(parameters: parameters,
                                   imageData: [:],
                                   success: {[weak self] (_ message : String) in
                                    
                                    guard let addMeasurementVC = self else{
                                        return
                                    }
                                    
                                    addMeasurementVC.stopButtonAnimation(isServiceFail: true)
        }) { (error) in
            self.stopButtonAnimation(isServiceFail: false)
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func stopButtonAnimation(isServiceFail: Bool){
        self.buttonBackgroundView.stopAnimation(animationStyle: .normal, completion: {
            self.buttonBackgroundView.backgroundColor = UIColor.white
            self.cancelButtonOutlt.isHidden = false
            self.doneButtonOutlt.isHidden = false
            if isServiceFail{
                self.viewRemoveFromSuperView()
            }
        })
    }
}

//MARK:- MeasurementVitalDataDicDelegate Method
//=============================================
extension MatchedMeasurementTextVC: MeasurementVitalDataDicDelegate {
    
    func measurementVitalDataDic(_ measurementVitalData : [[TextReportModel]]){
        self.measurementVitalData = measurementVitalData
    }
    
    //    MARK:- Create Dic from TextField
    //    =================================
    func convertDataIntoDic(_ vitalID : Int? ,_ vitalUnit : String?, _ vitalValue: Double?) -> [String: String]{
        //printlnDebug("vitalDic1 : \(self.measurementVitalData)")
        
        var dic: [String: String] = [:]

        dic["\(vitalID!)_\(vitalUnit!)"] = String(vitalValue ?? 0.0)
        return dic
    }
}




//MARK:- VitalHeaderCell Class
//============================
class VitalHeaderCell: UITableViewCell {
    
    //    MARK:- IBoutlets
    //    ================
    @IBOutlet weak var vitalNameLabel: UILabel!
    @IBOutlet weak var vitalvalueLabel: UILabel!
    @IBOutlet weak var vitalUnitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vitalNameLabel.text = "Vitals"
        self.vitalvalueLabel.text = "Values"
        self.vitalUnitLabel.text = "units"
        
        self.vitalNameLabel.textColor = UIColor.appColor
        self.vitalvalueLabel.textColor = UIColor.appColor
        self.vitalUnitLabel.textColor = UIColor.appColor
        
        for label in [self.vitalNameLabel,self.vitalvalueLabel,self.vitalUnitLabel] {
            label?.textColor = UIColor.appColor
            label?.font = AppFonts.sanProSemiBold.withSize(15)
        }
    }
}


