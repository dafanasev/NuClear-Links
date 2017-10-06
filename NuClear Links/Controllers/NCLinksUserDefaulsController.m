//
//  NCLinksUserDefaulsController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 04/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <shared/shared.h>
#import "NCLinksUserDefaulsController.h"

@implementation NCLinksUserDefaulsController

- (instancetype)initWithCoder:(NSCoder *)coder {
  NSUserDefaultsController *controller = [super initWithDefaults:[NSUserDefaults appGroupUserDefaults] initialValues:nil];
  controller.appliesImmediately = YES;
  return (NCLinksUserDefaulsController *)controller;
}

@end
