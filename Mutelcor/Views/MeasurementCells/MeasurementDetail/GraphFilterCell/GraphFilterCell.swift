//
//  GraphFilterCell.swift
//  Mutelcor
//
//  Created by on 17/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import TransitionButton

//    MARK:- Global Enums
//    ===================
enum FilterState: Int {
    case oneWeek
    case oneMonth
    case threeMonth
    case sixMonth
    case oneYear
    case all
}

class GraphFilterCell: UITableViewCell {
    
//    MARK:- Propeorties
//    ==================
    var buttonState : FilterState = .all {
        
        willSet {
            
            switch newValue {
                
            case .oneWeek : self.oneWeekBtn.backgroundColor = UIColor.appColor
                self.oneWeekBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                self.oneWeekBtn.layer.cornerRadius = 2.5
                self.oneWeekBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                for btn in [oneMonthBtn, threeMonthBtn, sixMonthBtn,oneYearBtn,allBtn]
                {
                    btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                    btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                    btn?.setTitleColor(UIColor.appColor, for: .normal)
                    btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                }
                
            case .oneMonth : self.oneMonthBtn.backgroundColor = UIColor.appColor
            self.oneMonthBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.oneMonthBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
            self.oneMonthBtn.layer.cornerRadius = 2.5
            for btn in [oneWeekBtn, threeMonthBtn, sixMonthBtn,oneYearBtn,allBtn]
            {
                btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                btn?.setTitleColor(UIColor.appColor, for: .normal)
                btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                }
                
            case .threeMonth : self.threeMonthBtn.backgroundColor = UIColor.appColor
            self.threeMonthBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.threeMonthBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
            self.threeMonthBtn.layer.cornerRadius = 2.5
            for btn in [oneWeekBtn, oneMonthBtn, sixMonthBtn,oneYearBtn,allBtn]
            {
                btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                btn?.setTitleColor(UIColor.appColor, for: .normal)
                btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                }
                
            case .sixMonth : self.sixMonthBtn.backgroundColor = UIColor.appColor
            self.sixMonthBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.sixMonthBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
            self.sixMonthBtn.layer.cornerRadius = 2.5
            for btn in [oneWeekBtn, oneMonthBtn, threeMonthBtn,oneYearBtn,allBtn]
            {
                btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                btn?.setTitleColor(UIColor.appColor, for: .normal)
                btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                }
                
            case .oneYear : self.oneYearBtn.backgroundColor = UIColor.appColor
            self.oneYearBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.oneYearBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
            self.oneYearBtn.layer.cornerRadius = 2.0
            for btn in [oneWeekBtn, oneMonthBtn, threeMonthBtn, sixMonthBtn, allBtn]
            {
                btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                btn?.setTitleColor(UIColor.appColor, for: .normal)
                btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                }
                
            case .all : self.allBtn.backgroundColor = UIColor.appColor
            self.allBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.allBtn.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
            self.allBtn.layer.cornerRadius = 2.0
            for btn in [oneWeekBtn, threeMonthBtn, sixMonthBtn,oneYearBtn,oneMonthBtn]
            {
                btn?.titleLabel?.font = AppFonts.sanProSemiBold.withSize(11.5)
                btn?.roundCorner(radius: 2.5, borderColor: UIColor.appColor, borderWidth: 1.0)
                btn?.setTitleColor(UIColor.appColor, for: .normal)
                btn?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                }
            }
        }
    }

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var oneWeekBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var threeMonthBtn: UIButton!
    @IBOutlet weak var sixMonthBtn: UIButton!
    @IBOutlet weak var oneYearBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var loadMoreBtnOutlt: TransitionButton!
    @IBOutlet weak var loadmoreBtnHeightConstant: NSLayoutConstraint!
    
//    MARK:- Cell LifeCycle
//    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.setUpUI()
    }
}

//MARK:- Methods
//===============
extension GraphFilterCell {
  
    func setUpUI() {
        
        self.buttonState = .all
        
    self.loadMoreBtnOutlt.setTitle("More", for: .normal)
    self.loadMoreBtnOutlt.titleLabel?.font = AppFonts.sanProSemiBold.withSize(12)
    self.loadMoreBtnOutlt.setTitleColor(UIColor.white, for: UIControlState.normal)
    self.loadMoreBtnOutlt.backgroundColor = UIColor.appColor
    self.loadMoreBtnOutlt.roundCorner(radius: self.loadMoreBtnOutlt.layer.frame.height/2, borderColor: UIColor.clear, borderWidth: .leastNormalMagnitude)
    self.oneMonthBtn.setTitle(K_ONE_MONTH_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
    self.oneWeekBtn.setTitle(K_ONE_WEEK_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
    self.threeMonthBtn.setTitle(K_THREE_MONTH_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
    self.sixMonthBtn.setTitle(K_SIX_MONTH_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
    self.oneYearBtn.setTitle(K_ONE_YEAR_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
    self.allBtn.setTitle(K_ALL_BUTTON_TITLE_PLACEHOLDER.localized, for: .normal)
  
    self.selectionStyle = UITableViewCellSelectionStyle.none

    }
}
