//
//  TimelineCollectionCell.swift
//  Mutelcor
//
//  Created by Nanak on 13/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TimelineCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoDateLbl: UILabel!
    @IBOutlet weak var photoTimeLbl: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.photoDateLbl.font = AppFonts.sansProRegular.withSize(12)
        self.photoTimeLbl.font = AppFonts.sansProRegular.withSize(12)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    
    func poplateData(with data: TimelineModel){
        
        self.imageView.image = #imageLiteral(resourceName: "personal_info_place_holder")
        self.photoTimeLbl.text = data.photo_time.changeDateFormat(.HHmmss, .Hmma)
        self.photoDateLbl.text = data.photo_date.changeDateFormat(.utcTime, .ddMMMYYYY)
        self.setPatientPic(data.image_url)
    }
    
    fileprivate func setPatientPic(_ patientPic: String){
        let percentageEncodingStr = patientPic.replacingOccurrences(of: " ", with: "%20")
        let imgUrl = URL(string: percentageEncodingStr)
        self.imageView.af_setImage(withURL: imgUrl!, placeholderImage: #imageLiteral(resourceName: "personal_info_place_holder"))
    }

}
