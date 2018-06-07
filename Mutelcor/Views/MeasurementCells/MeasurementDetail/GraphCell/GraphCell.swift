//
//  GraphCell.swift
//  Mutelcor
//
//  Created by on 17/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Charts

class GraphCell: UITableViewCell {
    
    // MARK:- Properties
    
    
    // MARK:- Outlets
    @IBOutlet weak var chartView: LineChartView!
    
    // MARK:- Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
        setGraphData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setGraphData()
    }
    
}

//MARK:- Methods
extension GraphCell {
    
    fileprivate func setupUI(){
        
        //chartView.delegate = self
        chartView.clipValuesToContentEnabled = false
        chartView.minOffset = 20
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.setScaleEnabled(false)
        
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawAxisLineEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.gridColor = .clear
        chartView.leftAxis.axisMinimum = 0.0
        chartView.leftAxis.labelFont = AppFonts.sansProBold.withSize(11)
        
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false

        chartView.xAxis.enabled = true
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.gridColor = .clear
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(7, force: true)
        chartView.xAxis.labelFont = AppFonts.sansProBold.withSize(11)
        
        let legend = chartView.legend
        legend.wordWrapEnabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .circle
        legend.xOffset = 0
        legend.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        legend.stackSpace = 15
        legend.enabled = true
    }
    
    func updateActivityGraph(with points: [ActivityConsumedPlannedTuple], plotType: GraphPlotType, dataType: ActivityDataType, lineType: GraphLineType) {
        guard let dataSets = chartView.data?.dataSets, dataSets.count > 0 else {
            setGraphData()
            return
        }
        chartView.xAxis.valueFormatter = DateValueFormatter(for: plotType)
        chartView.xAxis.labelRotationAngle = plotType.rotationAngle
        chartView.extraTopOffset = plotType.extraTopOffset
        
        for (index, _) in dataSets.enumerated() {
            
            if index == 0 {
                var consumedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = lineType
                for point in points {
                    let y = getActivityY(for: point, lineType: lineType, dataType: dataType)
//                    if y != 0 {
                    consumedEntries.append(ChartDataEntry(x: point.consumed.averageTimeInterval, y: y))
//                    }
                }
                let consumedDataSet = LineChartDataSet(values: consumedEntries, label: lineType.rawValue.capitalized)
                setLineColor(consumedDataSet, plotType: .consumed)
                chartView.data?.dataSets[index] = consumedDataSet
                
            } else {
                var plannedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = .planned
                for point in points {
                    let y = getActivityY(for: point, lineType: lineType, dataType: dataType)
//                    if y != 0 {
                    plannedEntries.append(ChartDataEntry(x: point.planned.averageTimeInterval, y: y))
//                    }
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
    
    func updateNutritionGraph(with points: [NutritionConsumedPlannedTuple], plotType: GraphPlotType, dataType: NutritionDataType) {
        guard let dataSets = chartView.data?.dataSets, dataSets.count > 0 else {
            setGraphData()
            return
        }
        chartView.xAxis.valueFormatter = DateValueFormatter(for: plotType)
        chartView.xAxis.labelRotationAngle = plotType.rotationAngle
        chartView.extraTopOffset = plotType.extraTopOffset
        
        for (index, _) in dataSets.enumerated() {
            
            if index == 0 {
                var consumedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = .consumed
                for point in points {
                    let y = getNutritionY(for: point, lineType: lineType, dataType: dataType)
                    //if y != 0 {
                      consumedEntries.append(ChartDataEntry(x: point.consumed.averageTimeInterval, y: y))
//                    }
                }
                let consumedDataSet = LineChartDataSet(values: consumedEntries, label: lineType.rawValue.capitalized)
                setLineColor(consumedDataSet, plotType: .consumed)
                chartView.data?.dataSets[index] = consumedDataSet
            } else {
                var plannedEntries = [ChartDataEntry]()
                let lineType: GraphLineType = .planned
                for point in points {
                    let y = getNutritionY(for: point, lineType: lineType, dataType: dataType)
//                    if y != 0 {
                    plannedEntries.append(ChartDataEntry(x: point.planned.averageTimeInterval, y: y))
//                    }
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
    
    func updateMeasurementGraph(with points: [MeasurementGraphTuple], plotType: GraphPlotType) {
        chartView.legend.enabled = false
        guard let dataSets = chartView.data?.dataSets, dataSets.count > 0 else {
            setGraphData()
            return
        }
        chartView.xAxis.valueFormatter = DateValueFormatter(for: plotType)
        chartView.xAxis.labelRotationAngle = plotType.rotationAngle
        chartView.extraTopOffset = plotType.extraTopOffset
        
        for (index, _) in dataSets.enumerated() {
            
            if index == 0 {
                var consumedEntries = [ChartDataEntry]()
                for point in points {
//                    if point.averageValueConversion != 0 {
                    
                    consumedEntries.append(ChartDataEntry(x: point.averageTimeInterval, y: point.averageValueConversion))
                
//                    }
                }
                let consumedDataSet = LineChartDataSet(values: consumedEntries, label: "")
                setLineColor(consumedDataSet, plotType: .consumed)
                chartView.data?.dataSets[index] = consumedDataSet
                
            } else {
                let plannedEntries = [ChartDataEntry]()
                let plannedDataSet = LineChartDataSet(values: plannedEntries, label: "")
                chartView.data?.dataSets[index] = plannedDataSet
            }
        }
        
        mainQueue {
            self.chartView.data?.notifyDataChanged()
            self.chartView.notifyDataSetChanged()
            self.chartView.animate(xAxisDuration: 1.5, easingOption: .linear)
        }
    }
    
    private func getActivityY(for point: ActivityConsumedPlannedTuple, lineType: GraphLineType, dataType: ActivityDataType) -> Double {
        var y = 0.0
        switch dataType {
        case .calorie:
            y = (lineType == .burnt ? point.consumed.averageCalories : point.planned.averageCalories)
        case .duration:
            y = (lineType == .burnt ? point.consumed.averageDuration : point.planned.averageDuration)
        case .distance:
            y = (lineType == .burnt ? point.consumed.averageDistance : point.planned.averageDistance)
        }
        return y
    }
    
    private func getNutritionY(for point: NutritionConsumedPlannedTuple, lineType: GraphLineType, dataType: NutritionDataType) -> Double {
        var y = 0.0
        switch dataType {
        case .calories:
            y = (lineType == .consumed ? point.consumed.averageCalories : point.planned.averageCalories)
        case .water:
            y = (lineType == .consumed ? point.consumed.averageWater : point.planned.averageWater)
        case .carb:
            y = (lineType == .consumed ? point.consumed.averageCarbs : point.planned.averageCarbs)
        case .protein:
            y = (lineType == .consumed ? point.consumed.averageProteins : point.planned.averageProteins)
        case .fats:
            y = (lineType == .consumed ? point.consumed.averageFats : point.planned.averageFats)
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
}
