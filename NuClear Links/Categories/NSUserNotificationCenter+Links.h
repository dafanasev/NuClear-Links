//
//  NSUserNotificationCenter+Links.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 14/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSUserNotificationCenter (Links)

- (void)deliverMessage:(NSString *)message;

@end
