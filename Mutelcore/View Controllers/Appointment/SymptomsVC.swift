//
//  SymptomsVC.swift
//  Mutelcore
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SymptomSelectionProtocol {
    
    func symptomSelectOnDidSelect(symptomArray : [String])
    func timeSlotSelectedIndex(selectedIndex : Int)
    
}

class SymptomsVC: UIViewController {
    
    //    MARK:- Proporties
    //    =================
    
    enum openThesymptomVCFor {
        
        case timeSlots
        case symptoms
        
    }
    
    var symptomVCFor : openThesymptomVCFor = .symptoms
    var symptoms = [String]()
    var visitTypeTimeSlots = [TimeSlotModel]()
    var delegate : SymptomSelectionProtocol!
    var selectedSymptom = [String]()
    var selectedCellIndex = [Int]()
    var selectedIndex : Int?
    var selectedSceduledID : Int?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainSymptomTableView: UIView!
    @IBOutlet weak var chooseSymptomView: UIView!
    @IBOutlet weak var chooseSymptomLabel: UILabel!
    @IBOutlet weak var chooseSymptomTableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUi()
        
        printlnDebug("timeSlots :\(self.symptoms)")
        
        
        if symptomVCFor == .symptoms {
            
            for item in self.selectedSymptom{
                
                if self.symptoms.contains(item){
                    
                    guard let idx = symptoms.index(of: item) else{
                        return
                    }
                    
                    self.selectedCellIndex.append(idx)
                }
            }
        }else{
            
        }
                
        // Do any additional setup after loading the view.
    }
    
    //    MARK:- IBAction
    //    ===================
    @IBAction func closeBtnActn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
        }) { (true) in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func doneBtnActn(_ sender: UIButton) {
        
        if self.symptomVCFor == .symptoms {
            
            
            self.delegate.symptomSelectOnDidSelect(symptomArray: self.selectedSymptom)
            
        }
        else{
            
            if let index = self.selectedIndex{
                
                self.delegate.timeSlotSelectedIndex(selectedIndex: index)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
            
        }) { (true) in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        
    }
}

//MARk:- UITableViewDataSource Methods
//====================================
extension SymptomsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.symptomVCFor == .symptoms{
            
          return self.symptoms.count
        }else{
            
          return self.visitTypeTimeSlots.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let symptomCell = tableView.dequeueReusableCell(withIdentifier: "symptomCellID", for: indexPath) as? SymptomCell else{
            
            
            fatalError("Symptom Cell Not Found!")
        }
        
        
        symptomCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
        
        
        if self.symptomVCFor == .symptoms {
            symptomCell.cellLabel.text = self.symptoms[indexPath.row]
            if self.selectedCellIndex.contains(indexPath.row){
                
                symptomCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentSelectedcheck")
                
            }else{
                
                symptomCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
            }
            
        }else{
        
            if !self.visitTypeTimeSlots.isEmpty{
            
                var strTime = ""
                var endTim = ""
                if let startTime = self.visitTypeTimeSlots[indexPath.row].startTime?.dateFString(DateFormat.hhmmssa.rawValue, DateFormat.HHmm.rawValue){
               
                    strTime = startTime
                    
                }
                
                if let endTime = self.visitTypeTimeSlots[indexPath.row].slotEndTime?.dateFString(DateFormat.hhmmssa.rawValue, DateFormat.HHmm.rawValue){
                    
                    endTim = endTime
                }
                
            symptomCell.cellLabel.text = "\(strTime)-\(endTim)"
            
            if self.selectedSceduledID == self.visitTypeTimeSlots[indexPath.row].scheduleID{
                
               symptomCell.cellImage.image = #imageLiteral(resourceName: "icAppointmentSelectedcheck")
            }
          }
        }
        
        return symptomCell
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension SymptomsVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if symptomVCFor == .symptoms{
            
            if self.selectedCellIndex.contains(indexPath.row){
                
                guard let idx = self.selectedCellIndex.index(of: indexPath.row) else{
                    return
                }
                
                self.selectedCellIndex.remove(at: idx)
                
                self.selectedSymptom.remove(at: idx)
                
            }
            else{
                
                self.selectedCellIndex.append(indexPath.row)
                self.selectedSymptom.append(self.symptoms[indexPath.row])
                
            }
        }else{
            
            self.selectedIndex = indexPath.row
            self.selectedSceduledID = self.visitTypeTimeSlots[indexPath.row].scheduleID

        }
        
        self.chooseSymptomTableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//        guard let cell = tableView.cellForRow(at: indexPath) as? SymptomCell else {
//            return
//        }
//        
//        if symptomVCFor == .timeSlots{
//            
//            self.selectedCellIndex.remove(at: 0)
//            cell.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
//            
//        }
//        
//        self.chooseSymptomTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
}
//MARK:- Methods
//==============
extension SymptomsVC {
    
    fileprivate func setUi(){
        
        self.chooseSymptomTableView.dataSource = self
        self.chooseSymptomTableView.delegate = self
        
        let symptomsCell = UINib(nibName: "SymptomCell", bundle: nil)
        self.chooseSymptomTableView.register(symptomsCell, forCellReuseIdentifier: "symptomCellID")
        
        if symptomVCFor == .symptoms{
            self.chooseSymptomTableView.allowsSelection = true
            self.chooseSymptomTableView.allowsMultipleSelection = true

            self.chooseSymptomLabel.text = "Choose Symptoms"
            if !self.symptoms.isEmpty {
                
                self.symptoms.append("Other")
                
            }
        } else {
            
            self.chooseSymptomLabel.text = "Time Slots"
            self.chooseSymptomTableView.allowsSelection = true
            self.chooseSymptomTableView.allowsMultipleSelection = false

        }
    }
}
