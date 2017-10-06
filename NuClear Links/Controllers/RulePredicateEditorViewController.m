//
//  RulePredicateEditorViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "RulePredicateEditorViewController.h"
#import <shared/shared.h>

@interface RulePredicateEditorViewController ()

@end

@implementation RulePredicateEditorViewController

-(void)dismissController:(id)sender {
  [[NSUserDefaults appGroupUserDefaults] synchronize];
  
  [super dismissController:sender];
}

@end
