//
//  Rule.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rule : NSObject <NSCoding>

@property NSString    *title;
@property BOOL        isActive;
@property NSString    *browserBundleIdentifier;
@property NSString    *browserName;
@property NSImage     *browserIcon;
@property NSURL       *url;
@property NSPredicate *predicate;

@property (class) NSArray<Rule *> *all;

-(instancetype)initWithTitle:(NSString *)title browserBundleIdentifier:(NSString *)browserBundleIdentifier isActive:(BOOL)isActive;

@end
