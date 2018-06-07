//
//  TimelineVC.swift
//  Mutelcor
//
//  Created by Nanak on 13/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TimelineVC: BaseViewController {

    //    MARk:- Proporties
    //    =================
    
    var timeLineData: [TimelineModel] = []
    
    //    MARK:- IBOutlets
    //    ================

    @IBOutlet weak var timelineCOllectionView: UICollectionView!
    @IBOutlet weak var preViewImg: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    //    MARK:- ViewController Life Cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationControllerOn = .dashboard
        self.sideMenuBtnActn = .sideMenuBtn
        self.setNavigationBar(screenTitle: K_TIMELINE.localized)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func closeBtnTap(_ sender: UIButton) {
        
        self.preViewShowHide(true)
    }
    
}

//MARK:- UICollectionViewDataSource Method
//====================================

extension TimelineVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeLineData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionCell", for: indexPath) as? TimelineCollectionCell else{
            fatalError("cell not found!")
        }
        cell.crossBtn.addTarget(self, action: #selector(self.deleteBtnTap(_:)), for: .touchUpInside)
        cell.poplateData(with: self.timeLineData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.timeLineData[indexPath.row]
        self.preViewShowHide(false)
        self.setPreview(data.image_url)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Delegate Methods
//=========================================================
extension TimelineVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenSize.SCREEN_WIDTH / 2) - 15, height: (ScreenSize.SCREEN_WIDTH / 2) - 40)
    }
}

//MARK:- Methods
//==============
extension TimelineVC {
    
    
    fileprivate func setupUI(){
        
        self.preViewShowHide(true)
        self.floatBtn.isHidden = true
        self.isNavigationBarButton = false
        self.timelineCOllectionView.delegate = self
        self.timelineCOllectionView.dataSource = self
        self.addBtnDisplayedFor = .Timeline
        self.timelineCOllectionView.register(UINib(nibName: "TimelineCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TimelineCollectionCell")
        self.getPhoto()
    }
    
    
    fileprivate func setPreview(_ patientPic: String){
        let percentageEncodingStr = patientPic.replacingOccurrences(of: " ", with: "%20")
        let imgUrl = URL(string: percentageEncodingStr)
        self.preViewImg.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
    }

    
    fileprivate func preViewShowHide(_ isShow: Bool){
        
        self.preViewImg.isHidden = isShow
        self.closeBtn.isHidden = isShow
    }
    
    
    @objc func deleteBtnTap(_ sender: UIButton){
        
        guard let indexPath = sender.collectionViewIndexPathIn(self.timelineCOllectionView) else {return}
        self.deletePhoto(with: indexPath.item)
    }
    
    
    fileprivate func getPhoto(){
        
        WebServices.getTimelineData(success: { (data) in
            
            self.timeLineData = data.map({ (model) -> TimelineModel in
                TimelineModel(json: model)!
            })
           // delay(1, closure: {
                if self.timeLineData.count >= 20{
                    self.addBtnDisplayedFor = .none
                    self.setNavigationBar(screenTitle: K_TIMELINE.localized)
                }
           // })
            self.timelineCOllectionView.reloadData()
        }) { (error) in
            debugPrint(error)
        }
    }
    
    fileprivate func deletePhoto(with index : Int){
        
        var params = JSONDictionary()
        params["photo_id"] = self.timeLineData[index].p_id
        
        WebServices.deleteTimelinePhoto(parameters: params, success: {
            self.timeLineData.remove(at: index)
            self.timelineCOllectionView.reloadData()
        }) { (error) in
            
        }
    }
}
