//
//  NutrientsCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NutrientsCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var nutrientsNameLabel: UILabel!
    @IBOutlet weak var targetValueLabel: UILabel!
    @IBOutlet weak var consumedValueLabel: UILabel!
    @IBOutlet weak var verticalNutrientsSepratorView: UIView!
    @IBOutlet weak var verticalTargetSepratorView: UIView!
    @IBOutlet weak var bottomSepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

extension NutrientsCell {
    
    fileprivate func setupUI(){
        
        self.verticalTargetSepratorView.backgroundColor = UIColor.clear
        self.verticalNutrientsSepratorView.backgroundColor = UIColor.clear
        self.bottomSepratorView.backgroundColor = UIColor.clear
        
        self.verticalTargetSepratorView.dashLine(CGPoint(x: CGFloat.leastNormalMagnitude, y: self.layer.frame.origin.y - 5), CGPoint(x: 0, y: self.layer.frame.height))
        self.verticalNutrientsSepratorView.dashLine(CGPoint(x: CGFloat.leastNormalMagnitude, y: self.layer.frame.origin.y - 5), CGPoint(x: 0, y: self.layer.frame.height))
        self.bottomSepratorView.dashLine(CGPoint(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude), CGPoint(x: self.layer.frame.width, y: 0))
        
        self.nutrientsNameLabel.font = AppFonts.sanProSemiBold.withSize(13)
        self.nutrientsNameLabel.textColor = UIColor.appColor
        self.targetValueLabel.font = AppFonts.sanProSemiBold.withSize(13)
        self.consumedValueLabel.font = AppFonts.sanProSemiBold.withSize(13)
        self.bottomSepratorView.isHidden = false
    }
    
    func populateData(_ dayWiseData : [DayWiseNutrition], _ indexPath : IndexPath){
        
        guard !dayWiseData.isEmpty else{
            return
        }
        
        let attr1 = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(16)]
        let attr2 = [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(12)]
        let isSperatorHidden = indexPath.row == 4 ? true : false
        self.bottomSepratorView.isHidden = isSperatorHidden
        
        switch indexPath.row {
            
        case 0:
            
            let consumeCal = dayWiseData[0].consumeCalories?.rounded(.toNearestOrAwayFromZero)
            let targetCal = dayWiseData[0].planCalories?.rounded(.toNearestOrAwayFromZero)
            
            self.targetValueLabel.attributedText = self.attrributedText(consumeCal, targetCal, true, unit: " \(K_CALORIES_UNIT.localized)", attr1, attr2)
            self.consumedValueLabel.attributedText = self.attrributedText(consumeCal, targetCal, false, unit: " \(K_CALORIES_UNIT.localized)", attr1, attr2)
        case 1:
            let consumeCarbs = dayWiseData[0].consumeCrubs
            let targetCarbs = dayWiseData[0].planCrabs
            
            var conCarbs: Double = 0
            var tarCarbs: Double = 0
            var consumeCarbUnit: String = " \(K_GRAM_TITLE.localized)"
            var targetCarbUnit: String = " \(K_GRAM_TITLE.localized)"
            if let carb = consumeCarbs, carb > 999 {
                conCarbs = carb/1000
                consumeCarbUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                conCarbs = consumeCarbs ?? 0
                consumeCarbUnit = " \(K_GRAM_TITLE.localized)"
            }
            if let target = targetCarbs, target > 999 {
                tarCarbs = target/1000
                targetCarbUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                tarCarbs = targetCarbs ?? 0
                targetCarbUnit = " \(K_GRAM_TITLE.localized)"
            }
            
            self.targetValueLabel.attributedText = self.attrributedText(conCarbs, tarCarbs, true, unit: targetCarbUnit, attr1, attr2)
            self.consumedValueLabel.attributedText = self.attrributedText(conCarbs, tarCarbs, false, unit: consumeCarbUnit, attr1, attr2)

        case 2:
            let consumeFats = dayWiseData[0].consumeFats
            let targetFats = dayWiseData[0].planFats
            var conFats: Double = 0
            var tarFats: Double = 0
            var consumeFatsUnit: String = " \(K_GRAM_TITLE.localized)"
            var targetFatsUnit: String = " \(K_GRAM_TITLE.localized)"
            if let fat = consumeFats, fat > 999 {
                conFats = fat/1000
                consumeFatsUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                conFats = consumeFats ?? 0
                consumeFatsUnit = " \(K_GRAM_TITLE.localized)"
            }
            if let target = targetFats, target > 999 {
                tarFats = target/1000
                targetFatsUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                tarFats = targetFats ?? 0
                targetFatsUnit = " \(K_GRAM_TITLE.localized)"
            }
            self.targetValueLabel.attributedText = self.attrributedText(conFats, tarFats, true, unit: targetFatsUnit, attr1, attr2)
            self.consumedValueLabel.attributedText = self.attrributedText(conFats, tarFats, false, unit: consumeFatsUnit, attr1, attr2)

        case 3:
            let consumeProtien = dayWiseData[0].consumeProtiens
            let targetProtien = dayWiseData[0].planProtiens
            var conProtein: Double = 0
            var tarProtein: Double = 0
            var consumeProteinUnit: String = " \(K_GRAM_TITLE.localized)"
            var targetProteinUnit: String = " \(K_GRAM_TITLE.localized)"
            if let carb = consumeProtien, carb > 999 {
                conProtein = carb/1000
                consumeProteinUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                conProtein = consumeProtien ?? 0
                consumeProteinUnit = " \(K_GRAM_TITLE.localized)"
            }
            if let target = targetProtien, target > 999 {
                tarProtein = target/1000
                targetProteinUnit = " \(K_KILOGRAM_TITLE.localized)"
            }else{
                tarProtein = targetProtien ?? 0
                targetProteinUnit = " \(K_GRAM_TITLE.localized)"
            }
            self.targetValueLabel.attributedText = self.attrributedText(conProtein, tarProtein, true, unit: targetProteinUnit, attr1, attr2)
            self.consumedValueLabel.attributedText = self.attrributedText(conProtein, tarProtein, false, unit: consumeProteinUnit, attr1, attr2)

        case 4:
            let consumeWater = dayWiseData[0].consumeWater
            let targetWater = dayWiseData[0].planWater
            
            self.targetValueLabel.attributedText = self.attrributedText(consumeWater, targetWater, true, unit: " \(K_LITRE_TITLE.localized)", attr1, attr2)
            self.consumedValueLabel.attributedText = self.attrributedText(consumeWater, targetWater, false, unit: " \(K_LITRE_TITLE.localized)", attr1, attr2)

        default :
            return
        }
    }
    
    fileprivate func attrributedText (_ consumeData : Double?,_ givenData : Double?, _ targetData : Bool, unit : String, _ attributes1 : [NSAttributedStringKey : Any]?, _ attributes2 : [NSAttributedStringKey : Any]?) -> NSMutableAttributedString{
        
        let consDataInString = consumeData?.cleanValue ?? "0"//String(describing : consumeData!)
        let givenDataInString = givenData?.cleanValue ?? "0"//String(describing : givenData!)
        
        let percentageConsumed = ((consumeData ?? 0)/(givenData ?? 0)) * 100
        var precentageCons = "0"
        
        if percentageConsumed.isNaN {
            precentageCons = "0"
        }else if percentageConsumed.isInfinite {
            precentageCons = "100"
        }else{
                precentageCons = String(describing : Int(percentageConsumed))
        }
        
        if targetData {
            let givenData = NSMutableAttributedString(string: givenDataInString, attributes: attributes1)
            let attString = NSAttributedString(string: unit, attributes: attributes2)
            givenData.append(attString)
            
            return givenData
        }else{
            var color : UIColor = UIColor.appColor
            if percentageConsumed > 100 {
                color = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
                
            }else if percentageConsumed > 70, percentageConsumed < 101 {
                color = UIColor.appColor
            }else {
                color = #colorLiteral(red: 1, green: 0.6588235294, blue: 0, alpha: 1)
            }
            
            let attributes = [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(16),
                              NSAttributedStringKey.foregroundColor : color] as [NSAttributedStringKey : Any]?
            
            let consumData = NSMutableAttributedString(string: consDataInString, attributes: attributes1)
            let unitAttributes = NSAttributedString(string: unit, attributes: attributes2)
            let leftCurl = NSAttributedString(string: " (", attributes: attributes1)
            let rightCurl = NSAttributedString(string: ")", attributes: attributes1)
            let percentageData = NSAttributedString(string: "\(precentageCons)%", attributes: attributes)
            
            consumData.append(unitAttributes)
            consumData.append(leftCurl)
            consumData.append(percentageData)
            consumData.append(rightCurl)
            
            return consumData
        }
    }
}
