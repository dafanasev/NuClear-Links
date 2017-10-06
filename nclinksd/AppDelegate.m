//
//  AppDelegate.m
//  nclinksd
//
//  Created by Dmitry Afanasyev on 28/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <shared/shared.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier] count] > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:)
                                                   forEventClass:kInternetEventClass andEventID:kAEGetURL];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
  
  NSURL *url = [NSURL URLWithString:urlStr];
  NSArray *urlArray = [NSArray arrayWithObject:url];
  
  NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
  NSString *defaultBrowserBundleId = [defaults objectForKey:kDefaultBrowserBundleId];
  
  [[NSWorkspace sharedWorkspace] openURLs:urlArray withAppBundleIdentifier:defaultBrowserBundleId options:0 additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}


@end
