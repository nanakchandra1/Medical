//
//  MeasurementSectionCell.swift
//  Mutelcor
//
//  Created by on 26/12/17.
//  Copyright © 2017 "" All rights reserved.
//

import UIKit

class MeasurementSectionCell: UITableViewHeaderFooterView {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var cellText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellText.textColor = UIColor.white
        self.cellText.font = AppFonts.sanProSemiBold.withSize(14)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        self.contentView.gradient(withX: 0, withY: 0, cornerRadius: false)
    }

    func populateData(section: Int, vitalDicKeys: [String]){
        
        let key = vitalDicKeys[section]
        self.cellText.text = key
    }
}
