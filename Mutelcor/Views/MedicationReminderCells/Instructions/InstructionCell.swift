//
//  InstructionCell.swift
//  Mutelcor
//
//  Created by on 29/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

enum ReminderInstruction {
    case beforeMealType
    case afterMeal
    case duringMeal
    case none
    
    var text: String {
        switch self {
        case .beforeMealType:
            return K_BEFORE_MEAL_TITLE.localized
        case .afterMeal:
            return K_AFTER_MEAL_TITLE.localized
        case .duringMeal:
            return K_DURING_MEAL_TITLE.localized
        case .none:
            return K_NONE_TITLE.localized
        }
    }
    
    init?(string: String) {
        switch string {
        case K_BEFORE_MEAL_TITLE.localized:
            self = .beforeMealType
        case K_AFTER_MEAL_TITLE.localized:
            self = .afterMeal
        case K_DURING_MEAL_TITLE.localized:
            self = .duringMeal
        case K_NONE_TITLE.localized:
            self = .none
        default:
            return nil
        }
    }
}

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
    
    // MARk: Table Cell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.beforeMealBtnOutlt.removeTarget(nil, action: nil, for: .allEvents)
        self.afterMealBtnOutlt.removeTarget(nil, action: nil, for: .allEvents)
        self.duringMealBtnOutlt.removeTarget(nil, action: nil, for: .allEvents)
        self.noneBtnOutlt.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARk: Public Methods
    func setBtnSelected(_ btn: UIButton) {
        afterMealBtnOutlt.isSelected = false
        duringMealBtnOutlt.isSelected = false
        beforeMealBtnOutlt.isSelected = false
        noneBtnOutlt.isSelected = false
        btn.isSelected = true
    }
    
    func setInstructionSelected(_ instruction: ReminderInstruction) {
        switch instruction {
        case .beforeMealType:
            setBtnSelected(beforeMealBtnOutlt)
        case .afterMeal:
            setBtnSelected(afterMealBtnOutlt)
        case .duringMeal:
            setBtnSelected(duringMealBtnOutlt)
        case .none:
            setBtnSelected(noneBtnOutlt)
        }
    }
    
}

extension InstructionCell {
    
    fileprivate func setupUI(){
        
        for label in [self.beforeMealLabel,self.afterMealLabel,self.duringMealLabel,self.noneLabel]{
            if DeviceType.IS_IPHONE_5 {
                label?.font = AppFonts.sansProRegular.withSize(15.9)
            }else{
              label?.font = AppFonts.sansProRegular.withSize(18)
            }
        }
        
        for button in [self.beforeMealBtnOutlt, self.afterMealBtnOutlt, self.duringMealBtnOutlt, self.noneBtnOutlt]{
            button?.setImage(#imageLiteral(resourceName: "icNotificationCheck"), for: .selected)
            button?.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
            button?.tintColor = UIColor.clear
        }
        
        self.beforeMealLabel.text = K_BEFORE_MEAL_TITLE.localized
        self.afterMealLabel.text = K_AFTER_MEAL_TITLE.localized
        self.duringMealLabel.text = K_DURING_MEAL_TITLE.localized
        self.noneLabel.text = K_NONE_TITLE.localized
    }
}
