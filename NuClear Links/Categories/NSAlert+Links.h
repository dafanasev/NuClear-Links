//
//  NSAlert+Links.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 11/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (Links)

+ (void)infoWithMessage:(NSString *)message;
+ (BOOL)confirm;

@end
