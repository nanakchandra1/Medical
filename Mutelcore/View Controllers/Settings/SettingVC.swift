//
//  SettingVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 08/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SettingVC: BaseViewController {

//    MARK:- Proporties
//    =================
    let settingRows = ["Change Passowrd","Terms & Condition","Privacy Policy","About App","Logout"]
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var settingTableView: UITableView!
    
//    MARK:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        
        let settingCellnib = UINib(nibName: "SettingCell", bundle: nil)
        self.settingTableView.register(settingCellnib, forCellReuseIdentifier: "settingCellID")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.sideMenuBtnActn = .sideMenuBtn

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.setNavigationBar("Settings", 2, 3)
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

//MARK:- UITableViewDataSource Methods
//====================================
extension SettingVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.settingRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellID") as? SettingCell else{
            
            fatalError("Setting Cell Not Found!")
        }
       
       cell.CellTitle.text = self.settingRows[indexPath.row]
       cell.cellImage.image = #imageLiteral(resourceName: "personal_info_next_arrow")
       cell.bottomView.backgroundColor = UIColor.sepratorColor
        
        if indexPath.row == self.settingRows.count - 1{
            
            cell.cellImage.isHidden = true
            cell.bottomView.isHidden = true
        }
        
        return cell
    }
}

//extension SettingVC : UITableViewDelegate Methods
//=================================================
extension SettingVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0: showToastMessage("Under Development")

        case 1:  showToastMessage("Under Development")
        case 2:  showToastMessage("Under Development")
        case 3:  showToastMessage("Under Development")
        case 4 :
            
        AppUserDefaults.removeAllValues()
        sharedAppDelegate.goToLoginOption()
         
        default : return
     
        }
    }
}
