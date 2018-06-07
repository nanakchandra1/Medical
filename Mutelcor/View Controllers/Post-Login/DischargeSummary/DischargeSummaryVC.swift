//
//  DischargeSummaryVC.swift
//  Mutelcor
//
//  Created by on 08/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class DischargeSummaryVC: BaseViewController {
    
//    MARK:- Proporties
//    =================
   fileprivate var dischargeSummaryData = [DischargeSummaryModel]()
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var dischargeSummaryTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getDischargeSummaryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
        self.addBtnDisplayedFor = .none
        self.setNavigationBar(screenTitle: K_DISCHARGE_SUMMARY_TITLE.localized)
    }
}

//MARK:- UITableViewDataSource Methods
//=====================================
extension DischargeSummaryVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dischargeSummaryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dischargeSummaryCellID", for: indexPath) as? DischargeSummaryCell else{
            fatalError("cell not found!")
        }
        cell.shareBtnOutlt.addTarget(self, action: #selector(self.shareBtntapped(sender:)), for: .touchUpInside)
        cell.populateData(self.dischargeSummaryData, indexPath: indexPath)
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
//=================================
extension DischargeSummaryVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

//MARK:- Methods
//==============
extension DischargeSummaryVC {
    
    fileprivate func setupUI(){
        
        self.floatBtn.isHidden = false
        self.noDataAvailiableLabel.text = "No Discharge Summary found"
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(16)
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.isHidden = true
        
        self.dischargeSummaryTableView.dataSource = self
        self.dischargeSummaryTableView.delegate = self
        self.view.backgroundColor = UIColor.sepratorColor
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let dischargeSummaryNib = UINib(nibName: "DischargeSummaryCell", bundle: nil)
        let headerNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        
        self.dischargeSummaryTableView.register(dischargeSummaryNib, forCellReuseIdentifier: "dischargeSummaryCellID")
        self.dischargeSummaryTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
    }
    
    @objc func shareBtntapped(sender: UIButton){
        guard let indexPath = sender.tableViewIndexPathIn(self.dischargeSummaryTableView) else{
            return
        }
        if let link = self.dischargeSummaryData[indexPath.row].attachment {
            self.openShareViewController(pdfLink: link)
        }
    }
    
    fileprivate func getDischargeSummaryData(){
        
        WebServices.getDischargeSummary(success: {[weak self] (_ dischargeSummaryData : [DischargeSummaryModel]) in
            
            guard let dischargeVC = self else{
                return
            }
            
            dischargeVC.dischargeSummaryData = dischargeSummaryData
            
            if !dischargeVC.dischargeSummaryData.isEmpty {
                dischargeVC.noDataAvailiableLabel.isHidden = true
                dischargeVC.dischargeSummaryTableView.reloadData()
            }else{
               dischargeVC.noDataAvailiableLabel.isHidden = false
            }
        }) { (error) in
            showToastMessage(error.localizedDescription)
        }
    }
}
