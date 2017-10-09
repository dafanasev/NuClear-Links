//
//  NSUserDefaults+AppGroup.h
//  shared
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"

@interface NSUserDefaults (Links)

@property NSArray<Rule *> *rules;

- (void)register;

@end
