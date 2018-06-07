//
//  SwitchGraphCellTableViewCell.swift
//  Mutelcor
//
//  Created by on 16/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

//To mention which button is selected
enum VitalBtnTapped {
    case hb
    case tlc
    case platlet
}

class SwitchGraphCell: UITableViewCell {

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
    
    var vitalBtnTapped: VitalBtnTapped = VitalBtnTapped.hb{
        
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

        self.setupUI()
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
    func populateData(_ topMostData: [LatestThreeVitalData]){
        
        guard !topMostData.isEmpty else{
            
            self.contentView.isHidden = true
            return
        }
        self.contentView.isHidden = false
        if topMostData.count == 3 {
            if let firstButtonName = topMostData[0].vitalSubName{
                self.hbButtonOutlet.setTitle(firstButtonName, for: UIControlState.normal)
            }
            if let secondButtonName = topMostData[1].vitalSubName{
                self.tlcBtnOutlet.setTitle(secondButtonName, for: UIControlState.normal)
            }
            if let thirdButtonName = topMostData[2].vitalSubName{
                self.platletBtnOutlet.setTitle(thirdButtonName, for: UIControlState.normal)
            }
        }else if topMostData.count == 2 {
            self.platletBtnOutlet.isHidden = true
            if let firstButtonName = topMostData[0].vitalSubName{
                self.hbButtonOutlet.setTitle(firstButtonName, for: UIControlState.normal)
            }
            if let secondButtonName = topMostData[1].vitalSubName{
                self.tlcBtnOutlet.setTitle(secondButtonName, for: UIControlState.normal)
            }
        }else{
            self.tlcBtnOutlet.isHidden = true
            self.platletBtnOutlet.isHidden = true
            if let firstButtonName = topMostData[0].vitalSubName{
                self.hbButtonOutlet.setTitle(firstButtonName, for: UIControlState.normal)
            }
        }
        
    }
    
    func populateCellViewAsBtnTapped(_ switchBtnTapped: SwitchBtnTapped){
        
        let btnTapped = (switchBtnTapped == .graphBtnTapped) ? false : true

            self.hbBottomView.isHidden = btnTapped
            self.hbButtonOutlet.isHidden = btnTapped
            self.hbVerticalSepratorView.isHidden = btnTapped
            self.tlcBtnOutlet.isHidden = btnTapped
            self.tlcBottomView.isHidden = btnTapped
            self.tlcVerticalSepratorView.isHidden = btnTapped
            self.platletBtnOutlet.isHidden  = btnTapped
            self.platletBottomView.isHidden  = btnTapped
            
            if btnTapped {
                self.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedgraph"), for: UIControlState.normal)
                self.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedtable"), for: UIControlState.normal)
            }else{
                self.graphBtnOulet.setImage(#imageLiteral(resourceName: "icMeasurementSelectedgraph"), for: UIControlState.normal)
                self.tabelBtnOutlet.setImage(#imageLiteral(resourceName: "icMeasurementDeselectedtable"), for: UIControlState.normal)
            }
    }
}
