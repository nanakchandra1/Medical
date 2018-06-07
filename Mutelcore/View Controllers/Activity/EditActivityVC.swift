//
//  EditActivityVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 14/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol EditActivityVCRemove {
    
    func removeActivityVC(_ remove : Bool)
    func recentActivityData(_ data : RecentActivityModel)
}

class EditActivityVC: UIViewController {

//    MARK:- Proporties
//    =================
    var delegate : EditActivityVCRemove!
    var recentActivityData = [RecentActivityModel]()
    
    enum ProceedtoScreenThrough{
        
        case activity , medication
    }
    
    var proceedToScreenThrough = ProceedtoScreenThrough.activity
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var editActivityTableView: UITableView!
    @IBOutlet weak var noDataAvailiableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        self.delegate.removeActivityVC(true)
    }
}

//Methods :- UITableViewDataSource
//=================================
extension EditActivityVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.proceedToScreenThrough == ProceedtoScreenThrough.activity{
            
          return self.recentActivityData.count
       
        }else{
            
           return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editActivityCellID", for: indexPath) as? EditActivityCell else{
            
            fatalError(" Edit Activity Cell Not Found!")
        }
        
        if self.proceedToScreenThrough == ProceedtoScreenThrough.activity {
            
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
            
            cell.populateRecentData(self.recentActivityData, indexPath)
            
        }else{
            
            cell.editButton.isHidden = false
            cell.deleteButton.isHidden = false
        }
        
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
            
            self.delegate.recentActivityData(data)
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            self.delegate.removeActivityVC(true)
            
        }else{
            
            
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
        
        if self.recentActivityData.isEmpty {
            
            self.noDataAvailiableLabel.isHidden = false
            self.noDataAvailiableLabel.text = "No Records Found!"
        }else{
            
          self.noDataAvailiableLabel.isHidden = true
            
        }

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
