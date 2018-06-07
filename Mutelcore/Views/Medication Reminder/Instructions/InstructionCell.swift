//
//  InstructionCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 29/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class InstructionCell: UITableViewCell {
    
//    MARK:- IBOUtlets
//    ================
    @IBOutlet weak var cellTitleOutlt: UILabel!
    @IBOutlet weak var beforeMealBtnOutlt: UIButton!
    @IBOutlet weak var beforeMealLabel: UILabel!
    @IBOutlet weak var afterMealBtnOutlt: UIButton!
    @IBOutlet weak var afterMealLabel: UILabel!
    @IBOutlet weak var duringMealBtnOutlt: UIButton!
    @IBOutlet weak var duringMealLabel: UILabel!
    @IBOutlet weak var noneBtnOutlt: UIButton!
    @IBOutlet weak var noneLabel: UILabel!
    
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

extension InstructionCell {
    
    fileprivate func setupUI(){
        
        for btn in [self.beforeMealBtnOutlt,self.afterMealBtnOutlt,self.duringMealBtnOutlt,self.noneBtnOutlt]{
            
            btn?.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
            btn?.setImage(#imageLiteral(resourceName: "icAppointmentCompletedGreen"), for: .selected)
            btn?.setTitle("", for: .normal)
            btn?.tintColor = UIColor.clear
            
        }
        
        for label in [self.beforeMealLabel,self.afterMealLabel,self.duringMealLabel,self.noneLabel]{
            
            if DeviceType.IS_IPHONE_5 {
                
                label?.font = AppFonts.sansProRegular.withSize(15.9)
            }else{
                
              label?.font = AppFonts.sansProRegular.withSize(18)
            }
        }
        
        self.beforeMealLabel.text = "Before Meal"
        self.afterMealLabel.text = "After Meal"
        self.duringMealLabel.text = "During Meal"
        self.noneLabel.text = "None"
    }
}
