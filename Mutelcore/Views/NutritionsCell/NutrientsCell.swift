//
//  NutrientsCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NutrientsCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var nutrientsNameLabel: UILabel!
    @IBOutlet weak var targetValueLabel: UILabel!
    @IBOutlet weak var consumedValueLabel: UILabel!
    @IBOutlet weak var verticalNutrientsSepratorView: UIView!
    @IBOutlet weak var verticalTargetSepratorView: UIView!
    @IBOutlet weak var bottomSepratorView: UIView!
    
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

extension NutrientsCell {
    
    fileprivate func setupUI(){
        
        self.verticalTargetSepratorView.backgroundColor = UIColor.clear
        self.verticalNutrientsSepratorView.backgroundColor = UIColor.clear
        self.bottomSepratorView.backgroundColor = UIColor.clear
        self.verticalTargetSepratorView.backgroundColor = UIColor.appColor
        self.verticalNutrientsSepratorView.backgroundColor = UIColor.appColor
        self.bottomSepratorView.backgroundColor = UIColor.appColor
        
//        self.verticalTargetSepratorView.dashLine(CGPoint(x: CGFloat(0), y: self.layer.frame.origin.y - 5), CGPoint(x: 0, y: self.layer.frame.height))
//        self.verticalNutrientsSepratorView.dashLine(CGPoint(x: CGFloat(0), y: self.layer.frame.origin.y - 5), CGPoint(x: 0, y: self.layer.frame.height))
//        self.bottomSepratorView.dashLine(CGPoint(x: CGFloat(0), y: CGFloat(0)), CGPoint(x: self.layer.frame.width, y: 0))
        
        self.nutrientsNameLabel.font = AppFonts.sanProSemiBold.withSize(13)
        self.nutrientsNameLabel.textColor = UIColor.appColor
        self.targetValueLabel.font = AppFonts.sanProSemiBold.withSize(13)
        self.consumedValueLabel.font = AppFonts.sanProSemiBold.withSize(13)
        
    }
    
    func populateData(_ dayWiseData : [DayWiseNutrition], _ indexPath : IndexPath){
        
        let attr1 = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16)]
        let attr2 = [NSFontAttributeName : AppFonts.sansProRegular.withSize(12)]
        
        switch indexPath.row {
            
        case 0: let consumeCal = dayWiseData[0].consumeCalories
        let targetCal = dayWiseData[0].planCalories
        
        self.targetValueLabel.attributedText = self.attrributedText(consumeCal, targetCal, true, unit: "g", attr1, attr2)
        self.consumedValueLabel.attributedText = self.attrributedText(consumeCal, targetCal, false, unit: "g", attr1, attr2)
        
        self.bottomSepratorView.isHidden = false
            
        case 1: let consumeCrabs = dayWiseData[0].consumeCrubs
        let targetCrabs = dayWiseData[0].planCrabs
        
        self.targetValueLabel.attributedText = self.attrributedText(consumeCrabs, targetCrabs, true, unit: "g", attr1, attr2)
        self.consumedValueLabel.attributedText = self.attrributedText(consumeCrabs, targetCrabs, false, unit: "g", attr1, attr2)
        
        self.bottomSepratorView.isHidden = false
            
        case 2: let consumeFats = dayWiseData[0].consumeFats
        let targetFats = dayWiseData[0].planFats
        
        self.targetValueLabel.attributedText = self.attrributedText(consumeFats, targetFats, true, unit: "g", attr1, attr2)
        self.consumedValueLabel.attributedText = self.attrributedText(consumeFats, targetFats, false, unit: "g", attr1, attr2)
        
        self.bottomSepratorView.isHidden = false
            
        case 3: let consumeProtien = dayWiseData[0].consumeProtiens
        let targetProtien = dayWiseData[0].planProtiens
        
        self.targetValueLabel.attributedText = self.attrributedText(consumeProtien, targetProtien, true, unit: "g", attr1, attr2)
        self.consumedValueLabel.attributedText = self.attrributedText(consumeProtien, targetProtien, false, unit: "g", attr1, attr2)
        
        self.bottomSepratorView.isHidden = false
            
        case 4: let consumeWater = dayWiseData[0].consumeWater
        let targetWater = dayWiseData[0].planWater
        
        self.targetValueLabel.attributedText = self.attrributedText(consumeWater, targetWater, true, unit: "ltr", attr1, attr2)
        self.consumedValueLabel.attributedText = self.attrributedText(consumeWater, targetWater, false, unit: "ltr", attr1, attr2)
        self.bottomSepratorView.isHidden = true
            
        default : fatalError("data not found!")
        }
    }
    
    fileprivate func attrributedText (_ consumeData : Double?,_ givenData : Double?, _ targetData : Bool, unit : String, _ attributes1 : [String : Any]?, _ attributes2 : [String : Any]?) -> NSMutableAttributedString{
        
        let consDataInString = String(describing : consumeData!)
        let givenDataInString = String(describing : givenData!)
        
        let percentageConsumed = (consumeData!/givenData!) * 100
        
        var precentageCons = "0"
        
        if percentageConsumed == Double.nan {
            precentageCons = String(describing : Int(percentageConsumed))
        }
        
        if targetData {
            
            let givenData = NSMutableAttributedString(string: givenDataInString, attributes: attributes1)
            let attString = NSAttributedString(string: unit, attributes: attributes2)
            givenData.append(attString)
            
            return givenData
        }else{
            
            var attributes = [String : Any?]()
            
            if percentageConsumed > 100 {
                
                attributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16),
                              NSForegroundColorAttributeName : #colorLiteral(red: 1, green: 0.2352941176, blue: 0.2352941176, alpha: 1)]
                
            }else if percentageConsumed > 70, percentageConsumed < 101 {
                
                attributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16),
                              NSForegroundColorAttributeName : UIColor.appColor]
                
            }else {
                
                attributes = [NSFontAttributeName : AppFonts.sanProSemiBold.withSize(16),
                              NSForegroundColorAttributeName : #colorLiteral(red: 1, green: 0.6588235294, blue: 0, alpha: 1)]
                
            }
            
            let consumData = NSMutableAttributedString(string: consDataInString, attributes: attributes1)
            let unitAttributes = NSAttributedString(string: unit, attributes: attributes2)
            let leftCurl = NSAttributedString(string: "(", attributes: attributes1)
            let rightCurl = NSAttributedString(string: ")", attributes: attributes1)
            let percentageData = NSAttributedString(string: "\(precentageCons)%", attributes: (attributes as Any as! [String : Any]))
            
            consumData.append(unitAttributes)
            consumData.append(leftCurl)
            consumData.append(percentageData)
            consumData.append(rightCurl)
            
            return consumData
        }
    }
}
