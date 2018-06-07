//
//  DashboardWeightTableCell.swift
//  Mutelcor
//
//  Created by  on 18/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DashboardWeightTableCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondPageView: UIView!
    @IBOutlet weak var thirdPageView: UIView!
    @IBOutlet weak var fourthPageView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: IndexedCollectionView!
    
    //MARK: Cell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.layer.cornerRadius = 2.2
        self.collectionView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 2.2
        self.containerView.shadow(2.2, CGSize(width: 1, height: 1), .black)
        
        let circularSegmentCollectionCellNib = UINib(nibName: "CircularSegmentCollectionCell", bundle: nil)
        self.collectionView.register(circularSegmentCollectionCellNib, forCellWithReuseIdentifier: "CircularSegmentCollectionCell")
        
        let caloriesConsumedCellNib = UINib(nibName: "CaloriesConsumedCell", bundle: nil)
        self.collectionView.register(caloriesConsumedCellNib, forCellWithReuseIdentifier: "caloriesConsumedCellID")
        
        let waterIntakeCellNib = UINib(nibName: "WaterIntakeCell", bundle: nil)
        self.collectionView.register(waterIntakeCellNib, forCellWithReuseIdentifier: "waterIntakeCellID")
        
        let timelineCellNib = UINib(nibName: "DashBoardTimeLineCell", bundle: nil)
        self.collectionView.register(timelineCellNib, forCellWithReuseIdentifier: "DashBoardTimeLineCell")

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.firstPageView.layer.cornerRadius = self.firstPageView.frame.height/2
        self.secondPageView.layer.cornerRadius = self.secondPageView.frame.height/2
        self.thirdPageView.layer.cornerRadius = self.thirdPageView.frame.height/2
        self.fourthPageView.layer.cornerRadius = self.fourthPageView.frame.height/2
        self.fifthView.layer.cornerRadius = self.fifthView.frame.height/2

    }
    
    func resetAll(selecting view: UIView) {
        self.firstPageView.alpha = 0.3
        self.secondPageView.alpha = 0.3
        self.thirdPageView.alpha = 0.3
        self.fourthPageView.alpha = 0.3
        self.fifthView.alpha = 0.3

        view.alpha = 1.0
    }    
}

