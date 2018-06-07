//
//  WaterIntakeCell.swift
//  Mutelcor
//
//  Created by on 21/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DashBoardTimeLineCell: UICollectionViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timelineProcessLabel: UILabel!
    @IBOutlet weak var beforLbl: UILabel!
    @IBOutlet weak var beforeImg: UIImageView!
    @IBOutlet weak var afterImg: UIImageView!
    @IBOutlet weak var afterLbl: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        self.timelineProcessLabel.font = AppFonts.sansProBold.withSize(18)
        self.beforLbl.text = K_BEFORE.localized
        self.afterLbl.text = K_AFTER.localized
        self.timelineProcessLabel.text = K_TIMELINE_PROGRESE.localized
        self.bgView.shadow()
        self.bgView.layer.borderColor = UIColor.lightGray.cgColor
        self.bgView.layer.borderWidth = 1
        self.bgView.shadow(2.2, CGSize(width: 0.7, height: 1.5), UIColor.navigationBarShadowColor)
        self.bgView.clipsToBounds = false
        self.afterLbl.font  = AppFonts.sanProSemiBold.withSize(16)
        self.beforLbl.font  = AppFonts.sanProSemiBold.withSize(16)
        self.timelineProcessLabel.font  = AppFonts.sanProSemiBold.withSize(16)


    }
    
}
