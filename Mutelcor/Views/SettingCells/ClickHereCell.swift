//
//  ClickHereCell.swift
//  Mutelcor
//
//  Created by on 29/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TTTAttributedLabel
class ClickHereCell: UITableViewCell {
    
//    MARK:- IBOutelts
//    ================
    @IBOutlet weak var clickHereLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    func populateData(){
        self.clickHereLabel.text = "If you don't remember your old password. Click Here"
        self.clickHereLabel.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.linkLabelColor,
                                              NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(16)]
        let location = self.clickHereLabel.text?.count
        let length = "Click Here".count
        let range = NSRange(location: (location! - length), length: length)
        let url = URL(string: "www.google.com")
        self.clickHereLabel.addLink(to: url, with: range)
    }
}
