//
//  CmsTitleCell.swift
//  Mutelcor
//
//  Created by on 10/08/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SwiftSoup
import TTTAttributedLabel

class CmsTitleCell: UITableViewCell {
    
//    MARK:- IBOutlets
//    ================
    @IBOutlet weak var titleLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension CmsTitleCell {
    
    func populateData(_ cmsData : [CmsData]){
        
        guard !cmsData.isEmpty else{
            self.titleLabel.isHidden = true
            return
        }
        self.titleLabel.isHidden = false
        let cmsTitle = cmsData.first?.cmsName
        let cmsDescription = cmsData.first?.cmsDescription
        
        var text: String = ""
        do {
            let doc = try SwiftSoup.parse(cmsDescription!)
            text = try doc.body()!.text()
        }catch Exception.Error( _, let message){
            showToastMessage(message)
        }catch{
            showToastMessage(error as! String)
        }
        
        text = text + " \(cmsData.first!.cmsLinks!)"
        
        let titleAttributes = self.addAttributes("Title:", cmsTitle ?? "", false)
        let descriptionAttributes = self.addAttributes("Description:", text, true)
        titleAttributes.append(descriptionAttributes)
        self.titleLabel.attributedText = titleAttributes
        
        if let link = cmsData.first?.cmsLinks, !link.isEmpty {
            titleLabel.linkAttributes = [NSAttributedStringKey.font.rawValue: AppFonts.sansProRegular.withSize(15),
                                         NSAttributedStringKey.foregroundColor: UIColor.linkLabelColor]
            let percentageEncodingStr = link.replacingOccurrences(of: " ", with: "%20")
            let location = self.titleLabel.text!.count - link.count
            let range = NSRange(location: location, length: link.count)
            let linkUrl = URL(string: percentageEncodingStr)
            self.titleLabel.addLink(to: linkUrl!, with: range)
        }
    }
    
    fileprivate func addAttributes(_ title : String, _ description : String,_ isdescriptionText : Bool) -> NSMutableAttributedString{
        
        let tileLableMutableAttributes = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedStringKey.foregroundColor : UIColor.appColor, NSAttributedStringKey.font: AppFonts.sansProRegular.withSize(15)])
        let nextLine = (isdescriptionText) ? "" : "\n\n"
        let titleTextAttribute = NSAttributedString(string: "\(description)\(nextLine)", attributes: [NSAttributedStringKey.font: AppFonts.sanProSemiBold.withSize(15)])
        tileLableMutableAttributes.append(titleTextAttribute)
        
        return tileLableMutableAttributes
    }
}
