//
//  addAllergyCollectionView.swift
//  Mutelcor
//
//  Created by on 09/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AddAllergyCollectionView: UITableViewCell {
    
//    MARK:- IBOutlets
//    =================
    @IBOutlet weak var allergyCollectionView: IndexedCollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let addAllergyCellNib = UINib(nibName: "AddAllergyCell", bundle: nil)
        self.allergyCollectionView.register(addAllergyCellNib, forCellWithReuseIdentifier: "addAllergyCellID")
    } 
}
