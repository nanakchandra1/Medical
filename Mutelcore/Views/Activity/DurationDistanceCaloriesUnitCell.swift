//
//  DurationDistanceCaloriesUnitCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        let duration = Int(totalDuration.rounded(.toNearestOrAwayFromZero))
        let distance = Int(totalDistance.rounded(.toNearestOrAwayFromZero))
        let calories = Int(totalCalories.rounded(.toNearestOrAwayFromZero))
        
        let durationMutableAttributes = NSMutableAttributedString(string: "Duration : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(10)])
        let distanceMutableAttributes = NSMutableAttributedString(string: "Distance : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(10)])
        let caloriesMutableAttributes = NSMutableAttributedString(string: "Calories : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(10)])
        
        durationMutableAttributes.append(NSAttributedString(string: "\(duration) mins", attributes: [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(10)]))
        distanceMutableAttributes.append(NSAttributedString(string: "\(distance) kms", attributes: [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(10)]))
        caloriesMutableAttributes.append(NSAttributedString(string: "\(calories) kcal", attributes: [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(10)]))
        
        self.durationLabel.attributedText = durationMutableAttributes
        self.distanceLabel.attributedText = distanceMutableAttributes
        self.caloriesLabel.attributedText = caloriesMutableAttributes
        
    }
}
