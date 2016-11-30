//
//  SelectionTableViewCell.swift
//  SelectionViewController
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

/// Simple implementation of `SelectionCell` with two labels and checkmark selection state.
open class SelectionTableViewCell: UITableViewCell, SelectionCell {

    /// The label to show the option title.
    @IBOutlet open var titleLabel: UILabel?
    
    /// The label to show the option detail.
    @IBOutlet open var detailLabel: UILabel?
    
    /// Sets this cell's `accessoryType` to be `.Checkmark` if selected, `.None` otherwise.
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        accessoryType = selected ? .checkmark : .none
    }

}
