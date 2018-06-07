//
//  ActivityProgressCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import SwiftyJSON

class ActivityProgressCell: UITableViewCell {
    
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var durationOuterView: UIView!
    @IBOutlet weak var durationOuterCircleView: UIView!
    @IBOutlet weak var durationProgressCircle: MBCircularProgressBarView!
    
    @IBOutlet weak var distanceOuterView: UIView!
    @IBOutlet weak var distanceOuterCircleView: UIView!
    @IBOutlet weak var distanceProgressView: MBCircularProgressBarView!
    
    @IBOutlet weak var caloriesOuterView: UIView!
    @IBOutlet weak var caloriesOuterCircleView: UIView!
    @IBOutlet weak var caloriesProgressView: MBCircularProgressBarView!
    
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var durationUnitLabel: UILabel!
    
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var distanceUnitValue: UILabel!
    
    @IBOutlet weak var caloriesValueLabel: UILabel!
    @IBOutlet weak var caloriesUnitLabel: UILabel!
    
    @IBOutlet weak var durationGoalLabel: UILabel!
    @IBOutlet weak var distanceGoalLabel: UILabel!
    @IBOutlet weak var caloriesGoalLabel: UILabel!
    
    @IBOutlet weak var previousDateBtn: UIButton!
    @IBOutlet weak var nextDateBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet weak var outerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for view in [durationProgressCircle , distanceProgressView, caloriesProgressView]{
            
            view?.progressLineWidth = 10
            view?.progressCapType = 0
            view?.emptyLineWidth = 10
            view?.emptyLineColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 0.513484589)
            view?.emptyCapType = 0
            view?.showValueString = false
            view?.showUnitString = false
            
        }
        
        for view in [durationOuterView, distanceOuterView, caloriesOuterView]{
            
            view?.layer.cornerRadius = view!.frame.width / 2
            view?.clipsToBounds = false
            view?.shadow(2.0, CGSize(width: 0.5, height: 1.3), UIColor.black)
        }
        
        
        for view in [durationOuterCircleView, distanceOuterCircleView, caloriesOuterCircleView]{
            
            view?.layer.cornerRadius = view!.frame.width / 2
            view?.clipsToBounds = true
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ActivityProgressCell {
    
    fileprivate func setupUI(){
        
        self.contentView.backgroundColor = UIColor.activityVCBackgroundColor
        
        self.viewContainAllObjects.layer.cornerRadius = 2.2
        self.viewContainAllObjects.layer.masksToBounds = true
        
        self.outerView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.outerView.layer.cornerRadius = 2.2
        self.outerView.clipsToBounds = false
        self.outerView.layer.masksToBounds = false
        
        self.previousDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanLeftarrow"), for: UIControlState.normal)
        self.nextDateBtn.setImage(#imageLiteral(resourceName: "icActivityplanRightarrow"), for: UIControlState.normal)
        self.calenderBtn.setImage(#imageLiteral(resourceName: "icAppointmentCalendar"), for: UIControlState.normal)
        
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        
        self.dateLabel.font = AppFonts.sansProBold.withSize(12.5)
        self.dateLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        
        self.caloriesUnitLabel.text = "kcal"
        self.durationUnitLabel.text = "mins"
        self.distanceUnitValue.text = "kms"
        
        self.durationValueLabel.textColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
        self.distanceValueLabel.textColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
        self.caloriesValueLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.2078431373, alpha: 1)
        
        for label in [self.durationGoalLabel, self.distanceGoalLabel, self.caloriesGoalLabel]{
            
            label?.text = ""
        }
        
        for label in [self.durationValueLabel,self.distanceValueLabel, self.caloriesValueLabel] {
            
            label?.text = ""
            
            if DeviceType.IS_IPHONE_5 {
                
                label?.font = AppFonts.sansProBold.withSize(22)
                
            }else if DeviceType.IS_IPHONE_4_OR_LESS {
                label?.font = AppFonts.sansProBold.withSize(18)
                
            }else{
                
                label?.font = AppFonts.sansProBold.withSize(25)
            }
        }
    }
    
    func setUpDurationProgress(_ angle : CGFloat){
        
        self.durationProgressCircle.progressColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
        self.durationProgressCircle.progressStrokeColor = #colorLiteral(red: 0.05098039216, green: 0.3215686275, blue: 0.5647058824, alpha: 1)
        
        UIView.animate(withDuration: 0.3) { 
            
            self.durationProgressCircle.value = angle
        }
    }
    
    func setUpDistanceProgress(_ angle : CGFloat){
        
        self.distanceProgressView.progressColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
        self.distanceProgressView.progressStrokeColor = #colorLiteral(red: 1, green: 0.5450980392, blue: 0.05882352941, alpha: 1)
        
        UIView.animate(withDuration: 0.3) {
            
            self.distanceProgressView.value = angle
        }
    }
    
    fileprivate func setUpCalorieProgress(_ angle : CGFloat){
        
        self.caloriesProgressView.progressColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.2078431373, alpha: 1)
        self.caloriesProgressView.progressStrokeColor = #colorLiteral(red: 0.5921568627, green: 0.03921568627, blue: 0.2078431373, alpha: 1)
        
        UIView.animate(withDuration: 0.3) {
            
            self.caloriesProgressView.value = angle
        }
    }
    
    func populateData(_ selectedDateData : [JSON] ){
        
        let consumeCalories = selectedDateData[0]["consume_calories"].doubleValue
        let planCalories = selectedDateData[0]["plan_calories"].doubleValue
        let consumeDuration = selectedDateData[1]["consume_duration"].doubleValue
        let planDuration = selectedDateData[1]["plan_duration"].doubleValue
        let consumeDistance = selectedDateData[2]["consume_distance"].doubleValue
        let planDistance = selectedDateData[2]["plan_distance"].doubleValue
        
        let consumeCal = Int(consumeCalories.rounded(.toNearestOrAwayFromZero))
        let planCal = Int(planCalories.rounded(.toNearestOrAwayFromZero))
        let consumeDur = Int(consumeDuration.rounded(.toNearestOrAwayFromZero))
        let planDur = Int(planDuration.rounded(.toNearestOrAwayFromZero))
        let consumeDis = Int(consumeDistance.rounded(.toNearestOrAwayFromZero))
        let planDis = Int(planDistance.rounded(.toNearestOrAwayFromZero))
        
        
        let consumeCalAngle : Double?
        let consumeDurationAngle : Double?
        let consumeDistanceAngle : Double?
        
        if consumeCalories == 0, planCalories == 0{
            
            consumeCalAngle = 0
            
        }else{
            
            let angle = (consumeCalories / planCalories ) * 100
            
            if angle > 100 {
                
                consumeCalAngle = 100
            }else{
                
                consumeCalAngle = angle
            }
        }
        
        if consumeDuration == 0, planDuration == 0{
            
            consumeDurationAngle = 0
            
        }else{
            
            let angle = (consumeDuration / planDuration ) * 100
            
            if angle > 100 {
                
                consumeDurationAngle = 100
            }else{
                
                consumeDurationAngle = angle
            }
        }
        
        if consumeDistance == 0, planDistance == 0{
            
            consumeDistanceAngle = 0
            
        }else{
            
            let angle = (consumeDistance / planDistance ) * 100
            
            if angle > 100 {
                
                consumeDistanceAngle = 100
            }else{
                
                consumeDistanceAngle = angle
            }
        }
        
        self.caloriesValueLabel.text = "\(consumeCal)"
        self.durationValueLabel.text = "\(consumeDur)"
        self.distanceValueLabel.text = "\(consumeDis)"
        
        let durationGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(16)])
        let distanceGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(16)])
        let caloriesGoalAtt = NSMutableAttributedString(string: "Goal : ", attributes: [NSFontAttributeName : AppFonts.sansProRegular.withSize(16)])
        
        let planCalAtt = addAttributes(String(describing: planCal), [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16)])
        let calUnit = addAttributes(" kcal", [NSFontAttributeName : AppFonts.sansProRegular.withSize(11.3)])
        
        let planDurationAtt = addAttributes(String(describing: planDur), [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16)])
        let durationUnit = addAttributes(" mins", [NSFontAttributeName : AppFonts.sansProRegular.withSize(11.3)])
        
        let planDistanceAtt = addAttributes(String(describing: planDis), [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16)])
        let distanceUnit = addAttributes(" kms", [NSFontAttributeName : AppFonts.sansProRegular.withSize(11.3)])
        
        durationGoalAtt.append(planDurationAtt)
        durationGoalAtt.append(durationUnit)
        
        distanceGoalAtt.append(planDistanceAtt)
        distanceGoalAtt.append(distanceUnit)
        
        caloriesGoalAtt.append(planCalAtt)
        caloriesGoalAtt.append(calUnit)
        
        self.durationGoalLabel.attributedText = durationGoalAtt
        self.distanceGoalLabel.attributedText = distanceGoalAtt
        self.caloriesGoalLabel.attributedText = caloriesGoalAtt
        
        self.setUpCalorieProgress(CGFloat(consumeCalAngle!))
        self.setUpDurationProgress(CGFloat(consumeDurationAngle!))
        self.setUpDistanceProgress(CGFloat(consumeDistanceAngle!))
        
    }
    
    func populateData(_ selectedDate : Date){
        
        let selectDate = selectedDate.stringFormDate(DateFormat.dMMMyyyy.rawValue)
        let currentDate = Date().stringFormDate(DateFormat.dMMMyyyy.rawValue)
        
        printlnDebug("\(selectedDate)")
        
        if selectDate == currentDate {
            
            self.dateLabel.text = "Today, \(String(describing: selectDate!))"
            
            self.nextDateBtn.isHidden = true
            
        }else {
            
            self.dateLabel.text = "\(String(describing: selectDate!))"
            self.nextDateBtn.isHidden = false
            
        }
    }
}
