//
//  SideMenuCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

//    MARK:- Proporties
//    ================
    lazy var gradientView = UIView()
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var viewContainImage: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.sepratorView.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        gradientView.frame = bounds
        
        self.viewContainImage.gradient(withX: 0, withY: 0, cornerRadius: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
