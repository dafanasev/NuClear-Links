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
#import "ShortenedURLExtractor.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier].count > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
  
  [NSValueTransformer setValueTransformer:[IsOneObjectValueTransformer new] forName:@"IsOneObjectValueTransformer"];
  
  [NSUserDefaults.standardUserDefaults register];
  
  [NSNotificationCenter.defaultCenter postNotificationName:kRulesStateNotification object:NULL userInfo:NULL];
  
  [NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(getURL:withReplyEvent:)
                                                   forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  [ShortenedURLExtractor.sharedExtractor saveCache];
}

- (void)getURL:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSURL *url = [NSURL URLWithString:[event paramDescriptorForKeyword:keyDirectObject].stringValue];
  
  if ([ShortenedURLExtractor.sharedExtractor isShortenedURL:url]) {
    [ShortenedURLExtractor.sharedExtractor extractURL:url andExecuteBlock:^(NSURL *resultUrl) {
      [self proxyURL:resultUrl];
    }];
  }
  else {
    [self proxyURL:url];
  }
}

- (void)proxyURL:(NSURL *)url {
  NSString *systemBrowserBundleId = Browser.systemBrowserBundleId;
  __block NSString *neededBrowserBundleId = systemBrowserBundleId;
  
  __block NSWorkspaceLaunchOptions options = NSWorkspaceLaunchAsync;
  if (!NSApplication.sharedApplication.isActive) {
    options |= NSWorkspaceLaunchWithoutActivation;
  }
  
  NSArray<NSURL *> *urlArray = @[url];
  
  if (NSUserDefaults.standardUserDefaults.areRulesEnabled) {
    @try {
      [NSUserDefaults.standardUserDefaults.rules enumerateObjectsUsingBlock:^(Rule * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
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
      neededBrowserBundleId = systemBrowserBundleId;
    }
  }
  
  [NSWorkspace.sharedWorkspace openURLs:urlArray withAppBundleIdentifier:neededBrowserBundleId options:options
         additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}

@end
