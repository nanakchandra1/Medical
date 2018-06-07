//
//  JunkFoodPerWeekCell.swift
//  Mutelcor
//
//  Created by on 04/01/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class JunkFoodPerWeekCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var presentJunkFood: UITextField!
    @IBOutlet weak var presentJunkFoodSepratorView: UIView!
    @IBOutlet weak var pastJunkFood: UITextField!
    @IBOutlet weak var pastJunkFoodSepratorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTitle.font = AppFonts.sansProRegular.withSize(16)
        self.cellTitle.textColor = UIColor.appColor
        self.pastJunkFood.font = AppFonts.sanProSemiBold.withSize(16)
        self.presentJunkFood.font = AppFonts.sanProSemiBold.withSize(16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(userInfo: UserInfo?, indexPath: IndexPath){
        
        self.presentJunkFood.keyboardType = .numberPad
        self.pastJunkFood.keyboardType = .numberPad
        self.presentJunkFood.placeholder = K_PRESENT_PLACEHOLDER.localized
        self.pastJunkFood.placeholder = K_PAST_PLACEHOLDER.localized
        
        guard let userData = userInfo, let activity = userData.activityInfo.first else{
            return
        }
        
        self.presentJunkFood.text = activity.presentJunkFood
        self.pastJunkFood.text = activity.pastJunkFood
    }
}
