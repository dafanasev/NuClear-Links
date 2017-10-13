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
#import "Browser.h"
#import "ShortenedURLExpander.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier].count > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
  
  [NSValueTransformer setValueTransformer:[IsOneObjectValueTransformer new] forName:@"IsOneObjectValueTransformer"];
  
  [NSUserDefaults.standardUserDefaults register];
  
  ShortenedURLExpander.sharedExpander.block = ^void (NSURL *url) {
    [self proxyURL:url];
  };
  
  [NSNotificationCenter.defaultCenter postNotificationName:kLinksSetupNotification object:NULL userInfo:NULL];
  
  [NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(getURL:withReplyEvent:)
                                                   forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  [ShortenedURLExpander.sharedExpander saveCache];
}

- (void)getURL:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSURL *url = [NSURL URLWithString:[event paramDescriptorForKeyword:keyDirectObject].stringValue];
  
  if (NSUserDefaults.standardUserDefaults.expandShortenedURLs && [ShortenedURLExpander.sharedExpander isShortenedURL:url]) {
    [ShortenedURLExpander.sharedExpander expandURLAndExecuteBlock:url];
  }
  else {
    [self proxyURL:url];
  }
}

- (void)proxyURL:(NSURL *)url {
  NSString *systemBrowserBundleId = Browser.defaultBrowserBundleId;
  __block NSString *neededBrowserBundleId = systemBrowserBundleId;
  
  __block NSWorkspaceLaunchOptions options = NSWorkspaceLaunchAsync;
  if (!NSApplication.sharedApplication.isActive || NSUserDefaults.standardUserDefaults.openInBackground) {
    options |= NSWorkspaceLaunchWithoutActivation;
  }
  
  if (NSUserDefaults.standardUserDefaults.areRulesEnabled) {
    @try {
      [NSUserDefaults.standardUserDefaults.rules enumerateObjectsUsingBlock:^(Rule * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
        if (rule.isActive && [rule.predicate evaluateWithObject:url]) {
          neededBrowserBundleId = rule.browser.bundleIdentifier;
          if (rule.openInBackground) {
            options |= NSWorkspaceLaunchWithoutActivation;
          }
          *stop = YES;
        }
      }];
    }
    @catch (NSException *exception) {
      neededBrowserBundleId = systemBrowserBundleId;
    }
  }
  
  [NSWorkspace.sharedWorkspace openURLs:@[url] withAppBundleIdentifier:neededBrowserBundleId options:options
         additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}

@end
