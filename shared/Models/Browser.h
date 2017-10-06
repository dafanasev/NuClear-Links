//
//  Browser.h
//  shared
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Browser : NSObject <NSCoding>

@property NSString *bundleIdentifier;
@property (readonly) NSString *title;
@property (readonly) NSImage  *image;

@property (class, readonly) NSDictionary <NSString *, Browser *> *browsersDictionary;

+(Browser *)browserWithBundleIdentifier:(NSString *)bundleIdentifier;

-(instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier;


@end
