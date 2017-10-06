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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [_browserPopUpButton.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull mi, NSUInteger idx, BOOL * _Nonnull stop) {
    NSLog(@"The represented object is: %@", mi.representedObject);
  }];
}

- (void)dismissController:(id)sender {
  // BUG: Array Controller does not propagate changes to UserDefaulsController automatically
  if (((NSButton *)sender).tag == 1) {
    RulesViewController *presentingController = (RulesViewController *)self.presentingViewController;
    [super dismissController:sender];
    [presentingController rulesControlClicked:sender];
  }
  else {
    // save before dismissing controller to save old values, actually doing cancel
    [(RulesViewController *)self.presentingViewController rulesControlClicked:sender];
    [super dismissController:sender];
  }
}

@end
