//
//  MessagesTableViewCell.swift
//  Mutelcor
//
//  Created by  on 14/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var innerViewOfMessageCount: UIView!
    @IBOutlet weak var outerViewOfMessageCount: UIView!
    @IBOutlet weak var viewContainObjects: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
   override func draw(_ rect: CGRect) {
        super.draw(rect)
    
    }
}

extension MessagesCell {
    
    fileprivate func setupUI(){
        
        self.viewContainObjects.layer.cornerRadius = 2.2
        self.viewContainObjects.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        
        self.userImage.roundCorner(radius: self.userImage.layer.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.outerViewOfMessageCount.roundCorner(radius: self.outerViewOfMessageCount.layer.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.innerViewOfMessageCount.roundCorner(radius: self.innerViewOfMessageCount.layer.frame.width / 2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.innerViewOfMessageCount.backgroundColor = UIColor.appColor
        
        self.messageCountLabel.textColor = UIColor.white
        self.messageCountLabel.font = AppFonts.sanProSemiBold.withSize(18.3)
        
        self.doctorName.font = AppFonts.sanProSemiBold.withSize(21)
        self.doctorSpecialityLabel.font = AppFonts.sansProRegular.withSize(17)
        
        self.messageDescription.font = AppFonts.sansProRegular.withSize(16)
        self.messageDescription.textColor = #colorLiteral(red: 0.2823529412, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
        self.messageDate.font = AppFonts.sansProRegular.withSize(16)
        self.messageDate.textColor = UIColor.grayLabelColor
        self.userImage.image = #imageLiteral(resourceName: "personal_info_place_holder")
    }
    
    func populateMessageData(_ patientMessages : [PatientMessageModel], _ indexPath : IndexPath){
        
        guard !patientMessages.isEmpty else{
            return
        }
        self.doctorName.text = patientMessages[indexPath.row].personName
        self.doctorSpecialityLabel.text = patientMessages[indexPath.row].docSpecailization
        
        self.messageDescription.text = patientMessages[indexPath.row].lastMessage?.replacingOccurrences(of: "\n", with: " ")
        
        let messageTime = patientMessages[indexPath.row].messageTime
        
        self.messageDate.text = messageTime?.changeDateFormat(.utcTime, .ddMMMYYYYHHmm)
        
        if let messageCount = patientMessages[indexPath.row].messageUnreadCount, messageCount != false.rawValue {
            self.outerViewOfMessageCount.isHidden = false
            self.messageCountLabel.text = "\(messageCount)"
            self.viewContainObjects.backgroundColor = UIColor.messageBackgroundWithCount
        }else{
            self.outerViewOfMessageCount.isHidden = true
            self.viewContainObjects.backgroundColor = UIColor.white
        }
        
        if let personImage = patientMessages[indexPath.row].doctorPic, !personImage.isEmpty{
            let percentageEncodingStr = personImage.replacingOccurrences(of: " ", with: "%20")
            let imgUrl = URL(string: percentageEncodingStr)
            self.userImage.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
        }
    }
}
