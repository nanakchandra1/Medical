//
//  ViewAttachmentCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ViewAttachmentCell: UITableViewCell {

//    MARK:- IBoutlets
//    ================
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var viewAttachmentBtn: UIButton!
    @IBOutlet weak var cellSepratorView: UIView!
    @IBOutlet weak var viewAttachmentBtnWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if DeviceType.IS_IPHONE_5 {
            
            self.viewAttachmentBtnWidthConstraint.constant = 130
            self.activityLabel.font = AppFonts.sanProSemiBold.withSize(12)
            self.viewAttachmentBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(10)
            
        }else{
            
            self.viewAttachmentBtnWidthConstraint.constant = 160
            self.activityLabel.font = AppFonts.sanProSemiBold.withSize(16)
            self.viewAttachmentBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(12.5)
        }

        self.activityLabel.textColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        self.cellSepratorView.backgroundColor = UIColor.sepratorColor
        self.viewAttachmentBtn.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.viewAttachmentBtn.setImage(#imageLiteral(resourceName: "icActivityplanGreenattachment"), for: UIControlState.normal)
        self.viewAttachmentBtn.setTitle("View Attachment", for: UIControlState.normal)
        self.viewAttachmentBtn.setTitleColor(UIColor.appColor, for: UIControlState.normal)
        self.viewAttachmentBtn.titleLabel?.textColor = UIColor.appColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Methods
//===============
extension ViewAttachmentCell {
    
    func populateCurrentActivityData(_ currentActivityPlan : [CurrentActivityPlan], _ index : IndexPath){
        
        let activityName = currentActivityPlan[index.row].activityName
        let actDuration : String?
        
        if let currentAttachment = currentActivityPlan[index.row].attachments, !currentAttachment.isEmpty {
            
            self.viewAttachmentBtn.isHidden = false
            
        }else{
            
            self.viewAttachmentBtn.isHidden = true
        }
        
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
            
            actDuration = String(activityDuration)
            
        }else{
            
            actDuration = "0"
        }
        
        let activityDurationUnit = currentActivityPlan[index.row].activityDurationUnit
        let activityFrequency = currentActivityPlan[index.row].activityFrequency
        
        self.activityLabel.text = "\(String(describing: activityName!)), \(String(describing: actDuration!))\(String(describing: activityDurationUnit!)), \(String(describing: intensity)), \(String(describing: activityFrequency!))"
        
    }
    
    func populatePreviousActivityData(_ previousActivityPlan : [PreviousActivityPlan], _ index : IndexPath){
        
        let activityName = previousActivityPlan[index.row].activityName
        let actDuration : String?
        
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
        
        if let previousAttachment = previousActivityPlan[index.row].attachments, !previousAttachment.isEmpty {
            
            self.viewAttachmentBtn.isHidden = false
        }else{
            
          self.viewAttachmentBtn.isHidden = true
        }
        
        if let activityDuration = previousActivityPlan[index.row].activityDuration{
            
            actDuration = String(activityDuration)
            
        }else{
            
            actDuration = "0"
        }
        
        let activityDurationUnit = previousActivityPlan[index.row].activityDurationUnit
        let activityFrequency = previousActivityPlan[index.row].activityFrequency
        
        self.activityLabel.text = "\(String(describing: activityName!)), \(String(describing: actDuration!))\(String(describing: activityDurationUnit!)), \(String(describing: intensity)), \(String(describing: activityFrequency!))"
        
    }
}
