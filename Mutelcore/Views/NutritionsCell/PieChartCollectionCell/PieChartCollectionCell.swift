//
//  PieChartCollectionCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 23/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
    
    //
    //    @IBOutlet weak var pieChart: PieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.breakfastLabel.textColor = UIColor.white
        self.lunchLabel.textColor = UIColor.white
        self.dinnerLabel.textColor = UIColor.white
        self.snacksLabel.textColor = UIColor.white
        
    }
    
    func populateDataOnGraph(_ graphData : [GraphView], _ indexPath : IndexPath){
        
        switch indexPath.item {
            
        case 0:
            
            var totalCalorie  = 0.0
            
            for (count, _) in graphData.enumerated() {
                
                let caloriesTaken = graphData[count].caloriesTaken?.rounded(.toNearestOrAwayFromZero)
                let scheduleName = graphData[count].scheduleName
                
                if count == 0 {
                    
                    self.breakfastLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(String(describing: caloriesTaken!))\n", "kcal")
                }else if count == 1{
                    
                    self.lunchLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(String(describing: caloriesTaken!))\n", "kcal")
                }else if count == 2{
                    
                    self.dinnerLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(String(describing: caloriesTaken!))\n", "kcal")
                }else{
                    
                    self.snacksLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(String(describing: caloriesTaken!))\n", "kcal")
                }
                totalCalorie = totalCalorie + caloriesTaken!
            }
            
            self.setAttributes("\(totalCalorie)\nkcal")
            
        case 1:
            
            var totalCrabs  = 0.0
            
            for (count, _) in graphData.enumerated() {
                
                let carbsTaken = graphData[count].crabsTaken?.rounded(.toNearestOrAwayFromZero)
                let scheduleName = graphData[count].scheduleName
                
                if count == 0 {
                    
                    self.breakfastLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(carbsTaken!)\n", "g")
                }else if count == 1{
                    
                    self.lunchLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(carbsTaken!)\n", "g")
                }else if count == 2{
                    
                    self.dinnerLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(carbsTaken!)\n", "g")
                }else{
                    
                    self.snacksLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(carbsTaken!)\n", "g")
                }
                
                totalCrabs = totalCrabs + carbsTaken!
            }
            
                        self.setAttributes("\(totalCrabs)\ng")
            
        case 2:
            
            var totalFats  = 0.0
            
            for (count, _) in graphData.enumerated() {
                
                let fatsTaken = graphData[count].fatsTaken?.rounded(.toNearestOrAwayFromZero)
                let scheduleName = graphData[count].scheduleName
                
                if count == 0 {
                    
                    self.breakfastLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(fatsTaken!)\n", "g")
                }else if count == 1{
                    
                    self.lunchLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(fatsTaken!)\n", "g")
                }else if count == 2{
                    
                    self.dinnerLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(fatsTaken!)\n", "g")
                }else{
                    
                    self.snacksLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(fatsTaken!)\n", "g")
                }
                
                totalFats = totalFats + fatsTaken!
            }
            
                        self.setAttributes("\(totalFats)\ng")
            
        case 3:
            
            var totalProtien  = 0.0
            
            for (count, _) in graphData.enumerated() {
                
                let proteinTaken = graphData[count].protiesTaken?.rounded(.toNearestOrAwayFromZero)
                let scheduleName = graphData[count].scheduleName
                
                if count == 0 {
                    
                    self.breakfastLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(proteinTaken!)\n", "g")
                }else if count == 1{
                    
                    self.lunchLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(proteinTaken!)\n", "g")
                }else if count == 2{
                    
                    self.dinnerLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(proteinTaken!)\n", "g")
                }else{
                    
                    self.snacksLabel.attributedText =  self.setTextAttributes("\(scheduleName!)\n", "\(proteinTaken!)\n", "g")
                }
                
                totalProtien = totalProtien + proteinTaken!
                
            }
            
                        self.setAttributes("\(totalProtien)\ng")
            
        default: return
            
        }
    }
    
    func setAttributes(_ value : String){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: value)
        centerText.setAttributes([NSFontAttributeName: AppFonts.sanProSemiBold.withSize(30), NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
        centerText.addAttributes([NSFontAttributeName: AppFonts.sanProSemiBold.withSize(15)], range: NSMakeRange(centerText.length - 4, 4))
        
        self.caloriesLabel.attributedText = centerText
    }
    
    func setTextAttributes(_ schedule : String, _ value : String, _ unit : String) -> NSMutableAttributedString{
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let mutableScheduleText = NSMutableAttributedString(string: schedule, attributes: [NSFontAttributeName: AppFonts.sanProSemiBold.withSize(10)])
        let attributedValueText = NSAttributedString(string: value, attributes: [NSFontAttributeName: AppFonts.sansProBold.withSize(18)])
        let attributedUnitText = NSAttributedString(string: unit, attributes: [NSFontAttributeName: AppFonts.sanProSemiBold.withSize(10)])
        
        mutableScheduleText.append(attributedValueText)
        mutableScheduleText.append(attributedUnitText)
        
        return mutableScheduleText
    }
}
