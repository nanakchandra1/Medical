//
//  NotificationCellTableViewCell.swift
//  Mutelcor
//
//  Created by on 04/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var notificationMessageLabel: UILabel!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
}

extension NotificationCell {
    
    fileprivate func setupUI(){
        
        self.notificationTypeLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.notificationTypeLabel.textColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.0862745098, alpha: 1)
        self.notificationMessageLabel.font = AppFonts.sansProRegular.withSize(13)
        self.rightArrowImage.image = #imageLiteral(resourceName: "icNotificationRightarrow")
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.contentView.backgroundColor = UIColor.clear
        self.timeStamp.font = AppFonts.sanProSemiBold.withSize(11)
    }
    
    func populateData(_ notification : [NotificationModel], _ indexPath : IndexPath){
        
        guard !notification.isEmpty else {
            return
        }
        
        self.notificationTypeLabel.text = notification[indexPath.row].notificationTitle
        self.notificationMessageLabel.text = notification[indexPath.row].message
        let notificationTime = notification[indexPath.row].notificationTime
        if let time = notificationTime?.getDateFromString(.utcTime,.ddMMMYYYYHHmm) {
            self.timeStamp.text = time.elapsedTime
        }
        
        if let isRead = notification[indexPath.row].isRead {
            let backgroundColor = (isRead != true.rawValue) ? UIColor.messageBackgroundWithCount : UIColor.white
            self.contentView.backgroundColor = backgroundColor
        }
    }
}
