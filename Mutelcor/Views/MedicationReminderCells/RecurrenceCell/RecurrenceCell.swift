//
//  RecurrenceCell.swift
//  Mutelcor
//
//  Created by on 29/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class RecurrenceCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var sundayBtnOutlt: IndexedButton!
    @IBOutlet weak var mondayBtnOutlt: IndexedButton!
    @IBOutlet weak var tuesdayBtnOutlt: IndexedButton!
    @IBOutlet weak var wednesdayBtnOUtlt: IndexedButton!
    @IBOutlet weak var thursdayBtnOutlt: IndexedButton!
    @IBOutlet weak var fridayBtnOutlt: IndexedButton!
    @IBOutlet weak var saturdayBtnOutlt: IndexedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for btn in [self.sundayBtnOutlt,self.mondayBtnOutlt,self.tuesdayBtnOutlt,self.wednesdayBtnOUtlt,self.thursdayBtnOutlt,self.fridayBtnOutlt,self.saturdayBtnOutlt,]{
            btn?.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
}

extension RecurrenceCell {
    
    fileprivate func setupUI(){
        
        for btn in [self.sundayBtnOutlt,self.mondayBtnOutlt,self.tuesdayBtnOutlt,self.wednesdayBtnOUtlt,self.thursdayBtnOutlt,self.fridayBtnOutlt,self.saturdayBtnOutlt,]{
            
            btn?.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
            btn?.setTitleColor(UIColor.appColor, for: .normal)
            btn?.setTitleColor(UIColor.white, for: .selected)
            btn?.tintColor = UIColor.clear
        }
        
        self.sundayBtnOutlt.setTitle(K_SUN_TITLE.localized, for: UIControlState.normal)
        self.mondayBtnOutlt.setTitle(K_MON_TITLE.localized, for: UIControlState.normal)
        self.tuesdayBtnOutlt.setTitle(K_TUE_TITLE.localized, for: UIControlState.normal)
        self.wednesdayBtnOUtlt.setTitle(K_WED_TITLE.localized, for: UIControlState.normal)
        self.thursdayBtnOutlt.setTitle(K_THUR_TITLE.localized, for: UIControlState.normal)
        self.fridayBtnOutlt.setTitle(K_FRI_TITLE.localized, for: UIControlState.normal)
        self.saturdayBtnOutlt.setTitle(K_SAT_TITLE.localized, for: UIControlState.normal)
        
        for (index, button) in [self.sundayBtnOutlt,self.mondayBtnOutlt,self.tuesdayBtnOutlt,self.wednesdayBtnOUtlt,self.thursdayBtnOutlt,self.fridayBtnOutlt,self.saturdayBtnOutlt].enumerated(){
            button?.outerIndex = index + 1
        }
    }
}
