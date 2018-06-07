//
//  IndexedCollectionView.swift
//  Mutelcore
//
//  Created by Appinventiv on 22/06/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class IndexedCollectionView: UICollectionView {
    var outerIndexPath: IndexPath?
    
    enum CollectionViewFor {
        
        case nutrients, image
    }
    
    var collectionViewUseFor : CollectionViewFor = .nutrients
}
