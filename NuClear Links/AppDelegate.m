//
//  AppDelegate.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 28/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier] count] > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


@end
