//
//  NSUserNotificationCenter+Links.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 14/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSUserNotificationCenter+Links.h"

@implementation NSUserNotificationCenter (Links)

- (void)deliverMessage:(NSString *)message {
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = @"NuClear Links";
  notification.informativeText = message;
  [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
}

@end
