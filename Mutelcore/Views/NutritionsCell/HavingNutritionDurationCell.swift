//
//  HavingNutritionDurationCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class HavingNutritionDurationCell: UICollectionViewCell {

//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var cellButtonOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
}

extension HavingNutritionDurationCell {
    
   fileprivate func setupUI(){
        
        self.cellButtonOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
          self.contentView.backgroundColor = UIColor.white
    
    if DeviceType.IS_IPHONE_5{
        
        self.cellButtonOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(9)
    }else{
        
        self.cellButtonOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.3)
    }
    
  }
}
