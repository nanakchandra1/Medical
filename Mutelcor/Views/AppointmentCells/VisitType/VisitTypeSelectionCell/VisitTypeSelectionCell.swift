//
//  VisittypeCell.swift
//  Mutelcor
//
//  Created by  on 26/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VisitTypeSelectionCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.sepratorView.isHidden = true
        self.sepratorView.backgroundColor = UIColor.sepratorColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func populateData(_ visitType :Int, _ indexPath : IndexPath){
        
        if visitType == false.rawValue {
            switch indexPath.row{
            case 0:
                self.contentView.backgroundColor = UIColor.white
                self.cellLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
                self.cellImage.image =  #imageLiteral(resourceName: "icAppointmentBlackVideo")
            case 1:
                self.contentView.backgroundColor = UIColor.appColor
                self.cellLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.cellImage.image =  #imageLiteral(resourceName: "icAppointmentWhitePhysical")
            default:
                return
            }
        }else{
            switch indexPath.row {
            case 0:
                self.contentView.backgroundColor = UIColor.appColor
                self.cellLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.cellImage.image = #imageLiteral(resourceName: "icAppointmentWhiteVideo")
            case 1:
                self.contentView.backgroundColor = UIColor.white
                self.cellLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.80078125)
                self.cellImage.image = #imageLiteral(resourceName: "icAppointmentBlackPhysical")
            default:
                return
            }
        }
    }
}


