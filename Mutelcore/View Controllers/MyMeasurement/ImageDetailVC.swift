//
//  ImageDetailVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 05/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ImageDetailVC: BaseViewController {

//    MARK:- Proporties
//    =================
    var imageData : ImageDataModel!
    var imageCount = [String]()
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var imageDetailCollectionView: UICollectionView!
    @IBOutlet weak var noDataAvailiableLabelOutlt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .BackBtn

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Image Detail", 2, 3)
 
        self.navigationControllerOn = .dashboard
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

extension ImageDetailVC : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
            
            fatalError("Cell Not Found!")
        }
        
        cell.sepratorView.isHidden = true
        cell.dateLabel.isHidden = true
        cell.timeLabel.isHidden = true
        cell.deleteButtonOutlt.isHidden = true
        cell.dateStackViewConstant.constant = 0
        cell.populateImageData(self.imageData, imageCount: self.imageCount, index: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIDevice.getScreenWidth / 3 - 6, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right:3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var imgURlArray = [String]()
        if !self.imageData.attachments!.isEmpty {
            
            imgURlArray = (self.imageData.attachments?.components(separatedBy: ","))!
            
            printlnDebug("imageURLArray: \(imgURlArray)")
        }
        
        let imageWebViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        
        printlnDebug("s : \(imgURlArray[indexPath.item])")
        imageWebViewScene.webViewUrl = imgURlArray[indexPath.item]
        
        
        self.navigationController?.pushViewController(imageWebViewScene, animated: true)
    }
}

//MARK:- Methods
//==============
extension ImageDetailVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.imageDetailCollectionView.dataSource = self
        self.imageDetailCollectionView.delegate = self
        
        let attachmentNib = UINib(nibName: "AttachmentCell", bundle: nil)
        self.imageDetailCollectionView.register(attachmentNib, forCellWithReuseIdentifier: "attachmentCellID")
        
        self.noDataAvailiableLabelOutlt.font = AppFonts.sanProSemiBold.withSize(15)
        self.noDataAvailiableLabelOutlt.textColor = UIColor.appColor
        
        self.imageDetailCollectionView.backgroundColor = #colorLiteral(red: 0.9332545996, green: 0.9333854318, blue: 0.9332134128, alpha: 1)
        
        if !self.imageData.attachmentName!.isEmpty {
            
          self.imageCount = (self.imageData.attachmentName?.components(separatedBy: ","))!

            printlnDebug("image :\(self.imageCount)")
          self.noDataAvailiableLabelOutlt.isHidden = true
            
        }else{
            
           self.noDataAvailiableLabelOutlt.isHidden = false
            self.noDataAvailiableLabelOutlt.text = "No Records Found!"
            
        }
    }
}
