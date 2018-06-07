//
//  VitalDataInTableCellTableViewCell.swift
//  Mutelcor
//
//  Created by on 01/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SpreadsheetView

class VitalDataInTableCell: UITableViewCell {
    
    enum TableCellFor {
        case measurement
        case activity
        case nutrition
    }
    
    //    MARK:- Proporties
    //    =================
    var tableCellFor = TableCellFor.measurement
    var vitalValues = [[MeasurementTablurData]]()
    var subVitalData = [MeasurementTabularSubVital]()
    var rowindex = 0
    var columnInActivity = ["Activity", "Duration", "Intensity", "Distance", "Steps", "Calories"]
    var columnsInNutrient = ["Schedule Name","Calories","Carbs","Fats","Protein","Water"]
    var activityDataInTabular = [ActivityDataInTabular]()
    var nutrientsListData = [NutritionGraphData]()

    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var vitalDataView: SpreadsheetView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.headerView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
}

//MARK:- Methods
//===============
extension VitalDataInTableCell {
    
    func setupUI(){
        
        self.vitalDataView.dataSource = self
        let vitalDataNib = UINib(nibName: "VitalTableCell", bundle: nil)
        self.vitalDataView.register(vitalDataNib, forCellWithReuseIdentifier: "vitalTableCellID")
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.isHidden = true
        
        self.vitalDataView.backgroundColor = UIColor.clear
        self.vitalDataView.circularScrolling = CircularScrolling.Configuration.none
        self.vitalDataView.alwaysBounceHorizontal = false
        self.vitalDataView.alwaysBounceVertical = false
        self.vitalDataView.gridStyle = GridStyle.solid(width: CGFloat(0), color: UIColor.clear)
        self.vitalDataView.bounces = false
        
        self.vitalDataView.decelerationRate = 0.2
    }
}

//MARK:- CollectionViewDataSource Methods
//=======================================
extension VitalDataInTableCell : SpreadsheetViewDataSource{
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int{
        
        switch self.tableCellFor {
            
        case .measurement:
            var vitalCount = 0
            if !self.subVitalData.isEmpty {
                vitalCount = self.subVitalData.count
            }
            return vitalCount + 1
        case .activity:
            return self.columnInActivity.count + 1
        case .nutrition:
            return self.columnsInNutrient.count + 1
        }
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int{
        
        switch self.tableCellFor {
        case .measurement :
            return self.vitalValues.count + 1
        case .activity :
            return self.activityDataInTabular.count + 1
        case .nutrition :
            return self.nutrientsListData.count + 1
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat{
        
        if self.tableCellFor == .measurement {
            
            if !self.subVitalData.isEmpty {
                if (self.subVitalData.count+1) > 4 {
                    return 93
                } else {
                    if let vital = self.vitalValues.first {
                        return CGFloat(Int(UIDevice.getScreenWidth) / (vital.count + 1))
                    }
                    return UIDevice.getScreenWidth
                }
            } else {
                return CGFloat.leastNormalMagnitude
            }
        } else {
            return 93
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat{
        return 40
    }
    
    // The cell that is returned must be retrieved from a call to `dequeueReusableCell(withReuseIdentifier:for:)`
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell?{
        
        guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
            fatalError("cell not found!")
        }
        
        self.rowindex = (indexPath.row + 1)
        
        switch self.tableCellFor {
        case .measurement :

            switch (indexPath.column , indexPath.row){
                
            case (0,0):
                
                cell.timeLabelOult.isHidden = true
                cell.bottomSepratorView.isHidden = true
                cell.verticalSepratorView.isHidden = true
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.dateLabelOult.textColor = UIColor.white
                cell.dateLabelOult.isHidden = false
                
                cell.dateLabelOult.text = K_DATE_TEXT.localized.uppercased()
                
            case (0, 0...self.vitalValues.count) :
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(10)
                if !self.vitalValues[indexPath.row - 1].isEmpty {
                    let date = self.vitalValues[indexPath.row-1][indexPath.column].measurementdate ?? ""
                    let time = self.vitalValues[indexPath.row-1][indexPath.column].measurementTime ?? ""
                    let dateTime = !date.isEmpty ? date + " \(time)" : ""
                    cell.dateLabelOult.text = dateTime
                }
                
            case (0...self.subVitalData.count,0) :
                
                cell.dateLabelOult.textColor = UIColor.white
                cell.timeLabelOult.textColor = UIColor.white
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.timeLabelOult.isHidden = false
                cell.bottomSepratorView.isHidden = true
                cell.verticalSepratorView.isHidden = true
                cell.dateLabelOult.isHidden = false
                
                if !self.subVitalData.isEmpty {
                    cell.dateLabelOult.text = self.subVitalData[indexPath.column - 1].vitalSubname
                    cell.timeLabelOult.text = self.subVitalData[indexPath.column - 1].unit
                }
            case (1...self.subVitalData.count+1,1...self.vitalValues.count + 1) :
                
                //printlnDebug(self.vitalValues.count)
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                
                cell.dateLabelOult.isHidden = false
                
                //printlnDebug("\(indexPath.row)\(indexPath.column)")
                
                if !self.vitalValues[indexPath.row - 1].isEmpty, self.vitalValues[0].count+1 <= self.subVitalData.count+1 {
                    
                    if (indexPath.column - 1) < self.vitalValues[indexPath.row - 1].count{
                        
                        if let vitalSeverity = self.vitalValues[indexPath.row-1][indexPath.column-1].vitalSeverity{
                            if vitalSeverity == 0{
                                cell.dateLabelOult.textColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
                            }else if vitalSeverity == 1{
                                cell.dateLabelOult.textColor = #colorLiteral(red: 0.8901960784, green: 0.7137254902, blue: 0, alpha: 1)
                            }else if vitalSeverity == 2{
                                cell.dateLabelOult.textColor = #colorLiteral(red: 0.9294117647, green: 0.1843137255, blue: 0.2901960784, alpha: 1)
                            }else{
                                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            }
                        }
                        if let vitalValue = self.vitalValues[indexPath.row-1][indexPath.column-1].vitalValue, !vitalValue.isEmpty{
                            cell.dateLabelOult.text = vitalValue
                        }else{
                            cell.dateLabelOult.text = "--"
                        }
                    }else{
                        cell.dateLabelOult.text = "--"
                    }
                }else{
                   cell.dateLabelOult.text = "--"
                }
            default : fatalError("Row and column not found!")
            }
           
        case .activity:
            switch (indexPath.column , indexPath.row) {
                
            case (0,0) :
                
                cell.timeLabelOult.isHidden = true
                cell.bottomSepratorView.isHidden = true
                cell.verticalSepratorView.isHidden = true
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.dateLabelOult.textColor = UIColor.white
                cell.dateLabelOult.isHidden = false
                
                cell.dateLabelOult.text = K_DATE_TEXT.localized.uppercased()
                
            case (0, 0...self.activityDataInTabular.count) :
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.timeLabelOult.isHidden = true
                cell.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(10)
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.isHidden = false
                let date = self.activityDataInTabular[indexPath.row - 1].activityDate?.changeDateFormat(.utcTime, .dMMMyyyy) ?? ""
                let time = self.activityDataInTabular[indexPath.row - 1].ActivityTime?.changeDateFormat(.HHmmss, .Hmm) ?? ""
                let dateTime = !date.isEmpty ? date + " \(time)" : ""
                cell.dateLabelOult.text = dateTime
                
            case (0...self.columnInActivity.count,0) :
                
                cell.dateLabelOult.textColor = UIColor.white
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = true
                cell.bottomSepratorView.isHidden = true
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.dateLabelOult.isHidden = false
                
                cell.dateLabelOult.text = self.columnInActivity[indexPath.column - 1].uppercased()
                cell.timeLabelOult.isHidden = true
                
            case (1...self.columnInActivity.count+1,1...self.activityDataInTabular.count + 1) :
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.timeLabelOult.isHidden = true
                
                if indexPath.column == 1 {
                    if let activityName = self.activityDataInTabular[indexPath.row - 1].activityName {
                        cell.dateLabelOult.text = activityName
                    }
                    
                }else if indexPath.column == 2{
                    if let activityDuration = self.activityDataInTabular[indexPath.row - 1].activityDuration {
                        let activityDur = Int(activityDuration.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))
                        let durationUnit = self.activityDataInTabular[indexPath.row - 1].activityDurationUnit ?? ""
                        cell.dateLabelOult.text = "\(activityDur) \(durationUnit)"
                        
                    }
                }else if indexPath.column == 3{
                    if let activityIntensity = self.activityDataInTabular[indexPath.row - 1].activityIntensity{
                        
                        if activityIntensity == "intensity1"{
                            cell.dateLabelOult.text = "Low"
                        }else if activityIntensity == "intensity2"{
                            cell.dateLabelOult.text = "Med"
                        }else{
                            cell.dateLabelOult.text = "High"
                        }
                    }
                }else if indexPath.column == 4{
                    if let totalDistance = self.activityDataInTabular[indexPath.row - 1].totalDistance{
                        cell.dateLabelOult.text = totalDistance.rounded(toPlaces: 2).cleanValue
                    }
                }else if indexPath.column == 5{
                    if let totalSteps = self.activityDataInTabular[indexPath.row - 1].totalSteps {
                        cell.dateLabelOult.text = "\(totalSteps)"
                    }
                }else{
                    if let caloriesBurn = self.activityDataInTabular[indexPath.row - 1].caloriesBurn{
                        cell.dateLabelOult.text = "\(caloriesBurn)"
                    }
                }
            default :
                fatalError("Row and column not found!")
            }
        default:

            switch (indexPath.column , indexPath.row) {
                
            case (0,0) :
                cell.timeLabelOult.isHidden = true
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                
                cell.dateLabelOult.textColor = UIColor.white
                cell.dateLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = true
                cell.bottomSepratorView.isHidden = true
                
                cell.dateLabelOult.text = K_DATE_TEXT.localized.uppercased()
                
            case (0, 0...self.nutrientsListData.count) :
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(10)
                cell.timeLabelOult.isHidden = true
                
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                
                let date = self.nutrientsListData[indexPath.row - 1].date?.changeDateFormat(.utcTime, .dMMMyyyy) ?? ""
                let time = self.nutrientsListData[indexPath.row - 1].time?.changeDateFormat(.HHmmss, .Hmm) ?? ""
                let dateTime = !date.isEmpty ? date + " \(time)" : ""
                cell.dateLabelOult.text = dateTime
                
            case (0...self.columnsInNutrient.count,0) :
                
                cell.dateLabelOult.textColor = UIColor.white
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = true
                cell.bottomSepratorView.isHidden = true
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.dateLabelOult.isHidden = false
                
                cell.dateLabelOult.text = self.columnsInNutrient[indexPath.column - 1].uppercased()
                cell.timeLabelOult.isHidden = true
                
            case (1...self.columnsInNutrient.count+1,1...self.nutrientsListData.count + 1) :
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.timeLabelOult.isHidden = true
                
                if indexPath.column == 1 {
                    if let scheduleName = self.nutrientsListData[indexPath.row - 1].scheduleName {
                        cell.dateLabelOult.text = scheduleName
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                    
                }else if indexPath.column == 2{
                    if let caloriesTaken = self.nutrientsListData[indexPath.row - 1].caloriesTaken {
                        cell.dateLabelOult.text = caloriesTaken.rounded(.toNearestOrAwayFromZero).cleanValue
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                    
                }else if indexPath.column == 3{
                    if let crabsTaken = self.nutrientsListData[indexPath.row - 1].crabsTaken{
                        cell.dateLabelOult.text = crabsTaken.rounded(.toNearestOrAwayFromZero).cleanValue
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                    
                }else if indexPath.column == 4{
                    if let fatsTaken = self.nutrientsListData[indexPath.row - 1].fatsTaken{
                        cell.dateLabelOult.text = fatsTaken.rounded(.toNearestOrAwayFromZero).cleanValue
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                    
                }else if indexPath.column == 5{
                    if let protienTaken = self.nutrientsListData[indexPath.row - 1].protiensTaken{
                        cell.dateLabelOult.text = protienTaken.rounded(.toNearestOrAwayFromZero).cleanValue
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                    
                }else if indexPath.column == 6{
                    if let waterTaken = self.nutrientsListData[indexPath.row - 1].waterTaken{
                        cell.dateLabelOult.text = waterTaken.rounded(.toNearestOrAwayFromZero).cleanValue
                    }else{
                        cell.dateLabelOult.text = "-"
                    }
                }
            default : fatalError("Row and column not found!")
            }
        }
        return cell
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int{
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int{
        if self.tableCellFor == .measurement{
            return 1
        }else if self.tableCellFor == .activity{
            return 1
        }else{
            return 1
        }
    }
}
