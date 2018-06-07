//
//  EditActivityCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
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
        
//        self.editButton.setImage(#imageLiteral(resourceName: "icMeasurementEdit"), for: UIControlState.normal)
//        self.deleteButton.setImage(#imageLiteral(resourceName: "icMeasurementDelete"), for: UIControlState.normal)
        
        if DeviceType.IS_IPHONE_5{
            
            self.activityNameLabel.font = AppFonts.sanProSemiBold.withSize(13)
            self.dateLabel.font = AppFonts.sansProRegular.withSize(11)
            self.timeLabel.font = AppFonts.sansProRegular.withSize(11)
            
        }else {
           
            self.activityNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
            self.dateLabel.font = AppFonts.sansProRegular.withSize(15)
            self.timeLabel.font = AppFonts.sansProRegular.withSize(15)
        }
        
        self.dateLabel.textColor = UIColor.grayLabelColor
        self.timeLabel.textColor = UIColor.grayLabelColor
        
    }
    
    func populateRecentData(_ recentActivitydata : [RecentActivityModel], _ index : IndexPath){
        
        let activityNam = recentActivitydata[index.row].activityName
        let activityName = "\(String(describing: activityNam!))\n"
        let actDuration : String?
        let actDistance : String?
        let actSteps : String?
        let calorieburn : String?
        if let activityDuration = recentActivitydata[index.row].activityDuration{
            
            actDuration = String(Int(activityDuration))
            
        }else{
            
            actDuration = "0"
        }
        
        if let totalDistance = recentActivitydata[index.row].totalDistance{
            
            actDistance = String(Int(totalDistance))
            
        }else{
            
            actDistance = "0"
        }
        if let totalSteps = recentActivitydata[index.row].totalSteps{
            
            actSteps = String(totalSteps)
            
        }else{
            
            actSteps = "0"
        }
        if let caloriesburn = recentActivitydata[index.row].caloriesBurn{
            
            calorieburn = String(caloriesburn)
            
        }else{
            
            calorieburn = "0"
        }
        
        let activityDurationUnit = recentActivitydata[index.row].activityDurationUnit
        
        var intensity = ""
        if  let inten = recentActivitydata[index.row].activityIntensity{
            
            if inten == "intensity1" {
                
               intensity = "Low"
            }else if inten == "intensity2"{
                
               intensity = "Medium"
            }else{
                
               intensity = "High"
            }
        }
        let distanceUnit = recentActivitydata[index.row].activityDistanceUnit
        
        let str = "\(String(describing: actDuration!))\(String(describing: activityDurationUnit!)), \(String(describing: actDistance!))\(String(describing: distanceUnit!)), \(String(describing: calorieburn!))\(" kcal"), \(String(describing: actSteps!)), \(String(describing: intensity))"
        
        let mutableAttributes = NSMutableAttributedString(string: activityName, attributes: [NSFontAttributeName : AppFonts.sansProBold.withSize(20)])
        
        let nsAttributedString = NSAttributedString(string: str, attributes: [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16)])
        
        mutableAttributes.append(nsAttributedString)
        
        self.activityNameLabel.attributedText = mutableAttributes
        
        if let activityData = recentActivitydata[index.row].activityDate{
            
            self.dateLabel.text = activityData.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue)
        }

        if let activityTime = recentActivitydata[index.row].ActivityTime{
            
            self.timeLabel.text = activityTime.dateFString(DateFormat.HHmmss.rawValue, DateFormat.Hmm.rawValue)
        }
        
    }
}
