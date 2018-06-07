//
//  SymptomsSearchVC.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol SearchDataDelegate :class {
    func searchData(_ selectedData : [AllSymptoms])
}

enum NavigateToSearchScreenThrough {
    case mostCommon
    case all
}

class SymptomsSearchVC: UIViewController {
    
    //    MARK:- Proporties
    //    ==================
    var navigateToSearchScreenThrough: NavigateToSearchScreenThrough = .all
    var allSymptoms: [AllSymptoms] = []
    var searchResult: [AllSymptoms] = []
    fileprivate var mostCommonSymptoms: [AllSymptoms] = []
    var searchText: String = ""
    var symptomID: String?
    fileprivate var isSearchBtnTapped: Bool = false
    weak var delegate: SearchDataDelegate?
    var selectedSymptoms: [AllSymptoms] = []
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var symptomSearchBar: UISearchBar!
    @IBOutlet weak var searchListingTableView: UITableView!
    @IBOutlet weak var crossBtnOutlt: UIButton!
    @IBOutlet weak var doneBtnOutlt: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    @IBOutlet weak var allBtnOutlt: UIButton!
    @IBOutlet weak var mostCommonBtnOutlt: UIButton!
    @IBOutlet weak var viewContainAllObjects: UIView!

    
    //    MARk:- UIVIewController Life Cycle
    //    ==================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.animatePopUpView()
    }
    
    fileprivate func animatePopUpView(){
        
        self.viewContainAllObjects.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.popUpBackgroundColor
            self.viewContainAllObjects.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    //    MARK:- IBActions
    //    =================
    @IBAction func CrossBtnTapped(_ sender: UIButton) {
        self.removeSearchVC(isDoneBtnTapped: false)
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        self.removeSearchVC(isDoneBtnTapped: true)
    }
    
    @IBAction func allBtnTapped(_ sender: UIButton) {
        
        guard !sender.isSelected else{
            return
        }
        sender.isSelected = !sender.isSelected
        let color = sender.isSelected ? UIColor.appColor : UIColor.gray
        sender.backgroundColor = color
        self.mostCommonBtnOutlt.backgroundColor = UIColor.gray
        self.mostCommonBtnOutlt.isSelected = false
        
        self.navigateToSearchScreenThrough = .all
        self.searchListingTableView.reloadData()
    }
    
    @IBAction func mostCommonBtnTapped(_ sender: UIButton) {
        
        guard !sender.isSelected else{
            return
        }
        sender.isSelected = !sender.isSelected
        let color = sender.isSelected ? UIColor.appColor : UIColor.gray
        sender.backgroundColor = color
        self.allBtnOutlt.backgroundColor = UIColor.gray
        self.allBtnOutlt.isSelected = false
        self.navigateToSearchScreenThrough = .mostCommon
        self.searchListingTableView.reloadData()
    }
    
    func removeSearchVC(isDoneBtnTapped: Bool){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewContainAllObjects.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: {  success in
            if isDoneBtnTapped {
                self.delegate?.searchData(self.selectedSymptoms)
            }
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
}

//MARK:- UISearchBarDelegate Methods
//==================================
extension SymptomsSearchVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let text = searchBar.text, text.isEmpty {
            self.isSearchBtnTapped = false
            self.searchResult = []
            self.noDataAvailiableLabel.isHidden = true
            self.searchListingTableView.reloadData()
        }else{
            self.searchSymptoms(searchBar.text!)
        }
    }
    
    fileprivate func searchSymptoms(_ searchText: String){
        
        if !searchText.isEmpty {
            
            if self.navigateToSearchScreenThrough == .all {
                let mostCommonSymptomsSearch = self.allSymptoms.filter { (symptoms)in
                    return (symptoms.symptomName?.contains(searchText.capitalized))!
                }
                self.searchResult = mostCommonSymptomsSearch
            }else{
                let symptomsSearch = self.mostCommonSymptoms.filter { (symptoms)in
                    
                    let text = searchText.capitalized
                    let symptomsName = symptoms.symptomName?.capitalized
                    let symptomTag = symptoms.symptomTags?.capitalized

                    return symptomsName!.contains(text) || symptomTag!.contains(text)
                }
                self.searchResult = symptomsSearch
            }
            self.isSearchBtnTapped = true
            let labelIsHidden = !self.searchResult.isEmpty ? true : false
            self.noDataAvailiableLabel.isHidden = labelIsHidden
        }else{
            self.noDataAvailiableLabel.isHidden = true
            self.isSearchBtnTapped = false
        }
        self.searchListingTableView.reloadData()
    }
}

//MARK:- UITableViewDataSource Methods
//=====================================
extension SymptomsSearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = (self.navigateToSearchScreenThrough == .all) ? self.allSymptoms.count : self.mostCommonSymptoms.count
        let symptomsCount = (isSearchBtnTapped) ? self.searchResult.count : rows
        return symptomsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let symptomCell = tableView.dequeueReusableCell(withIdentifier: "symptomCellID", for: indexPath) as? SymptomCell else{
            fatalError("Symptom Cell Not Found!")
        }
        
        let symptomsValue = (self.navigateToSearchScreenThrough == .all) ? self.allSymptoms : self.mostCommonSymptoms
        let symptoms = (!isSearchBtnTapped) ? symptomsValue[indexPath.row] : self.searchResult[indexPath.row]
        symptomCell.cellLabel.text = symptoms.symptomName ?? ""
        let image = symptoms.isSymptomSelected == true ? #imageLiteral(resourceName: "icAppointmentSelectedcheck") : #imageLiteral(resourceName: "icAppointmentDeselectedradio")
        symptomCell.cellImage.image = image
        
        return symptomCell
    }
}

//MARk:- UITableViewDelegate Methods
//==================================
extension SymptomsSearchVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedSymptoms: AllSymptoms?
        let symptoms = (self.navigateToSearchScreenThrough == .all) ? self.allSymptoms : self.mostCommonSymptoms
        selectedSymptoms = (!isSearchBtnTapped) ? symptoms[indexPath.row] : self.searchResult[indexPath.row]
        if let sym = selectedSymptoms {
            if !self.selectedSymptoms.isEmpty {
                let index = self.selectedSymptoms.index(where: { (symptom) -> Bool in
                    return symptom.symptomId == sym.symptomId
                })
                guard let idx = index else{
                    sym.isSymptomSelected = true
                    self.selectedSymptoms.append(sym)
                    self.searchListingTableView.reloadRows(at: [indexPath], with: .automatic)
                    return
                }
                sym.isSymptomSelected = false
                self.selectedSymptoms.remove(at: idx)
            }else{
                sym.isSymptomSelected = true
                self.selectedSymptoms.append(sym)
            }
        }
        self.searchListingTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK:- Methods
//==============
extension SymptomsSearchVC {
    
    fileprivate func setupUI(){
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.text = "No Record Found!"
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.symptomSearchBar.delegate = self
        self.searchListingTableView.dataSource = self
        self.searchListingTableView.delegate = self
        self.allBtnOutlt.setTitle(K_ALL_TITLE.localized, for: .normal)
        self.allBtnOutlt.titleLabel?.font =  AppFonts.sanProSemiBold.withSize(16)
        self.allBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.allBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        self.allBtnOutlt.backgroundColor = UIColor.appColor
        self.allBtnOutlt.tintColor = UIColor.clear
        self.mostCommonBtnOutlt.backgroundColor = UIColor.gray
        self.mostCommonBtnOutlt.setTitle(K_MOST_COMMON.localized, for: .normal)
        self.mostCommonBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.mostCommonBtnOutlt.titleLabel?.font =  AppFonts.sanProSemiBold.withSize(16)
        self.mostCommonBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
        self.mostCommonBtnOutlt.tintColor = UIColor.clear
        let symptomsCell = UINib(nibName: "SymptomCell", bundle: nil)
        self.searchListingTableView.register(symptomsCell, forCellReuseIdentifier: "symptomCellID")
        
        self.selectedSymptom()
    }
    
    fileprivate func selectedSymptom(){
        var symptonIDArray: [String] = []
        if let symptomID = self.symptomID, !symptomID.isEmpty {
            symptonIDArray = symptomID.components(separatedBy: ",")
        }
        for symptoms in self.allSymptoms {
            if !symptonIDArray.isEmpty {
                for id in symptonIDArray {
                    if !id.isEmpty && (symptoms.symptomId == Int(id)) {
                        symptoms.isSymptomSelected = true
                        self.selectedSymptoms.append(symptoms)
                        break
                    }else{
                        symptoms.isSymptomSelected = false
                        continue
                    }
                }
            }else{
                for selectedSymptom in self.selectedSymptoms {
                    let isSymptomSelected = symptoms.symptomId == selectedSymptom.symptomId ? true : false
                    symptoms.isSymptomSelected = isSymptomSelected
                }
            }
        }
        self.getmostCommonSymtoms()
    }
    
    fileprivate func getmostCommonSymtoms(){
        let mostCommonSymptoms = self.allSymptoms.filter({ (symptoms) -> Bool in
            return symptoms.isMostCommon != 0
        })
        self.mostCommonSymptoms = mostCommonSymptoms
    }
}
