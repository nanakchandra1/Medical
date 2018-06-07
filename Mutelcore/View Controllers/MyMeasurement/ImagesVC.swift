//
//  ImagesVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 10/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ImagesVC: BaseViewController {

    //MARK:- Proporties
    var imageData = [ImageDataModel]()
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var imageDataCollectionView: UICollectionView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- CollectionView Datasource Methods
//=======================================
extension ImagesVC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitalListingCellID", for: indexPath) as? VitalListingCell else{
            
            fatalError("VitalListingCell Not Found!")
        }
        
        cell.populateImageData(self.imageData, indexPath)
        
        cell.vitalData.isHidden = true
        cell.vitalUnit.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let imageDetailScene = ImageDetailVC.instantiate(fromAppStoryboard: .Measurement)
        
        imageDetailScene.imageData = self.imageData[indexPath.item]
        
        self.navigationController?.pushViewController(imageDetailScene, animated: true)
        
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension ImagesVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIDevice.getScreenWidth / 3 - 1, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}

//MARK:- Methods
//===============
extension ImagesVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.imageDataCollectionView.dataSource = self
        self.imageDataCollectionView.delegate = self
        
        self.noDataAvailiableLabel.isHidden = true
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(15)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        
        self.imageDataCollectionView.dataSource = self
        
        let latTestListingNib = UINib(nibName: "VitalListingCell", bundle: nil)
        self.imageDataCollectionView.register(latTestListingNib, forCellWithReuseIdentifier: "vitalListingCellID")
    }
    
    //    Data Not Availiable
    //    ===================
    func showNoDataLabel(_ noDataAvaliable : Bool){
        
        if noDataAvaliable{
            
            self.noDataAvailiableLabel.isHidden = false
            self.noDataAvailiableLabel.text = "No Records Found!"
            self.imageDataCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }else{
            self.noDataAvailiableLabel.isHidden = true
            self.imageDataCollectionView.backgroundColor = #colorLiteral(red: 0.9332545996, green: 0.9333854318, blue: 0.9332134128, alpha: 1)
            
        }
    }
}
