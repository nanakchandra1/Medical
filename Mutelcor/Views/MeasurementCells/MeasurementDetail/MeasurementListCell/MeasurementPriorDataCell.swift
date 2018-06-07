//
//  MeasurementPriorDataCell.swift
//  Mutelcor
//
//  Created by on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MeasurementPriorDataCell: UICollectionViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var measurementDataLabel: UILabel!
    @IBOutlet weak var measurementDataUnitlabel: UILabel!
    @IBOutlet weak var measurementName: UILabel!
    @IBOutlet weak var seprator: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setupUI()
        
    }
}

//MARK:- Methods
//==============
extension MeasurementPriorDataCell {
    
    fileprivate func setupUI(){
     
        self.roundCorner(radius: 2.0, borderColor: UIColor.clear, borderWidth: 0.0)
        
        self.dateLabel.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.dateLabel.textColor = UIColor.grayLabelColor
        
        self.timeLabel.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.timeLabel.textColor = UIColor.grayLabelColor
        
        self.measurementDataLabel.font = AppFonts.sansProBold.withSize(27)
        
        self.measurementDataUnitlabel.font = AppFonts.sansProRegular.withSize(13)
        
        self.measurementName.font = AppFonts.sansProBold.withSize(14)
        
    }

}
