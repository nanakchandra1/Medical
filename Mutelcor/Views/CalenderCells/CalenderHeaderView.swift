//
//  CalenderHeaderView.swift
//  Mutelcor
//
//  Created by on 03/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FSCalendar
import MXParallaxHeader

class CalenderHeaderView: UIView, MXParallaxHeaderDelegate {
    
    @IBOutlet weak var calendarContentView: FSCalendar!
    
    class func instanciateFromNib() -> CalenderHeaderView {
        return Bundle.main.loadNibNamed("CalenderHeaderView", owner: nil, options: nil)?.first as! CalenderHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - <MXParallaxHeader>
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
    }
}
