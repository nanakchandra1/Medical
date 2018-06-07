//
//  SymptomsVC.swift
//  Mutelcor
//
//  Created by  on 26/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SymptomSelectionProtocol : class {
    func symptomSelectOnDidSelect(_ symptomArray : [Symptoms])
    func timeSlotSelectedIndex(_ selectedTimeSlot : TimeSlotModel)
}

enum AppearSymptomVCFor {
    case timeSlots
    case symptoms
}

class SymptomsVC: UIViewController {
    
    //    MARK:- Proporties
    //    =================
    var symptomVCFor : AppearSymptomVCFor = .symptoms
    var symptoms = [Symptoms]()
    var visitTypeTimeSlots = [TimeSlotModel]()
    weak var delegate : SymptomSelectionProtocol?
    var selectedSymptom = [Symptoms]()
    var selectedTimeSlot: TimeSlotModel?
    var searchResult = [Symptoms]()
    var selectedScheduleID : Int?
    fileprivate var isSearchBtnTapped = false
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainSymptomTableView: UIView!
    @IBOutlet weak var chooseSymptomView: UIView!
    @IBOutlet weak var chooseSymptomLabel: UILabel!
    @IBOutlet weak var chooseSymptomTableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var symptomSearchBar: UISearchBar!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var viewConatinTableViewCenter: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noDataFound: UILabel!
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let halfHeight = 0.75*UIDevice.getScreenHeight
        viewConatinTableViewCenter.constant = halfHeight

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.viewConatinTableViewCenter.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //    MARK:- IBAction
    //    ===================
    @IBAction func closeBtnActn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            let halfHeight = 0.75*UIDevice.getScreenHeight
            self.viewConatinTableViewCenter.constant = halfHeight
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @IBAction func doneBtnActn(_ sender: UIButton) {
        
        if self.symptomVCFor == .symptoms {
            self.delegate?.symptomSelectOnDidSelect(self.selectedSymptom)
        }else{
            if let timeSlot = self.selectedTimeSlot{
                self.delegate?.timeSlotSelectedIndex(timeSlot)
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            let halfHeight = 0.75*UIDevice.getScreenHeight
            self.viewConatinTableViewCenter.constant = halfHeight
            self.view.layoutIfNeeded()
            
        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

//MARk:- UITableViewDataSource Methods
//====================================
extension SymptomsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let symptoms = self.isSearchBtnTapped ? self.searchResult.count : self.symptoms.count
        let rows = (self.symptomVCFor == .symptoms) ? symptoms : self.visitTypeTimeSlots.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let symptomCell = tableView.dequeueReusableCell(withIdentifier: "symptomCellID", for: indexPath) as? SymptomCell else{
            fatalError("Symptom Cell Not Found!")
        }

        symptomCell.populateData(self.symptomVCFor, self.symptoms, self.selectedSymptom, self.visitTypeTimeSlots, indexPath, self.selectedTimeSlot, self.isSearchBtnTapped, self.searchResult, self.selectedScheduleID)
        return symptomCell
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension SymptomsVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if symptomVCFor == .symptoms{
            let symptom = self.isSearchBtnTapped ? self.searchResult : self.symptoms
            if !self.selectedSymptom.isEmpty {
                let index = self.selectedSymptom.index(where: { (selecSymp) -> Bool in
                    return selecSymp.id == symptom[indexPath.row].id
                })
                guard let idx = index else{
                    self.selectedSymptom.append(symptom[indexPath.row])
                    self.chooseSymptomTableView.reloadData()
                    return
                }
                self.selectedSymptom.remove(at: idx)
            }else{
              self.selectedSymptom.append(symptom[indexPath.row])
            }
            
        }else{
            self.selectedTimeSlot = self.visitTypeTimeSlots[indexPath.row]
        }
        self.chooseSymptomTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
//MARK:- Methods
//==============
extension SymptomsVC {
    
    fileprivate func setupUI(){
        
        self.symptomSearchBar.barTintColor = UIColor.appColor
        self.chooseSymptomTableView.dataSource = self
        self.chooseSymptomTableView.delegate = self
        self.chooseSymptomLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.viewContainSymptomTableView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        let symptomsCell = UINib(nibName: "SymptomCell", bundle: nil)
        self.chooseSymptomTableView.register(symptomsCell, forCellReuseIdentifier: "symptomCellID")
        self.noDataFound.textColor = UIColor.appColor
        self.noDataFound.font = AppFonts.sansProRegular.withSize(14.7)
        self.noDataFound.text = "No Records Found!"
        self.noDataFound.isHidden = true
        
        if symptomVCFor == .symptoms{
            self.symptomSearchBar.isHidden = false
            self.searchBarHeightConstraint.constant = 56
            self.chooseSymptomTableView.allowsSelection = true
            self.chooseSymptomTableView.allowsMultipleSelection = true
            self.symptomSearchBar.delegate = self
            
            self.chooseSymptomLabel.text = K_CHOOSE_SYMPTOMS_TITLE.localized
        }else{
            self.symptomSearchBar.isHidden = true
            self.searchBarHeightConstraint.constant = 0
            self.chooseSymptomLabel.text = K_TIME_SLOTS.localized
            self.chooseSymptomTableView.allowsSelection = true
            self.chooseSymptomTableView.allowsMultipleSelection = false
        }
    }
}

//MARK:- UISearchBarDelegate Methods
//==================================
extension SymptomsVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let text = searchBar.text
        if text!.isEmpty {
            self.isSearchBtnTapped = false
            self.searchResult = []
            self.isNoDataFoundTextDisplay(isTextDisplay: true)
            self.chooseSymptomTableView.reloadData()
        }else{
            self.searchSymptoms(text!)
        }
    }
    
    fileprivate func searchSymptoms(_ searchText: String){
            if self.symptomVCFor == .symptoms {
                let searchSymptoms = self.symptoms.filter { (symptoms)in
                    let text = searchText.capitalized
                    let symptomName = symptoms.symptomName?.capitalized ?? ""
                    let symptomTag = symptoms.symptomsTag?.capitalized ?? ""
                    //printlnDebug(symptomName)
                    //printlnDebug(symptomTag)
                    return symptomName.contains(text) || symptomTag.contains(text)
                }
                self.searchResult = searchSymptoms
                let isNoDataFoundTextHidden = self.searchResult.isEmpty ? false : true
                self.isNoDataFoundTextDisplay(isTextDisplay: isNoDataFoundTextHidden)
                self.isSearchBtnTapped = true
            }else{
                self.isSearchBtnTapped = false
            }
            self.chooseSymptomTableView.reloadData()
    }
    
    fileprivate func isNoDataFoundTextDisplay(isTextDisplay: Bool = true){

        UIView.animate(withDuration: 0.3) {
            self.noDataFound.isHidden = isTextDisplay
        }
    }
}

