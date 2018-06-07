//
//  ActivityCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var selectActivityLabel: UILabel!
    @IBOutlet weak var selectActivityTextField: UITextField!
    @IBOutlet weak var selectActivitySepratorView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var durationSepratorView: UIView!
    
    @IBOutlet weak var durationUnitLabel: UILabel!
    @IBOutlet weak var durationUnitTextField: UITextField!
    @IBOutlet weak var durationUnitSepratorView: UIView!
    
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var intensitySepratorView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var distanceSepratorView: UIView!
    
    @IBOutlet weak var distanceUnitLabel: UILabel!
    @IBOutlet weak var distanceUnitTextField: UITextField!
    @IBOutlet weak var distanceUnitSepratorView: UIView!
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var stepsSepratorView: UIView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriestextField: UITextField!
    @IBOutlet weak var caloriesSepratorView: UIView!
    @IBOutlet weak var deleteActivityBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.deleteActivityBtnOutlet.isHidden = true
    }
    
}

extension ActivityCell {
    
    fileprivate func setUpUI(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        for label in [self.selectActivityLabel,self.durationUnitLabel, self.durationLabel, self.intensityLabel, self.distanceLabel, self.distanceUnitLabel, self.stepsLabel, self.caloriesLabel]{
            
            label?.textColor = UIColor.appColor
            label?.font = AppFonts.sansProRegular.withSize(16)
            
        }
        
        for textField in [self.selectActivityTextField,self.durationTextField, self.intensityTextField, self.distanceTextField, self.distanceUnitTextField, self.stepsTextField, self.caloriestextField, self.durationUnitTextField]{
            
            textField?.textColor = UIColor.textColor
            textField?.font = AppFonts.sanProSemiBold.withSize(16)
            
        }
        
        for sepratorView in [self.selectActivitySepratorView,self.durationSepratorView, self.intensitySepratorView, self.distanceSepratorView, self.distanceUnitSepratorView, self.stepsSepratorView, self.caloriesSepratorView]{
            
            sepratorView?.backgroundColor = UIColor.sepratorColor
            
        }
        
        self.deleteActivityBtnOutlet.roundCorner(radius: 2.2, borderColor: UIColor.red, borderWidth: 2.0)
        self.deleteActivityBtnOutlet.setTitle("Delete Activity", for: UIControlState.normal)
        self.deleteActivityBtnOutlet.setTitleColor(UIColor.red, for: UIControlState.normal)
        self.deleteActivityBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.selectActivityLabel.text = "Select Activity"
        self.selectActivityTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.selectActivityTextField.rightViewMode = UITextFieldViewMode.always
        
        self.durationLabel.text = "Duration"
        self.durationUnitLabel.text = "Unit"
        self.intensityLabel.text = "Intensity"
        self.durationUnitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.durationUnitTextField.rightViewMode = UITextFieldViewMode.always
        self.intensityTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.intensityTextField.rightViewMode = UITextFieldViewMode.always
        
        self.distanceLabel.text = "Distance"
        self.distanceUnitLabel.text = "Unit"
        self.stepsLabel.text = "Steps"
        self.distanceUnitTextField.rightView = UIImageView(image: #imageLiteral(resourceName: "icActivityplanGreendropdown"))
        self.distanceUnitTextField.rightViewMode = UITextFieldViewMode.always
        
        self.caloriesLabel.text = "Calories"

    }
}
