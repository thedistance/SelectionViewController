//
//  TDSelectionViewController.swift
//  SelectionViewController
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

public extension TDSelectionViewController {
    
    /**
     
     Calculates the selected rows of `tableView` sorted by section. `nil` objects are entered where there are no selections for a given section. This can be used to validate the user's selection.
     
     - returns: An array of `Int`s representing a section, with either a selected `indexPath` for that section or `nil` if there is none. There is a tuple for each section in `tableView`.
     
    */
    public func sectionedSelections() -> [(Int, NSIndexPath?)] {
        
        let sectioned = self.tableView.indexPathsForSelectedRows?.map { ($0.section, $0) } ?? []
        
        var sectionedInfo = [Int:NSIndexPath?]()
        
        for (s, ip) in sectioned {
            sectionedInfo[s] = ip
        }
        
        for s in 0..<(sortedOptionKeys?.count ?? 0) {
            sectionedInfo[s] = sectionedInfo[s] ?? nil as NSIndexPath?
        }
        
        return sectionedInfo.map({ $0 }).sort({ $0.0 < $1.0 })
    }
    
    /**
     - returns: Flag for whether there is a selected `NSIndexPath` for each section in `tableView`.
     - seealso: `sectionedSelections()`.
    */
    public func validSectionedSelection() -> Bool {
        return sectionedSelections().reduce(true) { $0 && ($1.1 != nil) }
    }
    
    /**
     
     The error title shown if the user's selection is invalid given `selectionType` and `requiresSelection`.
     - returns: `nil`
    */
    public func errorTitle() -> String? {
        return nil
    }
    
    /**
     
     The error message shown if the user's selection is invalid given `selectionType == .Single / .Multiple` and `requiresSelection`.
     
     - returns: "Please make a selection."
    */
    public func errorMessageForInvalidSelection() -> String {
        return "Please make a selection."
    }
    
    /**
 
     The error message shown if the user's selection is invalid given `selectionType == .SingleSectioned / .MultipleSectioned` and `requiresSelection`. Default value is
     
     - reurns: "Please make a selection for " followed by a list of sections without selections.
    */
    public func errorMessageForInvalidSectionedSelection() -> String {
        
        let missingSelections = sectionedSelections().filter { $0.1 == nil }
            .map { self.tableView(self.tableView, titleForHeaderInSection: $0.0) ?? "Section \($0.0)" }
       .joinWithSeparator(", ")
        
        return "Please make a selection for \(missingSelections)."
    }
    
    /**
     
     The error title shown if the user's selection is invalid given `selectionType` and `requiresSelection`. 
     
     - returns: "OK".
    */
    public func errorDismissButtonTitle() -> String {
        return "OK"
    }
    
    /**
 
     Checks whether the view can be dismissed based on `selectionType` and `requiresSelection`. If it can dismissal is requested from the delegate otherwise a `UIAlertController` is shown.
     
     - seealso: `validSectionedSelection()`
     - seealso: `errorTitle()`
     - seealso: `errorMessageForInvalidSelection()`
     - seealso: `errorMessageForInvalidSectionedSelection()`
     - seealso: `errorDismissButtonTitle()`
    */
    @IBAction public func dismissSelectionViewController(sender:AnyObject?) {
     
        if (self.requiresSelection) {
            
            let validSelection:Bool
            
            switch (self.selectionType) {
            case .Single, .Multiple:
                validSelection = self.selectedKeys.count > 0;
            case .SingleSectioned, .MultipleSectioned:
                validSelection = self.validSectionedSelection()
            }
            
            if (validSelection) {
                self.delegate?.selectionViewControllerRequestsDismissal(self)
            } else {
                
                let alertMessage:String
                
                switch self.selectionType {
                case .Single, .Multiple:
                    alertMessage = errorMessageForInvalidSelection()
                case .SingleSectioned, .MultipleSectioned:
                    alertMessage = errorMessageForInvalidSectionedSelection()
                }
                
                let alert = UIAlertController(title: errorTitle(),
                                              message: alertMessage,
                                              preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: errorDismissButtonTitle(),
                    style: .Cancel,
                    handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            self.delegate?.selectionViewControllerRequestsDismissal(self)
        }
    }
}