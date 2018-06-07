//
//  ePrescriptionVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ePrescriptionVC: BaseViewControllerWithBackButton {
    
    //    MARK:- Proporties
    //    =================
   fileprivate var currentEPrescription = [EprescriptionModel]()
   fileprivate var previousEPrescription = [[EprescriptionModel]]()
   fileprivate var eprescriptionHeader = [K_CURRENT_TITLE.localized, K_PREVIOUS_TITLE.localized]
    var navigateToScreenBy : NavigateToScreenBy = .otherViewController
    fileprivate var isHitCurrentEprescriptionService: Bool = false
    fileprivate var isHitPreviousEprescriptionService: Bool = false
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var addReminderLabel: UILabel!
    @IBOutlet weak var eprescriptionTableView: UITableView!
    
    //    MARK:- ViewController LifeCycle
    //    ==============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.getCurrentEPrescription()
        self.getPreviousEPrescription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftTopBarBtnType : SidemenuBtnAction = (navigateToScreenBy == .noitificationVC) ? .backBtn : .sideMenuBtn
        self.sideMenuBtnActn = leftTopBarBtnType
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_EPRESCRIPTION_SCREEN_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//===================================
extension ePrescriptionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eprescriptionHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tableRows = (section == false.rawValue) ? 1 : self.previousEPrescription.count
        return tableRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ePrescriptionTableCellID", for: indexPath) as? EPrescriptionTableCell else{
            fatalError("EPrescriptionTableCell not Found!")
        }
        
        cell.ePrescriptionBtn.addTarget(self, action: #selector(self.ePrescriptionBtnTapped(_:)), for: .touchUpInside)
        cell.shareBtnOutlt.addTarget(self, action: #selector(self.shareBtntapped(_:)), for: .touchUpInside)
        
        switch indexPath.section {
        case 0:
            cell.populateCurrentEprescriptionData(self.currentEPrescription, indexPath)
        case 1:
            cell.populatePreviousEPrescriptionData(self.previousEPrescription, indexPath)
        default :
            fatalError("Section Not Found!")
        }
        return cell
    }
}

//MARK:- UITableViewDelegate Method
//=================================
extension ePrescriptionVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            fatalError("AttachmentHeaderViewCell not Found!")
        }
        headerCell.headerTitle.text = self.eprescriptionHeader[section].uppercased()
        headerCell.headerTitle.textColor = UIColor.grayLabelColor
        headerCell.headerTitle.font = AppFonts.sansProBold.withSize(12.5)
        headerCell.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        headerCell.dropDownBtn.isHidden = true
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let previousSectionHeaderHeight = (!self.previousEPrescription.isEmpty) ? 36 : CGFloat.leastNormalMagnitude
        let sectionHeight = (section == 0) ? 36 : previousSectionHeaderHeight
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

//MARK:- Methods
//===============
extension ePrescriptionVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = false
        self.addReminderLabel.isHidden = true
        self.addReminderLabel.textColor = UIColor.appColor
        self.addReminderLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.addReminderLabel.text = "No Records Found!"
        self.eprescriptionTableView.dataSource = self
        self.eprescriptionTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let ePrescriptionTableCellNib = UINib(nibName: "EPrescriptionTableCell", bundle: nil)
        let headerCellNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.eprescriptionTableView.register(headerCellNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        self.eprescriptionTableView.register(ePrescriptionTableCellNib, forCellReuseIdentifier: "ePrescriptionTableCellID")
    }
    
    fileprivate func getCurrentEPrescription(){
        
        WebServices.getCurrentEPrescription(success: {[weak self] (_ currentEPrescription : [EprescriptionModel]) in
            
            guard let ePrescriptionVC = self else{
                return
            }
            ePrescriptionVC.isHitCurrentEprescriptionService = true
            ePrescriptionVC.currentEPrescription = currentEPrescription
            ePrescriptionVC.isNoDataAvailiableTextDisplay()
            ePrescriptionVC.eprescriptionTableView.reloadSections([0], with: .none)
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getPreviousEPrescription(){
        
        WebServices.getPreviousEPrescription(success: {[weak self] (_ previousEPrescription : [[EprescriptionModel]]) in
            
            guard let ePrescriptionVC = self else{
                return
            }
            ePrescriptionVC.isHitPreviousEprescriptionService = true
            ePrescriptionVC.previousEPrescription = previousEPrescription
            ePrescriptionVC.isNoDataAvailiableTextDisplay()
            ePrescriptionVC.eprescriptionTableView.reloadData()
        }) { (error : Error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func isNoDataAvailiableTextDisplay(){
        
        let isServiceHit = (self.isHitCurrentEprescriptionService == true || self.isHitPreviousEprescriptionService == true) ? true : false
        
        if isServiceHit {
            let isTableViewHidden = (self.currentEPrescription.isEmpty && self.previousEPrescription.isEmpty) ? true : false
            self.eprescriptionTableView.isHidden = isTableViewHidden
            self.addReminderLabel.isHidden = !isTableViewHidden
        }else{
            self.eprescriptionTableView.isHidden = !isServiceHit
            self.addReminderLabel.isHidden = isServiceHit
        }
    }
    
    @objc fileprivate func ePrescriptionBtnTapped(_ sender : UIButton) {
        
        guard let indexPath = sender.tableViewIndexPathIn(self.eprescriptionTableView) else{
            return
        }
        switch indexPath.section {
            
        case 0:
            if !self.currentEPrescription[0].attachmentPath.isEmpty {
                var attachmentUrl = [String]()
                var attachmentName = [String]()
                attachmentUrl = self.currentEPrescription[0].attachmentPath.components(separatedBy: ",")
                if !self.currentEPrescription[0].attachmentList.isEmpty {
                    attachmentName = self.currentEPrescription[0].attachmentList.components(separatedBy: ",")
                }
                
                if attachmentUrl.count > 1 {
                    self.attachmentView(attachmentUrl, attachmentName)
                }else{
                    self.openWebView(attachmentUrl.first!, attachmentName.first!)
                }
            }
        case 1:
            
            if let previousEprescription = self.previousEPrescription[indexPath.row].first{
                
                var attachmentUrl = [String]()
                var attachmentName = [String]()
                
                if !previousEprescription.attachmentPath.isEmpty {
                    
                    attachmentUrl = previousEprescription.attachmentPath.components(separatedBy: ",")
                    if !previousEprescription.attachmentList.isEmpty {
                      attachmentName = previousEprescription.attachmentList.components(separatedBy: ",")
                    }
                    
                    if attachmentUrl.count > 1 {
                        self.attachmentView(attachmentUrl, attachmentName)
                    }else{
                        self.openWebView(attachmentUrl.first!, attachmentName.first!)
                    }
                }
            }
        default :
            return
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
    
    fileprivate func openWebView(_ attachmentURl : String, _ attachmentName : String) {
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.webViewUrl = attachmentURl
        webViewScene.screenName = attachmentName
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
    
    //    MARK: Share Button Tapped
    //    =========================
    @objc fileprivate func shareBtntapped(_ sender : UIButton){
        
        guard !self.currentEPrescription.isEmpty else{
            return
        }
        guard let indexPath = sender.tableViewIndexPathIn(self.eprescriptionTableView) else{
            return
        }
        
        switch indexPath.section {
        case 0:
            guard !self.currentEPrescription.isEmpty else{
                return
            }
            let pdfFile = self.currentEPrescription[indexPath.row].pdfFile
            self.openShareViewController(pdfLink: pdfFile)
        case 1:
            guard !self.previousEPrescription.isEmpty else{
                return
            }
            guard !self.previousEPrescription[indexPath.row].isEmpty else{
                return
            }
            let pdfFile = self.previousEPrescription[indexPath.row][0].pdfFile
            self.openShareViewController(pdfLink: pdfFile)
        default:
            return
        }
    }
}

//MARk:- openWebViewDelegate Methods
//===================================
extension ePrescriptionVC: OpenWebViewDelegate {
    
    func attachmentData(_ attachmentURl: String, attachmentData: String) {
        self.openWebView(attachmentURl, attachmentData)
    }
}

