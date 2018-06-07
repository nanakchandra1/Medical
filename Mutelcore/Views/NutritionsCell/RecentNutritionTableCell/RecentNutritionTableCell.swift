//
//  RecentNutritionTableCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 21/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
        foodNutrientLabel.text = "Carb: \(food.carbs)g, Fats: \(food.fats)g, Proteins: \(food.proteins)g"
    }
    
}

