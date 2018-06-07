//
//  CaloriesConsumedCell.swift
//  Mutelcor
//
//  Created by on 21/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import MBCircularProgressBar
class CaloriesConsumedCell: UICollectionViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var caloriesValueLabel: UILabel!
    @IBOutlet weak var caloriesUnitLabel: UILabel!
    @IBOutlet weak var caloriesGoalLabel: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTitle.font = AppFonts.sansProBold.withSize(18)
        let fontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 25 : 30
        self.caloriesValueLabel.font = AppFonts.sansProBold.withSize(fontSize)
        let caloriesUnitFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 17 : 20
        self.caloriesUnitLabel.font = AppFonts.sansProRegular.withSize(caloriesUnitFontSize)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        progressView.progressLineWidth = 25
        progressView.progressCapType = 0
        progressView.emptyLineWidth = 25
        progressView.emptyLineColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 0.513484589)
        progressView.emptyCapType = 0
        progressView.showValueString = false
        progressView.showUnitString = false
    }
    
    func populateDashboardData(_ dashboardData: [DashboardDataModel], _ indexPath: IndexPath){
        
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        
        let consumeCalAngle : Double?
        
        switch indexPath.item {
        case 1:
            guard !data.nutritionCalories.isEmpty else{
                return
            }
            self.activityImage.image = #imageLiteral(resourceName: "dashboardCaloriesconsumed")
            self.cellTitle.text = K_CALORIES_CONSUMED_TEXT.localized
            self.caloriesValueLabel.textColor = #colorLiteral(red: 0.4274509804, green: 0.8196078431, blue: 0.2941176471, alpha: 1)
            let consumecalories = data.nutritionCalories[0].consumeCalories ?? 0
            let planCalories = data.nutritionCalories[0].planCalories ?? 0
            
            let consumeCal = Int(consumecalories)
            let planCal = Int(planCalories)
            
            if consumecalories == 0, planCalories == 0{
                consumeCalAngle = 0
            }else{
                
                let angle = (consumecalories / planCalories ) * 100
                let angleValue = (angle > 100) ? 100 : angle
                consumeCalAngle = angleValue
            }
            
            self.caloriesValueLabel.text = "\(consumeCal)"
            self.caloriesUnitLabel.text = K_CALORIES_UNIT.localized
             let caloriesGoalFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 25 : 29
            let caloriesGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(caloriesGoalFontSize)])
            let planCalAtt = addAttributes("\(planCal)", [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(caloriesGoalFontSize)])
            let caloriesUnitFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 17 : 20
            let calUnit = addAttributes(" \(K_CALORIES_UNIT.localized)", [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(caloriesUnitFontSize)])
            caloriesGoalAtt.append(planCalAtt)
            caloriesGoalAtt.append(calUnit)
            self.caloriesGoalLabel.attributedText = caloriesGoalAtt
            self.setUpCalorieProgress(CGFloat(consumeCalAngle ?? 0), #colorLiteral(red: 0.4274509804, green: 0.8196078431, blue: 0.2941176471, alpha: 1))
        case 2:
            guard !data.activityCalories.isEmpty else{
                return
            }
            self.activityImage.image = #imageLiteral(resourceName: "dashboardCaloriesburnt")
            self.cellTitle.text = K_CALORIES_BURNT_TEXT.localized
            self.caloriesValueLabel.textColor = #colorLiteral(red: 0.9294117647, green: 0.2509803922, blue: 0.2470588235, alpha: 1)
            let consumecalories = data.activityCalories[0].consumeCalories ?? 0
            let planCalories = data.activityCalories[0].planCalories ?? 0
            
            let consumeCal = Int(consumecalories)
            let planCal = Int(planCalories)
            
            if consumecalories == 0, planCalories == 0{
                consumeCalAngle = 0
            }else{
                let angle = (consumecalories / planCalories ) * 100
                let angleValue = (angle > 100) ? 100 : angle
                consumeCalAngle = angleValue
            }
            
            self.caloriesValueLabel.text = "\(consumeCal)"
            self.caloriesUnitLabel.text = K_CALORIES_UNIT.localized
            
            let caloriesGoalFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 25 : 29
            let caloriesGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : AppFonts.sansProRegular.withSize(caloriesGoalFontSize)])
            let planCalAtt = addAttributes("\(planCal)", [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(caloriesGoalFontSize)])
            let caloriesUnitFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 17 : 20
            let calUnit = addAttributes(" \(K_CALORIES_UNIT.localized)", [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(caloriesUnitFontSize)])
            caloriesGoalAtt.append(planCalAtt)
            caloriesGoalAtt.append(calUnit)
            self.caloriesGoalLabel.attributedText = caloriesGoalAtt
            self.setUpCalorieProgress(CGFloat(consumeCalAngle ?? 0), #colorLiteral(red: 0.9294117647, green: 0.2509803922, blue: 0.2470588235, alpha: 1))
        default:
            return
        }
    }
    
    fileprivate func setUpCalorieProgress(_ angle : CGFloat, _ color : UIColor){
        
        self.progressView.progressColor = color
        self.progressView.progressStrokeColor = color
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.value = angle
        }
    }
}
