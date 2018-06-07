//
//  ActivityVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    enum SwitchBtnTapped {
        
        case graphBtnTapped, listBtnTapped
    }
    
    enum LoadMoreBtnTapped {
        
        case yes , no
    }
    
    var apiGraphDataArray: [ActivityGraphData] = []
    var formattedGraphDataArray: [ActivityGraphData] = []
    let todaysDate = Date().startOfDay
    var dataType: ActivityDataType = .duration
    var lastPlotType: GraphPlotType = .week
    
    var weekPoints: [ActivityConsumedPlannedTuple] = []
    var monthPoints: [ActivityConsumedPlannedTuple] = []
    var threeMonthPoints: [ActivityConsumedPlannedTuple] = []
    var sixMonthPoints: [ActivityConsumedPlannedTuple] = []
    var oneYearPoints: [ActivityConsumedPlannedTuple] = []
    
    var loadMoreBtntapped = LoadMoreBtnTapped.no
    var switchBtnTapped : SwitchBtnTapped = SwitchBtnTapped.graphBtnTapped
    var activityList = ["Running", "Walking","Swimming"]
    var sevenDayActivityPlan = [SevenDaysAvgData]()
    var selectedDateData = [JSON]()
    var selectedDate = Date()
    var dayWiseDataDic = [String : Any]()
    var graphDataDic = [String : Any]()
    var activityDataInTabular = [ActivityDataInTabular]()
    var tabularDataCount : Int?
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var activityListingTableView: UITableView!
    @IBOutlet weak var activityPlanBtn: UIButton!
    
    @IBOutlet weak var testNameSelectionView: UIView!
    @IBOutlet weak var testNameTextField: UITextField!
    @IBOutlet weak var addActivityBtnOutlt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        getGraphData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        
        self.getSevenDayActivityData()
        self.getActivityByDate()
        self.activityDataInTabularForm()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Activity", 2, 3)
        self.navigationControllerOn = .dashboard
        self.activityPlanBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    func getGraphData() {
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        let parameters: JSONDictionary = ["curr_date": CommonClass.dateFormatter.string(from: Date())]
        
        WebServices.getActivityGraphData(parameters: parameters, success: { [weak self] graphDataArray in
            self?.apiGraphDataArray = self?.sortGraphData(graphDataArray) ?? []
            DispatchQueue.global().async {
                self?.generateGraphData()
            }
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
            CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
            let dateText = CommonClass.dateFormatter.string(from: startDate)
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
        getPointsForWeek()
        getPointsForMonth()
        getPointsFor3Months()
        getPointsFor6Months()
        getPointsForYear()
        getPointsForAll()
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
        
        mainQueue {
            cell = self.activityListingTableView.cellForRow(at: indexPath) as? GraphCell
            activityDate = self.apiGraphDataArray.first?.activityDate
        }
        
        if cell == nil || activityDate == nil {
            return
        }
        
        let weekStartingDate = todaysDate.adding(.day, value: -7)
        let previousMonthDate = todaysDate.adding(.month, value: -1)
        let threeMonthFirstDate = todaysDate.adding(.month, value: -3).startOfMonth
        let sixMonthFirstDate = todaysDate.adding(.month, value: -6).startOfMonth
        let previousYearDate = todaysDate.adding(.year, value: -1).startOfMonth
        
        if activityDate.startOfDay > weekStartingDate.startOfDay {
            self.lastPlotType = .week
            cell.updateActivityGraph(with: weekPoints, plotType: .week, dataType: dataType)
        } else if activityDate.startOfDay > previousMonthDate.startOfDay {
            self.lastPlotType = .month
            cell.updateActivityGraph(with: monthPoints, plotType: .month, dataType: dataType)
        } else if activityDate.startOfDay > threeMonthFirstDate.startOfDay {
            self.lastPlotType = .threeMonths
            cell.updateActivityGraph(with: threeMonthPoints, plotType: .threeMonths, dataType: dataType)
        } else if activityDate.startOfDay > sixMonthFirstDate.startOfDay {
            self.lastPlotType = .sixMonths
            cell.updateActivityGraph(with: sixMonthPoints, plotType: .sixMonths, dataType: dataType)
        } else if activityDate.startOfDay > previousYearDate.startOfDay {
            self.lastPlotType = .year
            cell.updateActivityGraph(with: oneYearPoints, plotType: .year, dataType: dataType)
        } else {
            
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
        let firstPointData = Array(formattedGraphDataArray[firstPointIndex..<secondPointIndex])
        
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
        
        //printlnDebug("plotType: \(type), firstDate: \(firstDate), lastDate: \(lastDate)")
        
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
        
        if section == 0{
            
            return 1
            
        }else{
            
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.section{
            
        case 0 :
            
            guard let activityProgressCell = tableView.dequeueReusableCell(withIdentifier: "activityProgressCellID") as? ActivityProgressCell else{
            
            fatalError("Activity Progress Cell Not Found!")
        }
        
        activityProgressCell.populateData(self.selectedDate)
        
        activityProgressCell.previousDateBtn.addTarget(self, action: #selector(self.leftArrowTapped(_:)), for: UIControlEvents.touchUpInside)
        activityProgressCell.nextDateBtn.addTarget(self, action: #selector(self.rightArrowTapped(_:)), for: UIControlEvents.touchUpInside)
        activityProgressCell.calenderBtn.addTarget(self, action: #selector(self.calenderBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        if !self.selectedDateData.isEmpty{
            
            activityProgressCell.populateData(self.selectedDateData)
        }
        
        return activityProgressCell
            
        case 1: switch indexPath.row {
            
        case 0:
            
            guard let activityDataCollectionCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID") as? MeasurementListCollectionCell else{
                
                fatalError("activitySelectionCell Not Found!")
            }
            
            activityDataCollectionCell.measurementListCollectionView.dataSource = self
            activityDataCollectionCell.measurementListCollectionView.delegate = self
//            activityDataCollectionCell.measurementMentCollectionViewLeadingConstraint.constant = 2
//            activityDataCollectionCell.measurementMentCollectionViewTrailingConstraint.constant = 2
            
            if !self.sevenDayActivityPlan.isEmpty {
                
                activityDataCollectionCell.measurementListCollectionView.reloadData()
            }
            
            return activityDataCollectionCell
            
        case 1: guard let switchGraphCell = tableView.dequeueReusableCell(withIdentifier: "switchGraphCellID") as? SwitchGraphCell else{
            
            fatalError("switchGraphCell Not Found!")
        }
        switchGraphCell.vitalBtnTapped = .hb
        switchGraphCell.graphBtnOulet.addTarget(self, action: #selector(self.graphBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        switchGraphCell.tabelBtnOutlet.addTarget(self, action: #selector(self.listBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        switchGraphCell.hbButtonOutlet.addTarget(self, action: #selector(self.durationButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        switchGraphCell.hbButtonOutlet.setTitle("DURATION", for: UIControlState.normal)
        switchGraphCell.tlcBtnOutlet.setTitle("DISTANCE", for: UIControlState.normal)
        switchGraphCell.platletBtnOutlet.setTitle("CALORIES", for: UIControlState.normal)
        
        
        switchGraphCell.tlcBtnOutlet.addTarget(self, action: #selector(self.distanceButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        switchGraphCell.platletBtnOutlet.addTarget(self, action: #selector(self.caloriesButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
            
            switchGraphCell.hbButtonOutlet.isHidden = false
            switchGraphCell.tlcBtnOutlet.isHidden = false
            switchGraphCell.platletBtnOutlet.isHidden = false
            switchGraphCell.hbBottomView.isHidden = false
            switchGraphCell.tlcBottomView.isHidden = false
            switchGraphCell.platletBottomView.isHidden = false
            switchGraphCell.hbVerticalSepratorView.isHidden = false
            switchGraphCell.tlcVerticalSepratorView.isHidden = false
            
            switchGraphCell.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedgraph"), for: UIControlState.normal)
            switchGraphCell.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedtable"), for: UIControlState.normal)
            
        }else{
            
            switchGraphCell.hbButtonOutlet.isHidden = true
            switchGraphCell.tlcBtnOutlet.isHidden = true
            switchGraphCell.platletBtnOutlet.isHidden = true
            switchGraphCell.hbBottomView.isHidden = true
            switchGraphCell.tlcBottomView.isHidden = true
            switchGraphCell.platletBottomView.isHidden = true
            switchGraphCell.hbVerticalSepratorView.isHidden = true
            switchGraphCell.tlcVerticalSepratorView.isHidden = true
            
            switchGraphCell.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedgraph"), for: UIControlState.normal)
            switchGraphCell.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedtable"), for: UIControlState.normal)
            
        }
        
        return switchGraphCell
            
        case 2:  if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
            
            guard let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCellID") as? GraphCell else{
                
                fatalError("GraphCell Not Found!")
            }
            
            graphCell.updateActivityGraph(with: getPoints(for: lastPlotType), plotType: lastPlotType, dataType: dataType)
            return graphCell
            
        }else{
            
            guard let tableDataCell = tableView.dequeueReusableCell(withIdentifier: "vitalDataInTableCellID") as? VitalDataInTableCell else{
                
                fatalError("GraphCell Not Found!")
            }
            
            tableDataCell.tableCellFor = .activity
            
            if !self.activityDataInTabular.isEmpty{
                
                tableDataCell.activityDataInTabular = self.activityDataInTabular
                
                tableDataCell.vitalDataView.reloadData()
                
            }
            
            return tableDataCell
            }
            
            
        case 3: guard let graphFilterCell = tableView.dequeueReusableCell(withIdentifier: "graphFilterCellID") as? GraphFilterCell else{
            
            fatalError("graphFilterCell Not Found!")
        }
        
        graphFilterCell.oneWeekBtn.addTarget(self, action: #selector(self.oneWeekBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.oneMonthBtn.addTarget(self, action: #selector(self.oneMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.threeMonthBtn.addTarget(self, action: #selector(self.threeMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.sixMonthBtn.addTarget(self, action: #selector(self.sixMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.oneYearBtn.addTarget(self, action: #selector(self.oneYearBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.allBtn.addTarget(self, action: #selector(self.AllBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.loadMoreBtnOutlt.addTarget(self, action: #selector(self.loadMoreBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        if let count = self.tabularDataCount{
            
            if count < 1{
                
                graphFilterCell.loadMoreBtnOutlt.isHidden = true
            }else{
                
                graphFilterCell.loadMoreBtnOutlt.isHidden = false
            }
        }else{
            
            graphFilterCell.loadMoreBtnOutlt.isHidden = false
        }
        
        return graphFilterCell
            
        default : fatalError("Cell not Found!")
            
            }
            
        default : fatalError("Section Not Found!")
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension ActivityVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section{
            
        case 0:
            
            switch indexPath.row{
                
            case 0 : if DeviceType.IS_IPHONE_5 {
                
                return CGFloat(190)
            }else{
                
                return CGFloat(220)
                }
                
            default : return CGFloat.leastNormalMagnitude
                
            }
            
        case 1: switch indexPath.row{
            
        case 0: return CGFloat(130)
            
        case 1: return(40.5)
            
        case 2: return (225)
            
        case 3: return CGFloat(83)
            
        default : return CGFloat.leastNormalMagnitude
            
            }
            
        default : return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        switch section{
            
        case 0 : return 0
            
        case 1 : return CGFloat(34.5)
            
        default : return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "activityPlanDateCellID") as? ActivityPlanDateCell else {
            
            fatalError("HeaderView Not Found!")
        }
        
        headerView.activityDateLabel.isHidden = true
        headerView.activityStatusLabel.text = "LAST 7 DAYS"
        
        return headerView
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension ActivityVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if !self.sevenDayActivityPlan.isEmpty {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityPlanCollectionCellID", for: indexPath) as? ActivityPlanCollectionCell else{
                
                fatalError("ActivityPlanCollectionCell Not Found!")
            }
            
            if indexPath.item == 0 {
                
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanClock")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].activityDuration
                
                cell.activityValueLabel.textColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
                cell.activityUnitLabel.text = "mins"
                cell.averageLabel.text = "avg"
                
            }else if indexPath.item == 1{
                
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanDistance")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].totalDistance
                
                cell.activityValueLabel.textColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
                cell.activityUnitLabel.text = "kms"
                cell.averageLabel.text = "avg"
            }else{
                
                cell.cellImageView.image = #imageLiteral(resourceName: "icActivityplanCal")
                cell.activityValueLabel.text = self.sevenDayActivityPlan[0].caloriesBurn
                
                cell.activityValueLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.05098039216, alpha: 1)
                cell.activityUnitLabel.text = "cal"
                cell.averageLabel.text = "avg"
            }
            
            return cell
            
        }else{
    
            guard let noSevenDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "noUpcomingAppointmentCellID", for: indexPath) as? NoUpcomingAppointmentCell else{
    
                fatalError("noUpcomingAppointmentCell Not Found!")
            }
    
//            noSevenDataCell.noDataAvailiableLabel.text = "No Record Found !"
    
            return noSevenDataCell
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//==================================================
extension ActivityVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 3), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(2)
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension ActivityVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        guard let index = textField.tableViewIndexPathIn(self.activityListingTableView) else{
        //
        //            return
        //        }
        //
        //        guard let cell = self.activityListingTableView.cellForRow(at: index) as? TestNameSelectionCell else{
        //
        //            return
        //        }
        
        MultiPicker.noOfComponent =  1
        
        if textField === self.testNameTextField{
            
            MultiPicker.openPickerIn(self.testNameTextField, firstComponentArray: self.activityList, secondComponentArray: [], firstComponent: self.testNameTextField.text, secondComponent: nil, titles: ["Activity"]) { (value, _, index, _) in
                
                self.testNameTextField.text = value
                
            }
        }
    }
}

//MARK:- Methods
//==============
extension ActivityVC {
    
    fileprivate func setupUI(){
        
        self.testNameTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.testNameTextField.rightViewMode = UITextFieldViewMode.always
        self.testNameTextField.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        
        self.testNameTextField.delegate = self
        
        self.addActivityBtnOutlt.addTarget(self, action: #selector(self.addActivityBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.floatBtn.isHidden = false
        
        self.view.backgroundColor = UIColor.activityVCBackgroundColor
        self.activityPlanBtn.setTitle("Activity Plan", for: UIControlState.normal)
        self.activityPlanBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.activityPlanBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.activityListingTableView.dataSource = self
        self.activityListingTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let selectionActivityNib = UINib(nibName: "TestNameSelectionCell", bundle: nil)
        let calenderCellNib = UINib(nibName: "CalenderCell", bundle: nil)
        let activityProgressCellNib = UINib(nibName: "ActivityProgressCell", bundle: nil)
        let activityCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let switchGraphCellNib = UINib(nibName: "SwitchGraphCell", bundle: nil)
        let graphCellNib = UINib(nibName: "GraphCell", bundle: nil)
        let graphFilterCellNib = UINib(nibName: "GraphFilterCell", bundle: nil)
        let activityDataInTableViewNib = UINib(nibName: "VitalDataInTableCell", bundle: nil)
        let activityplanDateNib = UINib(nibName: "ActivityPlanDateCell", bundle: nil)
        
        
        self.activityListingTableView.register(selectionActivityNib, forCellReuseIdentifier: "testNameSelectionCellID")
        self.activityListingTableView.register(calenderCellNib, forCellReuseIdentifier: "calenderCellID")
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
    //    MARK: Add Activity Button Tapped
    //    ================================
    @objc fileprivate func addActivityBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        
        let addActivityScene = AddActivityVC.instantiate(fromAppStoryboard: .Activity)
        self.navigationController?.pushViewController(addActivityScene, animated: true)
        
    }
    
    //    MARK: ListBtnTapped To view the vlaues in List
    //    ==============================================
    @objc fileprivate func listBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        
        self.switchBtnTapped = SwitchBtnTapped.listBtnTapped
        
        self.activityListingTableView.reloadData()
    }
    
    //    MARK: Graph Button Tapped to view the values in graph
    //    =====================================================
    @objc fileprivate func graphBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        
        self.switchBtnTapped = SwitchBtnTapped.graphBtnTapped
        
        self.activityListingTableView.reloadData()
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
        
        cell.vitalBtnTapped = .hb
        
        //        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[0].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            cell.updateActivityGraph(with: getPoints(for: lastPlotType), plotType: lastPlotType, dataType: dataType)
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
        
        cell.vitalBtnTapped = .tlc
        
        //        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[1].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            cell.updateActivityGraph(with: getPoints(for: lastPlotType), plotType: lastPlotType, dataType: dataType)
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
        
        cell.vitalBtnTapped = .platlet
        
        //        self.graphDataDic["vital_sub_id"] = self.topMostVitalData[2].vitalSubID
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            cell.updateActivityGraph(with: getPoints(for: lastPlotType), plotType: lastPlotType, dataType: dataType)
        }
    }
    
    func getPoints(for plotType: GraphPlotType) -> [ActivityConsumedPlannedTuple] {
        var points: [ActivityConsumedPlannedTuple] = []
        switch lastPlotType {
        case .week:
            points = weekPoints
        case .month:
            points = monthPoints
        case .threeMonths:
            points = threeMonthPoints
        case .sixMonths:
            points = sixMonthPoints
        case .year:
            points = oneYearPoints
        }
        return points
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
        
        cell.buttonState = .oneWeek
        let lastWeekDate = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastWeekDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: weekPoints, plotType: .week, dataType: dataType)
            
        } else {
            
            self.activityDataInTabularForm()
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
        
        cell.buttonState = .oneMonth
        
        let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: monthPoints, plotType: .month, dataType: dataType)
        }else{
            
            self.activityDataInTabularForm()
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
        
        cell.buttonState = .threeMonth
        
        
        let lastThirdMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -3, to: Date())
        
        self.graphDataDic["start_date"] = lastThirdMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: threeMonthPoints, plotType: .threeMonths, dataType: dataType)
        }else{
            
            self.activityDataInTabularForm()
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
        
        cell.buttonState = .sixMonth
        
        let lastSixthMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -6, to: Date())
        
        self.graphDataDic["start_date"] = lastSixthMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: sixMonthPoints, plotType: .sixMonths, dataType: dataType)
        }else{
            
            self.activityDataInTabularForm()
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
        
        cell.buttonState = .oneYear
        
        let lastYearDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastYearDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = activityListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateActivityGraph(with: oneYearPoints, plotType: .year, dataType: dataType)
        }else{
            
            self.activityDataInTabularForm()
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
        
        cell.buttonState = .All
        
        self.graphDataDic["start_date"] = ""
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            getPointsForAll()
        }else{
            
            self.activityDataInTabularForm()
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
        
        self.addChildViewController(dateScene)
        self.view.addSubview(dateScene.view)
        
    }
    
    @objc fileprivate func loadMoreBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .yes
        if self.tabularDataCount! > 0{
            
            if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
                
                
            }else{
                
                self.graphDataDic["next_count"] = self.tabularDataCount
                
                self.activityDataInTabularForm()
                
            }
        }
    }
}

//MARK:- Webservices
//===================
extension ActivityVC {
    
    fileprivate func getSevenDayActivityData(){
        
        let p = [String : Any]()
        
        WebServices.sevenDaysActivityAvg(parameters: p, success: { (_ sevenDayActivityData :[SevenDaysAvgData]) in
            
            if !sevenDayActivityData.isEmpty {
                
                self.sevenDayActivityPlan = sevenDayActivityData
                
            }else{
                
                
                
            }
            
            self.activityListingTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
            
        }
    }
    
    fileprivate func getActivityByDate(){
        
        self.dayWiseDataDic["curr_date"] = self.selectedDate.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        WebServices.getActivityBySelectedDate(parameters: self.dayWiseDataDic, success: { (_ dayWiseData : [JSON]) in
            
            if !dayWiseData.isEmpty {
                
                self.selectedDateData = dayWiseData
            }
            
            self.activityListingTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func activityDataInTabularForm(){
        
        self.graphDataDic["end_date"] = Date().stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        printlnDebug("graphDataDic\(graphDataDic)")
        
        WebServices.getActivityInTabularForm(parameters: self.graphDataDic, success: { (_ activityDataInTabular : [ActivityDataInTabular], _ count : Int) in
            
            if !activityDataInTabular.isEmpty {
                
                if self.loadMoreBtntapped == .yes{
                    
                    self.activityDataInTabular.append(contentsOf: activityDataInTabular)
                    
                }else{
                    
                    self.activityDataInTabular = activityDataInTabular
                    
                }
            }
            
            self.tabularDataCount = count
            
            self.activityListingTableView.reloadData()
            
        }) { (error) in
            
            //            showToastMessage(error.localizedDescription)
            
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
