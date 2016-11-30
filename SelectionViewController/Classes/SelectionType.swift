//
//  TDSelectionViewController.swift
//  SelectionViewController
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

/// Used to determine the selection and deselection behaviour or a `SelectionViewController`. Combine this with `SelectionViewController.requiresSelection` to enforce selection behaviours.
public enum SelectionType: Equatable {
    
    /**
 
     Case representing the user's selection criteria over the entire table. The selection's positions in each section of the table is not accounted for.
     
     - parameter min: The minimum selection that the user is allowed if `requiresSelection` is true.
     - parameter max: The maxiumum selection that the user is allowed. `nil` if there is no restriction. The cell items will be deselected if the number of `selectedKeys` on a `SelectionViewController` is exceeded in a first in first out manner.
     
    */
    case all(min:Int, max:Int?)
    
    /**
     
     Case representing the user's selection criteria over the entire table with constraints on each section of the table.
     
     - parameter sectionMin: The minimum selection that the user is allowed in a single selection if `requiresSelection` is true.
     - parameter sectionMax: The maxiumum selection that the user is allowed in a single selection. `nil` if there is no per section restriction. The cell items will be deselected if the number of `selectedKeys` on a `SelectionViewController` for a given section is exceeded in a first in first out manner for that section.
     
     - parameter totalMin: The minimum selection that the user is allowed over the entire table if `requiresSelection` is true.
     - parameter totalMax: The maxiumum selection that the user is allowed over the entire table. `nil` if there is no restriction.
     
     */
    case sectioned(sectionMin:Int, sectionMax:Int?, totalMin:Int, totalMax:Int?)
    
    // MARK: Convenience Creators
    
    /**
     
     Only a single item can be selected. If `requiresSelection`, there must be one and only one selection.
     
         .All(min:1, max:1)
    */
    public static var Single: SelectionType {
        return all(min:1, max:1)
    }
    
    /**
     
     Only a single item in each section can be selected. If `requiresSelection`, one and only one item must be selected in each section.
     
         .Sectioned(sectionMin:1, sectionMax:1, totalMin: nil, totalMax: nil)
    */
    public static var SingleSectioned: SelectionType {
        return sectioned(sectionMin:1, sectionMax:1, totalMin: 1, totalMax: nil)
    }
    
    /**
     
     Multiple items can be selected. If `requiresSelection`, at least one item from any section must be selected.
     
         .All(min:1, max:nil)
     
    */
    public static var Multiple: SelectionType {
        return all(min:1, max:nil)
    }
    
    /**
     
     Multiple items in a given section can be selected. If `requiresSelection`, at least one item must be selected in each section.
     
         .Sectioned(sectionMin:nil, sectionMax:nil, totalMin: 1, totalMax: nil)
    */
    public static var MultipleSectioned: SelectionType {
        return sectioned(sectionMin:1, sectionMax:nil, totalMin: 1, totalMax: nil)
    }
}

/// Equatable conformance for `SelectionType`.
public func ==(s1:SelectionType, s2:SelectionType) -> Bool {
    
    switch (s1, s2) {
    case (.all(let min1, let max1), .all(let min2, let max2)):
        return min1 == min2 && max1 == max2
    case (.sectioned(let smin1, let smax1, let tmin1, let tmax1), .sectioned(let smin2, let smax2, let tmin2, let tmax2)):
        return smin1 == smin2 && smax1 == smax2 && tmin1 == tmin2 && tmax1 == tmax2
    default:
        return false
    }
    
}
