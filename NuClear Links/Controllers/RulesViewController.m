//
//  RulesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "RulesViewController.h"
#import "Rule.h"
#import "RulePredicateEditorViewController.h"
#import "BrowserPopUpButton.h"
#import "NSUserDefaults+Links.h"

#define kShowRulePredicateEditorViewControllerSegue @"showRulePredicateEditorViewControllerSegue"


@interface RulesViewController ()

@property (strong) IBOutlet NSArrayController *arrayController;

- (IBAction)rulesControlClicked:(id)sender;

@end


@implementation RulesViewController

#pragma mark - Actions

- (IBAction)rulesControlClicked:(id)sender {
  // BUG: Array Controller does not propagate changes to UserDefaulsController automatically
  [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_arrayController.arrangedObjects] forKey:@"rules"];
}

- (IBAction)addButtonClicked:(NSButton *)sender {
  [_arrayController insertObject:[Rule new] atArrangedObjectIndex:0];
  // because [_arrayController selectsInsertedObjects] = YES does not work for compound objects
  [_arrayController setSelectionIndex:0];
  [self performSegueWithIdentifier:kShowRulePredicateEditorViewControllerSegue sender:self];
}

- (IBAction)duplicateButtonClicked:(NSButton *)sender {
  Rule *selectedObject = _arrayController.selectedObjects.firstObject;
  Rule *newRule = [selectedObject copy];
  newRule.title = [NSString stringWithFormat:@"%@ copy", newRule.title];
  NSUInteger newRuleIndex = _arrayController.selectionIndex + 1;
  [_arrayController insertObject:newRule atArrangedObjectIndex:newRuleIndex];
  // because [_arrayController selectsInsertedObjects] = YES does not work for compound objects
  [_arrayController setSelectionIndex:newRuleIndex];
  [self performSegueWithIdentifier:kShowRulePredicateEditorViewControllerSegue sender:self];
}

- (IBAction)removeButtonClicked:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Are you sure?";
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Cancel"];
  
  if ([alert runModal] == NSAlertFirstButtonReturn) {
    [_arrayController removeObjects:_arrayController.selectedObjects];
  }
}

- (IBAction)tableViewDoubleClicked:(NSTableView *)sender {
  if (_arrayController.selectedObjects.firstObject) {
    [self performSegueWithIdentifier:kShowRulePredicateEditorViewControllerSegue sender:self];
  }
}

# pragma mark - NSSeguePerforming

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
  RulePredicateEditorViewController *rulePredicateEditorViewController = (RulePredicateEditorViewController *)segue.destinationController;
  Rule *selectedRule = _arrayController.selectedObjects.firstObject;
  [rulePredicateEditorViewController.objectController setContent:[selectedRule copy]];
  rulePredicateEditorViewController.objectIndex = _arrayController.selectionIndex;
}

#pragma mark - NSTableViewDataSource

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
  NSArray<Rule *> *sortedRules = [NSUserDefaults.standardUserDefaults.rules sortedArrayUsingDescriptors:tableView.sortDescriptors];
  NSUserDefaults.standardUserDefaults.rules = sortedRules;
  [tableView reloadData];
}

@end
