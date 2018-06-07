//
//  NotificationDetailCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class NotificationDetailCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ===============
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var appointmentStatusLabel: UILabel!
    @IBOutlet weak var apppointmentDateLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
    @IBOutlet weak var favouriteBtnOutlt: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var selectNotificationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



extension NotificationDetailCell {
    
    fileprivate func setupUI(){
        
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.appointmentStatusLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.apppointmentDateLabel.font = AppFonts.sansProRegular.withSize(11)
        self.apppointmentDateLabel.textColor = UIColor.sepratorColor
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
        self.selectNotificationBtn.isHidden = true
    }
}
