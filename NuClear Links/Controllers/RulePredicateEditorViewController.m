//
//  RulePredicateEditorViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "RulePredicateEditorViewController.h"
#import "RulesViewController.h"
#import <shared/shared.h>


@interface RulePredicateEditorViewController ()

@end

@implementation RulePredicateEditorViewController


- (void)dismissController:(id)sender {
  [self.view.window makeFirstResponder:sender];
  
  if (((NSButton *)sender).tag == 1) {
    NSMutableArray<Rule *> *rules = [[[NSUserDefaults appGroupUserDefaults] rules] mutableCopy];
    [rules setObject:_objectController.selectedObjects.firstObject atIndexedSubscript:_objectIndex];
    [[NSUserDefaults appGroupUserDefaults] setRules:rules];
  }
  
  [super dismissController:sender];
}

@end
