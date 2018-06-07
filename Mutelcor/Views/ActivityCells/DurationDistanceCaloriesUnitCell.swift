//
//  DurationDistanceCaloriesUnitCell.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DurationDistanceCaloriesUnitCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
   
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//==============
extension DurationDistanceCaloriesUnitCell {
    
    fileprivate func setupUI(){
        
        for view in [self.durationView, self.distanceView, self.caloriesView]{
            view?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            view?.roundCorner(radius: 2.5, borderColor: UIColor.clear, borderWidth: 0.0)
        }
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func populateData(_ totalDuration : Double, _ totalDistance : Double, _ totalCalories : Double){
        
        let duration = totalDuration.cleanValue
        let distance = totalDistance.cleanValue
        let calories = Int(totalCalories.rounded(.toNearestOrAwayFromZero))
        
        let durationMutableAttributes = NSMutableAttributedString(string: "\(K_DURATION_BUTTON.localized) : ", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(12)])
        let distanceMutableAttributes = NSMutableAttributedString(string: "\(K_DISTANCE_BUTTON.localized) : ", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(12)])
        let caloriesMutableAttributes = NSMutableAttributedString(string: "\(K_CALORIES_BUTTON.localized) : ", attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(12)])
        
        let durationUnit = duration == "\(false.rawValue)" || duration == "\(true.rawValue)" ? K_MINUTE_UNIT : K_MINUTES_UNIT
        var distanceUnit = ""
        if let dist = Int(distance) , dist > 1 {
            distanceUnit = K_KILOMETERS_UNIT.localized
        }else{
            distanceUnit = K_KILOMETER_UNIT.localized
        }

        durationMutableAttributes.append(NSAttributedString(string: duration + " " + durationUnit.localized, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(10)]))
        distanceMutableAttributes.append(NSAttributedString(string: distance + " " + distanceUnit, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(10)]))
        caloriesMutableAttributes.append(NSAttributedString(string: "\(calories) \(K_CALORIES_UNIT.localized)", attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(10)]))
        
        self.durationLabel.attributedText = durationMutableAttributes
        self.distanceLabel.attributedText = distanceMutableAttributes
        self.caloriesLabel.attributedText = caloriesMutableAttributes
    }
}
