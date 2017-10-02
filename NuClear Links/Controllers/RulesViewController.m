//
//  RulesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <shared/shared.h>
#import "RulesViewController.h"


@interface RulesViewController ()

@property NSMutableArray<Rule *> *rules;

@end


@implementation RulesViewController

- (void)awakeFromNib {
  [super awakeFromNib];
  
  Rule *rule1 = [[Rule alloc] initWithTitle:@"Rule #1" browserBundleIdentifier:@"com.apple.safari"];
  Rule *rule2 = [[Rule alloc] initWithTitle:@"Rule #2" browserBundleIdentifier:@"com.google.Chrome"];
  
  self.rules = [@[rule1, rule2] mutableCopy];
    //  _rules = [Rule.all mutableCopy];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillDisappear {
  Rule.all = _rules;
  
  [super viewWillDisappear];
}



@end
