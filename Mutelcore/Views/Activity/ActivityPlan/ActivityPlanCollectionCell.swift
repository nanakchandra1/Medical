//
//  ActivityPlanCollectionCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ActivityPlanCollectionCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var activityValueLabel: UILabel!
    @IBOutlet weak var activityUnitLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}

extension ActivityPlanCollectionCell {
    
    fileprivate func setupUI(){
     
        self.activityValueLabel.font = AppFonts.sansProBold.withSize(27)
        self.activityUnitLabel.font = AppFonts.sansProRegular.withSize(13.6)
        self.averageLabel.font = AppFonts.sansProRegular.withSize(11.3)
        
    }
}
