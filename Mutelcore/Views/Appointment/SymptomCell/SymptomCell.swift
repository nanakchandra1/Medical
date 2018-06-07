//
//  SymptomCell.swift
//  Mutelcore
//
//  Created by Ashish on 27/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SymptomCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellImage.image = #imageLiteral(resourceName: "icAppointmentDeselectedCheck")
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
