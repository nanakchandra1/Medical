//
//  DashboardBMITableCell.swift
//  Mutelcor
//
//  Created by on 19/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DashboardBMITableCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var guageView: WMGaugeView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var needleCenter: NSLayoutConstraint!
    
    //MARK: Cell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 2.2
        containerView.shadow(2.2, CGSize(width: 1, height: 1), .black)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureGaugeView()
    }
    
    private func configureGaugeView() {
        
        self.guageView.showInnerBackground = false
        self.guageView.showInnerRim = false
        self.guageView.showRangeLabels = false
        self.guageView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat
        self.guageView.needleStyle = WMGaugeViewNeedleStyle3D
        
        self.guageView.scaleDivisionColor = .clear
        self.guageView.scaleSubDivisionColor = .clear
        
        self.guageView.innerRimWidth = 0
        self.guageView.innerRimBorderWidth = 0
        self.guageView.needleScrewRadius = 0
        
        self.guageView.maxValue = 50
        self.guageView.minValue = 18.5
        
        self.guageView.scaleEndAngle = 270
        self.guageView.scaleStartAngle = 90
    }
    
    func populateDasboardData(_ dashboardData: [DashboardDataModel]){
        
        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{
            return
        }
        guard !data.bmiLevel.isEmpty else{
            return
        }
        let bmiValue = data.bmiLevel[0].bmiLevel.rounded(toPlaces: 2)
        self.guageView.setValue(Float(bmiValue), animated: true)
    }
}
