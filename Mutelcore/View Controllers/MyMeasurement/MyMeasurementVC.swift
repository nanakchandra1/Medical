//
//  MyMeasurementViewController.swift
//  Mutelcore
//
//  Created by Ashish on 14/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import PageMenu
import SwiftyJSON

class MyMeasurementVC: BaseViewController {

//    MARK:- Proporties
//    ================
    var appointmentButtonTapped = false
    
    var measurementHomeData = [MeasurementHomeData]()
    var measurementCategory = [MeasurementCategory]()
    
    var vitalScene : VitalVC?
    
    var pageMenu : CAPSPageMenu?
    var controllerArray :[UIViewController] = []
    
//    MARK:- IBOutlets
//    ================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        
        self.getMeasurementcategory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Measurements", 2, 3)
    
    }
}

//MARK:- Pagemenu delegate Methods
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
    
    //SetupUi
    fileprivate func setupUI(){
        
        //        self.view.backgroundColor = UIColor.black
        
        
        
    }
    
        
    fileprivate func getMeasurementcategory(){
        
        let param = [String : Any]()
        
        WebServices.getMeasurementCategory(parameters: param, success: { [weak self](_ measurementCategory : [MeasurementCategory]) in
            
            self?.measurementCategory = measurementCategory
            self?.controllerArray = []
            for value in measurementCategory {
                
                let vitalScene = VitalVC.instantiate(fromAppStoryboard: .Measurement)
                vitalScene.view.backgroundColor = UIColor.lightGray
                vitalScene.title = value.categoryName
                self?.controllerArray.append(vitalScene)
                
            }
            
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(0.0),
                .scrollMenuBackgroundColor(UIColor.white),
                .viewBackgroundColor(UIColor.lightGray),
                .useMenuLikeSegmentedControl(true),
                .menuItemSeparatorPercentageHeight(0),
                .menuHeight(45.5),
                .selectedMenuItemLabelColor(UIColor.appColor),
                .selectionIndicatorColor(UIColor.appColor),
                .unselectedMenuItemLabelColor(UIColor.grayLabelColor),
                .menuItemFont(AppFonts.sanProSemiBold.withSize(13.6))
            ]
            
            self?.pageMenu = CAPSPageMenu(viewControllers: self!.controllerArray, frame: CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight), pageMenuOptions: parameters)
            self?.pageMenu?.delegate = self
            
            self?.view.addSubview(self!.pageMenu!.view)
            
            if !self!.measurementCategory.isEmpty{
                
                self?.getMeasurementList(self!.measurementCategory[0], 0)
            }
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
    
    fileprivate func getMeasurementList(_ measurementData : MeasurementCategory,_ index : Int){
        
        let id = AppUserDefaults.value(forKey: AppUserDefaults.Key.userId).stringValue
        
        let param = ["id" : id,
                     "category_id" : measurementData.id!,
                     "category_type" : measurementData.categoryType!] as [String : Any]
        
        WebServices.getMeasurementHomeData(parameters: param, success: {[weak self] (_ measurementHomeData : [MeasurementHomeData]) in
            
            self?.measurementHomeData = measurementHomeData
            
            self?.vitalScene?.measurementHomeData = []
            
            if !self!.measurementHomeData.isEmpty{
                
                self?.vitalScene?.addMeasurementBtn.isHidden = true
                self?.vitalScene?.noDataAvailiableLabel.isHidden = true
                self?.vitalScene?.measurementHomeData.append(self!.measurementHomeData[index])
                self?.vitalScene?.vitalCollectionView.reloadData()
            }else{
                
                self?.vitalScene?.addMeasurementBtn.isHidden = false
                self?.vitalScene?.noDataAvailiableLabel.isHidden = false
            }
            
        }) { (error) in
            
            showToastMessage(error.localizedDescription)
        }
    }
}
