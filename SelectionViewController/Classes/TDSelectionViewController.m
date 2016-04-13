//
//  TDSelectionViewController.m
//  mCommerce
//
//  Created by Josh Campion on 10/07/2014.
//  Copyright (c) 2014 The Distance. All rights reserved.
//

#import "TDSelectionViewController.h"

@implementation TDSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.selectedKeys == nil) {
        self.selectedKeys = [NSMutableSet set];
    }
    
    // reset the selection type to assign the allowsMultipleSelection
    self.selectionType = self.selectionType;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedKeys.count > 0) {
        // preselect any cells already specified by the presenter
        for (id<NSCopying> key in self.selectedKeys) {
            
            NSIndexPath *selectedPath = [self indexPathForKey:key];
            if (selectedPath) {
                [self.tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectionType:(SelectionType)selectionType
{
    _selectionType = selectionType;
    
    self.tableView.allowsMultipleSelection = selectionType != SelectionTypeSingle;
}

-(void)setOptions:(NSDictionary *)options withDetails:(NSDictionary *)details orderedAs:(NSArray *)orderedOptions
{
    self.sortedOptionKeys = orderedOptions;
    self.options = options;
    self.optionDetails = details;
}

-(void)cancelSelectionViewController:(id)sender
{
    [self.delegate selectionViewControllerRequestsCancel:self];
}

#pragma mark - Helper methods

-(NSIndexPath *)indexPathForKey:(id) key
{
    for (NSInteger s = 0; s < self.sortedOptionKeys.count; s++) {
        NSArray *section = self.sortedOptionKeys[s];
        for (NSInteger r = 0; r < section.count; r++) {
            if ([section[r] isEqual:key]) {
                return [NSIndexPath indexPathForRow:r inSection:s];
            }
        }
    }
    
    return nil;
}

-(id)keyForIndexPath:(NSIndexPath *) indexPath
{
    return self.sortedOptionKeys[indexPath.section][indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sortedOptionKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ((NSArray *)self.sortedOptionKeys[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    id<NSCopying> thisKey = [self keyForIndexPath:indexPath];
    NSString *thisValue = self.options[thisKey];
    NSString *thisDetail = self.optionDetails[thisKey];
    
    if ([cell conformsToProtocol:@protocol(SelectionCell)]) {
        UITableViewCell<SelectionCell>* selectionCell = (UITableViewCell<SelectionCell>*) cell;
        
        selectionCell.titleLabel.text = thisValue;
        selectionCell.detailLabel.text = thisDetail;
    }
    
    if ([self.selectedKeys containsObject:thisKey]) {
        //[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //[cell setSelected:YES];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *) indexPath
{
    id<NSCopying> thisKey = [self keyForIndexPath:indexPath];
    NSString *thisDetail = self.optionDetails[thisKey];
    
    return (thisDetail != nil) ? @"Detail" : @"Basic";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

#pragma mark - Table view delegate

// Ensures the checkmarks are correctly displays and updates the users choices
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // clear this re-selection
    id  selectedKey = self.sortedOptionKeys[indexPath.section][indexPath.row];
    
    if ([self.selectedKeys containsObject:selectedKey] && !self.requiresSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // manually send the delegate message as it doesn't get called when deselecting programmatically
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        return;
    }
    
    // if self.requiresSelection => should not be able to deselect - only allow user to deselect this choice by selecting another
    
    // if self.selected keys doesn't contain this key, this is a new selection. Continue below to conditionally deselect other elements
    
    // Perform any deselection
    if (self.selectionType == SelectionTypeSingle) {
        // other deselection is taken care of in tableView:didDeselectRowAtIndexPath: which is called as tableView.allowsMultipleSelection == false
    }
    
    if (self.selectionType == SelectionTypeSingleSectioned) {
        
        // clear an old value in this section manually as tableView.allowsMultipleSelection == true to allow selection in multiple sections
        
        // use a copy of the selected keys as this will change with any deselections
        NSSet *previousKeys = [self.selectedKeys copy];
        
        for (id key in previousKeys) {
            
            NSIndexPath *selectedPath = [self indexPathForKey:key];
            
            if (selectedPath.section == indexPath.section) {
                // clear the current selection to be none
                [tableView deselectRowAtIndexPath:selectedPath animated:YES];
                // manually send the delegate message as it doesn't get called when deselecting programmatically
                [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:selectedPath];
            }
        }
    }
    
    if (self.selectionType == SelectionTypeMultiple) {
        // any number of selections can be made
    }
    
    if (self.selectionType == SelectionTypeMultipleSectioned) {
        // any number of selections can be made
    }
    
    [self.selectedKeys addObject:[self keyForIndexPath:indexPath]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedKeys removeObject:[self keyForIndexPath:indexPath]];
}

@end
