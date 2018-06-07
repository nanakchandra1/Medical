//
//  ePrescriptionVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ePrescriptionVC: BaseViewController {
    
    
    //    MARK:- IBOutlets
    //    =================
    @IBOutlet weak var eprescriptionTableView: UITableView!
    
    
    //    MARK:- ViewController LifeCycle
    //    ==============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatBtn.isHidden = false
        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNavigationBar("ePrescription", 2, 3)
        
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
//===================================
extension ePrescriptionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return 1
            
        case 1: return 2
            
        default : return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ePrescriptionTableCellID", for: indexPath) as? EPrescriptionTableCell else{
            
            fatalError("EPrescriptionTableCell not Found!")
        }
        
        switch indexPath.section {
            
        case 0:
            cell.remarkViewHeightConstraint.isActive = true
            cell.remarkViewHeightConstraint.constant = 0
            
        case 1:
            cell.remarkLabel.isHidden = true
            cell.remarkViewTopLineView.isHidden = true
            cell.remarkViewBottomLineView.isHidden = true
            cell.ePrescriptionBtn.isHidden = true
            cell.ePrescriptionBtnContainerView.isHidden = true
            cell.remarkView.isHidden = true
            cell.ePrescriptionBtnContainerHeight.constant = 0
            cell.remarkViewHeightConstraint.isActive = false
            cell.remarkViewHeightConstraint.constant = 0
            
        default : fatalError("Section Not Found!")
            
        }
        
        return cell
    }
}

//MARK:- UITableViewDelegate Method
//=================================
extension ePrescriptionVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0: return UITableViewAutomaticDimension
            
        case 1: return UITableViewAutomaticDimension
            
        default : return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "attachmentHeaderViewCellID") as? AttachmentHeaderViewCell else{
            
            fatalError("AttachmentHeaderViewCell not Found!")
        }
        
        headerCell.headerTitle.textColor = UIColor.grayLabelColor
        headerCell.headerTitle.font = AppFonts.sansProBold.withSize(12.5)
        headerCell.dropDownBtn.isHidden = true
        headerCell.contentView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        
        if section == 0{
            
            headerCell.headerTitle.text = "Current"
            
        }else{
            
            headerCell.headerTitle.text = "Previous"
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 400
    }
}

//MARK:- Methods
//===============
extension ePrescriptionVC {
    
    fileprivate func setupUI(){
        
        self.eprescriptionTableView.dataSource = self
        self.eprescriptionTableView.delegate = self
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let ePrescriptionTableCellNib = UINib(nibName: "EPrescriptionTableCell", bundle: nil)
        self.eprescriptionTableView.register(ePrescriptionTableCellNib, forCellReuseIdentifier: "ePrescriptionTableCellID")
        let headerCellNib = UINib(nibName: "AttachmentHeaderViewCell", bundle: nil)
        self.eprescriptionTableView.register(headerCellNib, forHeaderFooterViewReuseIdentifier: "attachmentHeaderViewCellID")
        
    }
}
