//
//  IndexedShapeLayer.swift
//  Mutelcor
//
//  Created by  on 18/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class IndexedShapeLayer: CAShapeLayer {
    var index: Int?
    
    func setSelectedColor() {
        self.fillColor = UIColor(red: 252/255, green: 174/255, blue: 22/255, alpha: 1).cgColor
        self.strokeColor = UIColor(red: 192/255, green: 127/255, blue: 0, alpha: 1).cgColor
    }
    
    func setUnselectedColor() {
        self.fillColor = UIColor(red: 44/255, green: 193/255, blue: 187/255, alpha: 1).cgColor
        self.strokeColor = UIColor(red: 44/255, green: 189/255, blue: 132/255, alpha: 1).cgColor
    }
}
