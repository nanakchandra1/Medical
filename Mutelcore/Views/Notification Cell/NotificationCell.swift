//
//  NotificationCellTableViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var notificationMessageLabel: UILabel!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var notificationCountView: UIView!
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

extension NotificationCell {
    
    fileprivate func setupUI(){
        
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.clipsToBounds = false
        
        self.viewContainObjects.shadow(2.2, CGSize(width : 1.0, height : 1.0), UIColor.black)
        
        self.notificationTypeLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.notificationTypeLabel.textColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.0862745098, alpha: 1)
        
        self.notificationMessageLabel.font = AppFonts.sansProRegular.withSize(13)
        self.rightArrowImage.image = #imageLiteral(resourceName: "icNotificationRightarrow")
        
        self.notificationCountView.layer.cornerRadius = self.notificationCountView.frame.width / 2
        self.notificationCountView.backgroundColor = UIColor.appColor
        self.notificationCount.textColor = UIColor.white
        
        self.contentView.backgroundColor = UIColor.clear
        
    }
}
