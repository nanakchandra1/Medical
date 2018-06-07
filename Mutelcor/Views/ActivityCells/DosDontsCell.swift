//
//  DosDontsCell.swift
//  Mutelcor
//
//  Created by on 16/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftyJSON

class DosDontsCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var bulletsView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DosDontsCell {
    
    fileprivate func setupUI(){
        
        self.bulletsView.roundCorner(radius: self.bulletsView.frame.width / 2, borderColor: UIColor.clear, borderWidth: CGFloat(0))
        self.bulletsView.backgroundColor = UIColor.appColor
        self.cellTitleLabel.font = AppFonts.sanProSemiBold.withSize(13.6)
    }
    
    func populateData(buttonTapped: ButtonTapped, foodToAvoid: [String], attachment: [String], dosDonts: [JSON], pointsToRemember: [PointsToRemember], indexPath: IndexPath, nutritionPointToRemember: [NutritionPointToRemember]){
        
        switch buttonTapped {
            
        case .foodToAvoid:
            self.cellTitleLabel.text = foodToAvoid[indexPath.row]
        case .dailyAllowances:
            switch indexPath.section{
            case 0:
                self.cellTitleLabel.text = foodToAvoid[indexPath.row]
            case 1:
                self.cellTitleLabel.text = nutritionPointToRemember[indexPath.row].pointToRemember ?? ""
            default:
                return
            }
        case .attachment:
            self.cellTitleLabel.text = attachment[indexPath.row]
        case .donts:
            self.cellTitleLabel.text = dosDonts[indexPath.row].stringValue
        case .dos:
            switch indexPath.section{
            case 0:
               self.cellTitleLabel.text = dosDonts[indexPath.row].stringValue
            case 1:
                self.cellTitleLabel.text = pointsToRemember[indexPath.row].pointsToRember ?? ""
            default:
                return
            }
        }
    }
}
