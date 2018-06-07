//
//  CurrentPlanViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class CurrentPlanViewCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewContainAllObjects: UIView!
    
    @IBOutlet weak var viewContainChartCircle: UIView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var distanceImage: UIImageView!
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var distanceUnit: UILabel!
    
    @IBOutlet weak var calorieImageView: UIImageView!
    @IBOutlet weak var caloriesValue: UILabel!
    @IBOutlet weak var caloriesUnit: UILabel!
    
    @IBOutlet weak var durationImageView: UIImageView!
    @IBOutlet weak var durationValue: UILabel!
    @IBOutlet weak var durationUnit: UILabel!
    
    @IBOutlet weak var shareBtnOutlet: UIButton!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var currentPlanTableView: AutoResizingTableView!
    
    @IBOutlet weak var viewContainButton: UIView!
    @IBOutlet weak var sepratorBetweenBtn: UIView!
    @IBOutlet weak var dosBtnOutlt: UIButton!
    @IBOutlet weak var dontsBtnOutlt: UIButton!
    
    @IBOutlet weak var viewAttachmentBtnView: UIView!
    @IBOutlet weak var viewAttachmentBtnOutlt: UIButton!
    @IBOutlet weak var viewAttachmentWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewContainButton.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CurrentPlanViewCell {
    
    fileprivate func setupUI(){
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.contentView.backgroundColor = UIColor.activityVCBackgroundColor
        self.circleImageView.image = #imageLiteral(resourceName: "circle")
        
        self.distanceImage.image = #imageLiteral(resourceName: "icActivityplanWhitekm")
        
        self.distanceValue.textColor = UIColor.white
        self.distanceValue.font = AppFonts.sansProBold.withSize(27)
        self.distanceUnit.font = AppFonts.sansProRegular.withSize(12)
        self.distanceUnit.textColor = UIColor.white
        
        self.calorieImageView.image = #imageLiteral(resourceName: "icActivityplanWhitecal")
        
        self.caloriesValue.textColor = UIColor.white
        self.caloriesValue.font = AppFonts.sansProBold.withSize(27)
        self.caloriesUnit.font = AppFonts.sansProRegular.withSize(12)
        self.caloriesUnit.textColor = UIColor.white
        
        self.durationImageView.image = #imageLiteral(resourceName: "icActivityplanWhiteclock")
        
        self.durationValue.textColor = UIColor.white
        self.durationValue.font = AppFonts.sansProBold.withSize(27)
        self.durationUnit.font = AppFonts.sansProRegular.withSize(12)
        self.durationUnit.textColor = UIColor.white
        
        self.shareBtnOutlet.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: UIControlState.normal)
        self.shareBtnOutlet.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.viewAttachmentBtnOutlt.setImage(#imageLiteral(resourceName: "icActivityplanGreenattachment"), for: .normal)
        self.viewAttachmentBtnOutlt.tintColor = UIColor.appColor
        self.viewAttachmentBtnOutlt.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        
        self.rightImageView.image = #imageLiteral(resourceName: "ic_activity_line")
        self.leftImageView.image =  #imageLiteral(resourceName: "ic_activity_line")
        
        self.currentDateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.currentDateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
        self.dosBtnOutlt.setTitle("DO'S", for: .normal)
        self.dosBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.dosBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.dontsBtnOutlt.setTitle("DONT'S", for: .normal)
        self.dontsBtnOutlt.setTitleColor(UIColor.white, for: .normal)
        self.dontsBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
        self.sepratorBetweenBtn.backgroundColor = UIColor.dosBtnSepratorColor
        
        let viewAttachmentCellNib = UINib(nibName: "ViewAttachmentCell", bundle: nil)
        self.currentPlanTableView.register(viewAttachmentCellNib, forCellReuseIdentifier: "viewAttachmentCellID")
        
    }
    
//    MARK:- Populate Chart Data
//    ===========================
    func populateData(_ duration : Double?, _ distance : Double?, _ calories : Int?){
        
        if let dur = duration?.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero){
            
            printlnDebug("dur\(dur)")
            
           self.durationValue.text = "\(dur)"
        }
        if let dis = distance?.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero){
           printlnDebug("dis\(dis)")
            self.distanceValue.text = "\(dis)"
        }
        if let cal = calories{
            printlnDebug("cal\(cal)")
           self.caloriesValue.text = forTailingZero(temp: Double(cal))
        }
    }
    
//    MARK:- Current Plan Date
//    =========================
    func populateCurrentData(_ currentActivityData : [CurrentActivityPlan]){
        
        var startActivityDate = ""
        var endActivityDate = ""
        
        if let startActivityDat = currentActivityData[0].planStartDate, !startActivityDat.isEmpty{
            
            startActivityDate = startActivityDat.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue)!
            
        }
        
        if let endDat = currentActivityData[0].planEndDate, !endDat.isEmpty {
            
            endActivityDate = endDat.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue)!
            
        }
        
        self.currentDateLabel.text = "\(String(describing: startActivityDate)) - \(String(describing: endActivityDate))"
    }
}
