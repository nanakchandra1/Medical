//
//  DischargeSummaryVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DischargeSummaryVC: BaseViewController {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var dischargeSummaryTableView: UITableView!
    
//    MARK:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("Discharge Summary", 2, 3)

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

//MARK:- UITableViewDataSource Methods
//=====================================
extension DischargeSummaryVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dischargeSummaryCellID", for: indexPath) as? DischargeSummaryCell else{
                
                fatalError("cell not found!")
            }
            
            return cell
            
        case 1: guard let cell = tableView.dequeueReusableCell(withIdentifier: "measurementListCollectionCellID", for: indexPath) as? MeasurementListCollectionCell else{
            
            fatalError("cell not found!")
        }
        
        cell.measurementListCollectionView.dataSource = self
        cell.measurementListCollectionView.delegate = self
        
        return cell
            
        default : fatalError("cell Not Found!")
        }
    }
}

//MARK:- UITableViewDelegate Methods
//=================================
extension DischargeSummaryVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            
            return UITableViewAutomaticDimension
        }else{
            
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            
            fatalError("headerCellNot Found!")
        }
        
        headerCell.contentView.backgroundColor = UIColor.headerColor
        headerCell.dropDownBtn.isHidden = true
        headerCell.headerTitle.text = "LAST DISCHARGE SUMMARY"
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            
            return CGFloat.leastNonzeroMagnitude
        }else{
            
           return 43
        }
    }
}

//MARK:- UICollectionViewDataSource Methods
//=========================================
extension DischargeSummaryVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCellID", for: indexPath) as? AttachmentCell else{
            
            fatalError("Cell not Found!")
        }
        
        cell.deleteButtonOutlt.isHidden = true
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
//=================================================
extension DischargeSummaryVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return  CGSize(width: UIDevice.getScreenWidth / 3 - 4, height: collectionView.frame.height - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(2, 2, 2, 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 2
    }
}

//MARK:- Methods
//==============
extension DischargeSummaryVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = true
        
        self.dischargeSummaryTableView.dataSource = self
        self.dischargeSummaryTableView.delegate = self
        self.view.backgroundColor = UIColor.sepratorColor
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let dischargeSummaryNib = UINib(nibName: "DischargeSummaryCell", bundle: nil)
        let measurementListCollectionCellNib = UINib(nibName: "MeasurementListCollectionCell", bundle: nil)
        let headerNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.dischargeSummaryTableView.register(dischargeSummaryNib, forCellReuseIdentifier: "dischargeSummaryCellID")
        self.dischargeSummaryTableView.register(measurementListCollectionCellNib, forCellReuseIdentifier: "measurementListCollectionCellID")
        self.dischargeSummaryTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        
    }
}
