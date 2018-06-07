//
//  MeasurementListCollection.swift
//  Mutelcor
//
//  Created by on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MeasurementListCollectionCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet weak var measurementListCollectionView: IndexedCollectionView!
    @IBOutlet weak var noRecordImageOutlt: UIImageView!
    @IBOutlet weak var noRecordLabelOutlt: UILabel!
    
    @IBOutlet weak var outerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        self.noRecordImageOutlt.isHidden = true
        self.noRecordLabelOutlt.isHidden = true
    }
}

//MARK:- Methods
//==============
extension MeasurementListCollectionCell {
    
//    Initial Setups
    fileprivate func setupUI(){

        self.noRecordImageOutlt.image = #imageLiteral(resourceName: "icMeasurementNoattachedreports")
        self.noRecordLabelOutlt.text = K_NO_ATTACHED_REPORTS.localized
        
        self.noRecordImageOutlt.isHidden = true
        self.noRecordLabelOutlt.isHidden = true
        
        self.noRecordLabelOutlt.font = AppFonts.sanProSemiBold.withSize(16)
        self.noRecordLabelOutlt.textColor = UIColor.appColor
        
        self.registerNibs()
    }
    
//    registerNibs
    fileprivate func registerNibs() {
        
        let MeasurementPriorDataCellNib = UINib(nibName: "VitalListingCell", bundle: nil)
        self.measurementListCollectionView.register(MeasurementPriorDataCellNib, forCellWithReuseIdentifier: "vitalListingCellID")
        
        let attachmentCellNib = UINib(nibName: "AttachmentCell", bundle: nil)
        self.measurementListCollectionView.register(attachmentCellNib, forCellWithReuseIdentifier: "attachmentCellID")
        
        let activityPlanCollectionCellNib = UINib(nibName: "ActivityPlanCollectionCell", bundle: nil)
        self.measurementListCollectionView.register(activityPlanCollectionCellNib, forCellWithReuseIdentifier: "activityPlanCollectionCellID")
        
        let emptyCollectionCellNib = UINib(nibName: "NoUpcomingAppointmentCell", bundle: nil)
        self.measurementListCollectionView.register(emptyCollectionCellNib, forCellWithReuseIdentifier: "noUpcomingAppointmentCellID")
        
        let havingNutritionDurationCellNib = UINib(nibName: "HavingNutritionDurationCell", bundle: nil)
        self.measurementListCollectionView.register(havingNutritionDurationCellNib, forCellWithReuseIdentifier: "havingNutritionDurationCellID")
        
        let nextScheduleCellNib = UINib(nibName: "NextScheduleCell", bundle: nil)
        self.measurementListCollectionView.register(nextScheduleCellNib, forCellWithReuseIdentifier: "nextScheduleCellID")
    }
    
    func populateData(_ attachmentData : [AttachmentDataModel], _ isServiceHit : Bool){
        self.contentView.isHidden = false
        self.outerViewTopConstraint.constant = 0
        self.outerViewBottomConstraint.constant = 0
        self.outerViewTrailingConstraint.constant = 0
        self.outerViewLeadingConstraint.constant = 0
        
        let attachmentData = (attachmentData.isEmpty && isServiceHit) ? true : false
        self.noRecordImageOutlt.isHidden = !attachmentData
        self.noRecordLabelOutlt.isHidden = !attachmentData
        self.measurementListCollectionView.isHidden = attachmentData
        let backGroundColor = (attachmentData) ? UIColor.white : UIColor.activityVCBackgroundColor
        self.measurementListCollectionView.backgroundColor = backGroundColor
        self.contentView.backgroundColor = backGroundColor
    }
}
