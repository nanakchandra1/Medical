//
//  LogBookCell.swift
//  Mutelcor
//
//  Created by on 03/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LogBookCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageOult: UIImageView!
    @IBOutlet weak var logsAmountLabel: UILabel!
    @IBOutlet weak var logsNameLabelOutlt: UILabel!
    @IBOutlet weak var dateLabelOutlt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.logsNameLabelOutlt.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.logsNameLabelOutlt.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        self.dateLabelOutlt.font = AppFonts.sanProSemiBold.withSize(11.3)
        self.dateLabelOutlt.textColor = UIColor.grayLabelColor
        self.cellImageOult.roundCorner(radius: self.cellImageOult.frame.width/2, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
    }
    
    func populateData(_ logBookData : [LogBookModel], _ indexPath : IndexPath){
        
        guard !logBookData.isEmpty else{
            return
        }
        
        self.logsNameLabelOutlt.text = logBookData[indexPath.row].logTitle
        let logTime = logBookData[indexPath.row].logTime?.changeDateFormat(.utcTime, .ddMMMYYYY)
        self.dateLabelOutlt.text = logTime
        self.logsAmountLabel.text = logBookData[indexPath.row].logValue
        
        if let logType = logBookData[indexPath.row].logType {
            switch logType {
            case 1:
                self.cellImageOult.image = #imageLiteral(resourceName: "icAddmenuAppointment")
                self.cellImageOult.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.9215686275, alpha: 1)
            case 2:
                self.cellImageOult.image = #imageLiteral(resourceName: "icAddmenuMeasurement")
                self.cellImageOult.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.568627451, blue: 0.9294117647, alpha: 1)
            case 3:
                self.cellImageOult.image = #imageLiteral(resourceName: "icAddmenuActivity")
                self.cellImageOult.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.4901960784, blue: 0.2588235294, alpha: 1)
            case 4:
                self.cellImageOult.image = #imageLiteral(resourceName: "icAddmenuNutrition")
                self.cellImageOult.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.7450980392, blue: 0.737254902, alpha: 1)
            default:
                return
            }
        }
    }
}
