//
//  SelectionViewControllerDelegate.swift
//  SelectionViewController
//
//  Created by Josh Campion on 11/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

/// Delegate of a `SelectionViewController` responsible for responding to the result of a selection.
public protocol SelectionViewControllerDelegate: class {
    
    /// This should request dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back does not update the selection in the presenting view controller.
    func selectionViewControllerRequestsCancel(_ selectionViewController: SelectionViewController)
    
    /// This should request dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back updates the selection in the presenting view controller.
    func selectionViewControllerRequestsDismissal(_ selectionViewController: SelectionViewController)
    
}
