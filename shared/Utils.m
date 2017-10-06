//
//  Utils.m
//  shared
//
//  Created by Dmitry Afanasyev on 29/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Utils.h"
#import "Constants.h"

NSArray <NSString *> *browsersList() {
  NSMutableArray <NSString *> *browsersList = [NSMutableArray array];
  [(__bridge NSArray *)LSCopyAllHandlersForURLScheme(CFSTR("http")) enumerateObjectsUsingBlock:^(id  _Nonnull bundleId, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleId];
    if (![bundleId isEqualToString:kDaemonBundleId] && path && [[NSWorkspace sharedWorkspace] iconForFile:path]) {
      [browsersList addObject:(NSString *)bundleId];
    }
  }];
  
  return browsersList;
}
