//
//  ActivityPlanVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityPlanVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var previousActivityData = [PreviousActivityPlan]()
    var currentActivityData = [CurrentActivityPlan]()
    var currentDosArray = [JSON]()
    var currentDontsArray = [JSON]()
    var previousDoArray = [JSON]()
    var previousDontsArray = [JSON]()
    var totalCurrentDuration = 0.0
    var totalCurrentDistance = 0.0
    var totalCurrentCalories = 0
    var totalPreviousDuration = 0.0
    var totalPreviousDistance = 0.0
    var totalPreviousCalories = 0
    var previousPlanTableHeight: CGFloat = 0
    var currentPlanTableHeight: CGFloat = 0
    
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var doctorDetailView: UIView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var activityPlanTableView: UITableView!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
        
        self.previousActivityPlan()
        self.currentActivityPlan()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Activity Plan", 2, 3)
        self.navigationControllerOn = .dashboard
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK:- UITableViewDataSource Methods
//====================================
extension ActivityPlanVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        if tableView === self.activityPlanTableView{
            
            return 2
        }else{
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.activityPlanTableView{
            
            return 1
        }else{
            
            if tableView is DietAutoResizingTableView{
                
                return self.previousActivityData.count
            }else{
                
                return self.currentActivityData.count
            } 
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView === self.activityPlanTableView {
            
            switch indexPath.section {
                
            case 0:
                
                guard let currentPlanViewCell = tableView.dequeueReusableCell(withIdentifier: "currentPlanViewCellID", for: indexPath) as? CurrentPlanViewCell else{
                    
                    fatalError("Current Plan Activity Cell not Found!")
                }
                
                currentPlanViewCell.shareBtnOutlet.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: UIControlEvents.touchUpInside)
                currentPlanViewCell.dosBtnOutlt.addTarget(self, action: #selector(self.dosBtntapped(_:)), for: UIControlEvents.touchUpInside)
                currentPlanViewCell.dontsBtnOutlt.addTarget(self, action: #selector(self.dontsBtntapped(_:)), for: UIControlEvents.touchUpInside)
                currentPlanViewCell.viewAttachmentBtnOutlt.addTarget(self, action: #selector(self.currentViewAttachmentBtntapped(_:)), for: .touchUpInside)
                currentPlanViewCell.currentPlanTableView.delegate = self
                currentPlanViewCell.currentPlanTableView.dataSource = self
                currentPlanViewCell.currentPlanTableView.heightDelegate = self
                currentPlanViewCell.currentPlanTableView.reloadData()
                
                currentPlanViewCell.populateData(self.totalCurrentDuration, self.totalCurrentDistance, self.totalCurrentCalories)
                
                if !self.currentActivityData.isEmpty{
                    
                    currentPlanViewCell.populateCurrentData(self.currentActivityData)
                }
                
                return currentPlanViewCell
                
            case 1:
                
                guard let previousActivityCell = tableView.dequeueReusableCell(withIdentifier: "pastActivityPlanTableViewCellID", for: indexPath) as? PastActivityPlanTableViewCell else{
                    
                    fatalError("Cell Not Found!")
                }
                
                previousActivityCell.doBtnOutlt.addTarget(self, action: #selector(self.dosBtntapped(_:)), for: UIControlEvents.touchUpInside)
                previousActivityCell.dontsBtnOutlt.addTarget(self, action: #selector(self.dontsBtntapped(_:)), for: UIControlEvents.touchUpInside)
                previousActivityCell.viewAttachmentBtnOult.addTarget(self, action: #selector(self.previousViewAttachmentBtntapped(_:)), for: .touchUpInside)
                
                previousActivityCell.pastActivityPlanTableView.delegate = self
                previousActivityCell.pastActivityPlanTableView.dataSource = self
                previousActivityCell.pastActivityPlanTableView.heightDelegate = self
                previousActivityCell.previousActivityCollectionView.delegate = self
                previousActivityCell.previousActivityCollectionView.dataSource = self
                previousActivityCell.pastActivityPlanTableView.reloadData()
                
                if !self.previousActivityData.isEmpty{
                    
                    previousActivityCell.populateData(self.previousActivityData)
                }
                
                return previousActivityCell
                //        case 1: guard let previousActivityDurationDateCell = tableView.dequeueReusableCell(withIdentifier: "previousActivityDurationDateCellID", for: indexPath) as? PreviousActivityDurationDateCell else{
                //
                //            fatalError("Current Plan Activity Cell not Found!")
                //        }
                //
                //        if !self.currentActivityData.isEmpty {
                //
                //            previousActivityDurationDateCell.populateCurrentData(self.currentActivityData, index: indexPath)
                //            previousActivityDurationDateCell.noDataAvailiableLabel.isHidden = true
                //            previousActivityDurationDateCell.activityDurationDatelabel.isHidden = false
                //            previousActivityDurationDateCell.imageBeforeDurationDate.isHidden = false
                //            previousActivityDurationDateCell.imageAfterDurationDate.isHidden = false
                //            previousActivityDurationDateCell.shareBtnOult.isHidden = false
                //
                //        }else{
                //
                //            previousActivityDurationDateCell.noDataAvailiableLabel.isHidden = false
                //            previousActivityDurationDateCell.activityDurationDatelabel.isHidden = true
                //            previousActivityDurationDateCell.imageBeforeDurationDate.isHidden = true
                //            previousActivityDurationDateCell.imageAfterDurationDate.isHidden = true
                //            previousActivityDurationDateCell.shareBtnOult.isHidden = true
                //            previousActivityDurationDateCell.noDataAvailiableLabel.text = "No Current Plans."
                //
                //        }
                //
                //        return previousActivityDurationDateCell
                //
                //        case 2: guard let currentActivityplantableViewCell = tableView.dequeueReusableCell(withIdentifier: "pastActivityPlanTableViewCellID", for: indexPath) as? PastActivityPlanTableViewCell else{
                //
                //            fatalError("Past Plan Activity Cell not Found!")
                //        }
                //
                //        currentActivityplantableViewCell.delegate = self
                //
                //        if !self.currentActivityData.isEmpty{
                //
                //            currentActivityplantableViewCell.currentActivityPlanData = self.currentActivityData
                //            currentActivityplantableViewCell.cellCountOnCurrentActivity = .currentActivity
                //            currentActivityplantableViewCell.pastActivityPlanTableView.reloadData()
                //        }
                //
                //        return currentActivityplantableViewCell
                //
                //        case 3: guard let dosAndDontsCell = tableView.dequeueReusableCell(withIdentifier: "dosAndDontsCellID", for: indexPath) as? DosAndDontsCell else{
                //
                //            fatalError("Dos And Donts Cell not Found!")
                //        }
                //
                //        dosAndDontsCell.dosBtnOult.addTarget(self, action: #selector(self.dosBtntapped(_:)), for: UIControlEvents.touchUpInside)
                //        dosAndDontsCell.dontsBtnOutlt.addTarget(self, action: #selector(self.dontsBtntapped(_:)), for: UIControlEvents.touchUpInside)
                //
                //        return dosAndDontsCell
                //
                //        default : fatalError("Cell not Found!")
                //
                //            }
                //
                //        case 1: switch indexPath.row {
                //
                //        case 0: guard let activityCollectionCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID", for: indexPath) as? MeasurementListCollectionCell else{
                //
                //            fatalError("activityCollectionCell Cell not Found!")
                //        }
                //
                //        activityCollectionCell.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
                ////        activityCollectionCell.measurementMentCollectionViewLeadingConstraint.constant = 2
                ////        activityCollectionCell.measurementMentCollectionViewTrailingConstraint.constant = 2
                //        activityCollectionCell.measurementListCollectionView.dataSource = self
                //        activityCollectionCell.measurementListCollectionView.delegate = self
                //
                //        if !self.previousActivityData.isEmpty{
                //
                //            activityCollectionCell.measurementListCollectionView.reloadData()
                //
                //        }
                //
                //        return activityCollectionCell
                //
                //        case 1: guard let previousActivityDurationDateCell = tableView.dequeueReusableCell(withIdentifier: "previousActivityDurationDateCellID", for: indexPath) as? PreviousActivityDurationDateCell else{
                //
                //            fatalError("Current Plan Activity Cell not Found!")
                //        }
                //
                //        if !self.previousActivityData.isEmpty{
                //
                //            previousActivityDurationDateCell.populateData(self.previousActivityData, indexPath)
                //            previousActivityDurationDateCell.activityDurationDatelabel.isHidden = false
                //            previousActivityDurationDateCell.imageBeforeDurationDate.isHidden = false
                //            previousActivityDurationDateCell.imageAfterDurationDate.isHidden = false
                //            previousActivityDurationDateCell.noDataAvailiableLabel.isHidden = true
                //            previousActivityDurationDateCell.shareBtnOult.isHidden = false
                //
                //        }else{
                //
                //            previousActivityDurationDateCell.activityDurationDatelabel.isHidden = true
                //            previousActivityDurationDateCell.imageBeforeDurationDate.isHidden = true
                //            previousActivityDurationDateCell.imageAfterDurationDate.isHidden = true
                //            previousActivityDurationDateCell.activityDurationDatelabel.isHidden = true
                //            previousActivityDurationDateCell.noDataAvailiableLabel.isHidden = false
                //            previousActivityDurationDateCell.noDataAvailiableLabel.text = "No Previous Plans."
                //            previousActivityDurationDateCell.shareBtnOult.isHidden = true
                //        }
                //
                //        previousActivityDurationDateCell.shareBtnOult.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: UIControlEvents.touchUpInside)
                //
                //        return previousActivityDurationDateCell
                //
                //        case 2: guard let previousActivityplanTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pastActivityPlanTableViewCellID", for: indexPath) as? PastActivityPlanTableViewCell else{
                //
                //            fatalError("Past Plan Activity Cell not Found!")
                //        }
                //
                //        previousActivityplanTableViewCell.delegate = self
                //
                //        if !self.previousActivityData.isEmpty {
                //
                //            previousActivityplanTableViewCell.previousActivityPlanData = self.previousActivityData
                //            previousActivityplanTableViewCell.cellCountOnCurrentActivity = .previousActivity
                //            previousActivityplanTableViewCell.pastActivityPlanTableView.reloadData()
                //
                //        }
                //
                //        return previousActivityplanTableViewCell
                //
                //        case 3: guard let dosAndDontsCell = tableView.dequeueReusableCell(withIdentifier: "dosAndDontsCellID", for: indexPath) as? DosAndDontsCell else{
                //
                //            fatalError("Dos And Donts Cell not Found!")
                //        }
                //
                //        dosAndDontsCell.dosBtnOult.addTarget(self, action: #selector(self.dosBtntapped(_:)), for: UIControlEvents.touchUpInside)
                //        dosAndDontsCell.dontsBtnOutlt.addTarget(self, action: #selector(self.dontsBtntapped(_:)), for: UIControlEvents.touchUpInside)
                //
                //        return dosAndDontsCell
                //
                //        default : fatalError("Cell Not Found!")
                //
                //            }
                
            default : fatalError("Sections Not Found!")
            }
        }else{
            
            guard let viewAttachmentCell = tableView.dequeueReusableCell(withIdentifier: "viewAttachmentCellID") as? ViewAttachmentCell else{
                
                fatalError("viewAttachmentCell not found!")
            }
            
            if tableView is DietAutoResizingTableView {
                
                if !previousActivityData.isEmpty {
                    
                    viewAttachmentCell.populatePreviousActivityData(self.previousActivityData, indexPath)
                }
                
            }else{
                
                if !currentActivityData.isEmpty{
                    
                    viewAttachmentCell.populateCurrentActivityData(self.currentActivityData, indexPath)
                }
            }
            
            return viewAttachmentCell
        }
    }
}

//MARK:- AutoResizingTableViewDelegate Methods
//============================================
extension ActivityPlanVC : AutoResizingTableViewDelegate {
    
    func didUpdateTableHeight(_ tableView: UITableView, height: CGFloat) {
        if tableView is DietAutoResizingTableView, currentPlanTableHeight < height {
            currentPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        } else if tableView !== self.activityPlanTableView, previousPlanTableHeight < height {
            previousPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        }
    }
    
    func reloadTable() {
        
        self.activityPlanTableView.beginUpdates()
        self.activityPlanTableView.endUpdates()
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension ActivityPlanVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0, tableView === self.activityPlanTableView {
            return 360+currentPlanTableHeight
        } else if indexPath.section == 1, tableView === self.activityPlanTableView {
            return 287+previousPlanTableHeight
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView === self.activityPlanTableView {
            
            return 400
        }else{
            
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if tableView === self.activityPlanTableView {
            
            return 35
        }else{
            
            return 0
        } 
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView === self.activityPlanTableView {
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
                
                fatalError("HeaderView Not Found!")
            }
            
            if section == 0{
                
                headerView.activityStatusLabel.text = "CURRENT"
                headerView.activityDateLabel.text = Date().stringFormDate(DateFormat.ddMMMYYYY.rawValue)
                
            }else{
                
                headerView.activityStatusLabel.text = "PREVIOUS"
                
                if !self.previousActivityData.isEmpty{
                    
                    if let planStartDate = previousActivityData[0].planStartDate{
                        
                        headerView.activityDateLabel.text = planStartDate.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue)
                    }
                }
            }
            
            return headerView
        }
        else{
            
            return nil
        }
    }
}


//MARK:- UICollectionViewDataSource
//=================================
extension ActivityPlanVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityPlanCollectionCellID", for: indexPath) as? ActivityPlanCollectionCell else{
            
            fatalError("ActivityPlanCollectionCell Not Found!")
        }
        
        cell.averageLabel.isHidden = true
        
        if indexPath.item == 0 {
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanClock")
            cell.activityValueLabel.text = String(self.totalPreviousDuration)
            cell.activityValueLabel.textColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
            cell.activityUnitLabel.text = "mins"
            
            
        }else if indexPath.item == 1{
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanDistance")
            cell.activityValueLabel.text = String(self.totalPreviousDistance)
            cell.activityValueLabel.textColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
            cell.activityUnitLabel.text = "kms"
            
        }else{
            
            cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanCal")
            cell.activityValueLabel.text = String(self.totalPreviousCalories)
            cell.activityValueLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.05098039216, alpha: 1)
            cell.activityUnitLabel.text = "kcal"
            
        }
        
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
//=========================================
extension ActivityPlanVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 3) - 4, height: collectionView.frame.height - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(2)
    }
}

//MARK:- Methods
//==============
extension ActivityPlanVC {
    
    //    MARK: SetupUI
    //    =============
    fileprivate func setupUI(){
        
        self.doctorDetailView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.doctorSpecialityLabel.font = AppFonts.sansProRegular.withSize(11.3)
        self.doctorSpecialityLabel.textColor = #colorLiteral(red: 0.003921568627, green: 0, blue: 0, alpha: 1)
        
        self.activityPlanTableView.backgroundColor = #colorLiteral(red: 0.952861011, green: 0.9529944062, blue: 0.9528189301, alpha: 1)
        
        self.activityPlanTableView.dataSource = self
        self.activityPlanTableView.delegate = self
        
        self.registerNibs()
        
    }
    //    MARk: Register Nibs
    //    ===================
    fileprivate func registerNibs(){
        
        let currentPlanViewNib = UINib(nibName: "CurrentPlanViewCell", bundle: nil)
        let dosAndDontsCellNib = UINib(nibName: "DosAndDontsCell", bundle: nil)
        let measurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let previousActivityDurationDateCellNib = UINib(nibName: "PreviousActivityDurationDateCell", bundle: nil)
        let pastActivityPlanTableViewCellNib = UINib(nibName: "PastActivityPlanTableViewCell", bundle: nil)
        let activityPlanDateCellNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)
        let previousActivityPlanNib = UINib(nibName: "TargetCalorieTableCell", bundle: nil)
        
        self.activityPlanTableView.register(previousActivityPlanNib, forCellReuseIdentifier: "targetCalorieTableCellID")
        
        self.activityPlanTableView.register(currentPlanViewNib, forCellReuseIdentifier: "currentPlanViewCellID")
        self.activityPlanTableView.register(dosAndDontsCellNib, forCellReuseIdentifier: "dosAndDontsCellID")
        self.activityPlanTableView.register(measurementListCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.activityPlanTableView.register(previousActivityDurationDateCellNib, forCellReuseIdentifier: "previousActivityDurationDateCellID")
        self.activityPlanTableView.register(pastActivityPlanTableViewCellNib, forCellReuseIdentifier: "pastActivityPlanTableViewCellID")
        self.activityPlanTableView.register(activityPlanDateCellNib, forHeaderFooterViewReuseIdentifier: "activityPlanDateCellID")
        
    }
    
    //    MARK: Share Button Tapped
    //    =========================
    @objc fileprivate func shareBtntapped(_ sender : UIButton){
        
        let shareText = "Check My Activity"
        
        let ActivityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        self.present(ActivityController, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func dosBtntapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.activityPlanTableView) else{
            return
        }
        
        switch index.section {
            
        case 0 :
            
            self.openDosDontsAddSubView(self.currentDosArray, dosBtnTapped: true)
            
        case 1:
            
            self.openDosDontsAddSubView(self.previousDoArray, dosBtnTapped: true)
            
        default : return
        }
    }
    
    @objc fileprivate func dontsBtntapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.activityPlanTableView) else{
            return
        }
        
        switch index.section {
            
        case 0 :
            
            self.openDosDontsAddSubView(self.currentDontsArray, dosBtnTapped: false)
            
        case 1:
            
            self.openDosDontsAddSubView(self.previousDontsArray, dosBtnTapped: false)
            
        default : return
        }
    }
    
    fileprivate func openDosDontsAddSubView(_ dosDontsArray : [JSON], dosBtnTapped : Bool){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        
        dosAndDontsScene.dosDontsValues = dosDontsArray
        
        if dosBtnTapped == true{
            
            dosAndDontsScene.buttonTapped = .dos
        }else{
            
            dosAndDontsScene.buttonTapped = .donts
        }
        
        dosAndDontsScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            dosAndDontsScene.view.frame = CGRect(x: 0, y: 0 , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        }
        
        sharedAppDelegate.window?.addSubview(dosAndDontsScene.view)
        self.addChildViewController(dosAndDontsScene)
        
    }
    
//    MARK:- CurrentViewAttachment
//    ===========================
    @objc fileprivate func currentViewAttachmentBtntapped(_ sender : UIButton){
        
        if !self.currentActivityData.isEmpty{
            
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            if self.currentActivityData[0].attachments!.count > 1{
                
                if let attachUrl = self.currentActivityData[0].attachments, !attachUrl.isEmpty {
                    
                    attachmentUrl = attachUrl.components(separatedBy: ",")
                }
                
                if let attachName = self.currentActivityData[0].attachemntsName, !attachName.isEmpty {
                    
                    attachmentName = attachName.components(separatedBy: ",")
                }
                
                self.attachmentView(attachmentUrl, attachmentName)
                
            }else{
                
                var attachmentUrl = ""
                var attachmentName = ""
                
                if !self.currentActivityData[0].attachments!.isEmpty{
                    
                    attachmentUrl = self.currentActivityData[0].attachments!
                    
                }
                
                if self.currentActivityData[0].attachemntsName!.isEmpty{
                    
                    attachmentName = self.currentActivityData[0].attachemntsName!
                }
                
                self.openWebView(attachmentUrl, attachmentName)
                
            }
        }
    }
    
    @objc fileprivate func previousViewAttachmentBtntapped(_ sender : UIButton){
        
        if !self.previousActivityData.isEmpty{
            
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            if self.previousActivityData[0].attachments!.count > 1{
                
                if let attachUrl = self.previousActivityData[0].attachments, !attachUrl.isEmpty {
                    
                    attachmentUrl = attachUrl.components(separatedBy: ",")
                }
                
                if let attachName = self.previousActivityData[0].attachemntsName, !attachName.isEmpty {
                    
                    attachmentName = attachName.components(separatedBy: ",")
                }
                
                self.attachmentView(attachmentUrl, attachmentName)
                
            }else if self.previousActivityData[0].attachments!.count > 0 && self.previousActivityData[0].attachments!.count <= 1 {
                
                var attachmentUrl = ""
                var attachmentName = ""
                
                if !self.previousActivityData[0].attachments!.isEmpty{
                    
                    attachmentUrl = self.previousActivityData[0].attachments!
                    
                }
                
                if self.previousActivityData[0].attachemntsName!.isEmpty{
                    
                    attachmentName = self.previousActivityData[0].attachemntsName!
                }
                
                self.openWebView(attachmentUrl, attachmentName)
                
            }
        }
    }
    
    fileprivate func attachmentView(_ attachmentUrl : [String], _ attachmentName : [String]){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        dosAndDontsScene.attachmentURl = attachmentUrl
        dosAndDontsScene.attachmentName = attachmentName
        dosAndDontsScene.buttonTapped = .attachment
        dosAndDontsScene.view.frame = CGRect(x: 0, y: UIDevice.getScreenHeight, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        
        UIView.animate(withDuration: 0.3) {
            
            dosAndDontsScene.view.frame = CGRect(x: 0, y: 0 , width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight)
        }
        
        sharedAppDelegate.window?.addSubview(dosAndDontsScene.view)
        self.addChildViewController(dosAndDontsScene)
        
    }
    
    fileprivate func openWebView(_ attachmentUrl : String, _ attachmentName : String){
        
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.webViewUrl = attachmentUrl
        webViewScene.screenName = attachmentName
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}

//MARK :- WebServices
//===================
extension ActivityPlanVC {
    
    func previousActivityPlan(){
        
        let params = [String : Any]()
        
        WebServices.getPreviousActivity(parameters: params,
                                        success: { (_ previousActivityData : [PreviousActivityPlan], _ dos : [JSON], _ donts : [JSON]) in
                                            
                                            if !previousActivityData.isEmpty {
                                                
                                                self.previousActivityData = previousActivityData
                                                
                                                for i in 0...previousActivityData.count - 1 {
                                                    
                                                    if let caloriesBurn  = previousActivityData[i].caloriesBurn{
                                                        
                                                        self.totalPreviousCalories = self.totalPreviousCalories + caloriesBurn
                                                    }
                                                    
                                                    if let totalDuration = previousActivityData[i].activityDuration{
                                                        
                                                        self.totalPreviousDuration = self.totalPreviousDuration + totalDuration
                                                    }
                                                    
                                                    if let totalDistance = previousActivityData[i].totalDistance{
                                                        
                                                        self.totalPreviousDistance = self.totalPreviousDistance + totalDistance
                                                    }
                                                }
                                                
                                            }else{
                                                
                                                
                                                
                                                
                                            }
                                            
                                            if !dos.isEmpty{
                                                
                                                self.previousDoArray = dos
                                            }
                                            
                                            if !donts.isEmpty{
                                                
                                                self.previousDontsArray = donts
                                            }
                                            
                                            self.activityPlanTableView.reloadData()
                                            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    func currentActivityPlan(){
        
        let params = [String : Any]()
        
        WebServices.getCurrentActivity(parameters: params, success: { (_ currentActivityPlan : [CurrentActivityPlan], _ dos :[JSON], _ donts : [JSON]) in
            
            if !currentActivityPlan.isEmpty {
                
                self.currentActivityData = currentActivityPlan
                
                if let doctorName = currentActivityPlan[0].doctorname{
                    
                    self.doctorNameLabel.text = doctorName
                }else{
                    
                    self.doctorNameLabel.text = AppUserDefaults.value(forKey: AppUserDefaults.Key.doctorName).stringValue
                }
                
                if let doctorSpeciality = currentActivityPlan[0].doctorSpeciality{
                    
                    self.doctorSpecialityLabel.text = doctorSpeciality
                    
                }else{
                    
                    self.doctorSpecialityLabel.text = AppUserDefaults.value(forKey: AppUserDefaults.Key.doctorSpecialization).stringValue
                }
                
                for i in 0...currentActivityPlan.count - 1{
                    
                    if let caloriesBurn  = currentActivityPlan[i].caloriesBurn{
                        
                        self.totalCurrentCalories = self.totalCurrentCalories + caloriesBurn
                    }
                    
                    if let totalDuration = currentActivityPlan[i].activityDuration{
                        
                        self.totalCurrentDuration = self.totalCurrentDuration + totalDuration
                    }
                    
                    if let totalDistance = currentActivityPlan[i].totalDistance{
                        
                        self.totalCurrentDistance = self.totalCurrentDistance + totalDistance
                    }
                }
                
            }else{
                
                
                
                
            }
            
            if !dos.isEmpty{
                
                self.currentDosArray = dos
            }
            
            if !donts.isEmpty{
                
                self.currentDontsArray = donts
            }
            
            self.activityPlanTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
}

