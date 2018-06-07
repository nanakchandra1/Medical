//
//  MyMeasurementDetailVC.swift
//  Mutelcor
//
//  Created by on 17/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import TransitionButton

//MARK:- LoadMore Button
//======================
enum LoadMoreBtnTapped {
    case yes
    case no
}

//MARK:- Switch Between graph and list
//=====================================
enum SwitchBtnTapped {
    case graphBtnTapped
    case listBtnTapped
}

class MyMeasurementDetailVC: BaseViewControllerWithBackButton {

    enum ProceedToScreenThrough {
        case vitalScreen
        case images
    }
    
    //    MARK:- Properties
    //    =================
    fileprivate var loadMoreBtntapped = LoadMoreBtnTapped.no
    fileprivate var switchBtnTapped: SwitchBtnTapped = .graphBtnTapped
    var proceeedToScreenThrough: ProceedToScreenThrough = .vitalScreen
    fileprivate var graphCellRowHeight: CGFloat = CGFloat.leastNormalMagnitude
    fileprivate var headerBtnSelected : Bool = false
    fileprivate var isCellHidden = false
    fileprivate var appointmentButtonTapped = false
    fileprivate var selectedIndex = 0
    fileprivate var selectedVital: VitalListModel?
    
    var vitalDataModel: VitalDataModel?
    var lastSentData: LastSentData?
    fileprivate var vitalListData = [VitalListModel]()
    fileprivate var attachmentList = [AttachmentDataModel]()
    fileprivate var topMostVitalData = [LatestThreeVitalData]()
    fileprivate var measurementTabularData = [[MeasurementTablurData]]()
    fileprivate var tabularSubVitalData = [MeasurementTabularSubVital]()
    var vitalNameArray = [String]()
    var latestVitalListDic = [String: Any]()
    var attachmentListDic = [String: Any]()
    var graphDataDic = [String: Any]()
    var selectedTestName: String?
    var measurementarray = [Any]()
    var nextCount: Int?
    var vitalSubIDIndex = 0
    var lastPlotType: GraphPlotType?
    var isHitGetAttachedService: Bool = false
    var selectVitalCategoryID: Int?
    var selectedVitalName: String?
    var selectedVitalID: Int?
    
    let todaysDate = Date().startOfDay
    var formattedGraphDataArray: [MeasurementGraphData] = []
    var apiGraphDataArray: [MeasurementGraphData] = []
    
    var weekPoints: [MeasurementGraphTuple] = []
    var monthPoints: [MeasurementGraphTuple] = []
    var threeMonthPoints: [MeasurementGraphTuple] = []
    var sixMonthPoints: [MeasurementGraphTuple] = []
    var oneYearPoints: [MeasurementGraphTuple] = []
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var myMeasurementDetailTableView: UITableView!
    @IBOutlet weak var addMeasurementBtnOutlt: UIButton!
    @IBOutlet weak var measurementSelectionTextField: UITextField!
    
    
    //    MARK:- ViewController Life Cycle
    //    ===============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_MEASUREMENT_SCREEN_TITLE.localized)
        
        self.getVitalData()
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension MyMeasurementDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sections = (section == false.rawValue) ? 4 : 1
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 0:
                guard let nutritionsSelectionWithGraphCell = tableView.dequeueReusableCell(withIdentifier: "nutritionsSelectionCellID", for: indexPath) as? NutritionsSelectionCell else {
                    fatalError("Nutritions Selection With graph Cell Not Found!")
                }
                
                nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.outerIndexPath = indexPath
                nutritionsSelectionWithGraphCell.viewContainObjectLeadingConstraint.constant = 0
                nutritionsSelectionWithGraphCell.viewContainObjectTrailingConstraint.constant = 0
                
                if !(nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.delegate is MyMeasurementDetailVC) {
                    nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.dataSource = self
                    nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.delegate = self
                }
                nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.reloadData()
                nutritionsSelectionWithGraphCell.graphBtnOutlt.addTarget(self, action: #selector(self.graphBtnTapped(_:)), for: UIControlEvents.touchUpInside)
                nutritionsSelectionWithGraphCell.tableBtnOutlt.addTarget(self, action: #selector(self.listBtnTapped(_:)), for: UIControlEvents.touchUpInside)
                
                let isCollectionViewHidden  = (self.switchBtnTapped == .graphBtnTapped) ? false : true
                let graphBtnImage = (!isCollectionViewHidden) ? #imageLiteral(resourceName: "icMeasurementSelectedgraph") : #imageLiteral(resourceName: "icMeasurementDeselectedgraph")
                let tableBtnImage = (!isCollectionViewHidden) ? #imageLiteral(resourceName: "icMeasurementDeselectedtable") : #imageLiteral(resourceName: "icMeasurementSelectedtable")
                
                nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.isHidden = isCollectionViewHidden
                nutritionsSelectionWithGraphCell.graphBtnOutlt.setImage(graphBtnImage, for: UIControlState.normal)
                nutritionsSelectionWithGraphCell.tableBtnOutlt.setImage(tableBtnImage, for: UIControlState.normal)
                
                return nutritionsSelectionWithGraphCell
            case 1:
                
                if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
                    guard let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCellID") as? GraphCell else{
                        fatalError("GraphCell Not Found!")    
                    }
                    
                    let isTopMostVitalDataEmpty = (self.topMostVitalData.isEmpty) ? true : false
                    graphCell.contentView.isHidden = isTopMostVitalDataEmpty
                    let chartBackgroundColor = (isTopMostVitalDataEmpty) ? UIColor.clear : UIColor.white
                    graphCell.chartView.backgroundColor = chartBackgroundColor
                    
                    updateGraphCell(graphCell)
                    return graphCell
                    
                }else{
                    guard let tableDataCell = tableView.dequeueReusableCell(withIdentifier: "vitalDataInTableCellID") as? VitalDataInTableCell else {
                        fatalError("GraphCell Not Found!")
                    }
                    tableDataCell.tableCellFor = .measurement
                    let noDataAvailiableLabelHidden = self.measurementTabularData.isEmpty ? false : true
                    tableDataCell.noDataAvailiableLabel.isHidden = noDataAvailiableLabelHidden
                    tableDataCell.headerView.isHidden = !noDataAvailiableLabelHidden
                    tableDataCell.vitalDataView.isHidden = !noDataAvailiableLabelHidden
                    tableDataCell.vitalValues = self.measurementTabularData
                    tableDataCell.subVitalData = self.tabularSubVitalData
                    tableDataCell.vitalDataView.reloadData()
                    let isTopMostVitalEmpty = (self.topMostVitalData.isEmpty) ? true : false
                    tableDataCell.contentView.isHidden = isTopMostVitalEmpty
                    
                    return tableDataCell
                }
                
            case 2:
                guard let graphFilterCell = tableView.dequeueReusableCell(withIdentifier: "graphFilterCellID") as? GraphFilterCell else{
                    fatalError("GraphFilterCell Not Found!")
                }
                
                if self.switchBtnTapped == .listBtnTapped {
                    
                    if let count = self.nextCount{
                        let nxtCount = (count < 1) ? true : false
                        let loadMoreBtnHeight = (nxtCount == true) ? 0 : 30
                        graphFilterCell.loadMoreBtnOutlt.isHidden = nxtCount
                        graphFilterCell.loadmoreBtnHeightConstant.constant = CGFloat(loadMoreBtnHeight)
                    }else{
                        graphFilterCell.loadMoreBtnOutlt.isHidden = true
                        graphFilterCell.loadmoreBtnHeightConstant.constant = 0
                    }
                }else {
                    graphFilterCell.loadMoreBtnOutlt.isHidden = true
                    graphFilterCell.loadmoreBtnHeightConstant.constant = 0
                }
                
                if let plotType = lastPlotType, let buttonState = FilterState(rawValue: plotType.rawValue) {
                    graphFilterCell.buttonState = buttonState
                } else {
                    graphFilterCell.buttonState = .all
                }
                
                graphFilterCell.oneWeekBtn.addTarget(self, action: #selector(self.oneWeekBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.oneMonthBtn.addTarget(self, action: #selector(self.oneMonthBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.threeMonthBtn.addTarget(self, action: #selector(self.threeMonthBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.sixMonthBtn.addTarget(self, action: #selector(self.sixMonthBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.oneYearBtn.addTarget(self, action: #selector(self.oneYearBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.allBtn.addTarget(self, action: #selector(self.AllBtnTapped(_:)), for: .touchUpInside)
                graphFilterCell.loadMoreBtnOutlt.addTarget(self, action: #selector(self.loadMoreBtnTapped(_:)), for: .touchUpInside)
                
                let isTopMostVitalDataEmpty = (self.topMostVitalData.isEmpty) ? true : false
                graphFilterCell.contentView.isHidden = isTopMostVitalDataEmpty
                
                return graphFilterCell
                
            case 3:
                guard let measurementListPriorDataCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                    fatalError("measurementListPriorDataCell Not Found!")
                }
                
                measurementListPriorDataCell.measurementListCollectionView.outerIndexPath = indexPath
                measurementListPriorDataCell.outerViewTopConstraint.constant = 0
                measurementListPriorDataCell.outerViewBottomConstraint.constant = 0
                measurementListPriorDataCell.outerViewTrailingConstraint.constant = 0
                measurementListPriorDataCell.outerViewLeadingConstraint.constant = 0
                
                if !(measurementListPriorDataCell.measurementListCollectionView.delegate is MyMeasurementDetailVC) {
                    measurementListPriorDataCell.measurementListCollectionView.delegate = self
                    measurementListPriorDataCell.measurementListCollectionView.dataSource = self
                }
                
                if !self.topMostVitalData.isEmpty{
                    measurementListPriorDataCell.contentView.isHidden = false
                    measurementListPriorDataCell.measurementListCollectionView.reloadData()
                }else{
                    measurementListPriorDataCell.contentView.isHidden = true
                }
                return measurementListPriorDataCell
                
            default:
                fatalError("Section Cell Not Found!")
            }
            
        case 1:
            guard let attachmentCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                fatalError("measurementListPriorDataCell Not Found!")
            }
            
            attachmentCell.measurementListCollectionView.outerIndexPath = indexPath
            if !(attachmentCell.measurementListCollectionView.delegate is MyMeasurementDetailVC) {
                attachmentCell.measurementListCollectionView.delegate = self
                attachmentCell.measurementListCollectionView.dataSource = self
            }
            
            attachmentCell.populateData(self.attachmentList, self.isHitGetAttachedService)
            attachmentCell.measurementListCollectionView.reloadData()
            
            return attachmentCell
            
        default:
            fatalError("Section Not Found!")
        }
    }
    
    func updateGraphCell(_ cell: GraphCell) {
        if let graphLastPlotType = self.lastPlotType {
            
            let points = getPoints(from: graphLastPlotType)
            cell.updateMeasurementGraph(with: points, plotType: graphLastPlotType)
            
        } else {
            let activityDate = self.apiGraphDataArray.first?.measurementDate
            let (points, plotType) = getPoints(from: activityDate)
            cell.updateMeasurementGraph(with: points, plotType: plotType)
        }
    }
}

//MARK:- UITableViewDelegate Methods
//===================================
extension MyMeasurementDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
            
        case 0:
            if let selectedID = self.selectVitalCategoryID, selectedID == 0{
                return CGFloat.leastNormalMagnitude
            }else{
                switch indexPath.row {
                case 0:
                    let rowHeight: CGFloat = self.topMostVitalData.isEmpty ? CGFloat.leastNormalMagnitude : 38.5
                    return rowHeight
                case 1:
                    if self.switchBtnTapped != .listBtnTapped {
                        let rowHeight = self.apiGraphDataArray.isEmpty ? CGFloat.leastNormalMagnitude : 230
                        return rowHeight
                    }else{
                        let rowsHeight: CGFloat = self.measurementTabularData.isEmpty ? CGFloat.leastNormalMagnitude : CGFloat((self.measurementTabularData.count + 1) * 41)
                        return rowsHeight
                    }
                case 2:
                    if self.switchBtnTapped == .listBtnTapped {
                        var nxtCount : CGFloat = 0
                        if let count = self.nextCount {
                            nxtCount = (count > 1) ? 83 : 40
                        }
                        let rowHeight: CGFloat = self.topMostVitalData.isEmpty ? CGFloat.leastNormalMagnitude : nxtCount
                        return rowHeight
                    }else{
                        let rowHeight: CGFloat = self.topMostVitalData.isEmpty ? CGFloat.leastNormalMagnitude : 40
                        return rowHeight
                    }
                case 3:
                    let rowsHeight = self.topMostVitalData.isEmpty ? CGFloat.leastNormalMagnitude : 112
                    return rowsHeight
                default:
                    return CGFloat.leastNormalMagnitude
                }
            }
        case 1:
            return 140
        default :
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let sectionHeaderViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as?
            AttachmentHeaderViewCell else {
                fatalError("header")
        }
        
        sectionHeaderViewCell.headerTitle.text = K_ATTACHED_REPORTS.localized
        sectionHeaderViewCell.headerTitle.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        sectionHeaderViewCell.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        sectionHeaderViewCell.dropDownBtn.isHidden = true
        
        return sectionHeaderViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let height = (section == 1) ? 38 : 0
        return CGFloat(height)
    }
}

//MARK:- UICollectionViewDataSource Methods
//==========================================
extension MyMeasurementDetailVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        
        switch (outerIndexPath.section, outerIndexPath.row) {
            
        case (0,0):
            return self.topMostVitalData.count
        case (0,3):
            return self.topMostVitalData.count
        case (1,0):
            return self.attachmentList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        switch (outerIndexPath.section, outerIndexPath.row) {
            
        case (0,0):
            guard let nutrientsTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "nutrientsTypeCellID", for: indexPath) as? NutrientsTypeCell else{
                fatalError("NutrientsTypeCell Not Found!")
            }
            let vitalSubName = self.topMostVitalData[indexPath.item].vitalSubName ?? ""
            nutrientsTypeCell.cellTitleLabel.text = vitalSubName.uppercased()
            nutrientsTypeCell.populateGraphMeasurementData(indexPath, self.vitalSubIDIndex, self.topMostVitalData)
            return nutrientsTypeCell
        case (0,3):
            guard let measurementPriorDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else{
                fatalError("MeasuremetPriorDataCell Not Found!")
            }
            
            measurementPriorDataCell.populateLatestVitalData(self.topMostVitalData, indexPath)
            
            return measurementPriorDataCell
        case (1,0):
            guard let attachmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
                fatalError("attachmentCell Not Found!")
            }
            
            attachmentCell.populateData(self.attachmentList, index: indexPath)
            attachmentCell.deleteButtonOutlt.isHidden = true
            return attachmentCell
        default:
            fatalError("index Not found!")
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension MyMeasurementDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        
        switch (outerIndexPath.section, outerIndexPath.row){
            
        case (0,0):
            let width = self.topMostVitalData[indexPath.item].vitalSubName?.widthWithConstrainedHeight(height: 13.8, font: AppFonts.sanProSemiBold.withSize(13.8)) ?? 10.0
            return CGSize(width: width + 8.0 , height: indexedCollectionView.frame.height)
        case (0,3):
            return CGSize.init(width: (collectionView.frame.width / 3) - 3, height: 112)
        case (1,0):
            return CGSize.init(width: (collectionView.frame.width / 3) - 3, height: 130)
        default:
            return CGSize.init(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        switch (outerIndexPath.section, outerIndexPath.row){
            
        case (0,0):
            
            let index = IndexPath(row: outerIndexPath.row, section: 0)
            guard let cell  = self.myMeasurementDetailTableView.cellForRow(at: index) as? NutritionsSelectionCell else{
                return
            }
            self.loadMoreBtntapped = LoadMoreBtnTapped.no
            self.vitalSubIDIndex = indexPath.item
            self.graphDataDic["vital_sub_id"] = self.topMostVitalData[indexPath.item].vitalSubID
            cell.nutrientsSelectionCollectionView.reloadData()
            self.getGraphData()
            
            case (1,0):
                guard let attachment = self.attachmentList[indexPath.item].attachment else{
                    return
                }
                
                let imageWebViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
                imageWebViewScene.webViewUrl = attachment
                self.navigationController?.pushViewController(imageWebViewScene, animated: true)
            
        default:
            return
        }
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
                                        self.selectedIndex = index!
                                        self.measurementSelectionTextField.text = str
                                        self.selectVitalCategoryID = self.vitalListData[index!].categoryType
//                                        self.selectedVital = self.vitalListData[index!]
                                        let vitalID = self.vitalListData[index!].vitalID
                                        self.selectedVitalID = vitalID
                                        self.latestVitalListDic["vital_id"] = vitalID
                                        self.graphDataDic["vital_super_id"] = vitalID
                                        
                                        if self.vitalListData[index!].categoryType == 0{
                                            self.getAttachmentList(categoryType: 0)
                                        }else{
                                            self.getLatestVitals()
                                            self.getAttachmentList()
                                            self.getTabularData(sender: nil)
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
        addMeasurementScene.selectedIndex = self.selectedIndex
        addMeasurementScene.selectedVitalID = self.selectedVitalID
        addMeasurementScene.selectedVitalName = self.selectedVitalName
        addMeasurementScene.vitalList = self.vitalListData
        addMeasurementScene.formBuilderDic["vital_id"] = self.latestVitalListDic["vital_id"]
        addMeasurementScene.addMeasurementDic["vital_super_id"] = self.latestVitalListDic["vital_id"]
        addMeasurementScene.vitalNameArray = self.vitalNameArray
        
        self.navigationController?.pushViewController(addMeasurementScene, animated: true)
    }
    
    //    MARK: ListBtnTapped To view the vlaues in List
    //    ==============================================
    @objc fileprivate func listBtnTapped(_ sender : UIButton){
        guard let indexPath = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            return
        }
        let nextIndexPath = IndexPath(row: indexPath.row + 1, column: 0)
        self.switchBtnTapped = .listBtnTapped
        self.myMeasurementDetailTableView.reloadRows(at: [nextIndexPath], with: .fade)
        let weekBtnIndexPath = IndexPath(row: nextIndexPath.row + 1, column: 0)
        self.myMeasurementDetailTableView.reloadRows(at: [weekBtnIndexPath], with: .fade)
        self.myMeasurementDetailTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    //    MARK: Graph Button Tapped to view the values in graph
    //    =====================================================
    @objc fileprivate func graphBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.myMeasurementDetailTableView) else{
            return
        }
        guard let nutritionsSelectionCell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? NutritionsSelectionCell else{
            return
        }
        nutritionsSelectionCell.nutrientsSelectionCollectionView.reloadData()
        self.switchBtnTapped = SwitchBtnTapped.graphBtnTapped
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        self.myMeasurementDetailTableView.reloadRows(at: [nextIndexPath], with: .fade)
        guard let cell = self.myMeasurementDetailTableView.cellForRow(at: nextIndexPath) as? GraphCell else{
            return
        }
        
        if let graphLastPlotType = self.lastPlotType {
            let points = getPoints(from: graphLastPlotType)
            cell.updateMeasurementGraph(with: points, plotType: graphLastPlotType)
        } else {
            let measurementDate = self.apiGraphDataArray.first?.measurementDate
            let (points, plotType) = getPoints(from: measurementDate)
            cell.updateMeasurementGraph(with: points, plotType: plotType)
        }
        
        self.myMeasurementDetailTableView.reloadRows(at: [indexPath], with: .fade)
        let weekBtnIndexPath = IndexPath(row: nextIndexPath.row + 1, section: 0)
        self.myMeasurementDetailTableView.reloadRows(at: [weekBtnIndexPath], with: .fade)
    }
    
    func getPoints(from plotType: GraphPlotType) -> [MeasurementGraphTuple] {
        switch plotType {
            
        case .month :
            return monthPoints
        case .sixMonths :
            return sixMonthPoints
        case .threeMonths :
            return threeMonthPoints
        case .week :
            return weekPoints
        case .year :
            return oneYearPoints
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
        self.lastPlotType = GraphPlotType.week
        cell.buttonState = .oneWeek
        let lastWeekDate = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastWeekDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
            cell?.updateMeasurementGraph(with: weekPoints, plotType: .week)
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
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
        self.lastPlotType = GraphPlotType.month
        cell.buttonState = .oneMonth
        
        let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
            cell?.updateMeasurementGraph(with: monthPoints, plotType: .month)
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
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
        self.lastPlotType = GraphPlotType.threeMonths
        cell.buttonState = .threeMonth
        
        let lastThirdMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -3, to: Date())
        
        self.graphDataDic["start_date"] = lastThirdMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
            cell?.updateMeasurementGraph(with: threeMonthPoints, plotType: .threeMonths)
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
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
        self.lastPlotType = GraphPlotType.sixMonths
        cell.buttonState = .sixMonth
        
        let lastSixthMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -6, to: Date())
        
        self.graphDataDic["start_date"] = lastSixthMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
            cell?.updateMeasurementGraph(with: sixMonthPoints, plotType: .sixMonths)
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
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
        self.lastPlotType = GraphPlotType.year
        cell.buttonState = .oneYear
        
        let lastYearDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastYearDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
            cell?.updateMeasurementGraph(with: oneYearPoints, plotType: .year)
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
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
        self.lastPlotType = nil
        cell.buttonState = .all
        
        self.graphDataDic["start_date"] = ""
        
        if switchBtnTapped == .graphBtnTapped{
            getPointsForAll()
        }else{
            self.getTabularData(sender: nil)
        }
        self.getAttachmentList()
    }
    
    @objc fileprivate func loadMoreBtnTapped(_ sender : TransitionButton){
        
        self.loadMoreBtntapped = .yes
        
        if let count = self.nextCount, count > 0 {
            if self.switchBtnTapped == .listBtnTapped{
                self.graphDataDic["next_count"] = self.nextCount
                sender.startAnimation()
                self.getTabularData(sender: sender)
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
        
        self.measurementSelectionTextField.tintColor = UIColor.white
        self.measurementSelectionTextField.delegate = self
        self.measurementSelectionTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.measurementSelectionTextField.rightViewMode = UITextFieldViewMode.always
        self.measurementSelectionTextField.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.addMeasurementBtnOutlt.tintColor = UIColor.appColor
        self.addMeasurementBtnOutlt.addTarget(self, action: #selector(self.addMeasurementBtnTapped(_:)), for: .touchUpInside)
        self.addMeasurementBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: .normal)
        
        self.graphDataDic["end_date"] = Date().stringFormDate(.yyyyMMdd)
        self.graphDataDic["start_date"] = ""
        
        if let data = self.lastSentData {
            self.graphDataDic["vital_super_id"] = data.superId
        }
        
        if let name = self.selectedVitalName{
            self.measurementSelectionTextField.text = name
        }
        
        self.registerNibs()
    }
    
    //    register Nibs
    fileprivate func registerNibs(){
        
        let graphNib = UINib(nibName: "GraphCell", bundle: nil)
        let vitalDataInTableNib = UINib(nibName: "VitalDataInTableCell", bundle: nil)
        let graphFilterNib = UINib(nibName: "GraphFilterCell", bundle: nil)
        let attachmentNib = UINib(nibName: "AttachmentCell", bundle: nil)
        let MeasurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let attachmentHeaderNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        let nutritionsSelectionCell = UINib(nibName: "NutritionsSelectionCell", bundle: nil)
        
        self.myMeasurementDetailTableView.register(nutritionsSelectionCell, forCellReuseIdentifier: "nutritionsSelectionCellID")
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
        
        WebServices.getVitalList(parameters: param,
                                 success: {[weak self] (_ vitalListData : [VitalListModel]) in
                                    
                                    guard let vitalVC = self else{
                                        return
                                    }
                                    
                                    vitalVC.vitalListData = vitalListData
                                    
                                    let vitalList = vitalVC.vitalListData.map{(value) in
                                        value.vitalName
                                    }
                                    
                                    vitalVC.vitalNameArray = vitalList as! [String]
                                    
                                    if let lastSendData = vitalVC.lastSentData {
                                        vitalVC.measurementSelectionTextField.text = lastSendData.vitalName
                                        vitalVC.latestVitalListDic["vital_id"] = lastSendData.superId
                                        vitalVC.graphDataDic["vital_super_id"] = lastSendData.superId
                                        
                                        vitalVC.getLatestVitals()
                                        vitalVC.getTabularData(sender: nil)
                                        vitalVC.getAttachmentList()
                                    }else{
                                        if !vitalVC.vitalListData.isEmpty {
                                            
                                            switch vitalVC.proceeedToScreenThrough {
                                                
                                            case .vitalScreen:
                                                if let vitalID = vitalVC.selectedVitalID{
                                                    vitalVC.latestVitalListDic["vital_id"]  = vitalID
                                                    vitalVC.graphDataDic["vital_super_id"] = vitalID
                                                    vitalVC.getLatestVitals()
                                                    vitalVC.getTabularData(sender: nil)
                                                    vitalVC.getAttachmentList()
                                                }
                                            case .images:
                                                vitalVC.apiGraphDataArray = []
                                                vitalVC.getAttachmentList()
                                            }
                                        }
                                    }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getLatestVitals(){
        
        let id = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        self.latestVitalListDic["id"] = id
        
        WebServices.getLatestVitals(parameters: self.latestVitalListDic,
                                    success: {[weak self] (_ latestData :[LatestThreeVitalData]) in
                                        
                                        guard let measurementDetailVC = self else{
                                            return
                                        }
                                        
                                        measurementDetailVC.topMostVitalData = latestData
                                        measurementDetailVC.getGraphData()

                                        let switchGraphCellIndexPath = IndexPath.init(row: 0, column: 0)
                                        let latestVitalIndexPath = IndexPath.init(row: 3, column: 0)
                                        measurementDetailVC.myMeasurementDetailTableView.reloadRows(at: [switchGraphCellIndexPath, latestVitalIndexPath], with: .automatic)
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getGraphData(){
        
        guard !self.topMostVitalData.isEmpty else{
            self.apiGraphDataArray = []
            return
        }
        
        guard let vitalSubID = self.topMostVitalData[self.vitalSubIDIndex].vitalSubID else {
            self.apiGraphDataArray = []
            return
        }
        self.graphDataDic["vital_sub_id"] = vitalSubID
        
        guard let vitalSuperId = self.graphDataDic["vital_super_id"] else {
            self.apiGraphDataArray = []
            return
        }
        
        let currentDate = Date()
        let fiveYearAgoDate = currentDate.adding(.year, value: -5)
        
        let parameters: JSONDictionary = ["start_date": fiveYearAgoDate.stringFormDate(.yyyyMMdd),
                                          "end_date": currentDate.stringFormDate(.yyyyMMdd),
                                          "vital_super_id": vitalSuperId,
                                          "vital_sub_id": vitalSubID]
        
        WebServices.getMeasurementGraphData(parameters: parameters, success: { [weak self] measurementList in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.apiGraphDataArray = strongSelf.sortGraphData(measurementList.graphData)
            let indexPath = IndexPath.init(row: 1, column: 0)
            strongSelf.myMeasurementDetailTableView.reloadRows(at: [indexPath], with: .none)
            strongSelf.generateGraphData()
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    fileprivate func sortGraphData(_ data: [MeasurementGraphData]) -> [MeasurementGraphData] {
        return data.sorted(by: {
            return $0.measurementDate.compare($1.measurementDate) == .orderedAscending
        })
    }
    
    fileprivate func generateGraphData() {
        
        var graphDataArray: [MeasurementGraphData] = []
        var currentUnfilledApiDataIndex = 0
        var startDate = todaysDate.adding(.year, value: -1)
        let calendar = Calendar.current
        
        while startDate <= todaysDate {
            let dateText = startDate.stringFormDate(.yyyyMMdd)
            let isApiDataPresent = currentUnfilledApiDataIndex < apiGraphDataArray.count
            
            if isApiDataPresent {
                
                let apiGraphDataDate = apiGraphDataArray[currentUnfilledApiDataIndex].measurementDate
                let apiGraphDateSame = calendar.compare(apiGraphDataDate, to: startDate, toGranularity: .day)
                
                if (apiGraphDateSame == .orderedSame) {
                    graphDataArray.append(apiGraphDataArray[currentUnfilledApiDataIndex])
                    currentUnfilledApiDataIndex += 1
                    
                } else {
                    
                    if let graphData = getBlankGraphData(with: dateText) {
                        graphDataArray.append(graphData)
                    }
                }
                
            } else {
                
                if let graphData = getBlankGraphData(with: dateText) {
                    graphDataArray.append(graphData)
                }
            }
            
            startDate.add(.day, value: 1)
        }
        
        formattedGraphDataArray = sortGraphData(graphDataArray)
        startFetchingPoints()
    }
    
    fileprivate func getBlankGraphData(with dateText: String) -> MeasurementGraphData? {
        
        let dict: JSONDictionary = ["vital_id": 0,
                                    "measurement_date": dateText,
                                    "value_conversion": 0,
                                    "vital_severity": 0]
        
        return MeasurementGraphData(json: JSON(dict))
    }
    
    func startFetchingPoints() {
        self.getPointsForWeek()
        self.getPointsForMonth()
        self.getPointsFor3Months()
        self.getPointsFor6Months()
        self.getPointsForYear()
        self.getPointsForAll()
    }
    
    func getPointsForWeek() {
        let days = 7
        weekPoints = []
        for data in formattedGraphDataArray.suffix(days) {
            let weekPoint = getPoint([data], plotType: .week)
            weekPoints.append(weekPoint)
        }
    }
    
    func getPointsForMonth() {
        let previousMonthsEnd = todaysDate.adding(.month, value: -1).adding(.day, value: -1)
        let data = Array(formattedGraphDataArray.suffix(previousMonthsEnd.numberOfDays(from: todaysDate)))
        let chunks = data.chunks(5)
        monthPoints = getPoints(chunks, plotType: .month)
    }
    
    func getPointsFor3Months() {
        let firstMonth = todaysDate.adding(.month, value: -3)
        let firstMonthStart = firstMonth.startOfMonth
        let firstMonthMid = firstMonthStart.adding(.day, value: 14)
        let firstMonthAfterMid = firstMonthMid.adding(.day, value: 1)
        let firstMonthEnd = firstMonth.endOfMonth
        
        let firstMonthFirstHalfDays = firstMonthStart.numberOfDays(from: firstMonthMid)
        let firstMonthSecondHalfDays = firstMonthAfterMid.numberOfDays(from: firstMonthEnd)
        
        let secondMonth = todaysDate.adding(.month, value: -2)
        let secondMonthStart = secondMonth.startOfMonth
        let secondMonthMid = secondMonthStart.adding(.day, value: 14)
        let secondMonthAfterMid = secondMonthMid.adding(.day, value: 1)
        let secondMonthEnd = secondMonth.endOfMonth
        
        let secondMonthFirstHalfDays = secondMonthStart.numberOfDays(from: secondMonthMid)
        let secondMonthSecondHalfDays = secondMonthAfterMid.numberOfDays(from: secondMonthEnd)
        
        let thirdMonth = todaysDate.adding(.month, value: -1)
        let thirdMonthStart = thirdMonth.startOfMonth
        let thirdMonthMid = thirdMonthStart.adding(.day, value: 14)
        let thirdMonthAfterMid = thirdMonthMid.adding(.day, value: 1)
        let thirdMonthEnd = thirdMonth.endOfMonth
        
        let thirdMonthFirstHalfDays = thirdMonthStart.numberOfDays(from: thirdMonthMid)
        let thirdMonthSecondHalfDays = thirdMonthAfterMid.numberOfDays(from: thirdMonthEnd)
        
        let currentMonthStart = todaysDate.startOfMonth
        let currentMonthDays = currentMonthStart.numberOfDays(from: todaysDate)
        let totalDataCount = formattedGraphDataArray.count
        
        // Had to add 1 below because the days difference is calculated excluding beginning date
        let counts = [totalDataCount,
                      (currentMonthDays + 1),
                      (thirdMonthSecondHalfDays + 1),
                      (thirdMonthFirstHalfDays + 1),
                      (secondMonthSecondHalfDays + 1),
                      (secondMonthFirstHalfDays + 1),
                      (firstMonthSecondHalfDays + 1),
                      (firstMonthFirstHalfDays + 1)]
        
        threeMonthPoints = getGraphDataArray(with: counts, plotType: .threeMonths)
    }
    
    func getPointsFor6Months() {
        let firstMonth = todaysDate.adding(.month, value: -6)
        let firstMonthStart = firstMonth.startOfMonth
        let firstMonthEnd = firstMonth.endOfMonth
        let firstMonthDays = firstMonthStart.numberOfDays(from: firstMonthEnd)
        
        let secondMonth = todaysDate.adding(.month, value: -5)
        let secondMonthStart = secondMonth.startOfMonth
        let secondMonthEnd = secondMonth.endOfMonth
        let secondMonthDays = secondMonthStart.numberOfDays(from: secondMonthEnd)
        
        let thirdMonth = todaysDate.adding(.month, value: -4)
        let thirdMonthStart = thirdMonth.startOfMonth
        let thirdMonthEnd = thirdMonth.endOfMonth
        let thirdMonthDays = thirdMonthStart.numberOfDays(from: thirdMonthEnd)
        
        let fourthMonth = todaysDate.adding(.month, value: -3)
        let fourthMonthStart = fourthMonth.startOfMonth
        let fourthMonthEnd = fourthMonth.endOfMonth
        let fourthMonthDays = fourthMonthStart.numberOfDays(from: fourthMonthEnd)
        
        let fifthMonth = todaysDate.adding(.month, value: -2)
        let fifthMonthStart = fifthMonth.startOfMonth
        let fifthMonthEnd = fifthMonth.endOfMonth
        let fifthMonthDays = fifthMonthStart.numberOfDays(from: fifthMonthEnd)
        
        let sixthMonth = todaysDate.adding(.month, value: -1)
        let sixthMonthStart = sixthMonth.startOfMonth
        let sixthMonthEnd = sixthMonth.endOfMonth
        let sixthMonthDays = sixthMonthStart.numberOfDays(from: sixthMonthEnd)
        
        let currentMonthStart = todaysDate.startOfMonth
        let currentMonthDays = currentMonthStart.numberOfDays(from: todaysDate)
        let totalDataCount = formattedGraphDataArray.count
        
        // Had to add 1 below because the days difference is calculated excluding beginning date
        let counts = [totalDataCount,
                      (currentMonthDays + 1),
                      (sixthMonthDays + 1),
                      (fifthMonthDays + 1),
                      (fourthMonthDays + 1),
                      (thirdMonthDays + 1),
                      (secondMonthDays + 1),
                      (firstMonthDays + 1)]
        
        sixMonthPoints = getGraphDataArray(with: counts, plotType: .sixMonths)
    }
    
    func getPointsForYear() {
        let firstMonth = todaysDate.adding(.year, value: -1)
        let secondMonth = todaysDate.adding(.month, value: -11)
        let firstMonthStart = firstMonth.startOfDay
        let secondMonthEnd = secondMonth.endOfMonth
        let firstSecondMonthDays = firstMonthStart.numberOfDays(from: secondMonthEnd)
        
        let thirdMonth = todaysDate.adding(.month, value: -10)
        let fourthMonth = todaysDate.adding(.month, value: -9)
        let thirdMonthStart = thirdMonth.startOfMonth
        let fourthMonthEnd = fourthMonth.endOfMonth
        let thirdFourthMonthDays = thirdMonthStart.numberOfDays(from: fourthMonthEnd)
        
        let fifthMonth = todaysDate.adding(.month, value: -8)
        let sixthMonth = todaysDate.adding(.month, value: -7)
        let fifthMonthStart = fifthMonth.startOfMonth
        let sixthMonthEnd = sixthMonth.endOfMonth
        let fifthSixthMonthDays = fifthMonthStart.numberOfDays(from: sixthMonthEnd)
        
        let seventhMonth = todaysDate.adding(.month, value: -6)
        let eigthMonth = todaysDate.adding(.month, value: -5)
        let seventhMonthStart = seventhMonth.startOfMonth
        let eigthMonthEnd = eigthMonth.endOfMonth
        let seventhEigthMonthDays = seventhMonthStart.numberOfDays(from: eigthMonthEnd)
        
        let ninthMonth = todaysDate.adding(.month, value: -4)
        let tenthMonth = todaysDate.adding(.month, value: -3)
        let ninthMonthStart = ninthMonth.startOfMonth
        let tenthMonthEnd = tenthMonth.endOfMonth
        let ninthTenthMonthDays = ninthMonthStart.numberOfDays(from: tenthMonthEnd)
        
        let eleventhMonth = todaysDate.adding(.month, value: -2)
        let twelfthMonth = todaysDate.adding(.month, value: -1)
        let eleventhMonthStart = eleventhMonth.startOfMonth
        let twelfthMonthEnd = twelfthMonth.endOfMonth
        let eleventhTwelfthMonthDays = eleventhMonthStart.numberOfDays(from: twelfthMonthEnd)
        
        let currentMonthStart = todaysDate.startOfMonth
        let currentMonthDays = currentMonthStart.numberOfDays(from: todaysDate)
        let totalDataCount = formattedGraphDataArray.count
        
        // Had to add 1 below because the days difference is calculated excluding beginning date
        let counts = [totalDataCount,
                      (currentMonthDays + 1),
                      (eleventhTwelfthMonthDays + 1),
                      (ninthTenthMonthDays + 1),
                      (seventhEigthMonthDays + 1),
                      (fifthSixthMonthDays + 1),
                      (thirdFourthMonthDays + 1),
                      (firstSecondMonthDays + 1)]
        
        oneYearPoints = getGraphDataArray(with: counts, plotType: .year)
    }
    
    func getPointsForAll() {
        let indexPath = IndexPath(row: 1, section: 0)
        var cell: GraphCell!
        var measurementDate: Date!
        
        cell = self.myMeasurementDetailTableView.cellForRow(at: indexPath) as? GraphCell
        measurementDate = self.apiGraphDataArray.first?.measurementDate
        
        if cell == nil {
            return
        }
        
        let (point, plotType) = self.getPoints(from: measurementDate)
        cell.updateMeasurementGraph(with: point, plotType: plotType)
    }
    
    func getPoints(from measurementDate: Date?) -> ([MeasurementGraphTuple], GraphPlotType) {
        guard let date = measurementDate else {
            return (oneYearPoints, .year)
        }
        
        let weekStartingDate = self.todaysDate.adding(.day, value: -7)
        let previousMonthDate = self.todaysDate.adding(.month, value: -1)
        let threeMonthFirstDate = self.todaysDate.adding(.month, value: -3).startOfMonth
        let sixMonthFirstDate = self.todaysDate.adding(.month, value: -6).startOfMonth
        let previousYearDate = self.todaysDate.adding(.year, value: -1).startOfMonth
        
        if date.startOfDay > weekStartingDate.startOfDay {
            return (weekPoints, .week)
        } else if date.startOfDay > previousMonthDate.startOfDay {
            return (monthPoints, .month)
        } else if date.startOfDay > threeMonthFirstDate.startOfDay {
            return (threeMonthPoints, .threeMonths)
        } else if date.startOfDay > sixMonthFirstDate.startOfDay {
            return (sixMonthPoints, .sixMonths)
        } else if date.startOfDay > previousYearDate.startOfDay {
            return (oneYearPoints, .year)
        } else {
            return (oneYearPoints, .year)
        }
    }
    
    func getGraphDataArray(with counts: [Int], plotType: GraphPlotType) -> [MeasurementGraphTuple] {
        
        let currentFromIndex = (counts[0] - counts[1])
        let seventhPointData = Array(formattedGraphDataArray[max(0, currentFromIndex)..<counts[0]])
        
        let sixthPointIndex = (currentFromIndex - counts[2])
        let sixthPointData = Array(formattedGraphDataArray[max(0, sixthPointIndex)..<currentFromIndex])
        
        let fifthPointIndex = (sixthPointIndex - counts[3])
        let fifthPointData = Array(formattedGraphDataArray[max(0, fifthPointIndex)..<sixthPointIndex])
        
        let fourthPointIndex = (fifthPointIndex - counts[4])
        let fourthPointData = Array(formattedGraphDataArray[max(0, fourthPointIndex)..<fifthPointIndex])
        
        let thirdPointIndex = (fourthPointIndex - counts[5])
        let thirdPointData = Array(formattedGraphDataArray[max(0, thirdPointIndex)..<fourthPointIndex])
        
        let secondPointIndex = (thirdPointIndex - counts[6])
        let secondPointData = Array(formattedGraphDataArray[max(0, secondPointIndex)..<thirdPointIndex])
        
        let firstPointIndex = (secondPointIndex - counts[7])
        let firstPointData = Array(formattedGraphDataArray[max(0, firstPointIndex)..<secondPointIndex])
        
        let data = [firstPointData,
                    secondPointData,
                    thirdPointData,
                    fourthPointData,
                    fifthPointData,
                    sixthPointData,
                    seventhPointData
        ]
        
        let points = getPoints(data, plotType: plotType)
        return points
    }
    
    func getPoints(_ dataArray: [[MeasurementGraphData]], plotType: GraphPlotType) -> [MeasurementGraphTuple] {
        var points = [MeasurementGraphTuple]()
        for data in dataArray {
            points.append(getPoint(data, plotType: plotType))
        }
        return points
    }
    
    func getPoint(_ data: [MeasurementGraphData], plotType: GraphPlotType) -> MeasurementGraphTuple {
        var valueConversionY = 0
        
        guard let firstDate = data.first?.measurementDate, let lastDate = data.last?.measurementDate else {
            fatalError("Date must exist")
        }
        
        let firstDateTimeInterval = firstDate.timeIntervalSince1970
        let lastDateTimeInterval = lastDate.timeIntervalSince1970
        let averageTimeInterval = (firstDateTimeInterval + lastDateTimeInterval) / 2
        
        ////printlnDebug("plotType: \(type), firstDate: \(firstDate), lastDate: \(lastDate)")
        
        for graphData in data {
            //valueConversionY += graphData.value_conversion
            valueConversionY = max(valueConversionY, graphData.value_conversion)
        }
        
        let dataCount = data.count
        //let averageValueConversion = Double(valueConversionY/dataCount)
        let averageValueConversion = Double(valueConversionY/dataCount)
        
        return (averageTimeInterval: averageTimeInterval,
                averageValueConversion: averageValueConversion)
    }
    
    fileprivate func getAttachmentList(categoryType: Int = 1){
        
        self.graphDataDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        WebServices.getAttachmentList(parameters: self.graphDataDic,
                                      success: { [weak self](attachmentData :[AttachmentDataModel]) in
                                        
                                        guard let strongSelf = self else{
                                            return
                                        }
                                        strongSelf.attachmentList = []
                                        strongSelf.isHitGetAttachedService = true
                                        strongSelf.attachmentList = attachmentData
                                        if categoryType == 0 {
                                            strongSelf.myMeasurementDetailTableView.reloadData()
                                        }else{
                                            strongSelf.myMeasurementDetailTableView.reloadData()
                                        }
                                        
        }) {[weak self] (e) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.attachmentList = []
            strongSelf.isHitGetAttachedService = true
            showToastMessage(e.localizedDescription)
        }
    }
    
    fileprivate func getTabularData(sender: TransitionButton?){
        
        self.graphDataDic["id"] = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        WebServices.getTabularData(parameters: self.graphDataDic, success: {[weak self](tabularData: [[MeasurementTablurData]], count : Int,subvital: [MeasurementTabularSubVital]) in
            
            guard let measurementDetailVC = self else{
                return
            }
            
            if let button = sender {
                button.stopAnimation()
            }
            measurementDetailVC.tabularSubVitalData = subvital
            
            if measurementDetailVC.loadMoreBtntapped == LoadMoreBtnTapped.yes{
                measurementDetailVC.measurementTabularData.append(contentsOf: tabularData)
            }else{
                measurementDetailVC.measurementTabularData = tabularData
            }
            
            measurementDetailVC.nextCount = count
            
            let graphCellIndexPath = IndexPath(row: 1, section: 0)
            let dataTypeSelectionCellIndexPath = IndexPath(row: 2, section: 0)
            measurementDetailVC.myMeasurementDetailTableView.reloadRows(at: [graphCellIndexPath, dataTypeSelectionCellIndexPath], with: .fade)
            
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
