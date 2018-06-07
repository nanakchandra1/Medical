//
//  RecurrenceCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 29/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class RecurrenceCell: UITableViewCell {
    
//    MARK:- Proporties
//    ==================
    
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var sundayBtnOutlt: UIButton!
    @IBOutlet weak var mondayBtnOutlt: UIButton!
    @IBOutlet weak var tuesdayBtnOutlt: UIButton!
    @IBOutlet weak var wednesdayBtnOUtlt: UIButton!
    @IBOutlet weak var thursdayBtnOutlt: UIButton!
    @IBOutlet weak var fridayBtnOutlt: UIButton!
    @IBOutlet weak var saturdayBtnOutlt: UIButton!
    
    
    
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

extension RecurrenceCell {
    
    fileprivate func setupUI(){
        
        for btn in [self.sundayBtnOutlt,self.mondayBtnOutlt,self.tuesdayBtnOutlt,self.wednesdayBtnOUtlt,self.thursdayBtnOutlt,self.fridayBtnOutlt,self.saturdayBtnOutlt,]{
            
            btn?.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
            btn?.setTitleColor(UIColor.appColor, for: .normal)
            
        }
        
        self.sundayBtnOutlt.setTitle("Sun", for: UIControlState.normal)
        self.mondayBtnOutlt.setTitle("Mon", for: UIControlState.normal)
        self.tuesdayBtnOutlt.setTitle("Tue", for: UIControlState.normal)
        self.wednesdayBtnOUtlt.setTitle("Wed", for: UIControlState.normal)
        self.thursdayBtnOutlt.setTitle("Thur", for: UIControlState.normal)
        self.fridayBtnOutlt.setTitle("Fri", for: UIControlState.normal)
        self.saturdayBtnOutlt.setTitle("Sat", for: UIControlState.normal)
        
        self.cellTitle.font = AppFonts.sansProRegular.withSize(15.9)
        self.cellTitle.text = "Recurrence"
    }
}
