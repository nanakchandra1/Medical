//
//  MeasurementListCollection.swift
//  Mutelcore
//
//  Created by Appinventiv on 30/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MeasurementListCollectionCell: UITableViewCell {

//    MARK:- Proporties
//    =================

    
    
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
        // Initialization code
     
        self.setupUI()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Methods
//==============
extension MeasurementListCollectionCell {
    
//    Initial Setups
    fileprivate func setupUI(){
        
        self.contentView.backgroundColor = UIColor.activityVCBackgroundColor
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.measurementListCollectionView.bounces = false
        
        self.noRecordImageOutlt.isHidden = true
        self.noRecordLabelOutlt.isHidden = true
        
        self.noRecordLabelOutlt.font = AppFonts.sanProSemiBold.withSize(16)
        self.noRecordLabelOutlt.textColor = UIColor.appColor
        
        self.registerNibs()
    
    }
    
//    registerNibs
    fileprivate func registerNibs(){
        
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

    }
}
