//
//  ConnectedDevicesCell.swift
//  Mutelcor
//
//  Created by on 31/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ConnectedDevicesCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var devicesImageView: UIImageView!
    @IBOutlet weak var devicesName: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.sepratorView.backgroundColor = UIColor.sepratorColor
        self.devicesImageView.roundCorner(radius: 5, borderColor: UIColor.clear, borderWidth: CGFloat.leastNormalMagnitude)
    }
}

extension ConnectedDevicesCell {
    
    func populateData(deviceView: DevicesView, indexPath: IndexPath, avaliable: [Any],connected: [Any]){

        switch indexPath.section {
            
        case 0:
            let text = (deviceView == .devices && indexPath.row == 0) ? "\n(Wave AM4)" : ""
            if let name = connected[indexPath.row] as? [Any], let device = name[0] as? String, let image = name[1] as? UIImage{
                self.devicesImageView.image = image
                let deviceName = device + text
                let description = "Distance, Calories & Steps"
                self.devicesName.attributedText = self.addAttributes(deviceName,description)
            }
        case 1:
            let description = "Distance, Calories & Steps"
            if let name = avaliable[indexPath.row] as? [Any], let device = name[0] as? String, let image = name[1] as? UIImage {
                self.devicesImageView.image = image
                self.devicesName.attributedText = self.addAttributes(device,description)
            }
            
        default:
            return
        }
    }
    
    fileprivate func addAttributes(_ deviceName: String, _ description: String) -> NSAttributedString{
        
        let name = deviceName + "\n"
        
        let mutableAttributes = NSMutableAttributedString.init(string: name, attributes: [NSAttributedStringKey.font : AppFonts.sanProSemiBold.withSize(16)])
        let attributedString = NSAttributedString.init(string: description, attributes: [NSAttributedStringKey.font : AppFonts.sansProRegular.withSize(16)])
        mutableAttributes.append(attributedString)
        
        return mutableAttributes
    }
}
