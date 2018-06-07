//
//  VitalVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 10/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class VitalVC: BaseViewController {

//    MARK:- Proporties
//    =================
var measurementHomeData = [MeasurementHomeData]()

//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var vitalCollectionView: UICollectionView!
    @IBOutlet weak var addMeasurementBtn: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.vitalCollectionView.delegate = self
        self.vitalCollectionView.dataSource = self
        self.vitalCollectionView.reloadData()
    }
}

//MARK:- CollectionView Datasource Methods
//=======================================
extension VitalVC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      return  self.measurementHomeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else{
            
            fatalError("VitalListingCell Not Found!")
        }
        
        cell.populateMeasurementData(self.measurementHomeData, indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let myMeasurementDetailScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
        
        if let topController = UIApplication.topViewController() as? SlideMenuController, let navVC = topController.mainViewController as? UINavigationController {
            
            navVC.pushViewController(myMeasurementDetailScene, animated: true)
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension VitalVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIDevice.getScreenWidth / 3 - 1, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}


//MARK:- Methods
//==============
extension VitalVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.addMeasurementBtn.addTarget(self, action: #selector(self.addMeasurementBtnTapped(_:)), for: .touchUpInside)
        self.addMeasurementBtn.setImage(#imageLiteral(resourceName: "icMeasurementAdd"), for: UIControlState.normal)
        self.addMeasurementBtn.tintColor = UIColor.appColor
        self.addMeasurementBtn.isHidden = true
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.text = "No Measurement Data. Tap icon to Add Measurement."
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        
//        self.noDataAvailiableLabelOutlt.isHidden = true
//        self.noDataAvailiableLabelOutlt.font = AppFonts.sanProSemiBold.withSize(15)
//        self.noDataAvailiableLabelOutlt.textColor = UIColor.appColor
        
        self.vitalCollectionView.backgroundColor = UIColor.clear
        let vitalListingNib = UINib(nibName: "VitalListingCell", bundle: nil)
        self.vitalCollectionView.register(vitalListingNib, forCellWithReuseIdentifier: "vitalListingCellID")
        
    }
    
    @objc fileprivate func addMeasurementBtnTapped(_ sender : UIButton){
        
        let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
        self.navigationController?.pushViewController(addMeasurementScene, animated: true)
        
    }

    
//    Data Not Availiable
//    ===================
    func showNoDataLabel(_ noDataAvaliable : Bool){
        
//        if noDataAvaliable{
//
//            self.noDataAvailiableLabelOutlt.isHidden = false
//            self.noDataAvailiableLabelOutlt.text = "No Records Found!"
//            self.vitalCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//        }else{
//            self.noDataAvailiableLabelOutlt.isHidden = true
//            self.vitalCollectionView.backgroundColor = #colorLiteral(red: 0.9332545996, green: 0.9333854318, blue: 0.9332134128, alpha: 1)
//
//        }
    }
}
