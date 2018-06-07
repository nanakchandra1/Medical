//
//  ReceiverCell.swift
//  Mutelcore
//
//  Created by Ashish on 14/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var triangleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ReceiverCell {
    
    fileprivate func setupUI(){
        
        self.messageView.layer.cornerRadius = 2.2
        self.messageView.clipsToBounds = false
        
        self.messageView.shadow(2.2, CGSize(width: 1.0, height: 1.0), UIColor.black)
        self.messageView.backgroundColor = UIColor.senderMessageBackgroundColor
        
        self.messageText.font = AppFonts.sansProRegular.withSize(14)
        self.messageTime.font = AppFonts.sansProRegular.withSize(11)
        
    }
}
