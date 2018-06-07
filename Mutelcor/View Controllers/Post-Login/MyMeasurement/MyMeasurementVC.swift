//
//  MyMeasurementViewController.swift
//  Mutelcor
//
//  Created by  on 14/04/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import PageMenu
import SwiftyJSON

class MyMeasurementVC: BaseViewController {
    
    //    MARK:- Proporties
    //    ================
   fileprivate var appointmentButtonTapped = false
    
   fileprivate var measurementHomeData = [MeasurementHomeData]()
   fileprivate var measurementCategory = [MeasurementCategory]()
   fileprivate var imageData = [ImageDataModel]()
   fileprivate var vitalScene : VitalVC!
   fileprivate var pageMenu : CAPSPageMenu?
   fileprivate var controllerArray :[UIViewController] = []
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMeasurementCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.floatBtn.didMoveToSuperview()
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_MEASUREMENT_SCREEN_TITLE.localized)
        
    }
}

//MARK:- Pagemenu delegate Methods
//================================
extension MyMeasurementVC : CAPSPageMenuDelegate {
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
        self.vitalScene = controller as? VitalVC
        let measurementData = self.measurementCategory[index]
        self.getMeasurementList(measurementData,index)
    }
}

//MARK:- Methods
//==============
extension MyMeasurementVC {
    
    fileprivate func getMeasurementCategory(){
        
        WebServices.getMeasurementCategory(success: { [weak self](_ measurementCategory : [MeasurementCategory]) in
            
            guard let myMeasurementVC = self else{
                return
            }
            myMeasurementVC.measurementCategory = measurementCategory
            myMeasurementVC.controllerArray = []
            for value in measurementCategory {
                
                let vitalScene = VitalVC.instantiate(fromAppStoryboard: .Measurement)
                if myMeasurementVC.vitalScene == nil {
                    myMeasurementVC.vitalScene = vitalScene
                }
                vitalScene.delegate = self
                vitalScene.title = value.categoryName
                myMeasurementVC.controllerArray.append(vitalScene)
            }
            
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(0.0),
                .scrollMenuBackgroundColor(UIColor.white),
                .viewBackgroundColor(UIColor.white),
                .useMenuLikeSegmentedControl(true),
                .menuItemSeparatorPercentageHeight(0),
                .menuHeight(45.5),
                .selectedMenuItemLabelColor(UIColor.appColor),
                .selectionIndicatorColor(UIColor.appColor),
                .unselectedMenuItemLabelColor(UIColor.grayLabelColor),
                .menuItemFont(AppFonts.sanProSemiBold.withSize(13.6))
            ]
            
            myMeasurementVC.pageMenu = CAPSPageMenu(viewControllers: myMeasurementVC.controllerArray, frame: CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight), pageMenuOptions: parameters)
            myMeasurementVC.pageMenu?.delegate = self
            
            myMeasurementVC.view.addSubview(self!.pageMenu!.view)
            myMeasurementVC.view.sendSubview(toBack: self!.pageMenu!.view)
            if !myMeasurementVC.measurementCategory.isEmpty{
                myMeasurementVC.getMeasurementList(myMeasurementVC.measurementCategory[0], 0)
            }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getMeasurementList(_ measurementData: MeasurementCategory,_ index : Int){
        
        let id = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        let param = ["id" : id,
                     "category_id" : measurementData.id!,
                     "category_type" : measurementData.categoryType!] as [String : Any]
        
        WebServices.getMeasurementHomeData(parameters: param, success: {[weak self] (_ measurementHomeData : [MeasurementHomeData], imageData : [ImageDataModel]) in
            
            guard let myMeasurementVC = self else{
                return
            }
            
            myMeasurementVC.measurementHomeData = measurementHomeData
            myMeasurementVC.imageData = imageData
            
            myMeasurementVC.vitalScene?.measurementHomeData = []
            myMeasurementVC.vitalScene?.imageData = []
            
            if myMeasurementVC.measurementCategory[index].categoryType == 1 {
                
                if !myMeasurementVC.measurementHomeData.isEmpty{
                    myMeasurementVC.vitalScene?.viewContainAddMeasurementBtn.isHidden = true
                    myMeasurementVC.vitalScene?.measurementValuesFor = .vitals
                    myMeasurementVC.vitalScene?.view.backgroundColor = UIColor.activityVCBackgroundColor
//                    myMeasurementVC.vitalScene?.measurementHomeData.append(myMeasurementVC.measurementHomeData[index])
                    myMeasurementVC.vitalScene.measurementHomeData = myMeasurementVC.measurementHomeData
//                    myMeasurementVC.vitalScene?.measurementHomeData.append(myMeasurementVC.measurementHomeData[0])
                }else{
                    myMeasurementVC.vitalScene?.viewContainAddMeasurementBtn.isHidden = false
                    myMeasurementVC.vitalScene?.view.backgroundColor = UIColor.white
                }
            }else{
                
                if let imageValues = self?.imageData, !imageValues.isEmpty {
                    myMeasurementVC.vitalScene?.viewContainAddMeasurementBtn.isHidden = true
                    myMeasurementVC.vitalScene?.view.backgroundColor = UIColor.activityVCBackgroundColor
                    myMeasurementVC.vitalScene?.measurementValuesFor = .images
                    myMeasurementVC.vitalScene?.imageData = imageValues
                }else{
                    myMeasurementVC.vitalScene?.viewContainAddMeasurementBtn.isHidden = false
                    myMeasurementVC.vitalScene?.view.backgroundColor = UIColor.white
                }
            }
            myMeasurementVC.vitalScene?.vitalCollectionView.reloadData()
        }) { (error) in
            self.measurementHomeData = []
            self.imageData = []
            showToastMessage(error.localizedDescription)
        }
    }
}

extension MyMeasurementVC: RefreshDelegate {
    
    func refreshScreen() {
//        self.pageMenu?.currentPageIndex = 0
        self.pageMenu?.moveToPage(0)
        if !self.measurementCategory.isEmpty{
            self.getMeasurementList(self.measurementCategory[0], 0)
        }
//        self.getMeasurementCategory()
    }
}
