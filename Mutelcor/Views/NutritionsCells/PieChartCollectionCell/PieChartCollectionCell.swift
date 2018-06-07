//
//  PieChartCollectionCell.swift
//  Mutelcor
//
//  Created by on 23/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Charts

class PieChartCollectionCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var snacksLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.breakfastLabel.textColor = UIColor.white
        self.lunchLabel.textColor = UIColor.white
        self.dinnerLabel.textColor = UIColor.white
        self.snacksLabel.textColor = UIColor.white
        self.caloriesLabel.font = AppFonts.sanProSemiBold.withSize(30)
    }
    
    func populateDataOnGraph(_ graphData : [GraphView], _ indexPath : IndexPath){
        
        switch indexPath.item {            
        case 0:
            var totalCalorie  = 0.0
            for (count, _) in graphData.enumerated() {
                let calories = graphData[count].caloriesTaken ?? 0.0
                
                let caloriesTaken = calories.rounded()
                let scheduleName = graphData[count].scheduleName
                
                //let attributedText = self.setTextAttributes("\(scheduleName!.capitalized)\n", "\(caloriesTaken.cleanValue)\n", K_CALORIES_UNIT.localized)
                let attributedText = self.setTextAttributes("\n\(scheduleName!.capitalized)\n", "\(caloriesTaken.cleanValue)", "")

                if count == 0 {
                    self.breakfastLabel.attributedText =  attributedText
                } else if count == 1 {
                    self.lunchLabel.attributedText =  attributedText
                } else if count == 2 {
                    self.dinnerLabel.attributedText =  attributedText
                } else {
                    self.snacksLabel.attributedText =  attributedText
                }
                totalCalorie = totalCalorie + caloriesTaken
            }
            //self.caloriesLabel.text = totalCalorie.cleanValue
            self.setAttributes(value: "\(totalCalorie.cleanValue)\n", unit: K_CALORIES_UNIT.localized)

        case 1:
            
            var totalCrabs  = 0.0
            for (count, _) in graphData.enumerated() {
                
                let carbs = graphData[count].crabsTaken ?? 0.0
                let carbsTaken = carbs.rounded()
                let scheduleName = graphData[count].scheduleName
                
                //let attributedText = self.setTextAttributes("\(scheduleName!.capitalized)\n", "\(carbsTaken.cleanValue)\n", "\(K_GRAM_TITLE.localized)")
                let attributedText = self.setTextAttributes("\n\(scheduleName!.capitalized)\n", "\(carbsTaken.cleanValue)", "")

                if count == 0 {
                    self.breakfastLabel.attributedText =  attributedText
                } else if count == 1 {
                    self.lunchLabel.attributedText =  attributedText
                } else if count == 2 {
                    self.dinnerLabel.attributedText =  attributedText
                } else {
                    self.snacksLabel.attributedText =  attributedText
                }
                totalCrabs = totalCrabs + carbsTaken
            }
            //self.caloriesLabel.text = totalCrabs.cleanValue
            self.setAttributes(value: "\(totalCrabs.cleanValue)\n", unit: K_GRAM_TITLE.localized)

        case 2:
            
            var totalFats  = 0.0
            
            for (count, _) in graphData.enumerated() {
                let fats = graphData[count].fatsTaken ?? 0.0
                let fatsTaken = fats.rounded()
                let scheduleName = graphData[count].scheduleName
                
                //let attributedText = self.setTextAttributes("\(scheduleName!.capitalized)\n", "\(fatsTaken.cleanValue)\n", "\(K_GRAM_TITLE.localized)")
                let attributedText = self.setTextAttributes("\n\(scheduleName!.capitalized)\n", "\(fatsTaken.cleanValue)", "")

                if count == 0 {
                    self.breakfastLabel.attributedText =  attributedText
                }else if count == 1{
                    self.lunchLabel.attributedText =  attributedText
                }else if count == 2{
                    self.dinnerLabel.attributedText =  attributedText
                }else{
                    self.snacksLabel.attributedText =  attributedText
                }
                totalFats = totalFats + fatsTaken
            }
            //self.caloriesLabel.text = totalFats.cleanValue
            self.setAttributes(value: "\(totalFats.cleanValue)\n", unit: K_GRAM_TITLE.localized)
        case 3:
            
            var totalProtien  = 0.0
            for (count, _) in graphData.enumerated() {
                let protien = graphData[count].protiesTaken ?? 0.0
                let proteinTaken = protien.rounded()
                let scheduleName = graphData[count].scheduleName
                
                //let attributedText = self.setTextAttributes("\(scheduleName!.capitalized)\n", "\(proteinTaken.cleanValue)\n", "\(K_GRAM_TITLE.localized)")
                let attributedText = self.setTextAttributes("\n\(scheduleName!.capitalized)\n", "\(proteinTaken.cleanValue)", "")

                if count == 0 {
                    self.breakfastLabel.attributedText =  attributedText
                } else if count == 1 {
                    self.lunchLabel.attributedText =  attributedText
                } else if count == 2 {
                    self.dinnerLabel.attributedText =  attributedText
                } else {
                    self.snacksLabel.attributedText =  attributedText
                }
                totalProtien = totalProtien + proteinTaken
            }
            //self.caloriesLabel.text = totalProtien.cleanValue
            self.setAttributes(value: "\(totalProtien.cleanValue)\n", unit: K_GRAM_TITLE.localized)
        default:
            return
        }
    }
    
    func setAttributes(value: String, unit: String){

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center

        let mutableCenterText = NSMutableAttributedString(string: value, attributes: [.font: AppFonts.sanProSemiBold.withSize(30), .paragraphStyle: paragraphStyle])
        let attributedUnitText = NSAttributedString(string: unit, attributes: [.font: AppFonts.sanProSemiBold.withSize(15), .paragraphStyle: paragraphStyle])

        mutableCenterText.append(attributedUnitText)
        self.caloriesLabel.attributedText = mutableCenterText
    }
    
    func setTextAttributes(_ schedule : String, _ value : String, _ unit : String) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let mutableScheduleText = NSMutableAttributedString(string: schedule, attributes: [NSAttributedStringKey.font: AppFonts.sanProSemiBold.withSize(10)])
        let attributedValueText = NSAttributedString(string: value, attributes: [NSAttributedStringKey.font: AppFonts.sansProBold.withSize(18)])
        let attributedUnitText = NSAttributedString(string: unit, attributes: [NSAttributedStringKey.font: AppFonts.sanProSemiBold.withSize(10)])
        
        mutableScheduleText.append(attributedValueText)
        mutableScheduleText.append(attributedUnitText)
        
        return mutableScheduleText
    }
}
