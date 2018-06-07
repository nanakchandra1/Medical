//
//  EditActivityCell.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class EditActivityCell: UITableViewCell {

//    MARK:- IBOtlets
//    ===============
    @IBOutlet weak var topSepratorView: UIView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editDeleteBtnStackViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//==============
extension EditActivityCell {
    
    fileprivate func setupUI(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.topSepratorView.backgroundColor = UIColor.sepratorColor
        self.activityNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.dateLabel.font = AppFonts.sansProRegular.withSize(16)
        self.timeLabel.font = AppFonts.sansProRegular.withSize(16)
        self.dateLabel.textColor = UIColor.grayLabelColor
        self.timeLabel.textColor = UIColor.grayLabelColor
        
        let font = DeviceType.IS_IPHONE_5 ? 13: 16
        self.activityNameLabel.font = AppFonts.sanProSemiBold.withSize(CGFloat(font))
        let dateFont = DeviceType.IS_IPHONE_5 ? 11: 15
        self.dateLabel.font = AppFonts.sansProRegular.withSize(CGFloat(dateFont))
        self.timeLabel.font = AppFonts.sansProRegular.withSize(CGFloat(dateFont))
        self.dateLabel.textColor = UIColor.grayLabelColor
        self.timeLabel.textColor = UIColor.grayLabelColor
    }
    
    func populateRecentData(_ recentActivityData : [RecentActivityModel], _ index : IndexPath){
        self.editDeleteBtnStackViewWidth.constant = 0
        guard !recentActivityData.isEmpty else{
            return
        }
        
        let activity = recentActivityData[index.row].activityName
        let activityName = "\(activity ?? "")\n"
        let actDuration : String?
        let actDistance : String?
        let actSteps : String?
        let calorieburn : String?
        if let activityDuration = recentActivityData[index.row].activityDuration{
            actDuration = String(Int(activityDuration))
        }else{
            actDuration = "\(false.rawValue)"
        }
        
        if let totalDistance = recentActivityData[index.row].totalDistance{
            actDistance = String(Int(totalDistance))
        }else{
            actDistance = "\(false.rawValue)"
        }
        if let totalSteps = recentActivityData[index.row].totalSteps{
            actSteps = String(totalSteps)
        }else{
            actSteps = "\(false.rawValue)"
        }
        if let caloriesburn = recentActivityData[index.row].caloriesBurn{
            calorieburn = String(caloriesburn)
        }else{
            calorieburn = "\(false.rawValue)"
        }
        
        let activityDurationUnit = recentActivityData[index.row].activityDurationUnit
        
        var intensity = ""
        if  let inten = recentActivityData[index.row].activityIntensity{
            
            if inten == IntensityValue.low.rawValue {
               intensity = "Low"
            }else if inten == IntensityValue.moderate.rawValue{
               intensity = "Medium"
            }else{
               intensity = "High"
            }
        }
        let distanceUnit = recentActivityData[index.row].activityDistanceUnit
        
        let str = "\(actDuration ?? "") \(activityDurationUnit ?? ""), \(actDistance ?? "") \(distanceUnit ?? ""), \(calorieburn ?? "") \( K_CALORIES_UNIT.localized), \(actSteps ?? ""), \(intensity)"
        let mutableAttributes = NSMutableAttributedString(string: activityName, attributes: [NSAttributedStringKey.font : AppFonts.sansProBold.withSize(20)])
        
        let nsAttributedString = NSAttributedString(string: str, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(16)])
        mutableAttributes.append(nsAttributedString)
        self.activityNameLabel.attributedText = mutableAttributes
        
        if let activityData = recentActivityData[index.row].activityDate{
            self.dateLabel.text = activityData.changeDateFormat(.utcTime, .ddMMMYYYY)
        }
        if let activityTime = recentActivityData[index.row].ActivityTime{
            self.timeLabel.text = activityTime.changeDateFormat(.HHmmss, .Hmm)
        }
    }
}
