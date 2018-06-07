//
//  LogBookTableViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 03/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class LogBookTableViewCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var logBookCellTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Methods
extension LogBookTableViewCell {
    
    fileprivate func setupUI(){
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let logBookCellNib = UINib(nibName: "LogBookCell", bundle: nil)
        self.logBookCellTableView.register(logBookCellNib, forCellReuseIdentifier: "logBookCellID")
        
        let logBookHeaderCellNib = UINib(nibName: "LogBookHeaderCell", bundle: nil)
        self.logBookCellTableView.register(logBookHeaderCellNib, forHeaderFooterViewReuseIdentifier: "logBookHeaderCellID")
    }
}
