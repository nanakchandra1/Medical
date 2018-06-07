//
//  vitalTable.swift
//  Mutelcore
//
//  Created by Appinventiv on 01/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SpreadsheetView

class VitalTableCell: Cell {

//    MARK:- IBOutlets
    
    @IBOutlet weak var dateLabelOult: UILabel!
    @IBOutlet weak var timeLabelOult: UILabel!
    @IBOutlet weak var bottomSepratorView: UIView!
    @IBOutlet weak var verticalSepratorView: UIView!
    

   override func awakeFromNib() {
        super.awakeFromNib()
    
    self.bottomSepratorView.backgroundColor = UIColor.clear
    self.verticalSepratorView.backgroundColor = UIColor.clear

    self.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
    self.timeLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        self.dateLabelOult.text = nil
        self.timeLabelOult.text = nil
    }

}
