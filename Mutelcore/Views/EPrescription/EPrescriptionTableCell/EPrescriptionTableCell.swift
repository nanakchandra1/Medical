//
//  EPrescriptionTableCell.swift
//  Mutelcore
//
//  Created by Aakash Srivastav on 29/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class EPrescriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var viewContainAllObjects: UIView!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var timeTextLabel: UILabel!
    @IBOutlet var monthYearTextLabel: UILabel!
    
    @IBOutlet weak var dateTextverticalLineView: UIView!
    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var doctorSpecialityLabel: UILabel!
    
    @IBOutlet var shareImageView: UIImageView!
    @IBOutlet var shareImageContainerView: UIView!
    
    @IBOutlet var ePrescriptionBtn: UIButton!
    @IBOutlet var ePrescriptionBtnContainerView: UIView!
    @IBOutlet var ePrescriptionBtnContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet var remarkViewTopLineView: UIView!
    @IBOutlet var remarkViewBottomLineView: UIView!
    @IBOutlet var remarkLabel: UILabel!
    @IBOutlet var remarkLabelTop: NSLayoutConstraint!
    @IBOutlet var remarkLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var remarkViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var prescriptionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}

extension EPrescriptionTableCell {
    
    fileprivate func setupUI(){
        
    self.viewContainAllObjects.shadow(2.2, CGSize(width: 2, height: 2), UIColor.black)
    self.viewContainAllObjects.layer.cornerRadius = 2.2
    self.viewContainAllObjects.clipsToBounds = false
        
    self.shareImageView.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
    self.shareImageView.image = #imageLiteral(resourceName: "icActivityplanShare")
    self.dateTextLabel.font = AppFonts.sansProBold.withSize(29.5)
    self.monthYearTextLabel.font = AppFonts.sansProBold.withSize(12.5)
    self.timeTextLabel.font = AppFonts.sanProSemiBold.withSize(12)
    self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(18)
    self.doctorSpecialityLabel.font = AppFonts.sansProRegular.withSize(11.3)
    self.dateTextverticalLineView.backgroundColor = UIColor.sepratorColor
    self.remarkViewTopLineView.backgroundColor = UIColor.sepratorColor
    self.remarkViewBottomLineView.backgroundColor = UIColor.sepratorColor
    self.ePrescriptionBtn.roundCorner(radius: 2.2, borderColor: UIColor.ePrescriptionBtnColor, borderWidth: 1.0)
    self.ePrescriptionBtn.setTitle("ePrescription", for: UIControlState.normal)
    self.ePrescriptionBtn.setTitleColor(UIColor.ePrescriptionBtnColor, for: UIControlState.normal)
    self.ePrescriptionBtn.tintColor = UIColor.ePrescriptionBtnColor
        
    self.contentView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        
    }
}

