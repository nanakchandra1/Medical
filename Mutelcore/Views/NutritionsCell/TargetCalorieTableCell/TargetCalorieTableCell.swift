//
//  TargetCalorieTableCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 23/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class TargetCalorieTableCell: UITableViewCell {
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var viewAttachmentBtn: UIButton!
    
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet weak var dietTableView: DietAutoResizingTableView!
    @IBOutlet weak var nutrientsCollectionView: UICollectionView!
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var avoidFoodsBtn: UIButton!
    @IBOutlet weak var buttonSepratorView: UIView!
    @IBOutlet weak var dailyAllowancesBtn: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = "No Records Found!"
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        dietTableView.register(UINib(nibName: "NutrientLabelTableCell", bundle: nil), forCellReuseIdentifier: "nutrientLabelTableCellID")
        nutrientsCollectionView.register(UINib(nibName: "ActivityPlanCollectionCell", bundle: nil), forCellWithReuseIdentifier: "activityPlanCollectionCellID")
        
        let previousDateCellNib = UINib(nibName: "PreviousActivityDurationDateCell", bundle: nil)
        self.dietTableView.register(previousDateCellNib, forCellReuseIdentifier: "previousActivityDurationDateCellID")
        
        let viewAttachmentCellNib = UINib(nibName: "ViewAttachmentCell", bundle: nil)
        self.dietTableView.register(viewAttachmentCellNib, forCellReuseIdentifier: "viewAttachmentCellID")
        
        self.avoidFoodsBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.avoidFoodsBtn.setTitleColor(UIColor.white, for: .normal)
        self.avoidFoodsBtn.setTitle("FOOD TO AVOID", for: .normal)
        
        self.buttonSepratorView.backgroundColor = UIColor.dosBtnSepratorColor
        
        self.dailyAllowancesBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.dailyAllowancesBtn.setTitleColor(UIColor.white, for: .normal)
        self.dailyAllowancesBtn.setTitle("DAILY ALLOWANCES", for: .normal)
        
        self.shareImageView.roundCorner(radius: 2.2, borderColor: .appColor, borderWidth: 1)
        
        self.viewAttachmentBtn.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.viewAttachmentBtn.setImage(#imageLiteral(resourceName: "icActivityplanGreenattachment"), for: .normal)
        self.viewAttachmentBtn.tintColor = UIColor.appColor
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        gradientView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //totalCaloriesLabel.text = nil
    }
    
    func setAttributes(_ value : String, text: String, label: UILabel){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let mutableAttributedText = NSMutableAttributedString(string: text)
        let valueLength = value.characters.count
        
        mutableAttributedText.setAttributes([NSFontAttributeName: AppFonts.sanProSemiBold.withSize(20), NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(mutableAttributedText.length - valueLength, valueLength))
        
        label.attributedText = mutableAttributedText
    }
    
    func populateData(_ previousNutritionPlan : [NutritionPlan]){
        
       if previousNutritionPlan.isEmpty {
            
            self.noDataAvailiableLabel.isHidden = false
            self.viewContainAllObjects.isHidden = true
        }else{
            
            self.noDataAvailiableLabel.isHidden = true
            self.viewContainAllObjects.isHidden = false
            
        }
    }
}
