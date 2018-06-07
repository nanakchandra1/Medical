//
//  ActivityPlanVC.swift
//  Mutelcor
//
//  Created by on 15/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityPlanVC: BaseViewControllerWithBackButton {
    
    //    MARK:- Proporties
    //    =================
    fileprivate var previousActivityData = [PreviousActivityPlan]()
    fileprivate var currentActivityData = [PreviousActivityPlan]()
    fileprivate var currentDosArray = [JSON]()
    fileprivate var currentDontsArray = [JSON]()
    fileprivate var currentPointsToRemember = [PointsToRemember]()
    fileprivate var previousDoArray = [JSON]()
    fileprivate var previousDontsArray = [JSON]()
    fileprivate var previousPointsToRemember = [PointsToRemember]()
    fileprivate var totalCurrentDuration = 0.0
    fileprivate var totalCurrentDistance = 0.0
    fileprivate var totalCurrentCalories = 0
    fileprivate var totalPreviousDuration = 0.0
    fileprivate var totalPreviousDistance = 0.0
    fileprivate var totalPreviousCalories = 0
    fileprivate var previousPlanTableHeight: CGFloat = 0
    fileprivate var currentPlanTableHeight: CGFloat = 0
    fileprivate var isCurrentPlanTableCompletelyUpdated = false
    fileprivate var isPreviousPlanTableCompletelyUpdated = false
    fileprivate var isCurrentActivityServiceHit: Bool = false
    fileprivate var isPreviousActivityServiceHit: Bool = false
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var doctorDetailView: UIView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var activityPlanTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.currentActivityPlan()
        self.previousActivityPlan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .activity
        self.setNavigationBar(screenTitle: K_ACTIVITY_PLAN_SCREEN_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension ActivityPlanVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        let section = (tableView === self.activityPlanTableView) ? 2 : 1
        return section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInDietAutoResizingTableView = (tableView is DietAutoResizingTableView) ? self.previousActivityData.count : self.currentActivityData.count
        let sectionsInTableView = (tableView === self.activityPlanTableView) ? 1 : sectionInDietAutoResizingTableView
        return sectionsInTableView
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
                currentPlanViewCell.viewAttachmentBtnOutlt.addTarget(self, action: #selector(self.currentViewAttachmentBtnTapped(_:)), for: .touchUpInside)
                currentPlanViewCell.currentPlanTableView.delegate = self
                currentPlanViewCell.currentPlanTableView.dataSource = self
                currentPlanViewCell.currentPlanTableView.heightDelegate = self
                currentPlanViewCell.currentPlanTableView.reloadData()
                
                currentPlanViewCell.populateData(self.totalCurrentDuration, self.totalCurrentDistance, self.totalCurrentCalories)
                currentPlanViewCell.populateCurrentData(self.currentActivityData)
                return currentPlanViewCell
            case 1:
                guard let previousActivityCell = tableView.dequeueReusableCell(withIdentifier: "pastActivityPlanTableViewCellID", for: indexPath) as? PastActivityPlanTableViewCell else{
                    fatalError("Cell Not Found!")
                }
                
                previousActivityCell.doBtnOutlt.addTarget(self, action: #selector(self.dosBtntapped(_:)), for: UIControlEvents.touchUpInside)
                previousActivityCell.dontsBtnOutlt.addTarget(self, action: #selector(self.dontsBtntapped(_:)), for: UIControlEvents.touchUpInside)
                previousActivityCell.viewAttachmentBtnOult.addTarget(self, action: #selector(self.previousViewAttachmentBtnTapped(_:)), for: .touchUpInside)
                previousActivityCell.shareBtnOutlt.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: UIControlEvents.touchUpInside)
                previousActivityCell.pastActivityPlanTableView.delegate = self
                previousActivityCell.pastActivityPlanTableView.dataSource = self
                previousActivityCell.pastActivityPlanTableView.heightDelegate = self
                previousActivityCell.previousActivityCollectionView.delegate = self
                previousActivityCell.previousActivityCollectionView.dataSource = self
                previousActivityCell.pastActivityPlanTableView.reloadData()
                
                previousActivityCell.populateData(self.previousActivityData)
                return previousActivityCell
                
            default :
                fatalError("Sections Not Found!")
            }
        }else{
            
            guard let viewAttachmentCell = tableView.dequeueReusableCell(withIdentifier: "viewAttachmentCellID") as? ViewAttachmentCell else{
                fatalError("viewAttachmentCell not found!")
            }
            
            if tableView is DietAutoResizingTableView {
                viewAttachmentCell.populatePreviousActivityData(self.previousActivityData, indexPath)
            }else{
                viewAttachmentCell.populateCurrentActivityData(self.currentActivityData, indexPath)
            }
            
            return viewAttachmentCell
        }
    }
}

//MARK:- AutoResizingTableViewDelegate Methods
//============================================
extension ActivityPlanVC : AutoResizingTableViewDelegate {
    
    func didUpdateTableHeight(_ tableView: UITableView, height: CGFloat) {

        if !isPreviousPlanTableCompletelyUpdated, tableView is DietAutoResizingTableView, previousPlanTableHeight != height/*, previousPlanTableHeight < height*/ {
            previousPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
            
        } else if !isCurrentPlanTableCompletelyUpdated, tableView !== self.activityPlanTableView, currentPlanTableHeight != height/*, currentPlanTableHeight < height*/ {
            currentPlanTableHeight = height
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reloadTable), with: self, afterDelay: 0.05)
        }
    }
    
    @objc func reloadTable() {
        self.activityPlanTableView.beginUpdates()
        self.activityPlanTableView.endUpdates()
        //self.activityPlanTableView.reloadData()
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension ActivityPlanVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0, tableView === self.activityPlanTableView {
            let height = (!self.currentActivityData.isEmpty) ? 402+currentPlanTableHeight : CGFloat.leastNormalMagnitude
            return height
        } else if indexPath.section == 1, tableView === self.activityPlanTableView {
            let height = (!self.previousActivityData.isEmpty) ? 287+previousPlanTableHeight : CGFloat.leastNormalMagnitude
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let estimatedHeight = (tableView === self.activityPlanTableView) ? 400 : 30
        return CGFloat(estimatedHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if tableView === self.activityPlanTableView {
            
            switch section {
            case 0:
                let height = (!self.currentActivityData.isEmpty) ? 35 : CGFloat.leastNormalMagnitude
                return height
            case 1:
                let height = (!self.previousActivityData.isEmpty) ? 35 : CGFloat.leastNormalMagnitude
                return height
            default:
                return CGFloat.leastNormalMagnitude
            }
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView === self.activityPlanTableView {
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
                fatalError("HeaderView Not Found!")
            }
            
            if section == 0 {
                headerView.activityStatusLabel.text = K_CURRENT_TITLE.localized.uppercased()
                if let data = self.currentActivityData.first {
                    let date = data.createdDate?.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
                    headerView.activityDateLabel.text = date
                }
            }else{                
                headerView.activityStatusLabel.text = K_PREVIOUS_TITLE.localized.uppercased()
                if !self.previousActivityData.isEmpty{
                    if let planStartDate = previousActivityData[0].createdDate{
                        headerView.activityDateLabel.text = planStartDate.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
                    }
                }
            }
            return headerView
        } else {
            return nil
        }
    }

    /*
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView === self.activityPlanTableView else {
            return
        }

        if indexPath.section == 0 {
            isCurrentPlanTableCompletelyUpdated = true
        } else {
            isPreviousPlanTableCompletelyUpdated = true
        }
    }
    */
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
        cell.populatePreviousPlanData(duration: self.totalPreviousDuration, distance: self.totalPreviousDistance, calories: self.totalPreviousCalories, indexPath: indexPath)

        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
//=========================================
extension ActivityPlanVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 6, height: collectionView.frame.height - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 3
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
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.text = K_NO_ACTIVITY_PLAN.localized
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(15)
        self.noDataAvailiableLabel.isHidden = true
        
        if let docName = AppUserDefaults.value(forKey: .doctorName).string, !docName.isEmpty {
            self.doctorNameLabel.text = docName
        }
        
        self.doctorSpecialityLabel.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
        self.activityPlanTableView.backgroundColor = #colorLiteral(red: 0.952861011, green: 0.9529944062, blue: 0.9528189301, alpha: 1)
        
        self.activityPlanTableView.dataSource = self
        self.activityPlanTableView.delegate = self
        
        self.registerNibs()
    }
    //    MARk: Register Nibs
    //    ===================
    fileprivate func registerNibs(){
        
        let currentPlanViewNib = UINib(nibName: "CurrentPlanViewCell", bundle: nil)
        
        let measurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let previousActivityDurationDateCellNib = UINib(nibName: "PreviousActivityDurationDateCell", bundle: nil)
        let pastActivityPlanTableViewCellNib = UINib(nibName: "PastActivityPlanTableViewCell", bundle: nil)
        let activityPlanDateCellNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)
        let previousActivityPlanNib = UINib(nibName: "TargetCalorieTableCell", bundle: nil)
        
        self.activityPlanTableView.register(previousActivityPlanNib, forCellReuseIdentifier: "targetCalorieTableCellID")
        self.activityPlanTableView.register(currentPlanViewNib, forCellReuseIdentifier: "currentPlanViewCellID")
        self.activityPlanTableView.register(measurementListCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.activityPlanTableView.register(previousActivityDurationDateCellNib, forCellReuseIdentifier: "previousActivityDurationDateCellID")
        self.activityPlanTableView.register(pastActivityPlanTableViewCellNib, forCellReuseIdentifier: "pastActivityPlanTableViewCellID")
        self.activityPlanTableView.register(activityPlanDateCellNib, forHeaderFooterViewReuseIdentifier: "activityPlanDateCellID")
        
    }
    
    //    MARK: Share Button Tapped
    //    =========================
    @objc fileprivate func shareBtntapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.activityPlanTableView) else{
            return
        }
        
        switch indexPath.section {
            
        case 0:
            guard !self.currentActivityData.isEmpty else{
                return
            }
            let pdfLink = self.currentActivityData[indexPath.row].pdfFile ?? ""
            self.openShareViewController(pdfLink: pdfLink)
            
        case 1:
            guard !self.previousActivityData.isEmpty else{
                return
            }
            let pdfLink = self.previousActivityData[indexPath.row].pdfFile ?? ""
            self.openShareViewController(pdfLink: pdfLink)
        default:
            return
        }
    }
    
    @objc fileprivate func dosBtntapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.activityPlanTableView) else{
            return
        }
        
        let dosBtnArray = (index.section == false.rawValue) ? self.currentDosArray : self.previousDoArray
        let pointToRemember = (index.section == false.rawValue) ? self.currentPointsToRemember : self.previousPointsToRemember
        self.openDosDontsAddSubView(dosBtnArray, dosBtnTapped: true, pointToRemember)
    }
    
    @objc fileprivate func dontsBtntapped(_ sender : UIButton){
        
        guard let index = sender.tableViewIndexPathIn(self.activityPlanTableView) else{
            return
        }
        
        let dosBtnArray = (index.section == false.rawValue) ? self.currentDontsArray : self.previousDontsArray
        self.openDosDontsAddSubView(dosBtnArray, dosBtnTapped: false, [])
    }
    
    fileprivate func openDosDontsAddSubView(_ dosDontsArray : [JSON], dosBtnTapped : Bool, _ pointToRemember : [PointsToRemember]){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        dosAndDontsScene.dosDontsValues = dosDontsArray
        dosAndDontsScene.pointsToRemember = pointToRemember
        let buttonTapped: ButtonTapped = (dosBtnTapped) ? .dos : .donts
        dosAndDontsScene.buttonTapped = buttonTapped
        
        dosAndDontsScene.modalPresentationStyle = .overCurrentContext
        self.present(dosAndDontsScene, animated: false, completion: nil)
    }
    
    //    MARK:- CurrentViewAttachment
    //    ===========================
    @objc fileprivate func currentViewAttachmentBtnTapped(_ sender : UIButton){
        
        if !self.currentActivityData.isEmpty{
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            let attachment = self.currentActivityData[0].attachments ?? ""
            if !attachment.isEmpty{
                attachmentUrl = attachment.components(separatedBy: ",")
            }
            if let attachName = self.currentActivityData[0].attachemntsName{
                attachmentName = attachName.components(separatedBy: ",")
            }
            
            if !attachmentUrl.isEmpty {
                if  attachmentUrl.count > 1{
                    self.attachmentView(attachmentUrl, attachmentName)
                }else{
                    let attachName = attachmentName.first ?? ""
                    self.openWebView(attachmentUrl[0], attachName)
                }
            }
        }else{
            showToastMessage("No attachments.")
        }
    }
    
    @objc fileprivate func previousViewAttachmentBtnTapped(_ sender : UIButton){
        
        if !self.previousActivityData.isEmpty{
            var attachmentUrl = [String]()
            var attachmentName = [String]()
            
            let attachment = self.previousActivityData[0].attachments ?? ""
            if attachment.isEmpty {
                attachmentUrl = attachment.components(separatedBy: ",")
            }
            if let attachName = self.previousActivityData[0].attachemntsName{
                attachmentName = attachName.components(separatedBy: ",")
            }
            if !attachmentUrl.isEmpty {
                if  attachmentUrl.count > 1{
                    self.attachmentView(attachmentUrl, attachmentName)
                }else{
                    let attachName = attachmentName.first ?? ""
                    self.openWebView(attachmentUrl[0], attachName)
                }
            }
        }else{
            showToastMessage("No attachments.")
        }
    }
    
    fileprivate func attachmentView(_ attachmentUrl : [String], _ attachmentName : [String]){
        
        let dosAndDontsScene = DosDontsVC.instantiate(fromAppStoryboard: .Activity)
        dosAndDontsScene.attachmentURl = attachmentUrl
        dosAndDontsScene.attachmentName = attachmentName
        dosAndDontsScene.buttonTapped = .attachment
        dosAndDontsScene.delegate = self
        dosAndDontsScene.modalPresentationStyle = .overCurrentContext
        self.present(dosAndDontsScene, animated: false, completion: nil)
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
                                        success: {[weak self] (_ previousActivityData : [PreviousActivityPlan], _ dos : [JSON], _ donts : [JSON], _ pointToRemember : [PointsToRemember]) in
                                            
                                            guard let strongSelf = self else{
                                                return
                                            }
                                            strongSelf.isPreviousActivityServiceHit = true
                                            if !previousActivityData.isEmpty {
                                                
                                                strongSelf.previousActivityData = previousActivityData
                                                
                                                for i in 0...previousActivityData.count - 1 {
                                                    if let caloriesBurn  = previousActivityData[i].caloriesBurn{
                                                        strongSelf.totalPreviousCalories = strongSelf.totalPreviousCalories + caloriesBurn
                                                    }
                                                    if let totalDuration = previousActivityData[i].activityDuration{
                                                        strongSelf.totalPreviousDuration = strongSelf.totalPreviousDuration + totalDuration
                                                    }
                                                    if let totalDistance = previousActivityData[i].totalDistance{
                                                        strongSelf.totalPreviousDistance = strongSelf.totalPreviousDistance + totalDistance
                                                    }
                                                }
                                            }
                                            
                                            if !dos.isEmpty{
                                                strongSelf.previousDoArray = dos
                                            }
                                            
                                            if !donts.isEmpty{
                                                strongSelf.previousDontsArray = donts
                                            }
                                            if !pointToRemember.isEmpty {
                                                strongSelf.previousPointsToRemember = pointToRemember
                                            }
                                            
                                            strongSelf.isNoDataAvailiableTextDisplay()
                                            strongSelf.activityPlanTableView.reloadData()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    func currentActivityPlan(){
        
        let params = [String : Any]()
        
        WebServices.getCurrentActivity(parameters: params, success: { [weak self](_ currentActivityPlan : [PreviousActivityPlan], _ dos :[JSON], _ donts : [JSON], _ pointToRemember : [PointsToRemember]) in
            
            guard let strongSelf = self else{
                return
            }
            strongSelf.isCurrentActivityServiceHit = true
            if !currentActivityPlan.isEmpty {
                
                strongSelf.currentActivityData = currentActivityPlan
                
                if let doctorName = currentActivityPlan[0].doctorName{
                    strongSelf.doctorNameLabel.text = doctorName
                }else{
                    strongSelf.doctorNameLabel.text = AppUserDefaults.value(forKey: AppUserDefaults.Key.doctorName).stringValue
                }
                
                if let doctorSpeciality = currentActivityPlan[0].doctorSpeciality{
                    strongSelf.doctorSpecialityLabel.text = doctorSpeciality
                }else{
                    strongSelf.doctorSpecialityLabel.text = AppUserDefaults.value(forKey: .doctorSpecialization).stringValue
                }
                
                for i in 0...currentActivityPlan.count - 1{
                    
                    if let caloriesBurn  = currentActivityPlan[i].caloriesBurn{
                        strongSelf.totalCurrentCalories = strongSelf.totalCurrentCalories + caloriesBurn
                    }
                    
                    if let totalDuration = currentActivityPlan[i].activityDuration{
                        strongSelf.totalCurrentDuration = strongSelf.totalCurrentDuration + totalDuration
                    }
                    
                    if let totalDistance = currentActivityPlan[i].totalDistance{
                        strongSelf.totalCurrentDistance = strongSelf.totalCurrentDistance + totalDistance
                    }
                }
            }
            
            if !dos.isEmpty {
                strongSelf.currentDosArray = dos
            }
            
            if !donts.isEmpty {
                strongSelf.currentDontsArray = donts
            }
            if !pointToRemember.isEmpty {
                strongSelf.currentPointsToRemember = pointToRemember
            }
            strongSelf.isNoDataAvailiableTextDisplay()
            strongSelf.activityPlanTableView.reloadData()
            
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func isNoDataAvailiableTextDisplay(){
        
        let isServiceHit = (self.isCurrentActivityServiceHit == true && self.isPreviousActivityServiceHit == true) ? true : false
        
        if isServiceHit {
            
            let isTableViewHidden = (self.currentActivityData.isEmpty && self.previousActivityData.isEmpty) ? true : false
            self.activityPlanTableView.isHidden = isTableViewHidden
            self.noDataAvailiableLabel.isHidden = !isTableViewHidden
        }else{
           self.activityPlanTableView.isHidden = isServiceHit
            self.noDataAvailiableLabel.isHidden = !isServiceHit
        }
    }
}

//MARk:- openWebViewDelegate Methods
//===================================
extension ActivityPlanVC: OpenWebViewDelegate {
    
    func attachmentData(_ attachmentURl: String, attachmentData: String) {
        self.openWebView(attachmentURl, attachmentData)
    }
}
