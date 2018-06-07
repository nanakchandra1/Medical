//
//  ActivityCell.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var selectActivityLabel: UILabel!
    @IBOutlet weak var selectActivityTextField: UITextField!
    @IBOutlet weak var selectActivitySepratorView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationTextField: CustomTextField!
    @IBOutlet weak var durationSepratorView: UIView!
    
    @IBOutlet weak var durationUnitLabel: UILabel!
    @IBOutlet weak var durationUnitTextField: CustomTextField!
    @IBOutlet weak var durationUnitSepratorView: UIView!
    
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityTextField: CustomTextField!
    @IBOutlet weak var intensitySepratorView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceTextField: CustomTextField!
    @IBOutlet weak var distanceSepratorView: UIView!
    
    @IBOutlet weak var distanceUnitLabel: UILabel!
    @IBOutlet weak var distanceUnitTextField: CustomTextField!
    @IBOutlet weak var distanceUnitSepratorView: UIView!
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var stepsTextField: CustomTextField!
    @IBOutlet weak var stepsSepratorView: UIView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriestextField: CustomTextField!
    @IBOutlet weak var caloriesSepratorView: UIView!
    @IBOutlet weak var deleteActivityBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
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
        self.selectActivityTextField.tintColor = UIColor.white
        self.distanceUnitTextField.tintColor = UIColor.white
        self.durationUnitTextField.tintColor = UIColor.white
        self.intensityTextField.tintColor = UIColor.white
        
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
    
    func populateActivityData(calculatedValue: [CalculatedValue], activityFormData: [ActivityFormModel], intensityValues: [String], distanceUnit: [String], durationUnit: [String], indexPath: IndexPath){
        
        let activityID = calculatedValue[indexPath.row].activity
        
        if !activityFormData.isEmpty {
            let activityData = activityFormData.filter({ (activityData) -> Bool in
                return activityData.activityID == activityID
            })
            self.selectActivityTextField.text = activityData.first?.activityName
        }else{
            self.selectActivityTextField.text = ""
        }
        
        let durationInMin = calculatedValue[indexPath.row].duration
        let durationInHours = durationInMin / 60
        let rounderDurationValue = (calculatedValue[indexPath.row].durationType == .mins) ? durationInMin.rounded(toPlaces: 2) : durationInHours.rounded(toPlaces: 2)
        if rounderDurationValue == 0.0{
            self.durationTextField.placeholder = "0"
            self.durationTextField.text = ""
        }else{
          self.durationTextField.text = rounderDurationValue.cleanValue
        }

        let unit = (calculatedValue[indexPath.row].durationType == .mins) ? durationUnit[0] : durationUnit[1]
        self.durationUnitTextField.text = unit
        
        if calculatedValue[indexPath.row].intensityType == .low{
            self.intensityTextField.text = intensityValues[0]
        }else if calculatedValue[indexPath.row].intensityType == .moderate {
            self.intensityTextField.text = intensityValues[1]
        }else {
            self.intensityTextField.text = intensityValues[2]
        }
        let distance = calculatedValue[indexPath.row].distance
        //            let distanceInMiles = distanceInKm / 1.6
        //            let distanceValue = (self.calculatedValues[indexPath.row].distanceType == .kms) ? distanceInKm : distanceInMiles
        if distance == 0.0{
            self.distanceTextField.placeholder = "0"
            self.distanceTextField.text = ""
        }else{
            self.distanceTextField.text = distance.cleanValue
        }

        let distanceUnit = (calculatedValue[indexPath.row].distanceType == .kms) ? distanceUnit[0] : distanceUnit[1]
        self.distanceUnitTextField.text = distanceUnit
        
        let steps = calculatedValue[indexPath.row].steps
        if steps == 0{
            self.stepsTextField.placeholder = "0"
            self.stepsTextField.text = ""
        }else{
            self.stepsTextField.text = String(steps)
        }

        let calories = calculatedValue[indexPath.row].calories
        let roundedValuesInCalorie = calories.rounded(.toNearestOrAwayFromZero)
        if Int(roundedValuesInCalorie) == 0{
            self.caloriestextField.placeholder = "0"
            self.caloriestextField.text = ""
        }else{
            self.caloriestextField.text = "\(Int(roundedValuesInCalorie))"
        }

        let isDeleteBtnHidden = (indexPath.row == false.rawValue) ? true : false
        self.deleteActivityBtnOutlet.isHidden = isDeleteBtnHidden
    }
}
