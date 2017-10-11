//
//  NSAlert+Links.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 11/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSAlert+Links.h"

@implementation NSAlert (Links)

+ (void)infoWithMessage:(NSString *)message {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = message;
  [alert addButtonWithTitle:@"OK"];
  [alert runModal];
}

+ (BOOL)confirm {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Are you sure?";
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Cancel"];
  return [alert runModal] == NSAlertFirstButtonReturn;
}

@end
