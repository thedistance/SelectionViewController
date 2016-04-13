//
//  TDSelectionViewController.h
//  mCommerce
//
//  Created by Josh Campion on 10/07/2014.
//  Copyright (c) 2014 The Distance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDSelectionViewController;

/// Used to determine the selection and deselection behaviour or a `TDSelectionViewController`. Combine this with `TDSelectionViewController.requiresSelection` to enforce selection behaviours.
typedef NS_ENUM(NSUInteger, SelectionType) {
    /// Only a single item can be selected. If `requiresSelection`, there must be one and only one selection.
    SelectionTypeSingle,
    /// Only a single item in each section can be selected. If `requiresSelection`, one and only one item must be selected in each section.
    SelectionTypeSingleSectioned,
    /// Multiple items can be selected. If `requiresSelection`, at least one item from any section must be selected.
    SelectionTypeMultiple,
    /// Multiple items in a given section can be selected. If `requiresSelection`, at least one item must be selected in each section.
    SelectionTypeMultipleSectioned,
};

/// Protocol defining the properties required on a dequeued `UITableViewCell` to display a selection.
@protocol SelectionCell <NSObject>

/// The label that displays the main text for an option in a selection.
@property (nonatomic, strong) UILabel  * _Nullable titleLabel;

/// The label that displays any supplementaary information for an option in a selection.
@property (nonatomic, strong) UILabel  * _Nullable detailLabel;

@end

/// Delegate of a `TDSelectionViewController` responsible for responding to the result of a selection.
@protocol TDSelectionViewControllerDelegate <NSObject>

/// This requests dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back updates the selection in the presenting view controller.
-(void)selectionViewControllerRequestsDismissal:(TDSelectionViewController * _Nonnull) selectionVC;

/// This requests dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back does not update the selection in the presenting view controller.
-(void)selectionViewControllerRequestsCancel:(TDSelectionViewController * _Nonnull) selectionVC;

@end

/*!
 * @class TDSelectionViewController
 * @discussion Simple class to display a list of choices. 
 
 The class generates cells using the identifiers `Basic` or `Detail` based on the values in `self.optionDetails`. Cells should be registered against these identifiers to prevent exceptions being thrown. Options can be configured into multiple sections using nested arrays in the `sortedOptionKeys` property. Cells should conform to `SelectionCell`. Visual cell selection should be configured in the cell itself.
 
 The `delegate` property should be set to return the selected choice(s) on dismissal. The delegate methods only request dismissal, they makes no assumption of how to be dismissed. This allows for modal / push / custom / child view controller presentation of the choices.
 */
@interface TDSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    /// Used to track the current selection so that if multiple selections aren't allowed, the previous selection has its selection accessory checkmark removed.
    // NSIndexPath *currentSingleSelection;
}

/// Determines the auto-deselection behaviour.
@property (nonatomic, assign) SelectionType selectionType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// Dictionary representing the options the user can choose from. The keys are ids used in the code, and will be passed back to the delegate as the selections parameter in the `selectionViewController:requestsDismissalWithSelections:` method. The values should be NSStrings representing the description to be displayed to the user. Setting this property automatically sets the sortedOptionKeys property using the compare: selector if sortedOptionKeys has not been set.
@property (nonatomic, strong) NSDictionary<id, NSString *> * _Nullable options;

/// The titles to use for the section in the selection view.
@property (nonatomic, strong) NSArray<NSString *> * _Nullable sectionTitles;

/// Array of Arrays of keys for the choices. The nested array represents the section - row structure of the tableview. the keys should be unique otherwise the user's specific choices cannot be distinguished. As these objects should be the same as the keys in the self.options property, they should conform to the NSCopying Protocol. Sections are set using nested sets.
@property (nonatomic, strong) NSArray<NSArray<id> *> * _Nullable sortedOptionKeys;

/// Determines whether or not the view can be dismissed without the user making a selection. If true and no selection has been made when the user requests dismissal, a UIAlertView is presented.
@property (nonatomic, assign) BOOL requiresSelection;

/// Delegate to inform of the selection made on dismissal
@property (weak) id<TDSelectionViewControllerDelegate> _Nullable delegate;

/// The current selections made by the user. These should be stored as the keys from the options and optionKeys, thus each object conforms to NSCopying. Selections can be pre-specified by the presenter as this array determines the selected rows on viewWillAppear:. A set is used for more efficient checking of contains.
@property (nonatomic, strong) NSMutableSet * _Nonnull selectedKeys;

/// If an option's key has a value in this dictionary, that value is set as the detailTextLabel text. The values should thus be NSStrings.
@property (strong, nonatomic) NSDictionary * _Nullable optionDetails;

/// Asks for cancellation from the delegate. No selection checking is done as it is assumed the previous selection is retained.
-(IBAction)cancelSelectionViewController:(id _Nullable)sender;

/*!
 * @discussion Helper method to set the options and their order.
 * @param key An object which is a key in the options NSDictionary property
 */
-(void)setOptions:(NSDictionary<id, NSString *> * _Nonnull)options withDetails:(NSDictionary<id, NSString *> * _Nullable) details orderedAs:(NSArray<id> * _Nonnull) orderedOptions;

/// As a presenter may present multiple `TDSelectionViewController`s, either singularly or at the same time, this property can be used to distinguish what this selection is for. It is not used in the class implementation
@property (nonatomic, strong) id _Nullable key;

/*!
 * @discussion Helper method to map between the keys in `options` and the position of that option in a table.
 * @param key An object which is a key in `options`.
 * @return NSIndexPath The index of this key in `sortedOptionKeys`, representing this option's position in the table. `nil` if the key given is not found in the `options` dictionary.
 */
-(NSIndexPath * _Nullable)indexPathForKey:(id _Nonnull) key;

/*!
 * @discussion Helper method to map between the positions of options in the table and their keys in `options`.
 * @param  indexPath The index of the option whose key should be returned.
 * @return id A key in the options NSDictionary property which is at indexPath in sortedOptionKeys. `nil` if the indexPath given is out of bounds of `sortedOptionKeys`.
 */
-(id _Nullable)keyForIndexPath:(NSIndexPath * _Nonnull) indexPath;

@end
