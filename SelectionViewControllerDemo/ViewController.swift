//
//  ViewController.swift
//  SelectionViewControllerDemo
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import SelectionViewController

extension SelectionType {
    
    var description:String {
        switch self {
        case .Single:
            return "Single"
        case .SingleSectioned:
            return "Single Sectioned"
        case .Multiple:
            return "Multiple"
        case .MultipleSectioned:
            return "Multiple Sectioned"
        }
    }
    
}

class ViewController: UITableViewController {

    let options = ["OA":"Option A",
                   "OB":"Option B",
                   "OC":"Option C",
                   "CA":"Choice A",
                   "CB":"Choice B",
                   "CC":"Choice C"]
    
    let order = [["OA", "OB", "OC"], ["CA", "CB", "CC"]]
    
    let details = ["OB": "Extras", "CA": "Extras"]
    
    let selectionTypes:[SelectionType] = [
        .Single,
        .SingleSectioned,
        .Multiple,
        .MultipleSectioned,
    ]
    
    let selectionRequired:[Bool] = [
        false,
        true
    ]
    
    var selections = [NSIndexPath: Set<String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectionVC = (segue.destinationViewController as? UINavigationController)?.topViewController as? TDSelectionViewController {
            
            selectionVC.setOptions(options, withDetails: details, orderedAs: order)
            selectionVC.sectionTitles = ["Options", "Choices"]
            selectionVC.title = "Choose an option"
            selectionVC.delegate = self
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                if let s = selections[indexPath] {
                    selectionVC.selectedKeys = NSMutableSet(set: s)
                }
                
                selectionVC.selectionType = selectionTypes[indexPath.row]
                selectionVC.requiresSelection = selectionRequired[indexPath.section]
            }
        }
    }

    @IBAction func unwindHome(segue:UIStoryboardSegue) { }
    
}

extension ViewController: TDSelectionViewControllerDelegate {
    
    func selectionViewControllerRequestsCancel(selectionVC: TDSelectionViewController) {
        selectionVC.performSegueWithIdentifier("unwindHome", sender: self)
    }
    
    func selectionViewControllerRequestsDismissal(selectionVC: TDSelectionViewController) {
        
        if let sp = tableView.indexPathForSelectedRow {
            
            let selected = Set(selectionVC.selectedKeys.allObjects.flatMap { $0 as? String })
            
            selections[sp] = selected.count > 0 ? selected : nil
            tableView.reloadRowsAtIndexPaths([sp], withRowAnimation: .Automatic)
        }
        
        selectionVC.performSegueWithIdentifier("unwindHome", sender: self)
    }
}

extension ViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return selectionRequired.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionTypes.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Selection " + (selectionRequired[section] ? "" : "Not ") + "Required"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectionCell")
        
        cell?.textLabel?.text = "Selection: \(selectionTypes[indexPath.row].description)"
        
        cell?.detailTextLabel?.text = selections[indexPath]?
            .flatMap { options[$0] }
            .joinWithSeparator(", ") ?? "No Selection"
        
        
        return cell!
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
