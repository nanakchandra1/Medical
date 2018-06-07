//
//  EditActivityVC.swift
//  Mutelcor
//
//  Created by on 14/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol EditActivityVCRemove: class {
    func removeActivityVC()
    func recentActivityData(_ data: RecentActivityModel)
}

class EditActivityVC: UIViewController {
    
    enum ProceedtoScreenThrough{
        case activity
        case medication
    }
    
//    MARK:- Proporties
//    =================
    weak var delegate : EditActivityVCRemove?
    var recentActivityData = [RecentActivityModel]()
    var proceedToScreenThrough: ProceedtoScreenThrough = .activity
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var editActivityTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    //    MARK:- ViewController Life Cycle
    //    ================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        self.delegate?.removeActivityVC()
    }
}

//Methods :- UITableViewDataSource
//=================================
extension EditActivityVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = (self.proceedToScreenThrough == .activity) ? self.recentActivityData.count : 3
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editActivityCellID", for: indexPath) as? EditActivityCell else{
            
            fatalError(" Edit Activity Cell Not Found!")
        }
        
        let isProceedToScreenBy = (self.proceedToScreenThrough == .activity) ? true : false
        cell.editButton.isHidden = isProceedToScreenBy
        cell.deleteButton.isHidden = isProceedToScreenBy
        cell.populateRecentData(self.recentActivityData, indexPath)
        
        cell.editButton.addTarget(self, action: #selector(self.editBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.deleteBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
}

//Methods : UITableViewDelegate
//=============================
extension EditActivityVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.editActivityTableView.frame.height / 3)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.proceedToScreenThrough == .activity {
            
            let data = self.recentActivityData[indexPath.row]
            self.delegate?.recentActivityData(data)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.delegate?.removeActivityVC()
        }
    }
}

//MARk:- Methods
//===============
extension EditActivityVC{
    
    fileprivate func setupUI(){
        
        self.view.backgroundColor = UIColor.popUpBackgroundColor
        
        self.noDataAvailiableLabel.textColor = UIColor.appColor
        self.noDataAvailiableLabel.font = AppFonts.sanProSemiBold.withSize(15)
        let text = self.proceedToScreenThrough == .activity ? K_NO_RECENT_ACTIVITY.localized : "No Records Found!"
        self.noDataAvailiableLabel.text = text
        
        let isRecentActivityDataEmpty = (!self.recentActivityData.isEmpty) ? true : false
        self.noDataAvailiableLabel.isHidden = isRecentActivityDataEmpty
        
        self.editActivityTableView.dataSource = self
        self.editActivityTableView.delegate = self
        
        self.editActivityTableView.estimatedRowHeight = CGFloat(self.editActivityTableView.frame.height / 3)
        
        self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        let editActivityCellNib = UINib(nibName: "EditActivityCell", bundle: nil)
        self.editActivityTableView.register(editActivityCellNib, forCellReuseIdentifier: "editActivityCellID")
    }
    
    @objc fileprivate func editBtnTapped(_ sender : UIButton){
        
        
    }
    
    @objc fileprivate func deleteBtnTapped(_ sender : UIButton){
        
        
    }
}
