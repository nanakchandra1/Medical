//
//  ActivityPlanCollectionCell.swift
//  Mutelcor
//
//  Created by on 15/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ActivityPlanCollectionCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var activityValueLabel: UILabel!
    @IBOutlet weak var activityUnitLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()        
    }
}

extension ActivityPlanCollectionCell {
    
    fileprivate func setupUI(){
        
        self.activityUnitLabel.text = ""
        self.averageLabel.text = ""
        self.activityValueLabel.text = ""
        self.activityValueLabel.font = AppFonts.sansProBold.withSize(27)
        self.activityUnitLabel.font = AppFonts.sansProRegular.withSize(13.6)
        self.averageLabel.font = AppFonts.sansProRegular.withSize(11.3)
        
    }
    
    func populatePreviousPlanData(duration: Double, distance: Double, calories: Int, indexPath: IndexPath){
        
        if indexPath.item == false.rawValue {
            self.cellImageView.image = #imageLiteral(resourceName: "icActivityplanClock")
            self.activityValueLabel.text = duration.cleanValue
            self.activityValueLabel.textColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
            let durationUnit = duration > 1 ? K_MINUTES_UNIT : K_MINUTE_UNIT
            self.activityUnitLabel.text = durationUnit.localized
            
        }else if indexPath.item == true.rawValue {
            self.cellImageView.image = #imageLiteral(resourceName: "icActivityplanDistance")
            self.activityValueLabel.text = distance.cleanValue
            self.activityValueLabel.textColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
            let distanceUnit = distance > 1 ? K_KILOMETERS_UNIT : K_KILOMETER_UNIT
            self.activityUnitLabel.text = distanceUnit.localized
            
        }else {
            self.cellImageView.image = #imageLiteral(resourceName: "icActivityplanCal")
            self.activityValueLabel.text = String(calories)
            self.activityValueLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.05098039216, alpha: 1)
            self.activityUnitLabel.text = K_CALORIES_UNIT.localized
        }
    }
}
