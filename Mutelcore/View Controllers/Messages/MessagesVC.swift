//
//  MessagesVC.swift
//  Mutelcore
//
//  Created by Ashish on 14/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit


class MessagesVC: BaseViewController {

//    MARK:- Properties
//    ==================
    enum ProceeedToScreenThrough {
        
        case SideMenu , navigationBar
        
    }
    
    var proceedToScreenThrough : ProceeedToScreenThrough = ProceeedToScreenThrough.SideMenu

//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var messageTableView: UITableView!
    

//    MARK:- ViewController Life Cycle
//    ================================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.floatBtn.isHidden = false
        
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuBtnActn = .sideMenuBtn
        self.navigationControllerOn = .dashboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.setNavigationBar("Messages", 2, 3)
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MessagesVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "messagesCellID", for: indexPath) as? MessagesCell else{
            
            fatalError("Cell Not Found!")
        }
        
        return messageCell
    }
}

extension MessagesVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messageDetailScene = MessageDetailVC.instantiate(fromAppStoryboard: .Message)
        self.navigationController?.pushViewController(messageDetailScene, animated: true)
        
    }
}

//MARK:- Methods
//=============
extension MessagesVC {
    
    fileprivate func setupUI(){
        
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
      self.registerNibs()
    }
    
    fileprivate func registerNibs(){
        
        let messageNib = UINib(nibName: "MessagesCell", bundle: nil)
        self.messageTableView.register(messageNib, forCellReuseIdentifier: "messagesCellID")
    }
}

