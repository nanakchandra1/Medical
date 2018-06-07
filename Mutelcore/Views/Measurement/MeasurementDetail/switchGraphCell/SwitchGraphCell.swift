//
//  SwitchGraphCellTableViewCell.swift
//  Mutelcore
//
//  Created by Appinventiv on 16/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SwitchGraphCell: UITableViewCell {

//    MARK:- Proporties
//    =================
    enum VitalBtnTapped {
        
        case hb, tlc, platlet
        
    }

//    MARK:- IBOutlets
//    ===============
    @IBOutlet weak var hbButtonOutlet: UIButton!
    @IBOutlet weak var tlcBtnOutlet: UIButton!
    @IBOutlet weak var platletBtnOutlet: UIButton!
    @IBOutlet weak var graphBtnOulet: UIButton!
    @IBOutlet weak var tabelBtnOutlet: UIButton!
    @IBOutlet weak var hbBottomView: UIView!
    @IBOutlet weak var tlcBottomView: UIView!
    @IBOutlet weak var platletBottomView: UIView!
    @IBOutlet weak var hbVerticalSepratorView: UIView!
    @IBOutlet weak var tlcVerticalSepratorView: UIView!
    
    var vitalBtnTapped : VitalBtnTapped = VitalBtnTapped.hb{
        
        willSet{
            
            switch newValue {
                
            case .hb :
                self.hbButtonOutlet.setTitleColor(UIColor.appColor, for: .normal)
                self.tlcBtnOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.platletBtnOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.hbBottomView.backgroundColor = UIColor.appColor
                self.tlcBottomView.backgroundColor = UIColor.clear
                self.platletBottomView.backgroundColor = UIColor.clear
                
                
            case .tlc :
                
                self.tlcBtnOutlet.setTitleColor(UIColor.appColor, for: .normal)
                self.hbButtonOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.platletBtnOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.hbBottomView.backgroundColor = UIColor.clear
                self.tlcBottomView.backgroundColor = UIColor.appColor
                self.platletBottomView.backgroundColor = UIColor.clear
                
                
            case .platlet :
                self.platletBtnOutlet.setTitleColor(UIColor.appColor, for: .normal)
                self.tlcBtnOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.hbButtonOutlet.setTitleColor(UIColor.textColor, for: .normal)
                self.hbBottomView.backgroundColor = UIColor.clear
                self.tlcBottomView.backgroundColor = UIColor.clear
                self.platletBottomView.backgroundColor = UIColor.appColor
            }
        }
    }
    
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

extension SwitchGraphCell {
    
    fileprivate func setupUI(){
     
      self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.hbButtonOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.tlcBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.platletBtnOutlet.titleLabel?.font = AppFonts.sanProSemiBold.withSize(13.6)
        self.hbBottomView.backgroundColor = UIColor.appColor
        self.tlcBottomView.backgroundColor = UIColor.clear
        self.platletBottomView.backgroundColor = UIColor.clear
        
    }
    
//    MARK:- Represent button Titles
//    =============================
    func populateData(_ topMostData : [LatestThreeVitalData]){
        
        guard !topMostData.isEmpty else{
            
            return
        }
        
        if let firstButtonName = topMostData[0].vitalSubName{
            
            self.hbButtonOutlet.setTitle(firstButtonName, for: UIControlState.normal)
        }
        if let secondButtonName = topMostData[1].vitalSubName{
            
            self.tlcBtnOutlet.setTitle(secondButtonName, for: UIControlState.normal)
        }
        if let thirdButtonName = topMostData[2].vitalSubName{
            
            self.platletBtnOutlet.setTitle(thirdButtonName, for: UIControlState.normal)
        }
    }
}
