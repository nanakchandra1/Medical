//
//  NextScheduleCell.swift
//  Mutelcor
//
//  Created by on 13/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AlamofireImage

class NextScheduleCell: UICollectionViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var horizontalSepratorView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setupUI()
    }
}

//MARK:- Methods
//===============
extension NextScheduleCell {
    
    fileprivate func setupUI(){
        
        self.cellImageBackgroundView.layer.cornerRadius = self.cellImageBackgroundView.layer.frame.width / 2
        self.cellImageBackgroundView.clipsToBounds = true
        self.cellImageView.layer.cornerRadius = self.cellImageView.layer.frame.width / 2
        self.cellImageView.clipsToBounds = true
        self.cellTitleLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.horizontalSepratorView.backgroundColor = UIColor.sepratorColor
        self.dateLabel.textColor = #colorLiteral(red: 0.5215686275, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
        self.dateLabel.font = AppFonts.sanProSemiBold.withSize(16)
    }
    
    func populateData(_ dashboardData: [DashboardDataModel], _ index: IndexPath){
        
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        guard !data.nextSchedule.isEmpty else{
            return
        }
        
        self.cellImageBackgroundView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7450980392, blue: 0.537254902, alpha: 1)
        if let image = data.nextSchedule[index.item].scheduleIcon, !image.isEmpty  {
            let imageUrlInStr = image.replacingOccurrences(of: " ", with: "%20")
            let imgURl = URL(string: imageUrlInStr)
            self.cellImageView.af_setImage(withURL: imgURl!, placeholderImage: #imageLiteral(resourceName: "icAddmenuMeasurement"))
        }else{
            self.cellImageView.image = #imageLiteral(resourceName: "icAddmenuMeasurement")
        }
        
        self.cellTitleLabel.text = data.nextSchedule[index.item].testName?.uppercased()
        let time = data.nextSchedule[index.item].time?.changeDateFormat(.utcTime, .dMMMyyyy)
        self.dateLabel.text = time ?? ""
    }
}
