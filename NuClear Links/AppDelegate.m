//
//  AppDelegate.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 28/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AppDelegate.h"
#import "IsOneObjectValueTransformer.h"
#import "NSUserDefaults+Links.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier] count] > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
  
  [NSValueTransformer setValueTransformer:[IsOneObjectValueTransformer new] forName:@"IsOneObjectValueTransformer"];
  
  [[NSUserDefaults standardUserDefaults] register];
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:)
                                                   forEventClass:kInternetEventClass andEventID:kAEGetURL];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSString *defaultBrowserBundleId = [defaults objectForKey:kDefaultBrowserBundleId];
    // for some reason when main app reads com.apple.Safari from the defaults, nclinksd returns null
  if (!defaultBrowserBundleId) {
    defaultBrowserBundleId = @"com.apple.Safari";
  }
  
  NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
  NSArray<NSURL *> *urlArray = [NSArray arrayWithObject:url];
  
  __block NSString *neededBrowserBundleId = defaultBrowserBundleId;
  
  __block NSWorkspaceLaunchOptions options = NSWorkspaceLaunchAsync;
  @try {
    [[defaults rules] enumerateObjectsUsingBlock:^(Rule * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
      if (rule.isActive && [urlArray filteredArrayUsingPredicate:rule.predicate].count > 0) {
        neededBrowserBundleId = rule.browser.bundleIdentifier;
        if (rule.openInBackground) {
          options |= NSWorkspaceLaunchWithoutActivation;
        }
        *stop = YES;
      }
    }];
  }
  @catch (NSException *exception) {
    neededBrowserBundleId = defaultBrowserBundleId;
  }
  
  [[NSWorkspace sharedWorkspace] openURLs:urlArray withAppBundleIdentifier:neededBrowserBundleId options:options
           additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}

@end
