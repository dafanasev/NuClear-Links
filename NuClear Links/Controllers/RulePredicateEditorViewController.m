//
//  RulePredicateEditorViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "RulePredicateEditorViewController.h"
#import "RulesViewController.h"
#import "Rule.h"
#import "NSUserDefaults+Links.h"
#import "Constants.h"

#define kSaveChanges 1


@interface RulePredicateEditorViewController ()

@end

@implementation RulePredicateEditorViewController

- (void)dismissController:(id)sender {
  // In order to save titles it should lost its focus
  [self.view.window makeFirstResponder:sender];
  
  if (((NSButton *)sender).tag == kSaveChanges) {
    NSMutableArray<Rule *> *rules = [NSUserDefaults.standardUserDefaults.rules mutableCopy];
    Rule *rule = (Rule *)_objectController.selectedObjects.firstObject;
    if (_isNewBobject) {
      [rules insertObject:rule atIndex:_objectIndex];
    }
    else {
      [rules setObject:rule atIndexedSubscript:_objectIndex];
    }
    Rule.all = rules;
    [NSNotificationCenter.defaultCenter postNotificationName:kRulesCountDidChangeNotification object:NULL userInfo:NULL];
  }
  
  [super dismissController:sender];
}

@end
