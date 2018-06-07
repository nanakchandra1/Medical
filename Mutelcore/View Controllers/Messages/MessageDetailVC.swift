//
//  MessageDetailVC.swift
//  Mutelcore
//
//  Created by Appinventiv on 03/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MessageDetailVC: UIViewController {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backBtnOutlt: UIButton!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var appointmentBtnOutlt: UIButton!
    @IBOutlet weak var moreBtnOutlt: UIButton!
    @IBOutlet weak var messageDetailTableView: UITableView!
    @IBOutlet weak var bottomSendView: UIView!
    @IBOutlet weak var enterDescriptionView: UIView!
    @IBOutlet weak var sendDataTextView: UITextView!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentBtnOutlt: UIButton!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var sendBtnOutlt: UIButton!
    
    
//    MARK:- ViewController Life Cycle
//    ================================
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

}

extension MessageDetailVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            guard let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCellID", for: indexPath) as? SenderCell else{
                
                fatalError("Sender Cell Not Found!")
            }
            
            return senderCell
        }else{
            
            guard let receiverCell = tableView.dequeueReusableCell(withIdentifier: "receiverCellID", for: indexPath) as? ReceiverCell else{
                
                fatalError("Receiver Cell Not Found!")
            }
            
            return receiverCell
        }
    }
}

//MARK:- UITableViewDelegate Methods
//==================================
extension MessageDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
}

//MARK:- Methods
//==============
extension MessageDetailVC {
    
    fileprivate func setupUI(){
        
        IQKeyboardManager.sharedManager().enable = false
        
        self.headerView.gradient(withX: 0, withY: 0, cornerRadius: false)
        self.headerView.shadow(0.0, CGSize(width: 0.0, height: 1.0), UIColor.black)
        self.backBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentBack"), for: .normal)
        self.messageCountLabel.textColor = UIColor.white
        self.messageCountLabel.font = AppFonts.sanProSemiBold.withSize(14)
        self.doctorImageView.roundCorner(radius: self.doctorImageView.frame.width / 2, borderColor: UIColor.appColor, borderWidth: 1.0)
        self.doctorNameLabel.textColor = UIColor.white
        self.doctorNameLabel.font = AppFonts.sanProSemiBold.withSize(18.1)
        self.doctorSpeciality.textColor = UIColor.white
        self.doctorSpeciality.font = AppFonts.sansProRegular.withSize(14)
        self.appointmentBtnOutlt.setImage(#imageLiteral(resourceName: "icAppointmentInfo"), for: .normal)
        self.moreBtnOutlt.setImage(#imageLiteral(resourceName: "icMessagesMore"), for: .normal)
        
        self.bottomSendView.backgroundColor = UIColor.appColor
        self.enterDescriptionView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.attachmentBtnOutlt.setImage(#imageLiteral(resourceName: "icMessagesAttachment"), for: .normal)
        self.sendBtnView.roundCorner(radius: 2.2, borderColor: UIColor.clear, borderWidth: 0.0)
        self.sendBtnOutlt.setImage(#imageLiteral(resourceName: "icMessagesSend"), for: .normal)
        
        self.messageDetailTableView.dataSource = self
        self.messageDetailTableView.delegate = self
        
        self.registerNibs()
        
    }
    
    fileprivate func registerNibs(){
        
        let senderNibs = UINib(nibName: "SenderCell", bundle: nil)
        self.messageDetailTableView.register(senderNibs, forCellReuseIdentifier: "senderCellID")
        
        let receiverNibs = UINib(nibName: "ReceiverCell", bundle: nil)
        self.messageDetailTableView.register(receiverNibs, forCellReuseIdentifier: "receiverCellID")
        
    }
}
