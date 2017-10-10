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
#import "Constants.h"

#define kShowRulePredicateEditorViewControllerSegue @"showRulePredicateEditorViewControllerSegue"


@interface RulesViewController ()

@property (strong) IBOutlet NSArrayController *arrayController;

- (IBAction)rulesControlClicked:(id)sender;

@end


@implementation RulesViewController

#pragma mark - Actions

- (IBAction)rulesControlClicked:(id)sender {
  // BUG: Array Controller does not propagate changes to UserDefaulsController automatically
  NSUserDefaults.standardUserDefaults.rules = (NSArray<Rule *> *)_arrayController.arrangedObjects;
}

- (IBAction)addButtonClicked:(NSButton *)sender {
  RulePredicateEditorViewController *rulePredicateEditorViewController = [self.storyboard instantiateControllerWithIdentifier:kEditRuleSheet];
  [rulePredicateEditorViewController.objectController setContent:[Rule new]];
  rulePredicateEditorViewController.objectIndex = 0;
  [self presentViewControllerAsSheet:rulePredicateEditorViewController];
}

- (IBAction)duplicateButtonClicked:(NSButton *)sender {
  Rule *newRule = [_arrayController.selectedObjects.firstObject copy];
  newRule.title = [NSString stringWithFormat:@"%@ copy", newRule.title];
  
  RulePredicateEditorViewController *rulePredicateEditorViewController = [self.storyboard instantiateControllerWithIdentifier:kEditRuleSheet];
  [rulePredicateEditorViewController.objectController setContent:newRule];
  rulePredicateEditorViewController.objectIndex = _arrayController.selectionIndex + 1;
  [self presentViewControllerAsSheet:rulePredicateEditorViewController];
}

- (IBAction)removeButtonClicked:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Are you sure?";
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Cancel"];
  
  if ([alert runModal] == NSAlertFirstButtonReturn) {
    [_arrayController removeObjects:_arrayController.selectedObjects];
    [NSNotificationCenter.defaultCenter postNotificationName:kRulesStateNotification object:NULL userInfo:NULL];
  }
}

- (IBAction)tableViewDoubleClicked:(NSTableView *)sender {
  if (_arrayController.selectedObjects.firstObject) {
    [self performSegueWithIdentifier:kShowRulePredicateEditorViewControllerSegue sender:sender];
  }
}

#pragma mark - NSTableViewDataSource

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
  NSArray<Rule *> *sortedRules = [NSUserDefaults.standardUserDefaults.rules sortedArrayUsingDescriptors:tableView.sortDescriptors];
  NSUserDefaults.standardUserDefaults.rules = sortedRules;
  [tableView reloadData];
}

# pragma mark - NSSeguePerforming

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
  RulePredicateEditorViewController *rulePredicateEditorViewController = (RulePredicateEditorViewController *)segue.destinationController;
  Rule *selectedRule = _arrayController.selectedObjects.firstObject;
  [rulePredicateEditorViewController.objectController setContent:[selectedRule copy]];
  rulePredicateEditorViewController.objectIndex = _arrayController.selectionIndex;
}

@end
