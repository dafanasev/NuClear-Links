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

- (instancetype)init {
  return [super initWithDefaults:[NSUserDefaults appGroupUserDefaults] initialValues:nil];
}

@end
