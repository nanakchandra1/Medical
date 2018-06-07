//
//  IndexedCollectionView.swift
//  Mutelcor
//
//  Created by on 22/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

enum CollectionViewFor {
    case nutrients
    case image
    case environmentalSurgery
    case foodSurgery
    case drugSurgery
}

protocol AutoResizingCollectionViewDelegate: class {
    func didUpdateCollectionHeight(_ collectionView: UICollectionView, height: CGFloat,_ collectionViewFor : CollectionViewFor)
}

class IndexedCollectionView: UICollectionView {

    //    MARK:- Proporties
    //    =================
    var outerIndexPath: IndexPath?
    var collectionViewUseFor : CollectionViewFor = .nutrients
    
    /// Set maximum height for CollectionView
    /// If not set CollectionView's height will be calculated by its contentSize
    open var maxHeight: CGFloat?
    
    /// If true, creates height constraint if not already available
    @IBInspectable open var canSetHeightConstraint: Bool = false
    
    weak var heightDelegate: AutoResizingCollectionViewDelegate?
    
    /// Get CollectionView's height constraint
    private var heightConstraint: NSLayoutConstraint? {
        
        for constraint in constraints {
            if constraint.firstAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    /// Updates CollectionView's height as soon as its contentSize changes
    open override var contentSize: CGSize {
        
        willSet {
            /// Return if current height is same as current contentSize
            guard heightConstraint?.constant != newValue.height else {
                return
            }
            updateHeight(newValue.height)
        }
    }
    
    /// CollectionView's Life Cycle Methods
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Set height constraint in not already set and allowed to create height constraint
        if heightConstraint == nil && canSetHeightConstraint {
            setHeightConstraint()
        }
    }
    
    /// Set height constraint
    private func setHeightConstraint() {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    /// Updates CollectionView's height
    private func updateHeight(_ autoHeight: CGFloat) {
        
        /// Return if height constraint is not set for CollectionView
        guard let unwrappedheightConstraint = heightConstraint else {
            return
        }
        
        if let unwrappedMaxHeight = maxHeight {
            unwrappedheightConstraint.constant = min(autoHeight, unwrappedMaxHeight)
        } else {
            unwrappedheightConstraint.constant = autoHeight
        }
        heightDelegate?.didUpdateCollectionHeight(self, height: autoHeight, self.collectionViewUseFor)
    }
}

