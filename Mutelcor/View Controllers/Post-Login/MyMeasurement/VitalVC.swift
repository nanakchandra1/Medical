//
//  VitalVC.swift
//  Mutelcor
//
//  Created by on 10/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VitalVC: BaseViewController {
    
    enum MeasurementValuesFor {
        case vitals
        case images
    }
    
    //    MARK:- Proporties
    //    =================
    
    var measurementValuesFor: MeasurementValuesFor = .vitals
    var measurementHomeData = [MeasurementHomeData]()
    var imageData = [ImageDataModel]()
    weak var delegate: RefreshDelegate?
    
    //    MARK:- IBOutlets
    //    =================
    
    @IBOutlet weak var vitalCollectionView: UICollectionView!
    
    @IBOutlet weak var viewContainAddMeasurementBtn: UIView!
    @IBOutlet weak var addMeasurementBtn: UIButton!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
}

//MARK:- CollectionView Datasource Methods
//=======================================
extension VitalVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.measurementValuesFor == .vitals {
            return  self.measurementHomeData.count
        }else if self.measurementValuesFor == .images{
            return  self.imageData.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else{
            fatalError("VitalListingCell Not Found!")
        }
        
        if self.measurementValuesFor == .vitals {
            cell.populateMeasurementData(self.measurementHomeData, indexPath)
        }else if self.measurementValuesFor == .images{
            cell.populateImageData(self.imageData, indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if let topController = UIApplication.topViewController() as? SlideMenuController, let navVC = topController.mainViewController as? UINavigationController {
            
            if self.measurementValuesFor == .vitals {

                switch self.measurementHomeData[indexPath.item].valueConversion {
                    
                case "-":
                    let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
                    addMeasurementScene.delegate = navVC.viewControllers.last as? RefreshDelegate
                    addMeasurementScene.selectedVitalName = self.measurementHomeData[indexPath.item].vitalName
                    addMeasurementScene.selectedVitalID = self.measurementHomeData[indexPath.item].vitalId
                    navVC.pushViewController(addMeasurementScene, animated: true)
                default:
                    let myMeasurementDetailScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
                    myMeasurementDetailScene.selectedVitalName = self.measurementHomeData[indexPath.item].vitalName
                    myMeasurementDetailScene.selectVitalCategoryID = self.measurementHomeData[indexPath.item].vitalCategory
                    myMeasurementDetailScene.selectedVitalID = self.measurementHomeData[indexPath.item].vitalId
                    myMeasurementDetailScene.proceeedToScreenThrough = .vitalScreen
                    navVC.pushViewController(myMeasurementDetailScene, animated: true)
                }
            }else if self.measurementValuesFor == .images{
                if let attcahmentName = self.imageData[indexPath.item].attachmentName, !attcahmentName.isEmpty {
                    let myMeasurementDetailScene = MyMeasurementDetailVC.instantiate(fromAppStoryboard: .Measurement)
                    myMeasurementDetailScene.selectedVitalName = self.imageData[indexPath.item].vitalName
                    myMeasurementDetailScene.selectVitalCategoryID = self.imageData[indexPath.item].categoryType
                    if let id = self.imageData[indexPath.item].vitalSuperId {
                    myMeasurementDetailScene.selectedVitalID = Int(id)
                    }
                    myMeasurementDetailScene.graphDataDic["end_date"] = Date().stringFormDate(.yyyyMMdd)
                    myMeasurementDetailScene.graphDataDic["vital_super_id"] = self.imageData[indexPath.item].vitalSuperId
                    myMeasurementDetailScene.selectVitalCategoryID = self.imageData[indexPath.item].categoryType
                    myMeasurementDetailScene.proceeedToScreenThrough = .images
                    navVC.pushViewController(myMeasurementDetailScene, animated: true)
                    
//                    let imageScene = ImageDetailVC.instantiate(fromAppStoryboard: .Measurement)
//                    imageScene.imageData = self.imageData[indexPath.item]
//                    let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
//                    webViewScene.screenName = attcahmentName
//                    webViewScene.webViewUrl = self.imageData[indexPath.item].attachments
//                    navVC.pushViewController(myMeasurementDetailScene, animated: true)
                }else{
                    let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
                    addMeasurementScene.delegate = navVC.viewControllers.last as? RefreshDelegate
                    addMeasurementScene.selectedVitalName = self.imageData[indexPath.item].vitalName
                    if let id = self.imageData[indexPath.item].vitalId{
                        addMeasurementScene.selectedVitalID = Int(id)
                    }
                    navVC.pushViewController(addMeasurementScene, animated: true)
                }
            }
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension VitalVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.getScreenWidth / 3 - 4 , height: 170)
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
        self.viewContainAddMeasurementBtn.isHidden = true
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.text = K_NO_MEASUREMENT_DATA.localized
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        
        self.vitalCollectionView.delegate = self
        self.vitalCollectionView.dataSource = self
        
        self.vitalCollectionView.backgroundColor = UIColor.clear
        let vitalListingNib = UINib(nibName: "VitalListingCell", bundle: nil)
        self.vitalCollectionView.register(vitalListingNib, forCellWithReuseIdentifier: "vitalListingCellID")
    }
    
    @objc fileprivate func addMeasurementBtnTapped(_ sender : UIButton){
        
        if let topController = UIApplication.topViewController() as? SlideMenuController, let navVC = topController.mainViewController as? UINavigationController {
            let addMeasurementScene = AddMeasurementVC.instantiate(fromAppStoryboard: .Measurement)
            addMeasurementScene.delegate = self
            navVC.pushViewController(addMeasurementScene, animated: true)
        }
    }
}

extension VitalVC : RefreshDelegate {
    func refreshScreen() {
        self.delegate?.refreshScreen()
    }
}
