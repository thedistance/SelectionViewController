//
//  SelectionTableViewCell.swift
//  SelectionViewController
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import SelectionViewController

class SelectionTableViewCell: UITableViewCell, SelectionCell {

    @IBOutlet var titleLabel: UILabel?
    
    @IBOutlet var detailLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        accessoryType = selected ? .Checkmark : .None
    }

}


class SelectionViewController: TDSelectionViewController {
    
    @IBAction override func cancelSelectionViewController(sender: AnyObject?) {
        super.cancelSelectionViewController(sender)
    }
    
    @IBAction override func dismissSelectionViewController(sender: AnyObject?) {
        super.dismissSelectionViewController(sender)
    }
}