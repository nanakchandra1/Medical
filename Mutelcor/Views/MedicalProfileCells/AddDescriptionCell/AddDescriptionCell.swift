////
////  AddDescriptionCell.swift
////  Mutelcor
////
////  Created by  on 21/03/17.
////  Copyright © 2017. All rights reserved.
////
//
//import UIKit
//
//class AddDescriptionCell: UITableViewCell {
//    
////    MARK:- IBOutlets
////    =================
//    @IBOutlet weak var descriptionTextView: UITextView!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.descriptionTextView.font = AppFonts.sanProSemiBold.withSize(16)
//        self.descriptionTextView.roundCorner(radius: 2.2, borderColor: UIColor.black, borderWidth: 1.0)
//    }
//}
//
//extension AddDescriptionCell {
//    
//    func populateData(_ userInfo : UserInfo?, _ indexPath : IndexPath){
//        
//        guard let userData = userInfo else{
//            return
//        }
//        
//        guard !userData.medicalCategoryInfo.isEmpty else{
//            return
//        }
//        switch indexPath.section {
//        case 8:
//            self.descriptionTextView.text = userData.medicalCategoryInfo.first?.familyAllergy
//        case 9:
//            self.descriptionTextView.text = userData.medicalCategoryInfo.first?.previousAllergy
//        default:
//            return
//        }
//    }
//}

