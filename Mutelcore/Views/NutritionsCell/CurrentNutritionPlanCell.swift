//
//  CurrentNutritionPlanCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 23/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class CurrentNutritionPlanCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var shareBtnOutlt: UIButton!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var currentPlanImage: UIImageView!
    @IBOutlet weak var caloriesValue: UILabel!
    @IBOutlet weak var viewAttachmentBtn: UIButton!
    @IBOutlet weak var foodsToAvoidBtnOutlt: UIButton!
    @IBOutlet weak var foodAllowncesBtn: UIButton!
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var currentPlanTableView: AutoResizingTableView!
    @IBOutlet weak var buttonSepratorView: UIView!
    @IBOutlet weak var protiensLabelOult: UILabel!
    @IBOutlet weak var crabLabelOult: UILabel!
    @IBOutlet weak var waterLabelOutlt: UILabel!
    @IBOutlet weak var fatsLabelOutlt: UILabel!
    @IBOutlet weak var viewContainButton: UIView!
    
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewContainButton.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    func setAttributes(_ value : String, text: String, label: UILabel){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let mutableAttributedText = NSMutableAttributedString(string: text)
        mutableAttributedText.setAttributes([NSFontAttributeName: AppFonts.sanProSemiBold.withSize(30), NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, value.characters.count))
        
        label.attributedText = mutableAttributedText
    }
}

extension CurrentNutritionPlanCell {
    
    fileprivate func setupUI(){
        
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.text = "No Records Found!"
        
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.layer.masksToBounds = true
        
        self.buttonSepratorView.backgroundColor = UIColor.dosBtnSepratorColor
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false

        self.targetLabel.text = "Target"
        self.targetLabel.font = AppFonts.sanProSemiBold.withSize(15)
        self.currentPlanImage.image = #imageLiteral(resourceName: "icNutritionPlanCircle")
        self.caloriesValue.text = "2000 cal"
        
        self.viewAttachmentBtn.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.viewAttachmentBtn.setImage(#imageLiteral(resourceName: "icActivityplanGreenattachment"), for: .normal)
        self.viewAttachmentBtn.tintColor = UIColor.appColor
        
        self.foodAllowncesBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.foodAllowncesBtn.setTitleColor(UIColor.white, for: .normal)
        self.foodAllowncesBtn.setTitle("DAILY ALLOWANCES", for: .normal)
        
        self.foodsToAvoidBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.foodsToAvoidBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.foodsToAvoidBtnOutlt.setTitle("FOOD TO AVOID", for: .normal)
        
        
        self.shareBtnOutlt.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: .normal)
        self.shareBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.protiensLabelOult.textColor = UIColor.white
        self.fatsLabelOutlt.textColor = UIColor.white
        self.waterLabelOutlt.textColor = UIColor.white
        self.crabLabelOult.textColor = UIColor.white
        
        self.registernibs()
    
    }
    
    func registernibs(){
        
        let currentDateCellNib = UINib(nibName: "PreviousActivityDurationDateCell", bundle: nil)
        self.currentPlanTableView.register(currentDateCellNib, forCellReuseIdentifier: "previousActivityDurationDateCellID")

        let nutrientLabelTableCellNib = UINib(nibName: "NutrientLabelTableCell", bundle: nil)
        self.currentPlanTableView.register(nutrientLabelTableCellNib, forCellReuseIdentifier: "nutrientLabelTableCellID")

    }
    
    func populateData(_ currentNutritionPlan : [NutritionPlan]){
        
        if currentNutritionPlan.isEmpty{
            
            self.noDataAvailiableLabel.isHidden = false
            self.viewContainObjects.isHidden = true
            
        }else{
            
            self.noDataAvailiableLabel.isHidden = true
            self.viewContainObjects.isHidden = false
        }
    }
}
