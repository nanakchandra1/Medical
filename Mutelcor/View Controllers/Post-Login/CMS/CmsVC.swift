//
//  CmsVCViewController.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON
import TTTAttributedLabel

class CmsVC: BaseViewController {
    
    //    Mark:- Proporties
    //    ==================
    fileprivate var cmsData: [CmsData] = []
    var cmsDic: [String: Any] = [:]
    fileprivate var uploadData: [CmsImages] = []
    fileprivate var uploadVideos: [CmsImages] = []
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var cmsTableView: UITableView!
    
    //    MARK:- ViewController Life cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getCmsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .backBtn
        self.navigationControllerOn = .dashboard
        self.setNavigationBar(screenTitle: K_CMS_SCREEN_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//=====================================
extension CmsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cmsTitleCell = tableView.dequeueReusableCell(withIdentifier: "cmsTitleCellID", for: indexPath) as? CmsTitleCell else{
            fatalError("Cell Not Found!")
        }
        cmsTitleCell.titleLabel.delegate = self
        cmsTitleCell.populateData(self.cmsData)
        
        return cmsTitleCell
            
        case 1:
            guard let cmsAttachmentCell = tableView.dequeueReusableCell(withIdentifier: "cmsAttachmentCellID", for: indexPath) as? CmsAttachmentCell else{
            fatalError("Cell Not Found!")
        }
        
        if !(cmsAttachmentCell.ImagesCollectionView.delegate is CmsVC) {
            cmsAttachmentCell.ImagesCollectionView.dataSource = self
            cmsAttachmentCell.ImagesCollectionView.delegate = self
        }
        
        if !self.uploadData.isEmpty{
            cmsAttachmentCell.titleLabel.isHidden = false
            cmsAttachmentCell.ImagesCollectionView.reloadData()
        }else{
            cmsAttachmentCell.titleLabel.isHidden = true
            }
        
        return cmsAttachmentCell
            
        default :
            fatalError("Cell Not Found!")
        }
    }
}

//MARk- TTTAttributedLabelDelegate Methods
//========================================
extension CmsVC: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        webViewScene.webViewUrl = "\(url)"
        webViewScene.screenName = "Link"
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}

//MARk- UITableViewDelegate Methods
//=================================
extension CmsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowsHeight = (indexPath.row == false.rawValue) ? UITableViewAutomaticDimension : 150
        return rowsHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension CmsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.uploadData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let imagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cmsImagesCellID", for: indexPath) as? CmsImagesCell else {
            fatalError("Cell Not Found!")
        }
        
        imagesCell.populateData(self.uploadData, indexPath, self.uploadVideos)
        return imagesCell
    }
}

//MARK:- UICollectionViewDelegate Methods
//=======================================
extension CmsVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item <= self.uploadVideos.count - 1 {
            self.openSafariViewController(indexPath)
        }else{
            self.openImageInWebView(indexPath)
        }
    }
    
    fileprivate func openSafariViewController(_ indexPath: IndexPath){
        
        let videoUrl = self.uploadData[indexPath.item].fileUrl
        
        if let url = videoUrl, !url.isEmpty {
            let formattedVideoURl = url.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string: formattedVideoURl)
            let safariViewScene = SFSafariViewController(url: url!)
            //            safariViewScene.delegate = self
            if #available(iOS 10.0, *) {
                safariViewScene.preferredBarTintColor = UIColor.appColor
            }
            ////                    AppNetworking.showLoader()
            self.present(safariViewScene, animated: true, completion: nil)
        }
    }
    
    fileprivate func openImageInWebView(_ indexPath : IndexPath){
        
        let webViewScene = WebViewVC.instantiate(fromAppStoryboard: .Measurement)
        let webViewURl = self.uploadData[indexPath.item].fileUrl
        if let url = webViewURl, !url.isEmpty {
            webViewScene.webViewUrl = webViewURl
        }
        //        webViewScene.screenName = self.attachmentsFileName[indexPath.item].stringValue
        self.navigationController?.pushViewController(webViewScene, animated: true)
    }
}

//MARK:- SFSafariViewControllerDelegate Methods
//=============================================
//extension CmsVC : SFSafariViewControllerDelegate {
//
//    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
//        if didLoadSuccessfully {
//        AppNetworking.hideLoader()
//        }
//    }
//}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension CmsVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 10, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK:- Methods
//===============
extension CmsVC {
    
    fileprivate func setupUI(){
        
        
        self.cmsTableView.dataSource = self
        self.cmsTableView.delegate = self
        self.registerNibs()
    }
    
    fileprivate func registerNibs() {
        
        let cmsTitleNib = UINib(nibName: "CmsTitleCell", bundle: nil)
        let cmsAttachmentNib = UINib(nibName: "CmsAttachmentCell", bundle: nil)
        
        self.cmsTableView.register(cmsTitleNib, forCellReuseIdentifier: "cmsTitleCellID")
        self.cmsTableView.register(cmsAttachmentNib, forCellReuseIdentifier: "cmsAttachmentCellID")
    }
    
    fileprivate func getCmsData(){
        
        WebServices.getCmsData(parameters: self.cmsDic,
                               success: {[weak self] (_ cmsData : [CmsData]) in
                                guard let cmsVC = self else{
                                    return
                                }
                                cmsVC.cmsData = cmsData
                                if !cmsData.isEmpty {
                                    cmsVC.uploadData = cmsData[0].cmsVideos + cmsData[0].cmsImages
                                    cmsVC.uploadVideos = cmsData[0].cmsVideos
                                }
                                cmsVC.cmsTableView.reloadData()
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
