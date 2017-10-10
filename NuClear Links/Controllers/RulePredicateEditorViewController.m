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
  // I order to to save titles
  [self.view.window makeFirstResponder:sender];
  
  if (((NSButton *)sender).tag == kSaveChanges) {
    NSMutableArray<Rule *> *rules = [NSUserDefaults.standardUserDefaults.rules mutableCopy];
    [rules setObject:_objectController.selectedObjects.firstObject atIndexedSubscript:_objectIndex];
    NSUserDefaults.standardUserDefaults.rules = rules;
    [NSNotificationCenter.defaultCenter postNotificationName:kRulesStateNotification object:NULL userInfo:NULL];
  }
  
  [super dismissController:sender];
}

@end
