//
//  AutoResizingTableView.swift
//  AutoResizingTableView
//
//  Created by  on 09/02/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol AutoResizingTableViewDelegate: class {
    func didUpdateTableHeight(_ tableView: UITableView, height: CGFloat)
}

open class AutoResizingTableView: UITableView {
    
    /// Set maximum height for TableView
    /// If not set TableView's height will be calculated by its contentSize
    open var maxHeight: CGFloat?
    
    /// If true, creates height constraint if not already available
    @IBInspectable open var canSetHeightConstraint: Bool = false
    
    weak var heightDelegate: AutoResizingTableViewDelegate?
    
    /// Get TableView's height constraint
    private var heightConstraint: NSLayoutConstraint? {
        
        for constraint in constraints {
            
            if constraint.firstAttribute == .height {
                return constraint
            }
        }
        
        return nil
    }
    
    /// Updates TableView's height as soon as its contentSize changes
    open override var contentSize: CGSize {
        
        willSet {
            
            /// Return if current height is same as current contentSize
            guard heightConstraint?.constant != newValue.height else {
                return
            }
            
            updateHeight(newValue.height)
        }
    }
    
    /// TableView's Life Cycle Methods
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
    
    /// Updates TableView's height
    private func updateHeight(_ autoHeight: CGFloat) {
        
        /// Return if height constraint is not set for TableView
        guard let unwrappedheightConstraint = heightConstraint else {
            return
        }
        
        if let unwrappedMaxHeight = maxHeight {
            unwrappedheightConstraint.constant = min(autoHeight, unwrappedMaxHeight)
            
        } else {
            unwrappedheightConstraint.constant = autoHeight
        }
        
        heightDelegate?.didUpdateTableHeight(self, height: autoHeight)
    }
}
