//
//  SelectionCell.swift
//  SelectionViewController
//
//  Created by Josh Campion on 11/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

/// Protocol defining the properties required on a dequeued `UITableViewCell` to display a selection.
public protocol SelectionCell {
    
    /// The label that displays the main text for an option in a selection.
    var titleLabel:UILabel? { get }
    
    /// The label that displays any supplementaary information for an option in a selection.
    var detailLabel:UILabel? { get }
}