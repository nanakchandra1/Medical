//
//  PersonalInfoHeaderCell.swift
//  Mutelcor
//
//  Created by  on 04/01/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class PersonalInfoHeaderCell: UITableViewHeaderFooterView {

//    MARK:- IBOutlets
//    ================
    
    @IBOutlet weak var expandButtonOutlt: IndexedButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.expandButtonOutlt.setImage(#imageLiteral(resourceName: "icActivityplanAdd"), for: .normal)
        self.headerTitle.isHidden = false
        self.cellBackgroundView.isHidden = false
        self.sepratorView.isHidden = false
        self.sepratorView.backgroundColor = UIColor.sepratorColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.expandButtonOutlt.isHidden = false
        self.headerTitle.isHidden = false
        self.cellBackgroundView.isHidden = false
        self.sepratorView.isHidden = false
    }
    
    func populateDataInHeader(titles: [String], section: Int){
        self.expandButtonOutlt.outerIndex = section
        self.contentView.backgroundColor = UIColor.activityVCBackgroundColor
        self.backgroundColor = UIColor.activityVCBackgroundColor
        let textColor = section == 2 ? UIColor.appColor : UIColor.headerTitleColor
        self.headerTitle.textColor = textColor
        let isBottomViewHidden = section == 2 ? true : false
        self.sepratorView.isHidden = isBottomViewHidden
        let font = section == 2 ? 12 : 16.9
        self.headerTitle.font = AppFonts.sanProSemiBold.withSize(CGFloat(font))
        
        let expandButtonHidden = (section == 2 || section == 3 || section == 4 || section == 5) ? true : false
        self.expandButtonOutlt.isHidden = expandButtonHidden
        let cellBackgroundViewHidden = section == 3 || section == 4 ? true : false
        self.cellBackgroundView.isHidden = cellBackgroundViewHidden
         self.headerTitle.text = titles[section]
    }
    
    func populateFooterView(section: Int){
        self.expandButtonOutlt.isHidden = true
        self.headerTitle.isHidden = true
        self.cellBackgroundView.isHidden = true
        self.sepratorView.isHidden = true
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
    }
}
