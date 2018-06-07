//
//  ViewController.swift
//  MutelCoreChartDemo
//
//  Created by on 28/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Charts
import SwiftRandom
import SwiftyJSON

enum GraphPlotType: Int {
    case week
    case month
    case threeMonths
    case sixMonths
    case year
    
    var rotationAngle: CGFloat {
        switch self {
        case .month, .threeMonths:
            return 25
        default:
            return 0
        }
    }
    
    var extraTopOffset: CGFloat {
        switch self {
        case .month, .threeMonths:
            return -28
        default:
            return 0
        }
    }
}

enum ActivityDataType: Int {
    case duration
    case distance
    case calorie
}

enum NutritionDataType: Int {
    case calories
    case carb
    case fats
    case protein
    case water
}

enum GraphLineType: String {
    case consumed
    case planned
    case burnt
}

typealias ActivityGraphTupleData = (averageTimeInterval: Double, averageCalories: Double, averageDuration: Double, averageDistance: Double)
typealias ActivityConsumedPlannedTuple = (consumed: ActivityGraphTupleData, planned: ActivityGraphTupleData)

typealias NutritionGraphTupleData = (averageTimeInterval: Double, averageCalories: Double, averageFats: Double, averageCarbs: Double, averageProteins: Double, averageWater: Double)
typealias NutritionConsumedPlannedTuple = (consumed: NutritionGraphTupleData, planned: NutritionGraphTupleData)

typealias MeasurementGraphTuple = (averageTimeInterval: Double, averageValueConversion: Double)

class ViewController: UIViewController, ChartViewDelegate {
    
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
    
    @IBOutlet weak var chartView: LineChartView!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self
        chartView.clipValuesToContentEnabled = false
        chartView.minOffset = 20
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawAxisLineEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.gridColor = .clear
        chartView.leftAxis.axisMinimum = 0.0
        
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.gridColor = .clear
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(7, force: true)
        
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        let legend = chartView.legend
        legend.wordWrapEnabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .circle
        legend.xOffset = 10
        legend.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        legend.stackSpace = 15
        
        setGraphData()
        getGraphData()
    }
    
    @IBAction func reloadGraph(_ sender: UIButton) {
        getGraphData()
    }
    
    func getGraphData() {
        let parameters: JSONDictionary = ["curr_date": Date().stringFormDate(.yyyyMMdd)]
        
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
        guard let activityDate = apiGraphDataArray.first?.activityDate else {
            return
        }
        
        let weekStartingDate = todaysDate.adding(.day, value: -7)
        let previousMonthDate = todaysDate.adding(.month, value: -1)
        let threeMonthFirstDate = todaysDate.adding(.month, value: -3).startOfMonth
        let sixMonthFirstDate = todaysDate.adding(.month, value: -6).startOfMonth
        let previousYearDate = todaysDate.adding(.year, value: -1).startOfMonth
        
        if activityDate.startOfDay > weekStartingDate.startOfDay {
            updateGraph(with: weekPoints, plotType: .week)
        } else if activityDate.startOfDay > previousMonthDate.startOfDay {
            updateGraph(with: monthPoints, plotType: .month)
        } else if activityDate.startOfDay > threeMonthFirstDate.startOfDay {
            updateGraph(with: threeMonthPoints, plotType: .threeMonths)
        } else if activityDate.startOfDay > sixMonthFirstDate.startOfDay {
            updateGraph(with: sixMonthPoints, plotType: .sixMonths)
        } else if activityDate.startOfDay > previousYearDate.startOfDay {
            updateGraph(with: oneYearPoints, plotType: .year)
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
        
        let firstPointIndex = (secondPointIndex - counts[7]) + 1
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
    
    func updateGraph(with points: [ActivityConsumedPlannedTuple], plotType: GraphPlotType) {
        guard let dataSets = chartView.data?.dataSets, dataSets.count > 0 else {
            setGraphData()
            return
        }
        lastPlotType = plotType
        chartView.xAxis.valueFormatter = DateValueFormatter(for: plotType)
        
        for (index, _) in dataSets.enumerated() {
            
            if index == 0 {
                var consumedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = .consumed
                for point in points {
                    let y = getY(for: point, lineType: lineType)
                    consumedEntries.append(ChartDataEntry(x: point.consumed.averageTimeInterval, y: y))
                }
                let consumedDataSet = LineChartDataSet(values: consumedEntries, label: lineType.rawValue.capitalized)
                setLineColor(consumedDataSet, plotType: .consumed)
                chartView.data?.dataSets[index] = consumedDataSet
                
            } else {
                var plannedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = .planned
                for point in points {
                    let y = getY(for: point, lineType: lineType)
                    plannedEntries.append(ChartDataEntry(x: point.planned.averageTimeInterval, y: y))
                }
                let plannedDataSet = LineChartDataSet(values: plannedEntries, label: lineType.rawValue.capitalized)
                setLineColor(plannedDataSet, plotType: .planned)
                chartView.data?.dataSets[index] = plannedDataSet
            }
        }
        
        mainQueue {
            self.chartView.data?.notifyDataChanged()
            self.chartView.notifyDataSetChanged()
            self.chartView.animate(xAxisDuration: 1.5, easingOption: .linear)
        }
    }
    
    func getY(for point: ActivityConsumedPlannedTuple, lineType: GraphLineType) -> Double {
        var y = 0.0
        switch dataType {
        case .calorie:
            y = (lineType == .consumed ? point.consumed.averageCalories : point.planned.averageCalories)
        case .duration:
            y = (lineType == .consumed ? point.consumed.averageDuration : point.planned.averageDuration)
        case .distance:
            y = (lineType == .consumed ? point.consumed.averageDistance : point.planned.averageDistance)
        }
        return y
    }
    
    func setGraphData() {
        let firstLineEntries = [ChartDataEntry]()
        var lineType: GraphLineType = .consumed
        let firstLineDataSet = LineChartDataSet(values: firstLineEntries, label: lineType.rawValue.capitalized)
        setLineColor(firstLineDataSet, plotType: .consumed)
        
        let secondLineEntries = [ChartDataEntry]()
        lineType = .planned
        let secondLineDataSet = LineChartDataSet(values: secondLineEntries, label: lineType.rawValue.capitalized)
        setLineColor(secondLineDataSet, plotType: .planned)
        
        chartView.data = LineChartData(dataSets: [firstLineDataSet, secondLineDataSet])
    }
    
    func setLineColor(_ lineDataSet: LineChartDataSet, plotType: GraphLineType) {
        
        var lineColor = UIColor(red: 55/255, green: 141/255, blue: 239/255, alpha: 1)
        
        if plotType == .consumed {
            lineColor = UIColor(red: 116/255, green: 216/255, blue: 135/255, alpha: 1)
        }
        
        lineDataSet.colors = [lineColor]
        lineDataSet.lineWidth = 3.0
        lineDataSet.circleColors = [.white]
        lineDataSet.circleRadius = 6.5
        lineDataSet.circleHoleRadius = 4.5
        lineDataSet.circleHoleColor = lineColor
        lineDataSet.fillColor = lineColor
        lineDataSet.mode = .linear
        lineDataSet.drawValuesEnabled = false
        lineDataSet.axisDependency = .left
    }
    
    @IBAction func weekBtnTapped(_ sender: UIButton) {
        updateGraph(with: weekPoints, plotType: .week)
    }
    
    @IBAction func monthBtnTapped(_ sender: UIButton) {
        updateGraph(with: monthPoints, plotType: .month)
    }
    
    @IBAction func threeMonthBtnTapped(_ sender: UIButton) {
        updateGraph(with: threeMonthPoints, plotType: .threeMonths)
    }
    
    @IBAction func sixMonthBtnTapped(_ sender: UIButton) {
        updateGraph(with: sixMonthPoints, plotType: .sixMonths)
    }
    
    @IBAction func oneYearBtnTapped(_ sender: UIButton) {
        updateGraph(with: oneYearPoints, plotType: .year)
    }
    
    @IBAction func allBtnTapped(_ sender: UIButton) {
        getPointsForAll()
    }
    
    @IBAction func graphTypeSegmentControl(_ sender: UISegmentedControl) {
        dataType = ActivityDataType(rawValue: sender.selectedSegmentIndex)!
        switch lastPlotType {
        case .week:
            updateGraph(with: weekPoints, plotType: lastPlotType)
        case .month:
            updateGraph(with: monthPoints, plotType: lastPlotType)
        case .threeMonths:
            updateGraph(with: threeMonthPoints, plotType: lastPlotType)
        case .sixMonths:
            updateGraph(with: sixMonthPoints, plotType: lastPlotType)
        case .year:
            updateGraph(with: oneYearPoints, plotType: lastPlotType)
        }
    }
    
}


