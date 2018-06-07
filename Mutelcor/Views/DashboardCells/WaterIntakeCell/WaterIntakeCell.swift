//
//  WaterIntakeCell.swift
//  Mutelcor
//
//  Created by on 21/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class WaterIntakeCell: UICollectionViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var waterIntakeLabel: UILabel!
    @IBOutlet weak var waterConsumed: UILabel!
    @IBOutlet weak var waterGoal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.waterIntakeLabel.font = AppFonts.sansProBold.withSize(18)
    }
    
    func populateDashboardData(_ dashboardData: [DashboardDataModel], _ indexPath: IndexPath) {
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        guard !data.nutritionCalories.isEmpty else{
            return
        }
        self.waterIntakeLabel.text = K_WATER_INTAKE_TEXT.localized
        let consumeWater = data.nutritionCalories[0].consumeWater?.cleanValue ?? "0"
        let planWater = data.nutritionCalories[0].planWater?.cleanValue ?? "0"
        let waterGoalFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 25 : 29
        let waterGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(waterGoalFontSize)])
        let planWaterAtt = addAttributes(planWater, [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(waterGoalFontSize)])
        let waterunitFontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 17 : 20
        let waterUnit = addAttributes(" l", [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(waterunitFontSize)])
        
        let consumeWaterAtt = NSMutableAttributedString(string: consumeWater, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(40)])
        let consumeWaterUnit = addAttributes(" l", [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(30)])
        
        consumeWaterAtt.append(consumeWaterUnit)
        waterGoalAtt.append(planWaterAtt)
        waterGoalAtt.append(waterUnit)
        
        self.waterConsumed.attributedText = consumeWaterAtt
        self.waterGoal.attributedText = waterGoalAtt
    }
}
