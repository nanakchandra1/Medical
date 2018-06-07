//
//  VitalDataInTableCellTableViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 01/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SpreadsheetView

class VitalDataInTableCell: UITableViewCell {

//    MARK:- Proporties
//    =================
    
    enum TableCellFor {
        
        case measurement, activity, nutrition
    }
    
    var tableCellFor = TableCellFor.measurement
    var vitalValues = [[[String : Any]]]()
    var rowindex = 0
    var columnInActivity = ["Name", "Duration", "Steps", "Calories","Distance","Intensity"]
    var columnsInNutrient = ["Schedule Name","Calories","Carbs","Fats","Protein","Water"]
    var activityDataInTabular = [ActivityDataInTabular]()
    var nutrientsListData = [NutritionGraphData]()
    
    
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var vitalDataView: SpreadsheetView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!

//    MARK:- Cell Life Cycle
//    ======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        if self.tableCellFor == .measurement {
            
            return self.vitalValues[0].count + 1
            
        }else if self.tableCellFor == .activity{
           
           return self.columnInActivity.count + 1
            
        }else{
            
            return self.columnsInNutrient.count + 1
        }
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int{
       
        if self.tableCellFor == .measurement {
            
            return self.vitalValues.count + 1
            
        }else if self.tableCellFor == .activity{

            return self.activityDataInTabular.count + 1
        }else{
            
            return self.nutrientsListData.count + 1
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat{
        
        return CGFloat(93)
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat{
        
        return CGFloat(40)
    }

    //     The cell that is returned must be retrieved from a call to `dequeueReusableCell(withReuseIdentifier:for:)`
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell?{
        

        self.rowindex = indexPath.row+1
        
        if self.tableCellFor == TableCellFor.measurement{
            
            switch (indexPath.column , indexPath.row){
                
            case (0,0): guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                
                fatalError("cell not found!")
            }
            
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = false
            cell.bottomSepratorView.backgroundColor = UIColor.appColor
            cell.verticalSepratorView.backgroundColor = UIColor.clear
            cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.dateLabelOult.isHidden = false
            
            cell.dateLabelOult.text = "Date"
   
            return cell
                
            case (0, 0...self.vitalValues.count) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor

                    cell.dateLabelOult.text = self.vitalValues[indexPath.row-1][indexPath.column]["measurement_date"] as? String
                    cell.timeLabelOult.text = self.vitalValues[indexPath.row-1][indexPath.column]["measurement_time"] as? String
               
                return cell
                
            case (0...self.vitalValues[0].count,0) :
                
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.clear
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
                cell.dateLabelOult.isHidden = false

                    cell.dateLabelOult.text = self.vitalValues[indexPath.row][indexPath.column - 1]["vital_sub_name"] as? String
                    
                    cell.timeLabelOult.text = self.vitalValues[indexPath.row][indexPath.column - 1]["unit"] as? String

                return cell
                
            case (1...self.vitalValues[0].count+1,1...self.vitalValues.count) :
                
                printlnDebug(self.vitalValues.count)
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor

                cell.dateLabelOult.isHidden = false
                
                printlnDebug("\(indexPath.row)\(indexPath.column)")
                

                    if let vitalSeverity = self.vitalValues[indexPath.row-1][indexPath.column-1]["vital_severity"] as? Int{
                        
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
                    
                    if let vitalValue = self.vitalValues[indexPath.row-1][indexPath.column-1]["vital_value"] as? String{
                        
                        cell.dateLabelOult.text = vitalValue
                    }else{
                        
                        cell.dateLabelOult.text = "--"
                    }

                return cell
                
                
            default :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                return cell
                
            }
            
        }else if self.tableCellFor == .activity {
           
            switch (indexPath.column , indexPath.row) {
                
            case (0,0) : guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                
                fatalError("cell not found!")
            }
            
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = false
            cell.bottomSepratorView.backgroundColor = UIColor.appColor
            cell.verticalSepratorView.backgroundColor = UIColor.clear
            cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.dateLabelOult.isHidden = false
            
            cell.dateLabelOult.text = "Date"
            
            return cell
         
            case (0, 0...self.activityDataInTabular.count) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
                
                    if let activityDate = self.activityDataInTabular[indexPath.row - 1].activityDate {
                        
                        cell.dateLabelOult.text = activityDate.dateFString(DateFormat.utcTime.rawValue, DateFormat.yyyyMMdd.rawValue)
                        
                    }
                    if let activityTime = self.activityDataInTabular[indexPath.row - 1].ActivityTime {
                        
                        cell.timeLabelOult.text = activityTime.dateFString(DateFormat.HHmmss.rawValue, DateFormat.Hmm.rawValue)
                        
                    }
                
                return cell
                
            case (0...self.columnInActivity.count,0) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.clear
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
                cell.dateLabelOult.isHidden = false
                
                printlnDebug("indexPath.column\(indexPath.column)")
                
                cell.dateLabelOult.text = self.columnInActivity[indexPath.column - 1]
                cell.timeLabelOult.isHidden = true
                
                return cell
                
            case (1...self.columnInActivity.count+1,1...self.activityDataInTabular.count + 1) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
                
                cell.timeLabelOult.isHidden = true
                
                printlnDebug("in : \(indexPath.row)\(indexPath.column)")
                
                if indexPath.column == 1 {
                    
                    if let activityName = self.activityDataInTabular[indexPath.row - 1].activityName {
                        
                        cell.dateLabelOult.text = activityName
                        
                    }
                    
                }else if indexPath.column == 2{
                    
                    if let activityDuration = self.activityDataInTabular[indexPath.row - 1].activityDuration {
                        
                        let activityDur = Int(activityDuration.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))
                        
                        cell.dateLabelOult.text = "\(activityDur)"
                        
                    }
                }else if indexPath.column == 3{
                    
                    if let totalSteps = self.activityDataInTabular[indexPath.row - 1].totalSteps {
                        
                        cell.dateLabelOult.text = "\(totalSteps)"
                        
                    }
                    
                }else if indexPath.column == 4{
                    
                    if let caloriesBurn = self.activityDataInTabular[indexPath.row - 1].caloriesBurn{
                        
                        printlnDebug("\(caloriesBurn)")
                        
                        cell.dateLabelOult.text = "\(caloriesBurn)"
                    }
                    
                }else if indexPath.column == 5{
                    
                    if let totalDistance = self.activityDataInTabular[indexPath.row - 1].totalDistance{
                        
                        cell.dateLabelOult.text = "\(totalDistance)"
                    }
                }else{
                    
                    if let activityIntensity = self.activityDataInTabular[indexPath.row - 1].activityIntensity{
                        
                        if activityIntensity == "intensity1"{
                            
                            cell.dateLabelOult.text = "Low"
                        }else if activityIntensity == "intensity2"{
                            
                            cell.dateLabelOult.text = "Med"
                        }else{
                            
                            cell.dateLabelOult.text = "High"
                        }
                    }
                }
                
                return cell
                
            default :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                return cell
                
            }
        }else{
            
            switch (indexPath.column , indexPath.row) {
                
            case (0,0) : guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                
                fatalError("cell not found!")
            }
            
            cell.timeLabelOult.isHidden = true
            cell.verticalSepratorView.isHidden = false
            cell.bottomSepratorView.backgroundColor = UIColor.appColor
            cell.verticalSepratorView.backgroundColor = UIColor.clear
            cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.dateLabelOult.isHidden = false
            
            cell.dateLabelOult.text = "Date"
            
            return cell
                
            case (0, 0...self.nutrientsListData.count) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.textColor = UIColor.grayLabelColor
                cell.dateLabelOult.isHidden = false
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
//                cell.verticalSepratorView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.layer.frame.height))
//                cell.bottomSepratorView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: self.layer.frame.width, y: 0))
                
                var dat = ""
                var tim = ""
                if let date = self.nutrientsListData[indexPath.row - 1].date {
                    
                    dat = date.dateFString(DateFormat.utcTime.rawValue, DateFormat.yyyyMMdd.rawValue)!
                    
                }
                
                if let time = self.nutrientsListData[indexPath.row - 1].time {
                    
                    tim = time.dateFString(DateFormat.HHmmss.rawValue, DateFormat.Hmm.rawValue)!
                }
                
                cell.dateLabelOult.text = dat
                cell.timeLabelOult.text = tim
                
                return cell
                
            case (0...self.columnsInNutrient.count,0) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.dateLabelOult.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.timeLabelOult.isHidden = false
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.clear
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
                
                cell.dateLabelOult.isHidden = false
                
                cell.dateLabelOult.text = self.columnsInNutrient[indexPath.column - 1]
                cell.timeLabelOult.isHidden = true
                
                return cell
                
            case (1...self.columnsInNutrient.count+1,1...self.nutrientsListData.count + 1) :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                cell.timeLabelOult.isHidden = true
                cell.verticalSepratorView.isHidden = false
                cell.bottomSepratorView.isHidden = false
                cell.verticalSepratorView.backgroundColor = UIColor.appColor
                cell.bottomSepratorView.backgroundColor = UIColor.appColor
//                cell.verticalSepratorView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.layer.frame.height))
//                cell.bottomSepratorView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: self.layer.frame.width, y: 0))
                
                cell.timeLabelOult.isHidden = true
                
                if indexPath.column == 1 {
                    
                    if let scheduleName = self.nutrientsListData[indexPath.row - 1].scheduleName {
                        
                        cell.dateLabelOult.text = scheduleName
                        
                    }
                    
                }else if indexPath.column == 2{
                    
                    if let caloriesTaken = self.nutrientsListData[indexPath.row - 1].caloriesTaken {
                        
                        cell.dateLabelOult.text = "\(caloriesTaken.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))"
                        
                    }
                    
                }else if indexPath.column == 3{
                    
                    if let crabsTaken = self.nutrientsListData[indexPath.row - 1].crabsTaken{
                        
                        
                        cell.dateLabelOult.text = "\(crabsTaken.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))"
                    }
                    
                }else if indexPath.column == 4{
                    
                    if let fatsTaken = self.nutrientsListData[indexPath.row - 1].fatsTaken{
                        
                        cell.dateLabelOult.text = "\(fatsTaken.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))"
                    }
                    
                }else if indexPath.column == 5{
                    
                    if let protienTaken = self.nutrientsListData[indexPath.row - 1].protiensTaken{
                        
                        cell.dateLabelOult.text = "\(protienTaken.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))"
                    }
                    
                }else if indexPath.column == 6{
                    
                    if let waterTaken = self.nutrientsListData[indexPath.row - 1].waterTaken{
                        
                        cell.dateLabelOult.text = "\(waterTaken.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))"
                    }
                }
                
                return cell
                
                
            default :
                
                guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "vitalTableCellID", for: indexPath) as? VitalTableCell else{
                    
                    fatalError("cell not found!")
                }
                
                return cell
                
            }
        }
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
