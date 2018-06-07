//
//  DischargeSummaryCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 03/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DischargeSummaryCell: UITableViewCell {
    
//    IBOutlets
//    =========
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var dischargeDateLabel: UILabel!
    @IBOutlet weak var dischargeMonthLabel: UILabel!
    @IBOutlet weak var dischargeTimeLabel: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var shareBtnOutlt: UIButton!
    
    @IBOutlet weak var surgeryTypeLabel: UILabel!
    @IBOutlet weak var operativeApproachLabel: UILabel!
    @IBOutlet weak var surgeryProcedureLabel: UILabel!
    
    @IBOutlet weak var dateIntervalView: UIView!
    @IBOutlet weak var dischargeDateIntervalView: UIView!
    @IBOutlet weak var dischargeDateInnerIntervalView: UIView!
    @IBOutlet weak var dischargeDateDotLineView: UIView!
    
    @IBOutlet weak var admissionDateIntervalView: UIView!
    @IBOutlet weak var admissionDateInnerIntervalView: UIView!
    @IBOutlet weak var admissionDateDotLineView: UIView!
    
    @IBOutlet weak var surgeryDateIntervalView: UIView!
    @IBOutlet weak var surgeryDateInnerIntervalView: UIView!
    @IBOutlet weak var surgeryDateDotLineView: UIView!
    
    @IBOutlet weak var admissionDateLabel: UILabel!
    @IBOutlet weak var surgeyDateLabel: UILabel!
    @IBOutlet weak var dischargedDatLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var outerView: UIView!
    
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

extension DischargeSummaryCell {
    
    fileprivate func setupUI(){
        
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.clipsToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        self.dischargeDateLabel.font = AppFonts.sansProBold.withSize(29)
        self.dischargeMonthLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.dischargeTimeLabel.font = AppFonts.sanProSemiBold.withSize(12)
        self.doctorName.font = AppFonts.sanProSemiBold.withSize(18)
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(11.3)
        
        self.shareBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.shareBtnOutlt.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: .normal)
        
        self.dischargeDateIntervalView.roundCorner(radius: self.dischargeDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.dischargeDateInnerIntervalView.roundCorner(radius: self.dischargeDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.dischargeDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.dischargeDateIntervalView.backgroundColor = UIColor.white
        self.dischargeDateDotLineView.backgroundColor = UIColor.clear
        
        self.admissionDateIntervalView.roundCorner(radius: self.admissionDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.admissionDateInnerIntervalView.roundCorner(radius: self.admissionDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.admissionDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.admissionDateIntervalView.backgroundColor = UIColor.white
        self.admissionDateDotLineView.backgroundColor = UIColor.clear
        
        self.surgeryDateIntervalView.roundCorner(radius: self.surgeryDateIntervalView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.surgeryDateInnerIntervalView.roundCorner(radius: self.surgeryDateInnerIntervalView.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.surgeryDateInnerIntervalView.backgroundColor = UIColor.appColor
        self.surgeryDateIntervalView.backgroundColor = UIColor.white
        self.surgeryDateDotLineView.backgroundColor = UIColor.clear
        
        self.admissionDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.admissionDateDotLineView.layer.bounds.height), [3,2])
        self.surgeryDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.surgeryDateDotLineView.layer.bounds.height), [3,2])
        self.dischargeDateDotLineView.dashLine(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.dischargeDateDotLineView.layer.bounds.height), [3,2])
        
        self.shareBtnOutlt.tintColor = UIColor.appColor
        
        for label in [self.admissionDateLabel, self.surgeyDateLabel, self.dischargedDatLabel, self.descriptionLabel]{
            
         label?.font = AppFonts.sansProRegular.withSize(14)
        }
    }
}
