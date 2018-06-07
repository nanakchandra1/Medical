//
//  CircularSegmentCollectionCell.swift
//  Mutelcor
//
//  Created by  on 19/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FloatRatingView

class CircularSegmentCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var circularSegmentView: CircularSegmentView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var currentWeightDotView: UIView!
    @IBOutlet weak var startingWeightDotView: UIView!
    @IBOutlet weak var targetWeightDotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.editable = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        currentWeightDotView.layer.cornerRadius = currentWeightDotView.frame.height/2
        startingWeightDotView.layer.cornerRadius = startingWeightDotView.frame.height/2
        targetWeightDotView.layer.cornerRadius = targetWeightDotView.frame.height/2
    }
    
    func populateDashboardData(_ dashboardData: [DashboardDataModel]){

        guard !dashboardData.isEmpty else{
            return
        }
        guard let data = dashboardData.first else{  
            return
        }
        let rating = dashboardData[0].rating
        self.ratingView.rating = Float(rating ?? 0)
        guard !data.weightInfo.isEmpty else{
            return
        }
        
        let currentWeight = data.weightInfo[0].currentWeight
        let startingWeight = data.weightInfo[0].startWeight
        let targetWeight = data.weightInfo[0].targetWeight
        
        self.circularSegmentView.currentWeight = Int(currentWeight)
        self.circularSegmentView.startingWeight = Int(startingWeight)
        self.circularSegmentView.targetWeight = Int(targetWeight)
    }
}
