//
//  Rule.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Browser.h"

@interface Rule : NSObject <NSCoding>

@property NSString *title;
@property BOOL      isActive;
@property Browser  *browser;
@property NSPredicate *predicate;

@property (class) NSArray<Rule *> *all;

@end
