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
  NSUserDefaults *defaults = [NSUserDefaults appGroupUserDefaults];
  
  NSString *defaultBrowserBundleId = [defaults objectForKey:kDefaultBrowserBundleId];
  
  NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
  NSArray<NSURL *> *urlArray = [NSArray arrayWithObject:url];
  
  __block NSString *neededBrowserBundleId = defaultBrowserBundleId;
  
  @try {
    [[defaults rules] enumerateObjectsUsingBlock:^(Rule * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
      if (rule.isActive && [urlArray filteredArrayUsingPredicate:rule.predicate].count > 0) {
        neededBrowserBundleId = rule.browser.bundleIdentifier;
        *stop = YES;
      }
    }];
  }
  @catch (NSException *exception) {
    neededBrowserBundleId = defaultBrowserBundleId;
  }
  
  [[NSWorkspace sharedWorkspace] openURLs:urlArray withAppBundleIdentifier:neededBrowserBundleId options:0 additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}


@end
