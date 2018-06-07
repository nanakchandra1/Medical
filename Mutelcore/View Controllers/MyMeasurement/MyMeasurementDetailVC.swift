//
//  MyMeasurementDetailVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 17/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MyMeasurementDetailVC: BaseViewController {
    
    //    MARK:- Properties
    //    =================
    enum SwitchBtnTapped {
        
        case graphBtnTapped, listBtnTapped
    }
    
    enum CollectionViewCellFor {
        
        case MeasurementPriorData, AttachmentCell
    }
    
    enum ProceedToScreenThrough {
        
        case vitalScreen , LabTestScreen
    }
    enum LoadMoreBtnTapped {
        
        case yes , no
    }
    
    var loadMoreBtntapped = LoadMoreBtnTapped.no
    var collectionViewCellFor : CollectionViewCellFor = CollectionViewCellFor.MeasurementPriorData
    var switchBtnTapped : SwitchBtnTapped = SwitchBtnTapped.graphBtnTapped
    var proceeedToScreenThrough : ProceedToScreenThrough = ProceedToScreenThrough.vitalScreen
    var graphCellRowHeight : CGFloat = 230
    var headerBtnSelected : Bool = false
    var isCellHidden = false
    var appointmentButtonTapped = false
    
    var vitalDataModel : VitalDataModel!
    var vitalListData = [VitalListModel]()
    var graphData = [GraphDataModel]()
    var attachmentList = [AttachmentDataModel]()
    var topMostVitalData = [LatestThreeVitalData]()
    var vitalNameArray = [String]()
    var latestVitalListDic = [String : Any]()
    var attachmentListDic = [String : Any]()
    var graphDataDic = [String : Any]()
    var selectedTestName : String?
    var measurementarray = [Any]()
    var nextCount : Int?
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var myMeasurementDetailTableView: UITableView!
    @IBOutlet weak var noDataAvailiableBtnOutlt: UILabel!
    @IBOutlet weak var addMeasurementBtnOutlt: UIButton!
    @IBOutlet weak var measurementSelectionTextField: UITextField!
    
    
    //    MARK:- ViewController Life Cycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUpUI()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn
        
        self.getVitalData()
        //        self.getLatestVitals()
        //        self.getGraphData()
        //        self.getTabularData()
        //        self.getAttachmentList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Measurements", 2, 3)
        
        self.navigationControllerOn = .dashboard
    }
}
//MARK:- UITableViewDataSource Methods
//====================================
extension MyMeasurementDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
            
        case 0: return 4
            
        case 1: return 1
            
        default: fatalError("Section Not Found!")
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            switch indexPath.row {
                
            case 0: guard let switchFilterCell = tableView.dequeueReusableCell(withIdentifier: "switchGraphCellID", for: indexPath) as? SwitchGraphCell else{
                
                fatalError("Switch Graph Cell Not Found!")
            }
            
            switchFilterCell.graphBtnOulet.addTarget(self, action: #selector(self.graphBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            switchFilterCell.tabelBtnOutlet.addTarget(self, action: #selector(self.listBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            switchFilterCell.hbButtonOutlet.addTarget(self, action: #selector(self.hbButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            switchFilterCell.tlcBtnOutlet.addTarget(self, action: #selector(self.tlcButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            switchFilterCell.platletBtnOutlet.addTarget(self, action: #selector(self.platletButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            
            switchFilterCell.populateData(self.topMostVitalData)
            
            if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
                switchFilterCell.hbBottomView.isHidden = false
                switchFilterCell.hbButtonOutlet.isHidden = false
                switchFilterCell.hbVerticalSepratorView.isHidden = false
                switchFilterCell.tlcBtnOutlet.isHidden = false
                switchFilterCell.tlcBottomView.isHidden = false
                switchFilterCell.tlcVerticalSepratorView.isHidden = false
                switchFilterCell.platletBtnOutlet.isHidden  = false
                switchFilterCell.platletBottomView.isHidden  = false
                switchFilterCell.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedgraph"), for: UIControlState.normal)
                switchFilterCell.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedtable"), for: UIControlState.normal)
                
            }else{
                
                switchFilterCell.hbBottomView.isHidden = true
                switchFilterCell.hbButtonOutlet.isHidden = true
                switchFilterCell.hbVerticalSepratorView.isHidden = true
                switchFilterCell.tlcBtnOutlet.isHidden = true
                switchFilterCell.tlcBottomView.isHidden = true
                switchFilterCell.tlcVerticalSepratorView.isHidden = true
                switchFilterCell.platletBtnOutlet.isHidden  = true
                switchFilterCell.platletBottomView.isHidden  = true
                switchFilterCell.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedgraph"), for: UIControlState.normal)
                switchFilterCell.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedtable"), for: UIControlState.normal)
                
            }
            
            if self.topMostVitalData.isEmpty{
                
                switchFilterCell.contentView.isHidden = true
            }else{
                
                switchFilterCell.contentView.isHidden = false
            }
            
            return switchFilterCell
                
            case 1:
                
                if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
                    
                    guard let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCellID") as? GraphCell else{
                        
                        fatalError("GraphCell Not Found!")    
                    }
                    
                    if self.topMostVitalData.isEmpty{
                        
                        graphCell.contentView.isHidden = true
                        
                    }else{
                        
                        graphCell.contentView.isHidden = false
                        
                        //graphCell.populateData(self.graphData)
                    }
                    
                    return graphCell
                    
                }else{
                    
                    guard let tableDataCell = tableView.dequeueReusableCell(withIdentifier: "vitalDataInTableCellID") as? VitalDataInTableCell else{
                        
                        fatalError("GraphCell Not Found!")
                    }
                    
                    tableDataCell.tableCellFor = .measurement
                    
                    if self.measurementarray.isEmpty{
                        
                        tableDataCell.noDataAvailiableLabel.isHidden = false
//                        tableDataCell.vitalDataView.reloadData()
                        
                    }else{
                        
                        tableDataCell.noDataAvailiableLabel.isHidden = true
                        tableDataCell.vitalValues = self.measurementarray as! [[[String : Any]]]
                        tableDataCell.vitalDataView.reloadData()
                        
                    }
                    
                    if self.topMostVitalData.isEmpty{
                        
                        tableDataCell.contentView.isHidden = true
                    }else{
                        
                        tableDataCell.contentView.isHidden = false
                        
                    }
                    
                    return tableDataCell
                }
                
            case 2: guard let graphFilterCell = tableView.dequeueReusableCell(withIdentifier: "graphFilterCellID") as? GraphFilterCell else{
                
                fatalError("GraphFilterCell Not Found!")
            }
            
            graphFilterCell.loadMoreBtnOutlt.isHidden = true
            
            if let count = self.nextCount{
                
                if count < 1{
                    
                    graphFilterCell.loadMoreBtnOutlt.isHidden = true
                }else{
                    
                    graphFilterCell.loadMoreBtnOutlt.isHidden = false
                }
            }else{
                
                graphFilterCell.loadMoreBtnOutlt.isHidden = true
            }
            
            graphFilterCell.oneWeekBtn.addTarget(self, action: #selector(self.oneWeekBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.oneMonthBtn.addTarget(self, action: #selector(self.oneMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.threeMonthBtn.addTarget(self, action: #selector(self.threeMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.sixMonthBtn.addTarget(self, action: #selector(self.sixMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.oneYearBtn.addTarget(self, action: #selector(self.oneYearBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.allBtn.addTarget(self, action: #selector(self.AllBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.loadMoreBtnOutlt.addTarget(self, action: #selector(self.loadMoreBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            
            if self.topMostVitalData.isEmpty{
                
                graphFilterCell.contentView.isHidden = true
            }else{
                
                graphFilterCell.contentView.isHidden = false
            }
            
            return graphFilterCell
                
            case 3: guard let measurementListPriorDataCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                
                fatalError("measurementListPriorDataCell Not Found!")
            }
            
            measurementListPriorDataCell.outerViewTopConstraint.constant = 0
            measurementListPriorDataCell.outerViewBottomConstraint.constant = 0
            measurementListPriorDataCell.outerViewTrailingConstraint.constant = 0
            measurementListPriorDataCell.outerViewLeadingConstraint.constant = 0
            
            measurementListPriorDataCell.measurementListCollectionView.reloadData()
            
            measurementListPriorDataCell.measurementListCollectionView.delegate = self
            measurementListPriorDataCell.measurementListCollectionView.dataSource = self
            
            self.collectionViewCellFor = CollectionViewCellFor.MeasurementPriorData
            
            if self.topMostVitalData.isEmpty{
                
                measurementListPriorDataCell.contentView.isHidden = true
            }else{
                
                measurementListPriorDataCell.contentView.isHidden = false
            }
            
            return measurementListPriorDataCell
                
            default: fatalError("Section Cell Not Found!")
                
            }
            
        case 1:
            
            guard let attachmentCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                
                fatalError("measurementListPriorDataCell Not Found!")
            }
            
            attachmentCell.outerViewTopConstraint.constant = 0
            attachmentCell.outerViewBottomConstraint.constant = 0
            attachmentCell.outerViewTrailingConstraint.constant = 0
            attachmentCell.outerViewLeadingConstraint.constant = 0
            
            attachmentCell.measurementListCollectionView.reloadData()
            
            attachmentCell.measurementListCollectionView.dataSource = self
            attachmentCell.measurementListCollectionView.delegate = self
            
            self.collectionViewCellFor = CollectionViewCellFor.AttachmentCell
            
            if self.topMostVitalData.isEmpty{
                
                attachmentCell.contentView.isHidden = true
            }else{
                
                attachmentCell.contentView.isHidden = false
                
                if self.attachmentList.isEmpty {
                    
                    attachmentCell.noRecordImageOutlt.isHidden = false
                    attachmentCell.noRecordImageOutlt.image = #imageLiteral(resourceName: "icMeasurementNoattachedreports")
                    
                    attachmentCell.noRecordLabelOutlt.isHidden = false
                    attachmentCell.noRecordLabelOutlt.text = "No Attached Reports"
                }else{
                    
                    attachmentCell.noRecordImageOutlt.isHidden = true
                    attachmentCell.noRecordLabelOutlt.isHidden = true
                }
            }
            
            return attachmentCell
            
        default: fatalError("Section Not Found!")
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 2
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension MyMeasurementDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
            
        case 0:
            
            if !self.topMostVitalData.isEmpty {
                
                switch indexPath.row {
                    
                case 0: return 40
                    
                case 1: return self.graphCellRowHeight
                    
                case 2: return 83
                    
                case 3: return 112
                    
                default: fatalError("Section 0 row Not Found!")
                }
                
            }else{
                
                return 0
            }
            
        case 1: if !self.topMostVitalData.isEmpty{
            
            return 140
        }else{
            
            return 0
            }
            
        default : fatalError(" Section Not Found!")
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("header")
        }
        
        sectionHeaderViewCell.headerTitle.text = "ATTACHED REPORTS"
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(15.8)
        sectionHeaderViewCell.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        sectionHeaderViewCell.dropDownBtn.isHidden = true
        
        
        return sectionHeaderViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            
            if !self.topMostVitalData.isEmpty{
                
                return 38
            }else{
                
                return 0
            }
            
        }else{
            
            return 0
        }
    }
}

//MARK:- UICollectionViewDataSource Methods
//==========================================
extension MyMeasurementDetailVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if self.collectionViewCellFor == CollectionViewCellFor.MeasurementPriorData {
            
            return self.topMostVitalData.count
        }else {
            
            return self.attachmentList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.collectionViewCellFor == CollectionViewCellFor.MeasurementPriorData {
            
            guard let measurementPriorDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else{
                
                fatalError("MeasuremetPriorDataCell Not Found!")
            }
            
            measurementPriorDataCell.cellImage.isHidden = true
            measurementPriorDataCell.imageViewStacktopConstant.constant = 0
            
            measurementPriorDataCell.populateLatestVitalData(self.topMostVitalData, indexPath)
            
            return measurementPriorDataCell
            
        }else{
            
            guard let attachmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
                
                fatalError("attachmentCell Not Found!")
            }
            
            attachmentCell.populateData(self.attachmentList, index: indexPath)
            
            attachmentCell.deleteButtonOutlt.isHidden = true
            return attachmentCell
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension MyMeasurementDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if self.collectionViewCellFor == CollectionViewCellFor.MeasurementPriorData {
            
            return CGSize(width: (collectionView.frame.width / 3) - 3 , height: 110)
            
        }else{
            
            return CGSize(width: (collectionView.frame.width / 3) - 3 , height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 1.5
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension MyMeasurementDetailVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField === self.measurementSelectionTextField{
            
            MultiPicker.noOfComponent = 1
            
            MultiPicker.openPickerIn(self.measurementSelectionTextField,
                                     firstComponentArray: self.vitalNameArray,
                                     secondComponentArray: [],
                                     firstComponent: self.measurementSelectionTextField.text,
                                     secondComponent: "", titles: ["Vital Name"]) { (str, _, index, _) in
                                        
                                        self.selectedTestName = str
                                        
                                        self.measurementSelectionTextField.text = self.selectedTestName
                                        
                                        let vitalID = self.vitalListData[index!].vitalID
                                        
                                        self.latestVitalListDic["vital_id"] = vitalID
                                        
                                        self.graphDataDic["vital_super_id"] = vitalID
                                        
                                        self.getLatestVitals()
                                        self.getAttachmentList()
                                        
                                        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
                                            
                                            self.getGraphData()
                                            
                                        }else{
                                            
                                            self.getTabularData()
                                        }
            }
        }
    }
}

//MARK:- Add Targets Methods
//==========================
extension MyMeasurementDetailVC {
    
    @objc fileprivate func addMeasurementBtnTapped(_ sender : UIButton){
        
        let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
        
        if !self.measurementSelectionTextField.text!.isEmpty{
            
            addMeasurementScene.selectedName = self.measurementSelectionTextField.text
        }
        
        addMeasurementScene.vitalList = self.vitalListData
        
        addMeasurementScene.formBuilderDic["vital_id"] = self.latestVitalListDic["vital_id"]
        
        addMeasurementScene.addMeasurementDic["vital_super_id"] = self.latestVitalListDic["vital_id"]
        
        addMeasurementScene.vitalNameArray = self.vitalNameArray
        
        self.navigationController?.pushViewController(addMeasurementScene, animated: true)
        
    }
    
    //    MARK: ListBtnTapped To view the vlaues in List
    //    ==============================================
    @objc fileprivate func listBtnTapped(_ sender : UIButton){
        
        self.switchBtnTapped = SwitchBtnTapped.listBtnTapped
        
        self.myMeasurementDetailTableView.reloadData()
    }
    
    //    MARK: Graph Button Tapped to view the values in graph
    //    =====================================================
    @objc fileprivate func graphBtnTapped(_ sender : UIButton){
        
        self.switchBtnTapped = SwitchBtnTapped.graphBtnTapped
        
        self.myMeasurementDetailTableView.reloadData()
    }
    
    //    MARK:- Vital FilterBtnTapped
    //    ============================
    @objc fileprivate func hbButtonTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? SwitchGraphCell else{
            
            return
        }
        
        cell.vitalBtnTapped = .hb
        
        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[0].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func tlcButtonTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? SwitchGraphCell else{
            
            return
        }
        cell.vitalBtnTapped = .tlc
        
        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[1].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func platletButtonTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? SwitchGraphCell else{
            
            return
        }
        
        cell.vitalBtnTapped = .platlet
        
        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[2].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    //    MARK:- GraphFilterBtnTapped
    //    ===========================
    @objc fileprivate func oneWeekBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneWeek
        let lastWeekDate = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastWeekDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
        
    }
    
    @objc fileprivate func oneMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneMonth
        
        let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func threeMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .threeMonth
        
        
        let lastThirdMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -3, to: Date())
        
        self.graphDataDic["start_date"] = lastThirdMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func sixMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .sixMonth
        
        let lastSixthMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -6, to: Date())
        
        self.graphDataDic["start_date"] = lastSixthMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func oneYearBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneYear
        
        let lastYearDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastYearDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func AllBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            
            return
        }
        
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .All
        
        self.graphDataDic["start_date"] = ""
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            self.getGraphData()
        }else{
            
            self.getTabularData()
        }
    }
    
    @objc fileprivate func loadMoreBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.yes
        
        if self.nextCount! > 0{
            
            if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
                
            }else{
                
                self.graphDataDic["next_count"] = self.nextCount
                
                self.getTabularData()
                
            }
        }
    }
}

//MARK:- Methods
//===============
extension MyMeasurementDetailVC {
    
    //    Initial Setup
    fileprivate func setUpUI(){
        
        self.myMeasurementDetailTableView.dataSource = self
        self.myMeasurementDetailTableView.delegate = self
        self.myMeasurementDetailTableView.bounces = false
        
        self.measurementSelectionTextField.delegate = self
        self.measurementSelectionTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.measurementSelectionTextField.rightViewMode = UITextFieldViewMode.always
        self.measurementSelectionTextField.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.addMeasurementBtnOutlt.tintColor = UIColor.appColor
        
        self.noDataAvailiableBtnOutlt.isHidden = true
        self.noDataAvailiableBtnOutlt.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableBtnOutlt.textColor = UIColor.appColor
        self.noDataAvailiableBtnOutlt.text = "No Records Found!"
        
        self.addMeasurementBtnOutlt.addTarget(self, action: #selector(self.addMeasurementBtnTapped(_:)), for: .touchUpInside)
        self.addMeasurementBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: .normal)
        
        self.registerNibs()
        
    }
    
    //    register Nibs
    fileprivate func registerNibs(){
        
        let selectTestNib = UINib(nibName: "TestNameSelectionCell", bundle: nil)
        let SwitchGraphNib = UINib(nibName: "SwitchGraphCell", bundle: nil)
        let graphNib = UINib(nibName: "GraphCell", bundle: nil)
        let vitalDataInTableNib = UINib(nibName: "VitalDataInTableCell", bundle: nil)
        let graphFilterNib = UINib(nibName: "GraphFilterCell", bundle: nil)
        let attachmentNib = UINib(nibName: "AttachmentCell", bundle: nil)
        let MeasurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let attachmentHeaderNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.myMeasurementDetailTableView.register(selectTestNib, forCellReuseIdentifier: "testNameSelectionCellID")
        self.myMeasurementDetailTableView.register(SwitchGraphNib, forCellReuseIdentifier: "switchGraphCellID")
        self.myMeasurementDetailTableView.register(graphNib, forCellReuseIdentifier: "graphCellID")
        self.myMeasurementDetailTableView.register(vitalDataInTableNib, forCellReuseIdentifier: "vitalDataInTableCellID")
        self.myMeasurementDetailTableView.register(graphFilterNib, forCellReuseIdentifier: "graphFilterCellID")
        self.myMeasurementDetailTableView.register(attachmentNib, forCellReuseIdentifier: "attachmentCellID")
        self.myMeasurementDetailTableView.register(MeasurementListCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.myMeasurementDetailTableView.register(attachmentHeaderNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        
    }
    
    //    MARK:- WebServices
    //    ======================
    
    func getVitalData(){
        
        let id = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        let param = ["id" : id]
        
        printlnDebug("vitalData :\(param)")
        
        WebServices.getVitalList(parameters: param,
                                 success: {[weak self] (_ vitalListData : [VitalListModel]) in
                                    
                                    self?.vitalListData = vitalListData
                                    
                                    let vitalList = self?.vitalListData.map{(value) in
                                        
                                        value.vitalName
                                    }
                                    
                                    self?.vitalNameArray = vitalList as! [String]
                                    
                                    if !(self?.vitalListData.isEmpty)!{
                                        
                                        self?.measurementSelectionTextField.text = self?.vitalListData[0].vitalName
                                        self?.latestVitalListDic["vital_id"] = self?.vitalListData[0].vitalID
                                        self?.graphDataDic["vital_super_id"] = self?.vitalListData[0].vitalID
                                        
                                        self?.getLatestVitals()
                                        self?.getGraphData()
                                        self?.getTabularData()
                                        self?.getAttachmentList()
                                    }
                                    
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    func getLatestVitals(){
        
        let id = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        self.latestVitalListDic["id"] = id
        
        printlnDebug("latDic : \(self.latestVitalListDic)")
        WebServices.getLatestVitals(parameters: self.latestVitalListDic,
                                    success: { (_ latestData :[LatestThreeVitalData]) in
                                        
                                        self.topMostVitalData = latestData
                                        
                                        self.collectionViewCellFor = CollectionViewCellFor.MeasurementPriorData
                                        
                                        printlnDebug(latestData)
                                        
                                        if self.topMostVitalData.isEmpty {
                                            
                                            self.noDataAvailiableBtnOutlt.isHidden = false
                                            
                                        }else{
                                            
                                            self.noDataAvailiableBtnOutlt.isHidden = true
                                        }
                                        
                                        self.myMeasurementDetailTableView.reloadData()
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    func getGraphData(){
        
        self.graphDataDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        self.graphDataDic["end_date"] = Date()
        printlnDebug("graphDataDic : \(self.graphDataDic)")
        
        WebServices.getGraphData(parameters: self.graphDataDic,
                                 success: { (graphData : [GraphDataModel]) in
                                    
                                    self.graphData = graphData
                                    
                                    printlnDebug(graphData)
                                    
                                    self.myMeasurementDetailTableView.reloadData()
                                    
        }) { (e) in
            
            showToastMessage(e.localizedDescription)
        }
    }
    
    func getAttachmentList(){
        
        self.graphDataDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        printlnDebug("attatchDic : \(self.graphDataDic)")
        WebServices.getAttachmentList(parameters: self.graphDataDic,
                                      success: { (attachmentData :[AttachmentDataModel]) in
                                        
                                        self.attachmentList = attachmentData
                                        
                                        self.collectionViewCellFor = CollectionViewCellFor.AttachmentCell
                                        
                                        printlnDebug(attachmentData)
                                        
                                        self.myMeasurementDetailTableView.reloadData()
        }) { (e) in
            
            showToastMessage(e.localizedDescription)
            
        }
    }
    
    func getTabularData(){
        
        self.graphDataDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        printlnDebug("dic\(self.graphDataDic)")
        
        WebServices.getTabularData(parameters: self.graphDataDic, success: { (tabularData: [Any], count : Int) in
            
            printlnDebug("tabularData\(tabularData)")
            
            if self.loadMoreBtntapped == LoadMoreBtnTapped.yes{
                
                self.measurementarray.append(contentsOf: tabularData)
                
                printlnDebug("self.measurementarray\(self.measurementarray)")
                
            }else{
                
                self.measurementarray = tabularData
                printlnDebug("self.measurementarray\(self.measurementarray)")
            }
            
            self.nextCount = count
            self.myMeasurementDetailTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
}
