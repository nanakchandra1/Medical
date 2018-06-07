//
//  TallerNavigationBar.swift
//  Mutelcor
//
//  Created by on 12/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class TallerNavigationBar: UINavigationBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 52)
    }
}
