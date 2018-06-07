//
//  HavingNutritionDurationCell.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class HavingNutritionDurationCell: UICollectionViewCell {

//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var cellButtonOutlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension HavingNutritionDurationCell {
    
   fileprivate func setupUI(){
        
        self.cellButtonOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
          self.contentView.backgroundColor = UIColor.white
    
    let fontSize = (DeviceType.IS_IPHONE_5) ? 9 : 11.3
    self.cellButtonOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(CGFloat(fontSize))
  }
}
