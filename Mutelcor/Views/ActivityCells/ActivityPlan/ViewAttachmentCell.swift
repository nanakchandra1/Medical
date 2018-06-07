//
//  ViewAttachmentCell.swift
//  Mutelcor
//
//  Created by on 15/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewAttachmentCell: UITableViewCell {

//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var cellSepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.activityLabel.textColor = UIColor.grayLabelColor
        self.cellSepratorView.backgroundColor = UIColor.sepratorColor
        self.activityLabel.font = AppFonts.sanProSemiBold.withSize(15.8)
    }
}

//MARK:- Methods
//===============
extension ViewAttachmentCell {
    
    //    MARK: Populate Current Data
    //    =============================
    func populateCurrentActivityData(_ currentActivityPlan : [PreviousActivityPlan], _ index : IndexPath){
        
        guard !currentActivityPlan.isEmpty else{
            return
        }
        
        let activityName = currentActivityPlan[index.row].activityName ?? ""
        var actDuration: String = ""
        
        var intensity = ""
        if let intensityValue = currentActivityPlan[index.row].activityIntensity {
            
            if intensityValue == "intensity1"{
                intensity = "Low"
            }else if intensityValue == "intensity2"{
                intensity = "Med"
            }else{
                intensity = "High"
            }
        }
        
        if let activityDuration = currentActivityPlan[index.row].activityDuration{
            actDuration = activityDuration.cleanValue
        }else{
            actDuration = "0"
        }
        
        let activityDurationUnit = currentActivityPlan[index.row].activityDurationUnit ?? ""
        let activityFrequency = currentActivityPlan[index.row].activityFrequency ?? ""
        
        self.activityLabel.text = activityName + ", " + actDuration + activityDurationUnit + ", " + intensity + ",\n" + activityFrequency
    }
    
//    MARK: Populate Previous Data
//    =============================
    func populatePreviousActivityData(_ previousActivityPlan : [PreviousActivityPlan], _ index : IndexPath){
        
        guard !previousActivityPlan.isEmpty else{
            return
        }
        
        let activityName = previousActivityPlan[index.row].activityName ?? ""
        var actDuration : String = ""
        
        var intensity = ""
        if let intensityValue = previousActivityPlan[index.row].activityIntensity {
            
            if intensityValue == "intensity1"{
              intensity = "Low"
            }else if intensityValue == "intensity2"{
               intensity = "Med"
            }else{
                intensity = "High"
            }
        }
        
        if let activityDuration = previousActivityPlan[index.row].activityDuration{
            actDuration = activityDuration.cleanValue
        }else{
            actDuration = "0"
        }
        
        let activityDurationUnit = previousActivityPlan[index.row].activityDurationUnit ?? ""
        let activityFrequency = previousActivityPlan[index.row].activityFrequency ?? ""
        
        self.activityLabel.text = activityName + ", " + actDuration + activityDurationUnit + ", " + intensity + ",\n" + activityFrequency
    }
}
