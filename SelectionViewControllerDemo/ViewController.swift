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
            
            switch self {
            case let .all(min: min, max: max):
                return "All [\(min) - \(max ?? 0)]"
            case let .sectioned(sectionMin: sMin, sectionMax: sMax, totalMin: tMin, totalMax: tMax):
                return "Sectioned [\(sMin) - \(sMax ?? 0)] - [\(tMin) - \(tMax ?? 0)]"
            }
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
    
    let order:[[NSObject]] = [["OA" as NSObject, "OB" as NSObject, "OC" as NSObject], ["CA" as NSObject, "CB" as NSObject, "CC" as NSObject]]
    
    let details = ["OB": "Extras", "CA": "Extras"]
    
    let selectionTypes:[SelectionType] = [
        .Single,
        .SingleSectioned,
        .Multiple,
        .MultipleSectioned,
        .all(min: 1, max:3),
        .sectioned(sectionMin: 1, sectionMax: 2, totalMin: 0, totalMax: nil),
        .sectioned(sectionMin: 1, sectionMax: nil, totalMin: 2, totalMax: 4)
    ]
    
    let selectionRequired:[Bool] = [
        false,
        true
    ]
    
    var selections = [IndexPath: [NSObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectionVC = (segue.destination as? UINavigationController)?.topViewController as? SelectionViewController {
            
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
    
    func selectionViewControllerRequestsCancel(_ selectionVC: SelectionViewController) {
        selectionVC.performSegue(withIdentifier: "unwindHome", sender: self)
    }
    
    func selectionViewControllerRequestsDismissal(_ selectionVC: SelectionViewController) {
        
        if let sp = tableView.indexPathForSelectedRow {
            
            let selected = selectionVC.selectedKeys
            
            selections[sp] = selected.count > 0 ? selected : nil
            tableView.reloadRows(at: [sp], with: .automatic)
        }
        
        selectionVC.performSegue(withIdentifier: "unwindHome", sender: self)
    }
}

extension ViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return selectionRequired.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionTypes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Selection " + (selectionRequired[section] ? "" : "Not ") + "Required"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell")
        
        cell?.textLabel?.text = "Selection: \(selectionTypes[indexPath.row].description)"
        
        cell?.detailTextLabel?.text = selections[indexPath]?
            .flatMap { $0 as? String }
            .flatMap { options[$0] }
            .joined(separator: ", ") ?? "No Selection"
        
        return cell!
    }
}

class DemoSelectionViewController: SelectionViewController {
    
    @IBAction override func cancelSelectionViewController(_ sender: AnyObject?) {
        super.cancelSelectionViewController(sender)
    }
    
    @IBAction override func dismissSelectionViewController(_ sender: AnyObject?) {
        super.dismissSelectionViewController(sender)
    }
}
