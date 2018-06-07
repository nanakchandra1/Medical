//
//  RecentNutritionTableCell.swift
//  Mutelcor
//
//  Created by on 21/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class RecentNutritionTableCell: UITableViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodNutrientLabel: UILabel!
    @IBOutlet weak var addRecentNutritionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addRecentNutritionBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARK: Public Methods
    func populate(with food: RecentFood) {
        foodNameLabel.text = "\(food.name), \(food.quantity) \(food.unit), \(food.calories) Cal"
        foodNutrientLabel.text = "Carb: \(food.carbs)g, Fats: \(food.fats)g, Protiens: \(food.proteins)g"
    }
    
    func populateData(_ recentSymptoms : [RecentSymptoms], _ indexPath : IndexPath, _ symptomsSeverity: [String]){
        
        guard !recentSymptoms.isEmpty else{
            return
        }
        
        foodNameLabel.text = recentSymptoms[indexPath.row].symptomName
        
        let date = recentSymptoms[indexPath.row].symptomDate
        let convertedDate = date?.changeDateFormat(.utcTime, .dMMMyyyy)
        let time = recentSymptoms[indexPath.row].symptomTime ?? ""
        var severe = ""
        if let severity = recentSymptoms[indexPath.row].symptomSeverity {
            switch severity {
            case 1:
                severe = symptomsSeverity[0]
            case 2:
                severe = symptomsSeverity[1]
            case 3:
                severe = symptomsSeverity[2]
            default:
                severe = symptomsSeverity[0]
            }
        }
        
        let frequency = recentSymptoms[indexPath.row].symptomFrequency ?? ""
        foodNutrientLabel.text = "\(convertedDate ?? ""), \(time), \(severe), \(frequency)"
    }
}

