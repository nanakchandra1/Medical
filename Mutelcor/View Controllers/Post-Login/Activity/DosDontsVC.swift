//
//  DosDontsVCViewController.swift
//  Mutelcor
//
//  Created by on 16/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ButtonTapped {
    
    case dos
    case donts
    case foodToAvoid
    case dailyAllowances
    case attachment
}

protocol OpenWebViewDelegate: class {
    func attachmentData(_ attachmentURl : String, attachmentData : String)
}

class DosDontsVC: UIViewController {
    
    //    MARk:- Proporties
    //    ==================
    var buttonTapped  = ButtonTapped.dos
    var dosDontsValues = [JSON]()
    var nutritionPointToRemember = [NutritionPointToRemember]()
    var pointsToRemember = [PointsToRemember]()
    var foodToAvoidArray = [String]()
    var attachmentURl = [String]()
    var attachmentName = [String]()
    weak var delegate: OpenWebViewDelegate?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainTableView: UIView!
    @IBOutlet weak var ViewTitle: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var okBtnOutlt: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    @IBOutlet weak var DosDontsTableView: UITableView!
    @IBOutlet weak var viewConatinTableViewCenter: NSLayoutConstraint!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewConatinTableViewCenter.constant = 0.7*UIDevice.getScreenHeight
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.viewConatinTableViewCenter.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        self.removeDoDontVCSubView()
    }
    
    fileprivate func setupUI(){
        
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        self.viewContainTableView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        
        self.okBtnOutlt.setTitle(K_OK_TITLE.localized, for: UIControlState.normal)
        self.okBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.okBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.okBtnOutlt.backgroundColor = UIColor.appColor
        self.okBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        
        if self.buttonTapped == ButtonTapped.dos{
            self.ViewTitle.text = K_DOS_TITLE.localized
        }else if self.buttonTapped == .donts {
            self.ViewTitle.text = K_DONTS_TITLE.localized
        }else if self.buttonTapped == .foodToAvoid {
            self.ViewTitle.text = K_FOODS_TO_AVOID_TITLE.localized
        }else if self.buttonTapped == .dailyAllowances{
            self.ViewTitle.text = K_DAILY_ALLOWANCES_TITLE.localized
        }else{
            self.ViewTitle.text = K_ATTACHMENTS_SECTION_TITLE_PLACEHOLDER.localized
        }
        
        if self.dosDontsValues.isEmpty && self.foodToAvoidArray.isEmpty && self.attachmentURl.isEmpty{
            self.noDataAvailiableLabel.isHidden = false
            self.noDataAvailiableLabel.text = "No Record Found!"
        }else{
            self.noDataAvailiableLabel.isHidden = true
        }
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        self.ViewTitle.textColor = UIColor.appColor
        self.sepratorView.backgroundColor = UIColor.appColor
        self.ViewTitle.font = AppFonts.sansProBold.withSize(12)
        
        self.DosDontsTableView.dataSource = self
        self.DosDontsTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let dosDontsNib = UINib(nibName: "DosDontsCell", bundle: nil)
        self.DosDontsTableView.register(dosDontsNib, forCellReuseIdentifier: "dosDontsCellID")
        
        let headerNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)
        self.DosDontsTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "activityPlanDateCellID")
    }
    
    fileprivate func removeDoDontVCSubView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            let halfHeight = 0.7*UIDevice.getScreenHeight
            self.viewConatinTableViewCenter.constant = halfHeight
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

//MARK:- UITableViewDelegate and UITableViewDataSource
//====================================================
extension DosDontsVC : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch self.buttonTapped {
        case .dailyAllowances:
            return 2
        case .dos:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch self.buttonTapped {
            
        case .foodToAvoid:
            return self.foodToAvoidArray.count
        case .dailyAllowances:
            let rowsCount = section == 0 ? self.foodToAvoidArray.count : self.nutritionPointToRemember.count
            return rowsCount
        case .attachment:
            return self.attachmentURl.count
        case .donts:
            return self.dosDontsValues.count
        case .dos:
            let rowsCount = section == 0 ? self.dosDontsValues.count : self.pointsToRemember.count
            return rowsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dosDontsCellID", for: indexPath) as? DosDontsCell else{
            
            fatalError("Dos And Donts Cell Not Found!")
        }
        
        cell.populateData(buttonTapped: self.buttonTapped, foodToAvoid: self.foodToAvoidArray, attachment: self.attachmentName, dosDonts: self.dosDontsValues, pointsToRemember: self.pointsToRemember, indexPath: indexPath, nutritionPointToRemember: self.nutritionPointToRemember)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
            fatalError("HeaderView Not Found!")
        }
        headerView.activityDateLabel.isHidden = true
        headerView.activityStatusLabel.textColor = UIColor.appColor
        headerView.activityStatusLabel.text = K_POINTS_TO_REMEMBER.localized
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch self.buttonTapped {
            
        case .dailyAllowances:
            let sectionHeight = self.nutritionPointToRemember.isEmpty ? CGFloat.leastNormalMagnitude : 30.0
            let heightForHeader: CGFloat = (section == 0) ? CGFloat.leastNormalMagnitude : sectionHeight
            return heightForHeader
        case .dos:
            let sectionHeight = self.pointsToRemember.isEmpty ? CGFloat.leastNormalMagnitude : 30.0
            let heightForHeader: CGFloat = (section == 0) ? CGFloat.leastNormalMagnitude : sectionHeight
            return heightForHeader
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.buttonTapped == .attachment {
            self.removeDoDontVCSubView()
            self.delegate?.attachmentData(self.attachmentURl[indexPath.row], attachmentData: self.attachmentName[indexPath.row])
        }
    }
}
