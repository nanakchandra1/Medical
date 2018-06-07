//
//  ActivityVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON
import TransitionButton

class ActivityVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    var proceedToScreenThrough = ProceedToScreenBy.sideMenu
    
    fileprivate var apiGraphDataArray: [ActivityGraphData] = []
    fileprivate var formattedGraphDataArray: [ActivityGraphData] = []
    fileprivate let todaysDate = Date().startOfDay
    fileprivate var dataType: ActivityDataType = .duration
    fileprivate var lastPlotType: GraphPlotType?
    fileprivate var vitalButtonTapped: VitalBtnTapped = .hb
    fileprivate var filterButtonTapped: FilterState = .all
    
    fileprivate var weekPoints: [ActivityConsumedPlannedTuple] = []
    fileprivate var monthPoints: [ActivityConsumedPlannedTuple] = []
    fileprivate var threeMonthPoints: [ActivityConsumedPlannedTuple] = []
    fileprivate var sixMonthPoints: [ActivityConsumedPlannedTuple] = []
    fileprivate var oneYearPoints: [ActivityConsumedPlannedTuple] = []
    
    fileprivate var loadMoreBtntapped: LoadMoreBtnTapped = .no
    fileprivate var switchBtnTapped: SwitchBtnTapped = .graphBtnTapped
    fileprivate var activityList = ["Running", "Walking","Swimming"]
    fileprivate var sevenDayActivityPlan = [SevenDaysAvgData]()
    fileprivate var selectedDateData = [JSON]()
    fileprivate var selectedDate = Date()
    fileprivate var dayWiseDataDic = [String : Any]()
    fileprivate var graphDataDic = [String : Any]()
    fileprivate var activityDataInTabular = [ActivityDataInTabular]()
    fileprivate var tabularDataCount : Int?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var activityListingTableView: UITableView!
    @IBOutlet weak var activityPlanBtn: UIButton!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sideMenuBtnActn: SidemenuBtnAction = self.proceedToScreenThrough == .navigationBar ? .backBtn : .sideMenuBtn
        self.sideMenuBtnActn = sideMenuBtnActn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .activity
        self.setNavigationBar(screenTitle: K_ACTIVITY_SCREEN_TITLE.localized)
        
        self.getSevenDayActivityData()
        self.getActivityByDate()
        self.activityDataInTabularForm(sender: nil)
        getGraphData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityPlanBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    func getGraphData() {
        let parameters: JSONDictionary = ["curr_date": Date().stringFormDate(.yyyyMMdd)]
        
        WebServices.getActivityGraphData(parameters: parameters, success: { [weak self] graphDataArray in
            guard let strongSelf = self else {
                return
            }
            strongSelf.apiGraphDataArray = strongSelf.sortGraphData(graphDataArray)
            strongSelf.generateGraphData()
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func generateGraphData() {
        
        var graphDataArray: [ActivityGraphData] = []
        var currentUnfilledApiDataIndex = 0
        var startDate = todaysDate.adding(.year, value: -1)
        let calendar = Calendar.current
        
        while startDate <= todaysDate {
            let dateText = startDate.stringFormDate(.yyyyMMdd)
            let isApiDataPresent = currentUnfilledApiDataIndex < apiGraphDataArray.count
            
            if isApiDataPresent {
                
                let apiGraphDataDate = apiGraphDataArray[currentUnfilledApiDataIndex].activityDate
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
    
    func getBlankGraphData(with dateText: String) -> ActivityGraphData? {
        
        //        let dict: JSONDictionary = ["plan_duration": Int.random(20, 60),
        //                                    "plan_calories": Int.random(200, 600),
        //                                    "plan_distance": Int.random(4, 8),
        //                                    "consume_duration": Int.random(20, 60),
        //                                    "consume_calories": Int.random(200, 600),
        //                                    "consume_distance": Int.random(4, 8),
        //                                    "activity_date": dateText
        //        ]
        
        let dict: JSONDictionary = ["plan_duration": 0,
                                    "plan_calories": 0,
                                    "plan_distance": 0,
                                    "consume_duration": 0,
                                    "consume_calories": 0,
                                    "consume_distance": 0,
                                    "activity_date": dateText
        ]
        
        return ActivityGraphData(json: JSON(dict))
    }
    
    func sortGraphData(_ data: [ActivityGraphData]) -> [ActivityGraphData] {
        return data.sorted(by: {
            return $0.activityDate.compare($1.activityDate) == .orderedAscending
        })
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
        let indexPath = IndexPath(row: 2, section: 1)
        var cell: GraphCell!
        var activityDate: Date!
        
        cell = self.activityListingTableView.cellForRow(at: indexPath) as? GraphCell
        activityDate = self.apiGraphDataArray.first?.activityDate
        
        if cell == nil {
            return
        }
        
        let (points, plotType) = self.getPoints(from: activityDate)
        cell.updateActivityGraph(with: points, plotType: plotType, dataType: dataType, lineType: GraphLineType.burnt)
    }
    
    func getPoints(from measurementDate: Date?) -> ([ActivityConsumedPlannedTuple], GraphPlotType) {
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
    
    func getGraphDataArray(with counts: [Int], plotType: GraphPlotType) -> [ActivityConsumedPlannedTuple] {
        
        let currentFromIndex = (counts[0] - counts[1])
        let seventhPointData = Array(formattedGraphDataArray[currentFromIndex..<counts[0]])
        
        let sixthPointIndex = (currentFromIndex - counts[2])
        let sixthPointData = Array(formattedGraphDataArray[sixthPointIndex..<currentFromIndex])
        
        let fifthPointIndex = (sixthPointIndex - counts[3])
        let fifthPointData = Array(formattedGraphDataArray[fifthPointIndex..<sixthPointIndex])
        
        let fourthPointIndex = (fifthPointIndex - counts[4])
        let fourthPointData = Array(formattedGraphDataArray[fourthPointIndex..<fifthPointIndex])
        
        let thirdPointIndex = (fourthPointIndex - counts[5])
        let thirdPointData = Array(formattedGraphDataArray[thirdPointIndex..<fourthPointIndex])
        
        let secondPointIndex = (thirdPointIndex - counts[6])
        let secondPointData = Array(formattedGraphDataArray[secondPointIndex..<thirdPointIndex])
        
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
    
    func getPoints(_ dataArray: [[ActivityGraphData]], plotType: GraphPlotType) -> [ActivityConsumedPlannedTuple] {
        var points = [ActivityConsumedPlannedTuple]()
        for data in dataArray {
            points.append(getPoint(data, plotType: plotType))
        }
        return points
    }
    
    func getPoint(_ data: [ActivityGraphData], plotType: GraphPlotType) -> ActivityConsumedPlannedTuple {
        var consumedCalorieY = 0
        var consumedDurationY = 0
        var consumedDistanceY = 0
        
        var plannedCalorieY = 0
        var plannedDurationY = 0
        var plannedDistanceY = 0
        
        guard let firstDate = data.first?.activityDate, let lastDate = data.last?.activityDate else {
            fatalError("Date must exist")
        }
        
        let firstDateTimeInterval = firstDate.timeIntervalSince1970
        let lastDateTimeInterval = lastDate.timeIntervalSince1970
        let averageTimeInterval = (firstDateTimeInterval + lastDateTimeInterval) / 2
        
        ////printlnDebug("plotType: \(type), firstDate: \(firstDate), lastDate: \(lastDate)")
        
        for graphData in data {
            plannedCalorieY += graphData.planCalories
            consumedCalorieY += graphData.consumeCalories
            plannedDurationY += graphData.planDuration
            consumedDurationY += graphData.consumeDuration
            plannedDistanceY += graphData.planDistance
            consumedDistanceY += graphData.consumeDistance
        }
        
        let dataCount = data.count
        let consumedAverageCalories = Double(consumedCalorieY/dataCount)
        let consumedAverageDuration = Double(consumedDurationY/dataCount)
        let consumedAverageDistance = Double(consumedDistanceY/dataCount)
        
        let plannedAverageCalories = Double(plannedCalorieY/dataCount)
        let plannedAverageDuration = Double(plannedDurationY/dataCount)
        let plannedAverageDistance = Double(plannedDistanceY/dataCount)
        
        let consumed = (averageTimeInterval: averageTimeInterval, averageCalories: consumedAverageCalories, averageDuration: consumedAverageDuration, averageDistance: consumedAverageDistance)
        let planned = (averageTimeInterval: averageTimeInterval, averageCalories: plannedAverageCalories, averageDuration: plannedAverageDuration, averageDistance: plannedAverageDistance)
        
        return (consumed: consumed,
                planned: planned)
    }
    
    @IBAction func activityPlanBtnTapped(_ sender: UIButton) {
        
        let activityPlanScene = ActivityPlanVC.instantiate(fromAppStoryboard: .Activity)
        self.navigationController?.pushViewController(activityPlanScene, animated: true)
    }
}

//MARK:- UITableViewDataSource Method
//===================================
extension ActivityVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let sections = (section == false.rawValue) ? 1 : 4
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.section {
            
        case 0 :
            guard let activityProgressCell = tableView.dequeueReusableCell(withIdentifier: "activityProgressCellID") as? ActivityProgressCell else{
                fatalError("Activity Progress Cell Not Found!")
            }
            
            activityProgressCell.populateData(self.selectedDate)
            
            activityProgressCell.previousDateBtn.addTarget(self, action: #selector(self.leftArrowTapped(_:)), for: UIControlEvents.touchUpInside)
            activityProgressCell.nextDateBtn.addTarget(self, action: #selector(self.rightArrowTapped(_:)), for: UIControlEvents.touchUpInside)
            activityProgressCell.calenderBtn.addTarget(self, action: #selector(self.calenderBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            activityProgressCell.populateData(self.selectedDateData)
            
            return activityProgressCell
        case 1:
            switch indexPath.row {
                
            case 0:
                
                guard let activityDataCollectionCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                    fatalError("activitySelectionCell Not Found!")
                }
                
                activityDataCollectionCell.viewContainAllObjects.layer.cornerRadius = 2.2
                activityDataCollectionCell.viewContainAllObjects.layer.masksToBounds = true
                
                activityDataCollectionCell.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
                activityDataCollectionCell.outerView.layer.cornerRadius = 2.2
                activityDataCollectionCell.outerView.clipsToBounds = false
                activityDataCollectionCell.outerView.layer.masksToBounds = false
                
                activityDataCollectionCell.measurementListCollectionView.bounces = false
                
                if !(activityDataCollectionCell.measurementListCollectionView.delegate is ActivityVC){
                    activityDataCollectionCell.measurementListCollectionView.dataSource = self
                    activityDataCollectionCell.measurementListCollectionView.delegate = self
                }
                
                if !self.sevenDayActivityPlan.isEmpty {
                    activityDataCollectionCell.measurementListCollectionView.reloadData()
                }
                
                return activityDataCollectionCell
                
            case 1: guard let switchGraphCell = tableView.dequeueReusableCell(withIdentifier: "switchGraphCellID") as? SwitchGraphCell else{
                
                fatalError("switchGraphCell Not Found!")
            }
            
            switchGraphCell.graphBtnOulet.addTarget(self, action: #selector(self.graphBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            switchGraphCell.tabelBtnOutlet.addTarget(self, action: #selector(self.listBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            switchGraphCell.vitalBtnTapped = self.vitalButtonTapped
            switchGraphCell.hbButtonOutlet.setTitle(K_DURATION_BUTTON.localized.uppercased(), for: UIControlState.normal)
            switchGraphCell.tlcBtnOutlet.setTitle(K_DISTANCE_BUTTON.localized.uppercased(), for: UIControlState.normal)
            switchGraphCell.platletBtnOutlet.setTitle(K_CALORIES_BUTTON.localized.uppercased(), for: UIControlState.normal)
            
            switchGraphCell.hbButtonOutlet.addTarget(self, action: #selector(self.durationButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            switchGraphCell.tlcBtnOutlet.addTarget(self, action: #selector(self.distanceButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            switchGraphCell.platletBtnOutlet.addTarget(self, action: #selector(self.caloriesButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            
            switchGraphCell.populateCellViewAsBtnTapped(self.switchBtnTapped)
            
            return switchGraphCell
                
            case 2:  if self.switchBtnTapped == .graphBtnTapped {
                
                guard let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCellID") as? GraphCell else{
                    fatalError("GraphCell Not Found!")
                }
                
                updateGraphCell(graphCell)
                return graphCell
                
            }else{
                
                guard let tableDataCell = tableView.dequeueReusableCell(withIdentifier: "vitalDataInTableCellID") as? VitalDataInTableCell else{
                    fatalError("GraphCell Not Found!")
                }
                
                tableDataCell.tableCellFor = .activity
                
                if !self.activityDataInTabular.isEmpty {
                    tableDataCell.activityDataInTabular = self.activityDataInTabular
                    tableDataCell.vitalDataView.reloadData()
                }
                
                return tableDataCell
                }
                
            case 3: guard let graphFilterCell = tableView.dequeueReusableCell(withIdentifier: "graphFilterCellID") as? GraphFilterCell else{
                
                fatalError("graphFilterCell Not Found!")
            }
            
            graphFilterCell.loadMoreBtnOutlt.isHidden = true
            
            if self.switchBtnTapped == .listBtnTapped {
                
                graphFilterCell.buttonState = self.filterButtonTapped
                if let count = self.tabularDataCount {
                    
                    let nextCount = (count < 1) ? true : false
                    let loadMoreHeight = (nextCount) ? 0 : 30
                    graphFilterCell.loadMoreBtnOutlt.isHidden = nextCount
                    graphFilterCell.loadmoreBtnHeightConstant.constant = CGFloat(loadMoreHeight)
                    
                }else{
                    graphFilterCell.loadMoreBtnOutlt.isHidden = true
                    graphFilterCell.loadmoreBtnHeightConstant.constant = 0
                }
            }else{
                if let plotType = lastPlotType, let buttonState = FilterState(rawValue: plotType.rawValue) {
                    graphFilterCell.buttonState = buttonState
                } else {
                    graphFilterCell.buttonState = .all
                }
            }
            
            graphFilterCell.oneWeekBtn.addTarget(self, action: #selector(self.oneWeekBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.oneMonthBtn.addTarget(self, action: #selector(self.oneMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.threeMonthBtn.addTarget(self, action: #selector(self.threeMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.sixMonthBtn.addTarget(self, action: #selector(self.sixMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.oneYearBtn.addTarget(self, action: #selector(self.oneYearBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.allBtn.addTarget(self, action: #selector(self.AllBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            graphFilterCell.loadMoreBtnOutlt.addTarget(self, action: #selector(self.loadMoreBtnTapped(_:)), for: UIControlEvents.touchUpInside)
            
            return graphFilterCell
                
            default :
                fatalError("Cell not Found!")
                
            }
            
        default :
            fatalError("Section Not Found!")
        }
    }
    
    func updateGraphCell(_ cell: GraphCell) {
        if let graphLastPlotType = self.lastPlotType {
            let points = getPoints(for: graphLastPlotType)
            cell.updateActivityGraph(with: points, plotType: graphLastPlotType, dataType: dataType, lineType: GraphLineType.burnt)
            
        } else {
            let activityDate = self.apiGraphDataArray.first?.activityDate
            let (points, plotType) = getPoints(from: activityDate)
            cell.updateActivityGraph(with: points, plotType: plotType, dataType: dataType, lineType: GraphLineType.burnt)
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension ActivityVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
            fatalError("HeaderView Not Found!")
        }
        headerView.activityDateLabel.isHidden = true
        headerView.activityStatusLabel.text = K_LAST7DAYS.localized
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        switch section{
            
        case 0 :
            return CGFloat.leastNormalMagnitude
        case 1 :
            return 34.5
        default :
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section{
            
        case 0:
            
            switch indexPath.row{
                
            case 0 :
                let height = (DeviceType.IS_IPHONE_5) ? 190 : 220
                return CGFloat(height)
            default :
                return CGFloat.leastNormalMagnitude
            }
            
        case 1:
            switch indexPath.row{
                
            case 0:
                return 135
            case 1:
                return 40.5
            case 2:
                let height: CGFloat = CGFloat(self.activityDataInTabular.count > 5 ? 225 : ((self.activityDataInTabular.count + 1) * 41))

                let cellHeight = self.switchBtnTapped == .listBtnTapped ? height : 225
                return cellHeight
            case 3:
                if self.switchBtnTapped == .listBtnTapped {
                    var nxtCount : CGFloat = 0
                    if let count = self.tabularDataCount {
                        nxtCount = (count > 1) ? 83 : 40
                    }
                    return nxtCount
                }else{
                    return 40
                }
                
            default :
                return CGFloat.leastNormalMagnitude
            }
        default :
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension ActivityVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityPlanCollectionCellID", for: indexPath) as? ActivityPlanCollectionCell else{
            
            fatalError("ActivityPlanCollectionCell Not Found!")
        }
        
        if !self.sevenDayActivityPlan.isEmpty {
            cell.averageLabel.text = K_AVG.localized
            
            if indexPath.item == 0 {
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanClock")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].activityDuration
                cell.activityValueLabel.textColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
                cell.activityUnitLabel.text = K_MINUTES_UNIT.localized
            }else if indexPath.item == 1{
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanDistance")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].totalDistance
                cell.activityValueLabel.textColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
                cell.activityUnitLabel.text = K_KILOMETERS_UNIT.localized
            }else{
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanCal")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].caloriesBurn
                cell.activityValueLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.05098039216, alpha: 1)
                cell.activityUnitLabel.text = K_CALORIES_UNIT.localized
            }
        }
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//==================================================
extension ActivityVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing: CGFloat = 4
        let collectionViewWdith = (collectionView.frame.width - (2*interItemSpacing))
        
        return CGSize(width: collectionViewWdith/3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

//MARK:- Methods
//==============
extension ActivityVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = false
        
        self.view.backgroundColor = UIColor.activityVCBackgroundColor
        self.activityPlanBtn.setTitle(K_ACTIVITY_PLAN_SCREEN_TITLE.localized.uppercased(), for: UIControlState.normal)
        self.activityPlanBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.activityPlanBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.activityListingTableView.dataSource = self
        self.activityListingTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){

        let activityProgressCellNib = UINib(nibName: "ActivityProgressCell", bundle: nil)
        let activityCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let switchGraphCellNib = UINib(nibName: "SwitchGraphCell", bundle: nil)
        let graphCellNib = UINib(nibName: "GraphCell", bundle: nil)
        let graphFilterCellNib = UINib(nibName: "GraphFilterCell", bundle: nil)
        let activityDataInTableViewNib = UINib(nibName: "VitalDataInTableCell", bundle: nil)
        let activityplanDateNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)

        self.activityListingTableView.register(activityProgressCellNib, forCellReuseIdentifier: "activityProgressCellID")
        self.activityListingTableView.register(activityCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.activityListingTableView.register(switchGraphCellNib, forCellReuseIdentifier: "switchGraphCellID")
        self.activityListingTableView.register(graphCellNib, forCellReuseIdentifier: "graphCellID")
        self.activityListingTableView.register(graphFilterCellNib, forCellReuseIdentifier: "graphFilterCellID")
        self.activityListingTableView.register(activityDataInTableViewNib, forCellReuseIdentifier: "vitalDataInTableCellID")
        self.activityListingTableView.register(activityplanDateNib, forHeaderFooterViewReuseIdentifier: "activityPlanDateCellID")
    }
    
    //    MARK:- Button Action
    //    ====================
    //    MARK: ListBtnTapped To view the vlaues in List
    //    ==============================================
    @objc fileprivate func listBtnTapped(_ sender : UIButton){
        guard let indexPath = sender.tableViewIndexPathIn(self.activityListingTableView) else {
            return
        }
        guard self.switchBtnTapped != .listBtnTapped else{
            return
        }
        self.loadMoreBtntapped = .no
        self.switchBtnTapped = .listBtnTapped
        let nextIndexPath1 = IndexPath(row: indexPath.row + 1, section: 1)
        let nextIndexPath2 = IndexPath(row: indexPath.row + 2, section: 1)
        self.activityListingTableView.reloadRows(at: [indexPath, nextIndexPath1, nextIndexPath2], with: .fade)
    }
    
    //    MARK: Graph Button Tapped to view the values in graph
    //    =====================================================
    @objc fileprivate func graphBtnTapped(_ sender : UIButton){
        
        guard let indexPath = sender.tableViewIndexPathIn(self.activityListingTableView) else {
            return
        }
        guard self.switchBtnTapped != .graphBtnTapped else{
            return
        }
        self.loadMoreBtntapped = .no
        self.switchBtnTapped = .graphBtnTapped
        
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 1)
        self.activityListingTableView.reloadRows(at: [nextIndexPath], with: .fade)
        guard let cell = self.activityListingTableView.cellForRow(at: nextIndexPath) as? GraphCell else {
            return
        }
        
        if let graphLastPlotType = self.lastPlotType {
            let points = getPoints(for: graphLastPlotType)
            cell.updateActivityGraph(with: points, plotType: graphLastPlotType, dataType: dataType, lineType: GraphLineType.burnt)
        } else {
            let activityDate = self.apiGraphDataArray.first?.activityDate
            let (points, plotType) = getPoints(from: activityDate)
            cell.updateActivityGraph(with: points, plotType: plotType, dataType: dataType, lineType: GraphLineType.burnt)
        }
        
        let weekBtnIndexPath = IndexPath(row: nextIndexPath.row + 1, section: 1)
        self.activityListingTableView.reloadRows(at: [indexPath, weekBtnIndexPath], with: .fade)
    }
    
    func getPoints(for plotType: GraphPlotType) -> [ActivityConsumedPlannedTuple] {
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
    
    //    MARK:- DurationBtnTapped
    //    ============================
    @objc fileprivate func durationButtonTapped(_ sender : UIButton){
        
        self.dataType = .duration
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? SwitchGraphCell else{
            return
        }
        
        self.vitalButtonTapped = .hb
        cell.vitalBtnTapped = .hb
        
        //        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[0].vitalSubID
        
        if self.switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            updateGraphCell(cell)
        }
    }
    
    @objc fileprivate func distanceButtonTapped(_ sender : UIButton){
        
        self.dataType = .distance
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? SwitchGraphCell else{
            return
        }
        
        self.vitalButtonTapped = .tlc
        cell.vitalBtnTapped = .tlc
        
        //        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[1].vitalSubID
        
        if self.switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            updateGraphCell(cell)
        }
    }
    
    @objc fileprivate func caloriesButtonTapped(_ sender : UIButton){
        
        self.dataType = .calorie
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? SwitchGraphCell else{
            return
        }
        
        self.vitalButtonTapped = .platlet
        cell.vitalBtnTapped = .platlet
        
        if self.switchBtnTapped == .graphBtnTapped {
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            updateGraphCell(cell)
        }
    }
    
    //    MARK:- GraphFilterBtnTapped
    //    ===========================
    @objc fileprivate func oneWeekBtnTapped(_ sender : UIButton){
        
        self.lastPlotType = .week
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        self.filterButtonTapped = .oneWeek
        cell.buttonState = .oneWeek
        let lastWeekDate = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastWeekDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            cell.updateActivityGraph(with: weekPoints, plotType: .week, dataType: dataType, lineType: GraphLineType.burnt)
            
        } else {
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func oneMonthBtnTapped(_ sender : UIButton){
        
        self.lastPlotType = .month
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        
        self.filterButtonTapped = .oneMonth
        cell.buttonState = .oneMonth
        
        let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: monthPoints, plotType: .month, dataType: dataType, lineType: GraphLineType.burnt)
        }else{
            
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func threeMonthBtnTapped(_ sender : UIButton){
        
        self.lastPlotType = .threeMonths
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        
        self.filterButtonTapped = .threeMonth
        cell.buttonState = .threeMonth
        
        let lastThirdMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -3, to: Date())
        
        self.graphDataDic["start_date"] = lastThirdMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: threeMonthPoints, plotType: .threeMonths, dataType: dataType, lineType: GraphLineType.burnt)
        }else{
            
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func sixMonthBtnTapped(_ sender : UIButton){
        
        self.lastPlotType = .sixMonths
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        
        self.filterButtonTapped = .sixMonth
        cell.buttonState = .sixMonth
        
        let lastSixthMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -6, to: Date())
        
        self.graphDataDic["start_date"] = lastSixthMonthDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: sixMonthPoints, plotType: .sixMonths, dataType: dataType, lineType: GraphLineType.burnt)
        }else{
            
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func oneYearBtnTapped(_ sender : UIButton){
        
        self.lastPlotType = .year
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        
        self.filterButtonTapped = .oneYear
        cell.buttonState = .oneYear
        let lastYearDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastYearDate?.stringFormDate(.yyyyMMdd)
        
        if switchBtnTapped == .graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: oneYearPoints, plotType: .year, dataType: dataType, lineType: GraphLineType.burnt)
        }else{
            
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func AllBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        
        guard let index = sender.tableViewIndexPathIn(self.activityListingTableView) else{
            return
        }
        
        guard let cell = self.activityListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            return
        }
        
        self.filterButtonTapped = .all
        cell.buttonState = .all
        
        self.graphDataDic["start_date"] = ""
        
        if switchBtnTapped == .graphBtnTapped{
            
            getPointsForAll()
        }else{
            
            self.activityDataInTabularForm(sender: nil)
        }
    }
    
    @objc fileprivate func leftArrowTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate)!
        
        self.getActivityByDate()
    }
    
    @objc fileprivate func rightArrowTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
        
        self.getActivityByDate()
    }
    
    @objc fileprivate func calenderBtnTapped(_ sender : UIButton){
        self.loadMoreBtntapped = .no
        
        let dateScene = DateVC.instantiate(fromAppStoryboard: .Activity)
        
        dateScene.delegate = self
        dateScene.maxDate = Date()
        dateScene.modalPresentationStyle = .overCurrentContext
        self.present(dateScene, animated: false, completion: nil)
    }
    
    @objc fileprivate func loadMoreBtnTapped(_ sender : TransitionButton){
        
        self.loadMoreBtntapped = .yes
        if let count = self.tabularDataCount, count > 0 {
            if self.switchBtnTapped == .listBtnTapped{
                self.graphDataDic["next_count"] = self.tabularDataCount
                sender.startAnimation()
                self.activityDataInTabularForm(sender: sender)
            }
        }
    }
}

//MARK:- Webservices
//===================
extension ActivityVC {
    
    fileprivate func getSevenDayActivityData(){
        
        let p = [String : Any]()
        
        WebServices.sevenDaysActivityAvg(parameters: p, success: {[weak self] (_ sevenDayActivityData :[SevenDaysAvgData]) in
            
            guard let activityVC = self else{
                return
            }
            
            activityVC.sevenDayActivityPlan = sevenDayActivityData
            activityVC.activityListingTableView.reloadData()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getActivityByDate(){
        
        self.dayWiseDataDic["curr_date"] = self.selectedDate.stringFormDate(.yyyyMMdd)
        
        WebServices.getActivityBySelectedDate(parameters: self.dayWiseDataDic, success: {[weak self] (_ dayWiseData : [JSON]) in
            
            guard let activityVC = self else{
                return
            }
            
            activityVC.selectedDateData = dayWiseData
            activityVC.activityListingTableView.reloadData()
            
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func activityDataInTabularForm(sender: TransitionButton?){
        
        self.graphDataDic["end_date"] = Date().stringFormDate(.yyyyMMdd)
        let isLoaderDisplayed = sender != nil ? false : true
        
        WebServices.getActivityInTabularForm(parameters: self.graphDataDic,
                                             loader: isLoaderDisplayed,
                                             success: {[weak self] (_ activityDataInTabular : [ActivityDataInTabular], _ count : Int) in
                                                
                                                guard let activityVC = self else{
                                                    return
                                                }
                                                
                                                if let button = sender {
                                                    button.stopAnimation()
                                                }
                                                
                                                if !activityDataInTabular.isEmpty {
                                                    
                                                    if activityVC.loadMoreBtntapped == .yes{
                                                        activityVC.activityDataInTabular.append(contentsOf: activityDataInTabular)
                                                    }else{
                                                        activityVC.activityDataInTabular = activityDataInTabular
                                                    }
                                                }else{
                                                    activityVC.activityDataInTabular = []
                                                }
                                                activityVC.tabularDataCount = count
                                                let graphCellIndexPath = IndexPath(row: 2, section: 1)
                                                let dataTypeSelectionCellIndexPath = IndexPath(row: 3, section: 1)
                                                activityVC.activityListingTableView.reloadRows(at: [graphCellIndexPath, dataTypeSelectionCellIndexPath], with: .fade)
                                                
        }) { (error) in
            
            if let button = sender {
                button.stopAnimation()
            }
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- Protocol
//===============
extension ActivityVC : SelectedDate {
    
    func donebtnActn(_ date: Date) {
        self.selectedDate = date
        self.getActivityByDate()
    }
}
