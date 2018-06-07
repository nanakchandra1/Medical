//
//  Do'sAndDont'sCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 15/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DosAndDontsCell: UITableViewCell {

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var dosBtnOult: UIButton!
    @IBOutlet weak var viewBtwnDosAndDonts: UIView!
    @IBOutlet weak var dontsBtnOutlt: UIButton!
    @IBOutlet weak var viewContainBtn: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.viewContainBtn.gradient(withX: 0, withY: 0, cornerRadius: false)
        
    }
}

extension DosAndDontsCell {
    
    fileprivate func setupUI(){
     
        self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        
        self.dosBtnOult.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.dosBtnOult.setTitle("DO'S", for: UIControlState.normal)
        self.dosBtnOult.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        self.dontsBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.dontsBtnOutlt.setTitle("DONT'S", for: UIControlState.normal)
        self.dontsBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(15.8)
        
    }
}
