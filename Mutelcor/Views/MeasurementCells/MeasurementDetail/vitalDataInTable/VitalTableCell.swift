//
//  vitalTable.swift
//  Mutelcor
//
//  Created by on 01/06/17.
//  Copyright © 2017. All rights reserved.
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
        
        self.bottomSepratorView.isHidden = true
        self.verticalSepratorView.isHidden = true
        self.bottomSepratorView.backgroundColor = UIColor.white
        self.verticalSepratorView.backgroundColor = UIColor.white
        
        self.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
        self.timeLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.verticalSepratorView.dashLine(CGPoint(x: 0.0, y: self.verticalSepratorView.layer.frame.origin.y), CGPoint(x: 0, y: self.verticalSepratorView.layer.frame.height))
         self.bottomSepratorView.dashLine(CGPoint(x: 0.0, y: 0.0), CGPoint(x: self.bottomSepratorView.layer.frame.width, y: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dateLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
        self.timeLabelOult.font = AppFonts.sanProSemiBold.withSize(14)
        self.dateLabelOult.text = nil
        self.timeLabelOult.text = nil
        dateLabelOult.textColor = .black
    }

}
