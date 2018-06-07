//
//  PreviousActivityDurationDateCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PreviousActivityDurationDateCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var activityDurationDatelabel: UILabel!
    @IBOutlet weak var imageBeforeDurationDate: UIImageView!
    @IBOutlet weak var imageAfterDurationDate: UIImageView!
    @IBOutlet weak var shareBtnOult: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   override func prepareForReuse() {
        super.prepareForReuse()
    
        self.activityDurationDatelabel.text = ""
    }
}

extension PreviousActivityDurationDateCell{
    
    fileprivate func setupUI(){
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        self.shareBtnOult.setImage(#imageLiteral(resourceName: "icActivityplanShare"), for: UIControlState.normal)
        self.shareBtnOult.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.activityDurationDatelabel.font = AppFonts.sanProSemiBold.withSize(12.5)
        self.activityDurationDatelabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        self.imageBeforeDurationDate.image = #imageLiteral(resourceName: "ic_activity_line")
        self.imageAfterDurationDate.image = #imageLiteral(resourceName: "ic_activity_line")
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font =  AppFonts.sanProSemiBold.withSize(16)
        
    }
    
    
    func populateCurrentData(_ currentActivityData : [CurrentActivityPlan], index : IndexPath){
        
        var startActivityDate : String?
        var endActivityDate : String?
        
        if let startActivityDat = currentActivityData[index.row - 1].planStartDate?.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue){

            startActivityDate = startActivityDat
    
        }

        if let endDat = currentActivityData[0].planEndDate?.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue){
        
            endActivityDate = endDat
          
        }
        
        self.activityDurationDatelabel.text = "\(String(describing: startActivityDate!)) - \(String(describing: endActivityDate!))"
        
    }
    
    func populateData(_ previousActivityData : [PreviousActivityPlan], _ index : IndexPath){
        
        var startActivityDate : String?
        var endActivityDate : String?
        
        if let startActivityDat = previousActivityData[index.row].planStartDate?.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue){
            
            startActivityDate = startActivityDat
        }
        
        if let endDat = previousActivityData[index.row].planEndDate?.dateFString(DateFormat.utcTime.rawValue, DateFormat.ddMMMYYYY.rawValue){
            
            endActivityDate = endDat
        }
        
        self.activityDurationDatelabel.text = "\(String(describing: startActivityDate!)) - \(String(describing: endActivityDate!))"
        
    }
    
    func populatePreviousNutritionData(_ previousNutritionData : [NutritionPlan], _ index : IndexPath){
        
        var startActivityDate : String?
        var endActivityDate : String?
        
        if let startActivityDat = previousNutritionData[index.row].startingDate?.stringFormDate(DateFormat.ddMMMYYYY.rawValue){
            
            startActivityDate = startActivityDat
        }
        
        if let endDat = previousNutritionData[index.row].endingDate?.stringFormDate(DateFormat.ddMMMYYYY.rawValue){
            
            endActivityDate = endDat
        }
        
        self.activityDurationDatelabel.text = "\(String(describing: startActivityDate!)) - \(String(describing: endActivityDate!))"
        
    }
}
