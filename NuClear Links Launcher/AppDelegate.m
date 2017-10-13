//
//  AppDelegate.m
//  NuClear Links Launcher
//
//  Created by Dmitry Afanasyev on 13/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSArray *pathComponents = NSBundle.mainBundle.bundlePath.pathComponents;
  pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, pathComponents.count - 4)];
  NSString *path = [NSString pathWithComponents:pathComponents];
  [NSWorkspace.sharedWorkspace launchApplication:path];
  [NSApp terminate:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


@end
