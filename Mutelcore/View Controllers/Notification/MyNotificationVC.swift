//
//  MyNotificationVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 04/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MyNotificationVC: BaseViewController {
    
    //    MARK:- Proporties
    //    ================
    enum NotificationView {
        
        case all, favourite
    }
    
    var allNotificationTableView = UITableView()
    var favoriteTableView = UITableView()
    
    var isAllNotificationPressed  = false
    var isFavouriteNotificationPressed = false
    
    //    MARK:- IBOutlets
    //    ================
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var verticalSepratorView: UIView!
    @IBOutlet weak var horizontalSepratorView: UIView!
    @IBOutlet weak var allBtnOutlt: UIButton!
    @IBOutlet weak var FavoriteBtnOutlt: UIButton!
    @IBOutlet weak var notificationDetailScrollView: UIScrollView!
    @IBOutlet weak var backBtnOutlt: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var appointmentBtnOutlt: UIButton!
    @IBOutlet weak var notificationBtnOutlt: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var messageBtnOutlt: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllBtnOutlt: UIButton!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var deleteBtnOutlt: UIButton!
    
    var notificationViewTapped  = NotificationView.all{
        
        willSet{
            
            switch newValue {
                
            case .all : self.allBtnOutlt.setTitleColor(UIColor.white, for: .normal)
            self.FavoriteBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
                
            case .favourite : self.FavoriteBtnOutlt.setTitleColor(UIColor.white, for: .normal)
            self.allBtnOutlt.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
//    MARK:- IBActions
//    =================
    @IBAction func allBtnTapped(_ sender: UIButton) {
        
        self.notificationViewTapped = .all

        UIView.animate(withDuration: 0.3) {
            
            self.notificationDetailScrollView.contentOffset.x = 0
            self.horizontalSepratorView.frame.origin.x = 0
        }
    }
    
    @IBAction func favouriteBtnTapped(_ sender: UIButton) {
        
        self.notificationViewTapped = .favourite
        
        
        UIView.animate(withDuration: 0.3) {
            
            self.notificationDetailScrollView.contentOffset.x = UIDevice.getScreenWidth
            self.horizontalSepratorView.frame.origin.x = self.horizontalSepratorView.frame.width
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func appointmentBtnTapped(_ sender: UIButton) {
        
        appointmentBtntapped()
    }
    
    @IBAction func notificationBtnTapped(_ sender: UIButton) {
        
        if self.notificationViewTapped == .all{
            
            self.allNotificationTableView.reloadData()
        }else{
            
            self.favoriteTableView.reloadData()
        }
    }
    @IBAction func messageBtnTapped(_ sender: UIButton) {
        
        let messageScene = MessagesVC.instantiate(fromAppStoryboard: .Message)
        self.navigationController?.pushViewController(messageScene, animated: true)
        
    }
}

//MARK:- Methods
//==============
extension MyNotificationVC {
    
    fileprivate func setupUI(){
        
        self.navigationBarView.gradient(withX: 0, withY: 0, cornerRadius: false)
        
        self.backBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentBack"), for: .normal)
        self.backBtnOutlt.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.screenTitleLabel.text = "My Notifications"
        self.screenTitleLabel.textColor = UIColor.white
        self.screenTitleLabel.font = AppFonts.sanProSemiBold.withSize(18)
        
        self.messageBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentMail"), for: .normal)
        self.messageBtnOutlt.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.messageView.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.messageCountLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.1921568627, blue: 0.4352941176, alpha: 1)
        self.messageCountLabel.font = AppFonts.sansProBold.withSize(10)
        
        self.notificationBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentBell"), for: .normal)
        self.notificationBtnOutlt.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.notificationView.roundCorner(radius: 2.2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.notificationCountLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.1921568627, blue: 0.4352941176, alpha: 1)
        self.notificationCountLabel.font = AppFonts.sansProBold.withSize(10)
        
        self.appointmentBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentInfo"), for: .normal)
        self.appointmentBtnOutlt.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.selectAllBtnOutlt.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.deleteBtnOutlt.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.selectAllView.isHidden = true
        self.selectAllView.backgroundColor = UIColor.clear
        
        self.selectAllLabel.font = AppFonts.sansProRegular.withSize(15)
        self.selectAllLabel.textColor = UIColor.white
        self.selectAllLabel.text = "Select All"
        
        self.horizontalSepratorView.backgroundColor = UIColor.white
        self.notificationDetailScrollView.contentSize = CGSize(width: 2 * UIDevice.getScreenWidth, height: 2)
        
        self.notificationDetailScrollView.delegate = self
        
        self.allBtnOutlt.setTitle("ALL", for: .normal)
        self.FavoriteBtnOutlt.setTitle("FAVOURITES", for: .normal)
        
        self.notificationViewTapped = .all
        
        self.setupTableViewUI()
        
        self.addSubView()
        
        self.registerNibs()
    }
    
    fileprivate func setupTableViewUI(){
        
        self.allNotificationTableView.separatorStyle = .none
        self.favoriteTableView.separatorStyle = .none
        
        self.allNotificationTableView.dataSource = self
        self.allNotificationTableView.delegate = self
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.delegate = self
        
    }
    
    fileprivate func addSubView(){
        
        self.allNotificationTableView.frame = CGRect(x: 0, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - self.navigationBarView.frame.height)
        
        self.favoriteTableView.frame = CGRect(x: UIDevice.getScreenWidth, y: 0, width: UIDevice.getScreenWidth, height: UIDevice.getScreenHeight - (self.tabBarView.frame.height + (self.navigationController?.navigationBar.frame.height)!))
        
        self.notificationDetailScrollView.addSubview(self.allNotificationTableView)
        self.notificationDetailScrollView.addSubview(self.favoriteTableView)
    }
    
    fileprivate func registerNibs(){
        
        let notificationDetailCellNib = UINib(nibName: "NotificationDetailCell", bundle: nil)
        self.allNotificationTableView.register(notificationDetailCellNib, forCellReuseIdentifier: "notificationDetailCellID")
        self.favoriteTableView.register(notificationDetailCellNib, forCellReuseIdentifier: "notificationDetailCellID")
        
    }
}

//MARK:- UIScrollViewDelegate Methods
//===================================
extension MyNotificationVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.notificationDetailScrollView.contentOffset.x < UIDevice.getScreenWidth {
            
            self.horizontalSepratorView.frame.origin.x = 0
            self.notificationViewTapped = .all
            
        }else{
            
            self.horizontalSepratorView.frame.origin.x = self.horizontalSepratorView.frame.width
            self.notificationViewTapped = .favourite
            
        }
    }
}

//MARK:- UITableViewDataSource Methods
//===================================
extension MyNotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.allNotificationTableView {
            
            return 10
        }else{
            
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationDetailCellID", for: indexPath) as? NotificationDetailCell else{
            
            fatalError("NotificationDetailCell not found!")
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        cell.addGestureRecognizer(longPressGesture)
        
        cell.selectNotificationBtn.addTarget(self, action: #selector(self.selectBtntapped(_:)), for: .touchUpInside)
        
        if tableView === self.allNotificationTableView{
            
            if self.isAllNotificationPressed {
                
                cell.selectNotificationBtn.isHidden = false
                
            }else{
               cell.selectNotificationBtn.isHidden = true
                
            }
            
            if cell.selectNotificationBtn.isSelected{
                
                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationCheck"), for: .normal)
            }else{
                
                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
            }
            
        }else{
            
            if self.isFavouriteNotificationPressed {
                
                cell.selectNotificationBtn.isHidden = false
            }else{
                
                cell.selectNotificationBtn.isHidden = true
            }
            
            if cell.selectNotificationBtn.isSelected{
                
                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationCheck"), for: .normal)
            }else{
                
                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
            }
        }
        return cell
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension MyNotificationVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}

//MARK:- Methods
//==============
extension MyNotificationVC {
    
    @objc fileprivate func cellTapped(_ sender : UILongPressGestureRecognizer){
        
        if sender.state == .began {
            
            if self.notificationViewTapped == .all{
                
                self.isAllNotificationPressed = !self.isAllNotificationPressed
                
               if self.isAllNotificationPressed{
                    
                self.selectAllView.isHidden = false
                self.messageView.isHidden = true
                self.messageBtnOutlt.isHidden = true
                self.messageCountLabel.isHidden = true
                self.notificationView.isHidden = true
                self.notificationBtnOutlt.isHidden = true
                self.appointmentBtnOutlt.isHidden = true
                
                }else{
                    
                    self.selectAllView.isHidden = true
                    self.messageView.isHidden = false
                    self.messageBtnOutlt.isHidden = false
                    self.messageCountLabel.isHidden = false
                    self.notificationView.isHidden = false
                    self.notificationBtnOutlt.isHidden = false
                    self.appointmentBtnOutlt.isHidden = false
                }
                
                self.allNotificationTableView.reloadData()
                
            }else{
                
                self.isFavouriteNotificationPressed = !self.isFavouriteNotificationPressed
                
                if self.isFavouriteNotificationPressed{
                    
                    self.selectAllView.isHidden = false
                    self.messageView.isHidden = true
                    self.messageBtnOutlt.isHidden = true
                    self.messageCountLabel.isHidden = true
                    self.notificationView.isHidden = true
                    self.notificationBtnOutlt.isHidden = true
                    self.appointmentBtnOutlt.isHidden = true
                }else{
                    
                    self.selectAllView.isHidden = true
                    self.messageView.isHidden = false
                    self.messageBtnOutlt.isHidden = false
                    self.messageCountLabel.isHidden = false
                    self.notificationView.isHidden = false
                    self.notificationBtnOutlt.isHidden = false
                    self.appointmentBtnOutlt.isHidden = false
                }
                
                self.favoriteTableView.reloadData()
            }
        }
    }
    
    @objc fileprivate func selectBtntapped(_ sender : UIButton) {
        
        if notificationViewTapped == .all{
            
            guard let indexPath = sender.tableViewIndexPathIn(self.allNotificationTableView) else{
                
                return
            }
            
            guard let cell = self.allNotificationTableView.cellForRow(at: indexPath) as? NotificationDetailCell else{
                
                return
            }
            
            cell.selectNotificationBtn.isSelected = !cell.selectNotificationBtn.isSelected
            
//            if cell.selectNotificationBtn.isSelected{
//
//                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationCheck"), for: .normal)
//            }else{
//
//               cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
//            }
            
            self.allNotificationTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }else{
            
            guard let indexPath = sender.tableViewIndexPathIn(self.favoriteTableView) else{
                
                return
            }
            
            guard let cell = self.favoriteTableView.cellForRow(at: indexPath) as? NotificationDetailCell else{
                
                return
            }
            
            cell.selectNotificationBtn.isSelected = !cell.selectNotificationBtn.isSelected
            
//            if cell.selectNotificationBtn.isSelected{
//
//                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationCheck"), for: .normal)
//            }else{
//
//                cell.selectNotificationBtn.setImage(#imageLiteral(resourceName: "icNotificationUncheck"), for: .normal)
//            }
            self.favoriteTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

