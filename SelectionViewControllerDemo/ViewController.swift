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
        
        if self == .Single {
            return "Single"
        } else if self == .SingleSectioned {
            return "Single Sectioned"
        } else if self == .Multiple {
            return "Multiple"
        } else if self == .MultipleSectioned {
            return "Multiple Sectioned"
        } else {
            return "Enum"
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
    
    let order:[[NSObject]] = [["OA", "OB", "OC"], ["CA", "CB", "CC"]]
    
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
    
    var selections = [NSIndexPath: [NSObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectionVC = (segue.destinationViewController as? UINavigationController)?.topViewController as? SelectionViewController {
            
            selectionVC.setOptions(options, withDetails: details, sectionTitles: ["Options", "Choices"], orderedAs: order)
            
            selectionVC.title = "Choose an option"
            selectionVC.delegate = self
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                if let s = selections[indexPath] {
                    selectionVC.selectedKeys = s
                }
                
                selectionVC.selectionType = selectionTypes[indexPath.row]
                selectionVC.requiresSelection = selectionRequired[indexPath.section]
            }
        }
    }

    @IBAction func unwindHome(segue:UIStoryboardSegue) { }
    
}


extension ViewController: SelectionViewControllerDelegate {
    
    
    
    func selectionViewControllerRequestsCancel(selectionVC: SelectionViewController) {
        selectionVC.performSegueWithIdentifier("unwindHome", sender: self)
    }
    
    func selectionViewControllerRequestsDismissal(selectionVC: SelectionViewController) {
        
        if let sp = tableView.indexPathForSelectedRow {
            
            let selected = selectionVC.selectedKeys
            
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
            .flatMap { $0 as? String }
            .flatMap { options[$0] }
            .joinWithSeparator(", ") ?? "No Selection"
        
        return cell!
    }
}

class DemoSelectionViewController: SelectionViewController {
    
    @IBAction override func cancelSelectionViewController(sender: AnyObject?) {
        super.cancelSelectionViewController(sender)
    }
    
    @IBAction override func dismissSelectionViewController(sender: AnyObject?) {
        super.dismissSelectionViewController(sender)
    }
}
