//
//  NutritionVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class NutritionVC: BaseViewController {
    
    //    MARK:- Proporties
    //    =================
    enum SwitchBtnTapped {
        
        case graphBtnTapped, listBtnTapped
    }
    enum LoadMoreBtnTapped {
        
        case yes, no
    }
    
    var switchBtnTapped = SwitchBtnTapped.graphBtnTapped
    var loadMoreBtntapped = LoadMoreBtnTapped.no
    var nutrientsType = ["CALORIES","CARBS","FATS","PROTIEN","WATER"]
    var nutrientDuration = ["ALL","BREAKFAST","LUNCH","DINNER","SNACKS"]
    var graphDataDic = [String : Any]()
    var selectedDate = Date()
    var dayWiseDataDic = [String : Any]()
    var daywiseNutritionData : [DayWiseNutrition] = []
    var graphView : [GraphView] = []
    var nutrientList : [NutritionGraphData] = []
    var selectedNutrientIndex : Int = 0
    var selectGraphNutrientIndex : Int = 0
    var nextCount = 0
    
    var apiGraphDataArray: [NutritionChartData] = []
    var formattedGraphDataArray: [NutritionChartData] = []
    let todaysDate = Date().startOfDay
    var dataType: NutritionDataType = .calories
    var lastPlotType: GraphPlotType = .week
    
    var weekPoints: [NutritionConsumedPlannedTuple] = []
    var monthPoints: [NutritionConsumedPlannedTuple] = []
    var threeMonthPoints: [NutritionConsumedPlannedTuple] = []
    var sixMonthPoints: [NutritionConsumedPlannedTuple] = []
    var oneYearPoints: [NutritionConsumedPlannedTuple] = []
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var viewContainTextFieldAndBtn: UIView!
    @IBOutlet weak var viewContainTextField: UIView!
    @IBOutlet weak var activitySelectionTextField: UITextField!
    @IBOutlet weak var addNutritionBtnOutlt: UIButton!
    @IBOutlet weak var nutitionListingTableView: UITableView!
    @IBOutlet weak var weekPerformanceBtnOult: UIButton!
    @IBOutlet weak var nutritionPlanBtnOutlt: UIButton!
    @IBOutlet weak var btnSepratorView: UIView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    //    Mark:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        getGraphData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationControllerOn = .dashboard
        self.sideMenuBtnActn = .sideMenuBtn
        
        self.getDayWiseData()
        self.getNutrientsDataInTable()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Nutrition", 2, 3)
        self.buttonBackgroundView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
    
    func getGraphData() {
        CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        let parameters: JSONDictionary = ["curr_date": CommonClass.dateFormatter.string(from: Date())]
        
        WebServices.getNutritionGraphData(parameters: parameters, success: { [weak self] graphDataArray in
            self?.apiGraphDataArray = self?.sortGraphData(graphDataArray) ?? []
            DispatchQueue.global().async {
                self?.generateGraphData()
            }
            }, failure: { error in
                showToastMessage(error.localizedDescription)
        })
    }
    
    func generateGraphData() {
        
        var graphDataArray: [NutritionChartData] = []
        var currentUnfilledApiDataIndex = 0
        var startDate = todaysDate.adding(.year, value: -1)
        let calendar = Calendar.current
        
        while startDate <= todaysDate {
            CommonClass.dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
            let dateText = CommonClass.dateFormatter.string(from: startDate)
            let isApiDataPresent = currentUnfilledApiDataIndex < apiGraphDataArray.count
            
            if isApiDataPresent {
                
                let apiGraphDataDate = apiGraphDataArray[currentUnfilledApiDataIndex].nutritionDate
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
    
    func getBlankGraphData(with dateText: String) -> NutritionChartData? {
        
        //        let dict: JSONDictionary = ["plan_duration": Int.random(20, 60),
        //                                    "plan_calories": Int.random(200, 600),
        //                                    "plan_distance": Int.random(4, 8),
        //                                    "consume_duration": Int.random(20, 60),
        //                                    "consume_calories": Int.random(200, 600),
        //                                    "consume_distance": Int.random(4, 8),
        //                                    "nutrition_data": dateText
        //        ]
        
        let dict: JSONDictionary = ["plan_duration": 0,
                                    "plan_calories": 0,
                                    "plan_distance": 0,
                                    "consume_duration": 0,
                                    "consume_calories": 0,
                                    "consume_distance": 0,
                                    "nutrition_data": dateText
        ]
        
        return NutritionChartData(json: JSON(dict))
    }
    
    func sortGraphData(_ data: [NutritionChartData]) -> [NutritionChartData] {
        return data.sorted(by: {
            return $0.nutritionDate.compare($1.nutritionDate) == .orderedAscending
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
        let indexPath = IndexPath(row: 4, section: 0)
        var cell: GraphCell!
        var nutritionDate: Date!
        
        mainQueue {
            cell = self.nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell
            nutritionDate = self.apiGraphDataArray.first?.nutritionDate
        }
        
        if cell == nil || nutritionDate == nil {
            return
        }
        
        let weekStartingDate = todaysDate.adding(.day, value: -7)
        let previousMonthDate = todaysDate.adding(.month, value: -1)
        let threeMonthFirstDate = todaysDate.adding(.month, value: -3).startOfMonth
        let sixMonthFirstDate = todaysDate.adding(.month, value: -6).startOfMonth
        let previousYearDate = todaysDate.adding(.year, value: -1).startOfMonth
        
        if nutritionDate.startOfDay > weekStartingDate.startOfDay {
            cell.updateNutritionGraph(with: weekPoints, plotType: .week, dataType: dataType)
        } else if nutritionDate.startOfDay > previousMonthDate.startOfDay {
            cell.updateNutritionGraph(with: monthPoints, plotType: .month, dataType: dataType)
        } else if nutritionDate.startOfDay > threeMonthFirstDate.startOfDay {
            cell.updateNutritionGraph(with: threeMonthPoints, plotType: .threeMonths, dataType: dataType)
        } else if nutritionDate.startOfDay > sixMonthFirstDate.startOfDay {
            cell.updateNutritionGraph(with: sixMonthPoints, plotType: .sixMonths, dataType: dataType)
        } else if nutritionDate.startOfDay > previousYearDate.startOfDay {
            cell.updateNutritionGraph(with: oneYearPoints, plotType: .year, dataType: dataType)
        } else {
            
        }
    }
    
    func getGraphDataArray(with counts: [Int], plotType: GraphPlotType) -> [NutritionConsumedPlannedTuple] {
        
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
    
    func getPoints(_ dataArray: [[NutritionChartData]], plotType: GraphPlotType) -> [NutritionConsumedPlannedTuple] {
        var points = [NutritionConsumedPlannedTuple]()
        for data in dataArray {
            points.append(getPoint(data, plotType: plotType))
        }
        return points
    }
    
    func getPoint(_ data: [NutritionChartData], plotType: GraphPlotType) -> NutritionConsumedPlannedTuple {
        var consumedCalorieY = 0
        var consumedFatsY = 0
        var consumedCarbsY = 0
        var consumedWaterY = 0
        var consumedProteinsY = 0
        
        var plannedCalorieY = 0
        var plannedFatsY = 0
        var plannedCarbsY = 0
        var plannedWaterY = 0
        var plannedProteinsY = 0
        
        guard let firstDate = data.first?.nutritionDate, let lastDate = data.last?.nutritionDate else {
            fatalError("Date must exist")
        }
        
        let firstDateTimeInterval = firstDate.timeIntervalSince1970
        let lastDateTimeInterval = lastDate.timeIntervalSince1970
        let averageTimeInterval = (firstDateTimeInterval + lastDateTimeInterval) / 2
        
        //printlnDebug("plotType: \(type), firstDate: \(firstDate), lastDate: \(lastDate)")
        
        for graphData in data {
            plannedCalorieY += graphData.planCalories
            consumedCalorieY += graphData.consumeCalories
            plannedFatsY += graphData.planFats
            consumedFatsY += graphData.consumeFats
            plannedCarbsY += graphData.planCarbs
            consumedCarbsY += graphData.consumeCarbs
            plannedProteinsY += graphData.planProteins
            consumedProteinsY += graphData.consumeProteins
            plannedWaterY += graphData.planWater
            consumedWaterY += graphData.consumeWater
        }
        
        let dataCount = data.count
        let consumedAverageCalories = Double(consumedCalorieY/dataCount)
        let consumedAverageProteins = Double(consumedProteinsY/dataCount)
        let consumedAverageWater = Double(consumedWaterY/dataCount)
        let consumedAverageFats = Double(consumedFatsY/dataCount)
        let consumedAverageCarbs = Double(consumedCarbsY/dataCount)
        
        let plannedAverageCalories = Double(plannedCalorieY/dataCount)
        let plannedAverageProteins = Double(plannedProteinsY/dataCount)
        let plannedAverageWater = Double(plannedWaterY/dataCount)
        let plannedAverageFats = Double(plannedFatsY/dataCount)
        let plannedAverageCarbs = Double(plannedCarbsY/dataCount)
        
        let consumed = (averageTimeInterval: averageTimeInterval, averageCalories: consumedAverageCalories, averageFats: consumedAverageFats, averageCarbs: consumedAverageCarbs, averageProteins: consumedAverageProteins, averageWater: consumedAverageWater)
        let planned = (averageTimeInterval: averageTimeInterval, averageCalories: plannedAverageCalories, averageFats: plannedAverageFats, averageCarbs: plannedAverageCarbs, averageProteins: plannedAverageProteins, averageWater: plannedAverageWater)
        
        return (consumed: consumed,
                planned: planned)
    }
    
    //    MARK:- IBButton Actions
    //    =======================
    @IBAction func weekPerformanceBtnTapped(_ sender: UIButton) {
        
        let weekPerformanceScene = WeekPerformanceVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(weekPerformanceScene, animated: true)
    }
    
    @IBAction func nutritionPlanBtnTapped(_ sender: UIButton) {
        
        let nutritionPlanScene = NutritionPlanVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(nutritionPlanScene, animated: true)
    }
    @IBAction func addnutritionBtnTapped(_ sender: UIButton) {
        
        let addNutritionScene = AddNutritionVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(addNutritionScene, animated: true)
        
    }
}

//MARK:- UITableViewDataSource Methods
//====================================
extension NutritionVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row{
            
        case 0 : guard let nutritionTargetConsumedCell = tableView.dequeueReusableCell(withIdentifier: "nutritionTargetConsumedCellID", for: indexPath) as? NutritionTargetConsumedCell else {
            
            fatalError("Nutritions Target Consumed Cell Not Found!")
        }
        
        nutritionTargetConsumedCell.populateData(self.selectedDate)
        nutritionTargetConsumedCell.previousDateBtn.addTarget(self, action: #selector(self.leftArrowTapped(_:)), for: UIControlEvents.touchUpInside)
        nutritionTargetConsumedCell.nextDateBtn.addTarget(self, action: #selector(self.rightArrowTapped(_:)), for: UIControlEvents.touchUpInside)
        nutritionTargetConsumedCell.calenderBtn.addTarget(self, action: #selector(self.calenderBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        nutritionTargetConsumedCell.nutrientsValues = self.nutrientsType
        
        if !daywiseNutritionData.isEmpty {
            
            nutritionTargetConsumedCell.dayWiseNutritionData = self.daywiseNutritionData
            nutritionTargetConsumedCell.nutrientsTableView.reloadData()
            
        }
        
        return nutritionTargetConsumedCell
            
        case 1 : guard let nutrientImageCell = tableView.dequeueReusableCell(withIdentifier: "nutrientImageCellID", for: indexPath) as? NutrientImageCell else {
            
            fatalError("Nutrient Image Cell Not Found!")
        }
        
        nutrientImageCell.imageCollectionView.dataSource = self
        nutrientImageCell.imageCollectionView.delegate = self
        nutrientImageCell.imageCollectionView.outerIndexPath = indexPath
        nutrientImageCell.imageCollectionView.collectionViewUseFor = .image
        nutrientImageCell.nutrientCollectionView.dataSource = self
        nutrientImageCell.nutrientCollectionView.delegate = self
        nutrientImageCell.nutrientCollectionView.collectionViewUseFor = .nutrients
        nutrientImageCell.nutrientCollectionView.outerIndexPath = indexPath
        nutrientImageCell.leftArrowBtn.addTarget(self, action: #selector(self.imageLeftArrowBtnTapped(_:)), for: .touchUpInside)
        nutrientImageCell.rightArrowBtn.addTarget(self, action: #selector(self.imageRightArrowBtnTapped(_:)), for: .touchUpInside)
        
        if self.selectedNutrientIndex == 0{
            
            nutrientImageCell.hideLeftButton()
            
        }else if self.selectedNutrientIndex == self.nutrientsType.count - 1{
            
            nutrientImageCell.hideRightButton()
        }else{
            
            nutrientImageCell.dontHideButton()
        }
        
        if !self.graphView.isEmpty {
            
            nutrientImageCell.imageCollectionView.reloadData()
            
        }
        
        return nutrientImageCell
            
        case 2 : guard let nutritionsSelectionWithGraphCell = tableView.dequeueReusableCell(withIdentifier: "nutritionsSelectionCellID", for: indexPath) as? NutritionsSelectionCell else {
            
            fatalError("Nutritions Selection With graph Cell Not Found!")
        }
        
        nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.outerIndexPath = indexPath
        nutritionsSelectionWithGraphCell.viewContainObjectLeadingConstraint.constant = 0
        nutritionsSelectionWithGraphCell.viewContainObjectTrailingConstraint.constant = 0
        nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.dataSource = self
        nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.delegate = self
        
        nutritionsSelectionWithGraphCell.graphBtnOutlt.addTarget(self, action: #selector(self.graphBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        nutritionsSelectionWithGraphCell.tableBtnOutlt.addTarget(self, action: #selector(self.listBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped {
            
            nutritionsSelectionWithGraphCell.graphBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementSelectedgraph"), for: UIControlState.normal)
            nutritionsSelectionWithGraphCell.tableBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedtable"), for: UIControlState.normal)
            nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.isHidden = false
            
        }else{
            
            nutritionsSelectionWithGraphCell.graphBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedgraph"), for: UIControlState.normal)
            nutritionsSelectionWithGraphCell.tableBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementSelectedtable"), for: UIControlState.normal)
            nutritionsSelectionWithGraphCell.nutrientsSelectionCollectionView.isHidden = true
        }

        return nutritionsSelectionWithGraphCell
            
        case 3 : guard let nutritionsDurationCell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID", for: indexPath) as? MeasurementListCollectionCell else {
            
            fatalError("Nutritions Duration Cell Not Found!")
        }
        
        nutritionsDurationCell.outerViewTrailingConstraint.constant = 0
        nutritionsDurationCell.outerViewLeadingConstraint.constant = 0
        nutritionsDurationCell.outerViewTopConstraint.constant = 0
        nutritionsDurationCell.outerViewBottomConstraint.constant = 0
                
        nutritionsDurationCell.measurementListCollectionView.outerIndexPath = indexPath
        nutritionsDurationCell.measurementListCollectionView.dataSource = self
        nutritionsDurationCell.measurementListCollectionView.delegate = self
        
        return nutritionsDurationCell
            
        case 4 : if self.switchBtnTapped == .graphBtnTapped {
            
            guard let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCellID", for: indexPath) as? GraphCell else {
                
                fatalError("Graph Cell Not Found!")
            }
            
            graphCell.updateNutritionGraph(with: weekPoints, plotType: lastPlotType, dataType: dataType)
            return graphCell
            
        }else{
            
            guard let nutrientsDataInTableCell = tableView.dequeueReusableCell(withIdentifier: "vitalDataInTableCellID", for: indexPath) as? VitalDataInTableCell else {
                
                fatalError("Graph Cell Not Found!")
            }
            
            nutrientsDataInTableCell.tableCellFor = .nutrition
            
            if !self.nutrientList.isEmpty{
                
                nutrientsDataInTableCell.nutrientsListData = self.nutrientList
                nutrientsDataInTableCell.vitalDataView.reloadData()
            }
            
            return nutrientsDataInTableCell
            }
            
        case 5 : guard let graphFilterCell = tableView.dequeueReusableCell(withIdentifier: "graphFilterCellID", for: indexPath) as? GraphFilterCell else {
            
            fatalError("Nutritions Selection Cell Not Found!")
        }
        
        graphFilterCell.oneWeekBtn.addTarget(self, action: #selector(self.oneWeekBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.oneMonthBtn.addTarget(self, action: #selector(self.oneMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.threeMonthBtn.addTarget(self, action: #selector(self.threeMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.sixMonthBtn.addTarget(self, action: #selector(self.sixMonthBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.oneYearBtn.addTarget(self, action: #selector(self.oneYearBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.allBtn.addTarget(self, action: #selector(self.AllBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        graphFilterCell.loadMoreBtnOutlt.addTarget(self, action: #selector(self.loadMoreBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        if self.nextCount == 0{
            
            graphFilterCell.loadMoreBtnOutlt.isHidden = true
        }else{
            
            graphFilterCell.loadMoreBtnOutlt.isHidden = false
        }
        
        return graphFilterCell
            
        default : fatalError("Cell Not Found!")
            
        }
    }
}

//extension NutritionVC : UITableViewDelegate Methods
//===================================================
extension NutritionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.row{
            
        case 0 : return CGFloat(self.nutrientsType.count * 40) + 91.5
            
        case 1 : return 288
            
        case 2 : return 38.5
            
        case 3 : if self.switchBtnTapped == .graphBtnTapped {
            
            return 44
            
        }else{
            
            return 0
            }
            
        case 4 : return 230
            
        case 5 : return 81
            
        default : return CGFloat.leastNonzeroMagnitude
            
        }
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension NutritionVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return self.nutrientsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        
        switch outerIndexPath.row{
            
        case 1:
            
            if  indexedCollectionView.collectionViewUseFor == .nutrients{
                
                guard let nutrientsTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "nutrientsTypeCellID", for: indexPath) as? NutrientsTypeCell else{
                    
                    fatalError("NutrientsTypeCell Not Found!")
                    
                }
                
                nutrientsTypeCell.cellTitleLabel.text = self.nutrientsType[indexPath.item]
                
                nutrientsTypeCell.populateData(indexPath, self.selectedNutrientIndex, self.nutrientsType)
                
                return nutrientsTypeCell
            }else{
                
                if indexPath.item == self.nutrientsType.count - 1{
                    
                    guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCellID", for: indexPath) as? ImageCollectionViewCell else{
                        
                        fatalError("NutrientsTypeCell Not Found!")
                        
                    }
                    
                    if !self.graphView.isEmpty {
                        
                        imageCollectionViewCell.populateData(self.graphView)
                    }
                    
                    return imageCollectionViewCell
                    
                }else{
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PieChartCollectionCell", for: indexPath) as? PieChartCollectionCell else {
                        fatalError()
                    }
                    if !self.graphView.isEmpty {
                        
                        cell.populateDataOnGraph(self.graphView, indexPath)
                    }
                    
                    return cell
                    
                }
            }
            
        case 2:
            
            guard let nutrientsTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "nutrientsTypeCellID", for: indexPath) as? NutrientsTypeCell else{
                
                fatalError("NutrientsTypeCell Not Found!")
                
            }
            
            if let dataType = NutritionDataType(rawValue: indexPath.item) {
                self.dataType = dataType
            }
            
            let index = IndexPath(row: outerIndexPath.row + 2, column: 0)
            let graphCell = self.nutitionListingTableView.cellForRow(at: index) as? GraphCell
            graphCell?.updateNutritionGraph(with: getPoints(for: lastPlotType), plotType: lastPlotType, dataType: dataType)
            
            nutrientsTypeCell.cellTitleLabel.text = self.nutrientsType[indexPath.item]
            
            nutrientsTypeCell.populateGraphNutrientData(indexPath, self.selectGraphNutrientIndex, self.nutrientsType)
            
            return nutrientsTypeCell
        case 3 :
            
            guard let havingNutritionDurationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "havingNutritionDurationCellID", for: indexPath) as? HavingNutritionDurationCell else{
                
                fatalError("HavingNutritionDurationCell Not Found!")
                
            }
            
            havingNutritionDurationCell.cellButtonOutlt.setTitle(self.nutrientDuration[indexPath.item], for: .normal)
            
            if indexPath.item == 0{
                
                havingNutritionDurationCell.cellButtonOutlt.backgroundColor = UIColor.appColor
                havingNutritionDurationCell.cellButtonOutlt.setTitleColor(UIColor.white, for: .normal)
                
            }else{
                
                havingNutritionDurationCell.cellButtonOutlt.setTitleColor(UIColor.appColor, for: .normal)
            }
            
            return havingNutritionDurationCell
            
        default: fatalError("CollectionCell Not Found!")
        }
    }
}

//extension NutritionVC : ChartViewDelegate {
//
//}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension NutritionVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        
        switch outerIndexPath.row {
            
        case 1 :
            
            if indexedCollectionView.collectionViewUseFor == .nutrients {
                
                self.selectedNutrientIndex = indexPath.item
                
                let index = IndexPath(row: outerIndexPath.row, section: 0)
                
                guard let cell  = self.nutitionListingTableView.cellForRow(at: index) as? NutrientImageCell else{
                    return
                }
                
                if self.selectedNutrientIndex == 0{
                    
                    cell.hideLeftButton()
                    
                }else if self.selectedNutrientIndex == self.nutrientsType.count - 1{
                    
                    cell.hideRightButton()
                }else{
                    
                    cell.dontHideButton()
                }
                
                cell.imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                cell.nutrientCollectionView.reloadData()
                
            }
            
        case 2 : self.selectGraphNutrientIndex = indexPath.item
        
        let index = IndexPath(row: outerIndexPath.row, section: 0)
        
        guard let cell  = self.nutitionListingTableView.cellForRow(at: index) as? NutritionsSelectionCell else{
            return
        }
        
        cell.nutrientsSelectionCollectionView.reloadData()
            
        default : return
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        guard let indexedCollectionView = collectionView as? IndexedCollectionView, let outerIndexPath = indexedCollectionView.outerIndexPath else {
            fatalError("Collection view must be indexed collection view")
        }
        
        switch outerIndexPath.row {
            
        case 1:
            
            if indexedCollectionView.collectionViewUseFor == .nutrients{
                
                let width = self.nutrientsType[indexPath.row].widthWithConstrainedHeight(height: 13.8, font: AppFonts.sanProSemiBold.withSize(13.8))
                
                return CGSize(width: width + 8.0 , height: indexedCollectionView.frame.height)
            }else{
                
                return CGSize(width: indexedCollectionView.frame.width, height: indexedCollectionView.frame.height)
            }
            
        case 2: let width = self.nutrientsType[indexPath.row].widthWithConstrainedHeight(height: 13.8, font: AppFonts.sanProSemiBold.withSize(13.8))
        
        return CGSize(width: width + 8.0 , height: indexedCollectionView.frame.height)
            
        case 3: return CGSize(width: indexedCollectionView.frame.width / CGFloat(self.nutrientDuration.count), height: indexedCollectionView.frame.height)
            
            
        default : return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(0.0)
    }
}

//MARK:- UITextFieldDelegate Methods
//==================================
extension NutritionVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let nutritionSelectionCell = self.nutitionListingTableView.cellForRow(at: indexPath) as? TestNameSelectionCell else{
            
            return
        }
        
        MultiPicker.noOfComponent = 1
        
        MultiPicker.openPickerIn(nutritionSelectionCell.selectTestNameTextField, firstComponentArray: [], secondComponentArray: [], firstComponent: nutritionSelectionCell.selectTestNameTextField.text, secondComponent: "", titles: ["Nutritions"]) { (value, _, indexPath, _) in
            
            nutritionSelectionCell.selectTestNameTextField.text = value
        }
    }
}


//MARK:- Methods
//===============
extension NutritionVC {
    
    fileprivate func setupUI(){
        
        self.viewContainTextFieldAndBtn.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        self.activitySelectionTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icMeasurementDropdown"))
        self.activitySelectionTextField.rightViewMode = UITextFieldViewMode.always
        self.addNutritionBtnOutlt.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: .normal)
        self.addNutritionBtnOutlt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addNutritionBtnOutlt.tintColor = UIColor.appColor
        
        self.floatBtn.isHidden = false
        
        self.nutritionPlanBtnOutlt.setTitle("NUTRITIONS PLAN", for: .normal)
        self.nutritionPlanBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.nutritionPlanBtnOutlt.titleLabel?.font  = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.weekPerformanceBtnOult.setTitle("WEEK PERFORMANCE", for: .normal)
        self.weekPerformanceBtnOult.setTitleColor(UIColor.white, for: .normal)
        self.weekPerformanceBtnOult.titleLabel?.font  = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.btnSepratorView.backgroundColor = UIColor.appColor
        
        self.nutitionListingTableView.dataSource = self
        self.nutitionListingTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let nutritionsValueSelectionCell = UINib(nibName: "TestNameSelectionCell", bundle: nil)
        let calenderCell = UINib(nibName: "CalenderCell", bundle: nil)
        let nutritionTargetConsumedCell = UINib(nibName: "NutritionTargetConsumedCell", bundle: nil)
        let nutritionsSelectionCell = UINib(nibName: "NutritionsSelectionCell", bundle: nil)
        let nutrientImageCell = UINib(nibName: "NutrientImageCell", bundle: nil)
        let nutritionDataCell = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let graphCell = UINib(nibName: "GraphCell", bundle: nil)
        let vitalDataInTableCell = UINib(nibName: "VitalDataInTableCell", bundle: nil)
        let graphFilterCell = UINib(nibName: "GraphFilterCell", bundle: nil)
        
        
        self.nutitionListingTableView.register(nutritionsValueSelectionCell, forCellReuseIdentifier: "testNameSelectionCellID")
        self.nutitionListingTableView.register(calenderCell, forCellReuseIdentifier: "calenderCellID")
        self.nutitionListingTableView.register(nutritionTargetConsumedCell, forCellReuseIdentifier: "nutritionTargetConsumedCellID")
        self.nutitionListingTableView.register(nutritionsSelectionCell, forCellReuseIdentifier: "nutritionsSelectionCellID")
        self.nutitionListingTableView.register(nutrientImageCell, forCellReuseIdentifier: "nutrientImageCellID")
        self.nutitionListingTableView.register(nutritionDataCell, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.nutitionListingTableView.register(graphCell, forCellReuseIdentifier: "graphCellID")
        self.nutitionListingTableView.register(vitalDataInTableCell, forCellReuseIdentifier: "vitalDataInTableCellID")
        self.nutitionListingTableView.register(graphFilterCell, forCellReuseIdentifier: "graphFilterCellID")
        
    }
    
    //    MARK:- Button Targets
    //    =====================
    
    //    MARK: ListBtnTapped To view the vlaues in List
    //    ==============================================
    @objc fileprivate func listBtnTapped(_ sender : UIButton){
        
        self.switchBtnTapped = SwitchBtnTapped.listBtnTapped
        
        self.nutitionListingTableView.reloadData()
    }
    
    //    MARK: Graph Button Tapped to view the values in graph
    //    =====================================================
    @objc fileprivate func graphBtnTapped(_ sender : UIButton){
        
        self.switchBtnTapped = SwitchBtnTapped.graphBtnTapped
        
        self.nutitionListingTableView.reloadData()
    }
    
    func getPoints(for plotType: GraphPlotType) -> [NutritionConsumedPlannedTuple] {
        var points: [NutritionConsumedPlannedTuple] = []
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
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneWeek
        let lastWeekDate = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastWeekDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 4, section: 0)
            guard let cell = nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateNutritionGraph(with: weekPoints, plotType: .week, dataType: dataType)
        }else{
            
            self.getNutrientsDataInTable()
        }
        
    }
    
    @objc fileprivate func oneMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneMonth
        
        let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 4, section: 0)
            guard let cell = nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateNutritionGraph(with: monthPoints, plotType: .month, dataType: dataType)
        }else{
            
            self.getNutrientsDataInTable()
        }
    }
    
    @objc fileprivate func threeMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .threeMonth
        
        
        let lastThirdMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -3, to: Date())
        
        self.graphDataDic["start_date"] = lastThirdMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 4, section: 0)
            guard let cell = nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateNutritionGraph(with: threeMonthPoints, plotType: .threeMonths, dataType: dataType)
        }else{
            
            self.getNutrientsDataInTable()
        }
    }
    
    @objc fileprivate func sixMonthBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .sixMonth
        
        let lastSixthMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -6, to: Date())
        
        self.graphDataDic["start_date"] = lastSixthMonthDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 4, section: 0)
            guard let cell = nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateNutritionGraph(with: sixMonthPoints, plotType: .sixMonths, dataType: dataType)
        }else{
            
            self.getNutrientsDataInTable()
        }
    }
    
    @objc fileprivate func oneYearBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .oneYear
        
        let lastYearDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        
        self.graphDataDic["start_date"] = lastYearDate?.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            let indexPath = IndexPath(row: 4, section: 0)
            guard let cell = nutitionListingTableView.cellForRow(at: indexPath) as? GraphCell else {
                return
            }
            
            cell.updateNutritionGraph(with: oneYearPoints, plotType: .year, dataType: dataType)
        }else{
            
            self.getNutrientsDataInTable()
        }
    }
    
    @objc fileprivate func AllBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.no
        self.graphDataDic["next_count"] = ""
        
        guard let index = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            
            return
        }
        
        guard let cell = self.nutitionListingTableView.cellForRow(at: index) as? GraphFilterCell else{
            
            return
        }
        
        cell.buttonState = .All
        
        self.graphDataDic["start_date"] = ""
        
        if switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            getPointsForAll()
        }else{
            
            self.getNutrientsDataInTable()
        }
    }
    
    @objc fileprivate func loadMoreBtnTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = LoadMoreBtnTapped.yes
        
        if self.switchBtnTapped == SwitchBtnTapped.graphBtnTapped{
            
            
        }else{
            
            if self.nextCount > 0 {
                
                self.graphDataDic["next_count"] = self.nextCount
                
                self.getNutrientsDataInTable()
            }
        }
    }
    
    @objc fileprivate func leftArrowTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate)!
        self.getDayWiseData()
        
    }
    
    @objc fileprivate func rightArrowTapped(_ sender : UIButton){
        
        self.loadMoreBtntapped = .no
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
        self.getDayWiseData()
    }
    
    @objc fileprivate func calenderBtnTapped(_ sender : UIButton){
        self.loadMoreBtntapped = .no
        
        let dateScene = DateVC.instantiate(fromAppStoryboard: .Activity)
        
        dateScene.delegate = self
        dateScene.maxDate = Date()
        
        self.addChildViewController(dateScene)
        self.view.addSubview(dateScene.view)
        
    }
    
    @objc fileprivate func addNutritionBtnTapped(){
        
        let addNutritionScene = AddNutritionVC.instantiate(fromAppStoryboard: .Nutrition)
        self.navigationController?.pushViewController(addNutritionScene, animated: true)
        
    }
    
    @objc fileprivate func imageLeftArrowBtnTapped(_ sender : UIButton) {
        
        guard let indexPath = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            return
        }
        guard let cell = self.nutitionListingTableView.cellForRow(at: indexPath) as? NutrientImageCell else{
            return
        }
        
        let visibleCells = cell.imageCollectionView.visibleCells
        
        guard let index = visibleCells[0].collectionViewIndexPathIn(cell.imageCollectionView) else{
            
            return
        }
        
        if index.item > 0{
            
            self.selectedNutrientIndex = index.item - 1
            let collectionViewIndexPath = IndexPath(item: index.item - 1, section: 0)
            cell.imageCollectionView.scrollToItem(at: collectionViewIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }else{
            
            self.selectedNutrientIndex = 0
        }
        
        if self.selectedNutrientIndex == 0{
            
            cell.hideLeftButton()
            
        }else if self.selectedNutrientIndex == self.nutrientsType.count - 1{
            
            cell.hideRightButton()
        }else{
            
            cell.dontHideButton()
        }
        
        cell.nutrientCollectionView.reloadData()
    }
    
    @objc fileprivate func imageRightArrowBtnTapped(_ sender : UIButton) {
        
        guard let indexPath = sender.tableViewIndexPathIn(self.nutitionListingTableView) else{
            return
        }
        guard let cell = self.nutitionListingTableView.cellForRow(at: indexPath) as? NutrientImageCell else{
            return
        }
        
        let visibleCells = cell.imageCollectionView.visibleCells
        
        guard let index = visibleCells[0].collectionViewIndexPathIn(cell.imageCollectionView) else{
            
            return
        }
        
        if index.item < 4{
            
            self.selectedNutrientIndex = index.item + 1
            
            let collectionViewIndexPath = IndexPath(item: index.item + 1, section: 0)
            cell.imageCollectionView.scrollToItem(at: collectionViewIndexPath, at: .centeredHorizontally, animated: true)
        }else{
            
           self.selectedNutrientIndex = 4
        }
        
        if self.selectedNutrientIndex == 0{
            
            cell.hideLeftButton()
            
        }else if self.selectedNutrientIndex == self.nutrientsType.count - 1{
            
            cell.hideRightButton()
        }else{
            
            cell.dontHideButton()
        }
        
        cell.nutrientCollectionView.reloadData()
    }
}

//MARK:- WebServices
//===================
extension NutritionVC {
    
    fileprivate func getDayWiseData(){
        
        self.dayWiseDataDic["curr_date"] = self.selectedDate.stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        WebServices.getDayWiseNutrition(parameters:  self.dayWiseDataDic, success: { (_ DayWiseData :[DayWiseNutrition], _ graphViewData : [GraphView]) in
            
            self.daywiseNutritionData = DayWiseData
            self.graphView = graphViewData
            
            self.nutitionListingTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getNutrientsDataInTable(){
        
        self.graphDataDic["end_date"] = Date().stringFormDate(DateFormat.yyyyMMdd.rawValue)
        
        WebServices.getNutritionDataInTable(parameters: self.graphDataDic, success: { (_ nutrientsList : [NutritionGraphData],_ nextCount : Int) in
            
            if self.loadMoreBtntapped == .yes{
                self.nutrientList.append(contentsOf: nutrientsList)
                
            }else{
                
                self.nutrientList = nutrientsList
            }
            self.nextCount = nextCount
            
            self.nutitionListingTableView.reloadData()
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
}

//MARK:- Protocol
//===============
extension NutritionVC : SelectedDate {
    
    func donebtnActn(_ date: Date) {
        
        self.selectedDate = date
        
        self.getDayWiseData()
    }
}
