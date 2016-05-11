//
//  SelectionViewController.swift
//  SelectionViewController
//
//  Created by Josh Campion on 11/05/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

/**
 
 Simple class to display a list of choices.
 
 The class generates cells using the identifiers `Basic` or `Detail` based on the values in `self.optionDetails`. Cells should be registered against these identifiers to prevent exceptions being thrown. Options can be configured into multiple sections using nested arrays in the `sortedOptionKeys` property. Cells should conform to `SelectionCell`. Visual cell selection should be configured in the cell itself.
 
 The `delegate` property should be set to return the selected choice(s) on dismissal. The delegate methods only request dismissal, they makes no assumption of how to be dismissed. This allows for modal / push / custom / child view controller presentation of the choices.
 
 */
public class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// As a presenter may present multiple `SelectionViewController`s, either singularly or at the same time, this property can be used to distinguish what this selection is for. It is not used in the class implementation.
    public var key:Any?
    
    /// Determines the auto-deselection behaviour.
    public var selectionType:SelectionType = .Single {
        didSet {
            
            if case let .All(_, max) = selectionType where max == 1 {
                tableView?.allowsMultipleSelection = false
            } else {
                tableView?.allowsMultipleSelection = true
            }
        }
    }
    
    /// The table to show the selection.
    @IBOutlet public var tableView:UITableView?
    
    /// Dictionary representing the options the user can choose from. The keys are ids used in the code, and will be passed back to the delegate as the selections parameter in the `selectionViewController:requestsDismissalWithSelections:` method. The values should be what is to be displayed to the user. This should be set from the `setOptions(_:withDetails:sectionTitles:orderedAs:)` method.
    public private(set) var options = [NSObject:AnyObject]()
    
    /// Supplementary info for entries in `options`. Keys should match those in `options`.
    public private(set) var optionDetails = [NSObject:AnyObject]()
    
    /// The titles to use for the section in the selection view. This should be set from the `setOptions(_:withDetails:sectionTitles:orderedAs:)` method.
    public private(set) var sectionTitles:[String]? = nil
    
    /// Array of Arrays of keys for the choices. The nested array represents the section - row structure of the tableview. the keys should be unique otherwise the user's specific choices cannot be distinguished. These objects should be the same as the keys in  `options`. This should be set from the `setOptions(_:withDetails:sectionTitles:orderedAs:)` method.
    public private(set) var sortedOptionKeys = [[NSObject]]()
    
    /// Determines whether or not the view can be dismissed without the user making a selection. If true and no selection has been made when the user requests dismissal, a UIAlertView is presented. Default value is `false`.
    public var requiresSelection = false
    
    /// Delegate to inform of the user's requests for dismissal or cancel.
    public weak var delegate:SelectionViewControllerDelegate?
    
    /// The current selections made by the user. These should be stored as the keys from the `options` and `optionKeys`. Selections can be pre-specified by the presenter as this property updates the selected rows in `tableView` on `viewWillAppear:`.
    public var selectedKeys = [NSObject]()
    
    /// Updates properties.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // re-assign the selection type to set the tableView multi selection properties
        let type = selectionType
        self.selectionType = type
    }
    
    /// Pre-selects `tableView` cells based on `selectedKeys`.
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedKeys.count > 0 {
            
            for key in selectedKeys {
                
                if let selectedPath = indexPathForKey(key) {
                    tableView?.selectRowAtIndexPath(selectedPath, animated: false, scrollPosition: .None)
                }
            }
            
        }
    }
    
    /**
     
     Public setter for the data source properties. This sets all of the properties and reloads `tableView`.
     
     - parameter options: Sets `options`.
     - parameter withDetails: Sets `optionDetails`.
     - parameter sectionTitles: Sets `sectionTitles`.
     - parameter orderedAs: Sets `sortedOptionKeys`.
     
    */
    public func setOptions(options:[NSObject:AnyObject], withDetails: [NSObject:AnyObject], sectionTitles:[String]?, orderedAs:[[NSObject]]) {
        self.options = options
        self.optionDetails = withDetails
        self.sectionTitles = sectionTitles
        self.sortedOptionKeys = orderedAs
        
        tableView?.reloadData()
    }
    
    // MARK: Help Methods
    
    /**
     
     Helper method to map between the positions of options in the table and their keys in `options`.
     
     - parameter indexPath: The index of the option whose key should be returned.
     - returns: A key in `options` which is at `indexPath` in `sortedOptionKeys`.
     
     */
    public func keyForIndexPath(indexPath:NSIndexPath) -> NSObject {
        return sortedOptionKeys[indexPath.section][indexPath.row]
    }
    
    /**
     
     Helper method to map between the keys in `options` and the position of that option in a table.
     
     - parameter key: An object which is a key in `options`.
     - returns: The index of this key in `sortedOptionKeys`, representing this option's position in the table. `nil` if the key given is not found in the `options` dictionary.
     */
    public func indexPathForKey(key:NSObject) -> NSIndexPath? {
        for s in 0..<sortedOptionKeys.count {
            
            let sectionKeys = sortedOptionKeys[s]
            
            for r in 0..<sectionKeys.count {
                if sectionKeys[r] == key {
                    return NSIndexPath(forRow: r, inSection: s)
                }
            }
        }
        
        return nil
    }
    
    // MARK: TableViewDataSource Methods
    
    /**
     Convenience method for getting `UITableView.reuseIdentifier` for a given `NSIndexPath`.
     
     - parameter tableView: The `UITableView` to deque a cell from.
     - parameter indexPath: The path to get a reuse identifier for.
     
     - returns: "Detail" if `optionDetails` has an entry for the given `indexPath`, "Basic" otherwise.
     
    */
    public func tableView(tableView:UITableView, cellIdentifierForRowAtIndexPath indexPath:NSIndexPath) -> String {
        
        let key = keyForIndexPath(indexPath)
        let hasDetail = optionDetails[key] != nil
        
        return hasDetail ? "Detail" : "Basic"
    }
    
    /// - returns: the number of sub arrays in `sortedOptionKeys`.
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedOptionKeys.count
    }
    
    /// - returns: the number of entries in the array at the given `indexPath.section` in `sortedOptionKeys`.
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedOptionKeys[section].count
    }
    
    /// - returns: A `UITableViewCell` dequeued based on the result of `tableView(_:cellIdentifierForRowAtIndexPath:)`. If that cell conforms to `SelectionCell`, the option and deatil are set on the label properties.
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = self.tableView(tableView, cellIdentifierForRowAtIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if let selectionCell = cell as? SelectionCell {
            
            let key = keyForIndexPath(indexPath)
            let thisOption = options[key]
            let thisDetail = optionDetails[key]
            
            selectionCell.titleLabel?.text = thisOption as? String
            selectionCell.detailLabel?.text = thisDetail as? String
        }
        
        return cell
    }
    
    /// - returns: The entry in `sectionTitles` if it is set.
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles?[section]
    }
    
    // MARK: UITableViewDelegate Methods
    
    /// Manages selections. Deselects cells based on `selectionType`.
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // clear this re-selection
        
        let key = keyForIndexPath(indexPath)
        
        if selectedKeys.contains(key) && !self.requiresSelection {
            clearTableViewSelectionForIndexPath(indexPath)
        }
        
        // if self.requiresSelection => should not be able to deselect - only allow user to deselect this choice by selecting another
        
        // if self.selected keys doesn't contain this key, this is a new selection. Continue below to conditionally deselect other elements
        
        if self.selectionType == .SingleSectioned {
            
            let previousKeys = selectedKeys
            
            for key in previousKeys {
                
                if let selectedPath = indexPathForKey(key)
                    where selectedPath.section == indexPath.section {
                    clearTableViewSelectionForIndexPath(selectedPath)
                }
            }
        }
        
        selectedKeys.append(key)
    }
    
    /// Updates `selectedKeys` based on the key for the given `indexPath`.
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let key = keyForIndexPath(indexPath)
        if let idx = selectedKeys.indexOf(key) {
            selectedKeys.removeAtIndex(idx)
        }
    }
    
    /// Convenience method for deselecting a cell.
    public func clearTableViewSelectionForIndexPath(indexPath:NSIndexPath) {
        
        guard let tableView = self.tableView else { return }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // manually send the delegate message as it doesn't get called when deselecting programmatically
        tableView.delegate?.tableView?(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    /**
     
     Calculates the selected rows of `tableView` sorted by section. `nil` objects are entered where there are no selections for a given section. This can be used to validate the user's selection.
     
     - returns: An array of `Int`s representing a section, with either a selected `indexPath` for that section or `nil` if there is none. There is a tuple for each section in `tableView`.
     
     */
    public func sectionedSelections() -> [(Int, NSIndexPath?)] {
        
        let sectioned = self.tableView?.indexPathsForSelectedRows?.map { ($0.section, $0) } ?? []
        
        var sectionedInfo = [Int:NSIndexPath?]()
        
        for (s, ip) in sectioned {
            sectionedInfo[s] = ip
        }
        
        for s in 0..<(sortedOptionKeys.count ?? 0) {
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
        
        guard let tableView = self.tableView else { return "" }
        
        let missingSelections = sectionedSelections().filter { $0.1 == nil }
            .map { self.tableView?.dataSource?.tableView?(tableView, titleForHeaderInSection: $0.0) ?? "Section \($0.0)" }
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
    
    
    // MARK: Delegate Methods
    
    /// Asks for cancellation from the delegate. No selection checking is done as it is assumed the previous selection is retained.
    public func cancelSelectionViewController(sender:AnyObject?) {
        delegate?.selectionViewControllerRequestsCancel(self)
    }
    
    /**
     
     Checks whether the view can be dismissed based on `selectionType` and `requiresSelection`. If it can dismissal is requested from the delegate otherwise a `UIAlertController` is shown.
     
     - seealso: `validSectionedSelection()`
     - seealso: `errorTitle()`
     - seealso: `errorMessageForInvalidSelection()`
     - seealso: `errorMessageForInvalidSectionedSelection()`
     - seealso: `errorDismissButtonTitle()`
     */
    public func dismissSelectionViewController(sender:AnyObject?) {
        
        if (self.requiresSelection) {
            
            let validSelection:Bool
            
            if self.selectionType == .Single || self.selectionType == .Multiple {
                validSelection = self.selectedKeys.count > 0;
            } else {
                validSelection = self.validSectionedSelection()
            }
            
            if (validSelection) {
                self.delegate?.selectionViewControllerRequestsDismissal(self)
            } else {
                
                let alertMessage:String
                
                if self.selectionType == .Single || self.selectionType == .Multiple {
                    alertMessage = errorMessageForInvalidSelection()
                } else {
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