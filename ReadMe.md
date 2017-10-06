# SelectionViewController

![CocoaPods Compatible](https://cocoapod-badges.herokuapp.com/v/SelectionViewController/badge.png)]
![iOS](https://cocoapod-badges.herokuapp.com/p/SelectionViewController/badge.png)
![MIT license](https://img.shields.io/badge/license-MIT-lightgrey.svg)

Customisable Multi-Select UIViewController for iOS.

## Features

* [x] Simple Set Up
* [x] Single, Multiple and Sectioned Selection
* [x] Complex Selection Requirements Specifiable
* [x] Required / Optional Selection
* [x] Configurable UI
* [x] [Documentation](https://thedistance.github.io/SelectionViewController)

![Selection Overview](https://raw.githubusercontent.com/thedistance/SelectionViewController/gh-pages/Images/SelectionOverview.png)

*Simple form showing sections of options with extra details and multiple selections.*

## Requirements

- iOS 8.0+
- Xcode 9
- Swift 4.0

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is the preferred dependency manager as it reduces build times during app development. SelectionViewController has been built for CocoaPods. Add
	
	pod 'SelectionViewController'
	
to your podfile and run
	
	pod install
	
to install the framework.

## Usage

### UI

Currently, no default UI is provided. You should create a `SelectionViewController` in your Storyboard with cells with Reuse Identifier `Basic` and `Detail` (if `details` are provided - see below). Selection should be configured in a `UITableViewCell` subclass:

	class SelectionTableViewCell: UITableViewCell, SelectionCell {

    	@IBOutlet var titleLabel: UILabel?
    	@IBOutlet var detailLabel: UILabel?

    	override func setSelected(selected: Bool, animated: Bool) {
        	super.setSelected(selected, animated: animated)

        	// Configure the view for the selected state
        	accessoryType = selected ? .Checkmark : .None
    	}
	}

### Getting Started

When you want to show the selection, instantiate your selection view controller from the storyboard and configure the options using [`setOptions(_:withDetails:sectionTitles:orderedAs:)`](http://thedistance.github.io/SelectionViewController/Classes/SelectionViewController.html#/s:FC23SelectionViewController23SelectionViewController10setOptionsFTGVs10DictionaryCSo8NSObjectPs9AnyObject__11withDetailsGS1_S2_PS3___13sectionTitlesGSqGSaSS__9orderedAsGSaGSaS2____T_). This is the key method to set up the data for the selection.

The data for a `SelectionViewController` is set using 4 properties:

* `options: NSDictionary<id, id>`: A dictionary linking unique keys to the value to display to the user. The default implementation assumes the values are strings, however you can subclass `SelectionViewController` and override `tableview(_:cellForRowAtIndexPath:)` to handle the values and details. Keys are used to allow for consistent referencing to a specific option with multiple localised display values.
* `sortedOptionKeys: NSArray<NSArray<id> *>`: An array of arrays of keys. This defines the sections, and order of the options in the sections.
* `sectionTitles: NSArray<NSString *>`: An array of titles for the section. This should have the same count as `orderedSectionKeys` otherwise an index out of bounds exception will be thrown.
* `details: NSDictionary`: A dictionary of the option keys and any extra objects that should be associated with this key.

Each of these properties is read only, as setting them individually could corrupt the data source. Hence the combined setter method.

The simple example in the screenshot above uses the following:

	let options = ["OA":"Option A",
                   "OB":"Option B",
                   "OC":"Option C",
                   "CA":"Choice A",
                   "CB":"Choice B",
                   "CC":"Choice C"]
    
    let order = [["OA", "OB", "OC"], ["CA", "CB", "CC"]]
    
    let titles = ["Options", "Choices"]
    
	let details = ["OB": "Extras", "CA": "Extras"]

	selectionVC.setOptions(options, withDetails: details, sectionTitles: titles, orderedAs: order)
	
	
### Selection Behaviour

The behaviour of the selection is set using the `selectionType` and `requiresSelection` properties. The [SelectionType](http://thedistance.github.io/SelectionViewController/Enums/SelectionType.html) enum has 2 cases, each with associated values:

* `.All(min: _, max: _)`: Case representing the user's selection criteria over the entire table. The selection's positions in each section of the table is not accounted for.
* `.Sectioned(sectionMin: _, sectionMax: _, totalMin: _, totalMax: _)`: Case representing the user's selection criteria over the entire table with constraints on each section of the table.

If the user selects more than the `max` choices for a `.All` selection type, or `sectionMax` for a `.Sectioned`, choices are deselected in a first in first out manner. If `requiresSelection` is set to `true` all values in these enums combine to determine whether the user has made a valid selection. 

These two variables allow you to specify complex selection criteria:

* For a table with 3 sections a user can select 2-4 choices per section and 8 in total: 

        .Sectioned(sectionMin: 2, sectionMax: 4, totalMin: 6, totalMax: 8)
       
To make common types of selection easier, 4 convenience options are given:

* **Single**: Only a single item can be selected. If `requiresSelection`, there must be one and only one selection. 
* **SingleSectioned**: Only a single item in each section can be selected. If `requiresSelection`, one and only one item must be selected in each section.
* **Multiple**: Multiple items can be selected. If `requiresSelection`, at least one item from any section must be selected.
* **MultipleSectioned**: Multiple items in a given section can be selected. If `requiresSelection`, at least one item must be selected in each section.
    
If the selection criteria are not met by the user an alert is shown from the `dismissSelectionViewController(_:)` method. This alert can be configured by subclassing `SelectionViewController` and overriding one of

* `errorTitle()`
* `errorMessageForInvalidSelection()`
* `errorDismissButtonTitle()`

### Getting User's Selection

`SelectionViewController` has a `delegate` which is used to communicate results to the presenting view. 

* `selectionViewControllerRequestsDismissal(_:)`: The user's choices should be deemed chosen and the selection view dismissed. Their selection can be accessed through the `selectedKeys` property.
* `selectionViewControllerRequestsCancel(_:)`: The user's current selection on this view should be ignored and the selection view dismissed.

### Demo

This repo contains a simple demo that shows the features of this library.

![Demo Start](https://raw.githubusercontent.com/thedistance/SelectionViewController/gh-pages/Images/DemoStart.png)
![Selection Overview](https://raw.githubusercontent.com/thedistance/SelectionViewController/gh-pages/Images/SelectionOverview.png)
![Demo End](https://raw.githubusercontent.com/thedistance/SelectionViewController/gh-pages/Images/DemoEnd.png)

## Communication

- If you have **found a bug**, open an issue.
- If you have **a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you'd like to **ask a general question**, email us on <hello+selectionviewcontroller@thedistance.co.uk>.
