//
//  TableContentView.swift
//  Mutelcor
//
//  Created by on 03/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class TableContentView: UIView {

    @IBOutlet weak var contentTableView: UITableView!
    
    class func instanciateFromNib() -> TableContentView {
        return Bundle.main.loadNibNamed("tableContentView", owner: nil, options: nil)?.first as! TableContentView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
