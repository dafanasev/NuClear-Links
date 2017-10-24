//
//  AppDelegate.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 28/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AppDelegate.h"
#import "IsOneObjectValueTransformer.h"
#import "NilToRedColorValueTransformer.h"
#import "HasNotBrokenRulesValueTransformer.h"
#import "NSUserDefaults+Links.h"
#import "Constants.h"
#import "Browser.h"
#import "ShortenedURLExpander.h"
#import "NSBundle+Links.h"
#import "NSUserNotificationCenter+Links.h"
#import <ServiceManagement/ServiceManagement.h>


@interface AppDelegate ()

@end


@implementation AppDelegate

- (instancetype)init {
  if (self = [super init]) {
    [NSUserDefaults.standardUserDefaults register];
    
    ShortenedURLExpander.sharedExpander.block = ^void (NSURL *url) {
      [self proxyURL:url];
    };
    
    [NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(getURL:withReplyEvent:)
                                                   forEventClass:kInternetEventClass andEventID:kAEGetURL];
  }
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  if ([NSRunningApplication runningApplicationsWithBundleIdentifier:NSBundle.mainBundle.bundleIdentifier].count > 1) {
    [NSApplication.sharedApplication terminate:self];
  }
  
  [NSNotificationCenter.defaultCenter postNotificationName:kLinksSetupNotification object:NULL];
  
  [NSValueTransformer setValueTransformer:[IsOneObjectValueTransformer new] forName:NSStringFromClass(IsOneObjectValueTransformer.class)];
  [NSValueTransformer setValueTransformer:[NilToRedColorValueTransformer new] forName:NSStringFromClass(NilToRedColorValueTransformer.class)];
  [NSValueTransformer setValueTransformer:[HasNotBrokenRulesValueTransformer new] forName:NSStringFromClass(HasNotBrokenRulesValueTransformer.class)];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  if (!Browser.isLinksActive) {
    SMLoginItemSetEnabled((__bridge CFStringRef)kLauncherBundleId, NO);
  }
  
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
  __block NSString *neededBrowserBundleId = Browser.defaultBrowserBundleId;
  
  __block NSWorkspaceLaunchOptions options = NSWorkspaceLaunchAsync;
  if (!NSApplication.sharedApplication.isActive || NSUserDefaults.standardUserDefaults.openInBackground) {
    options |= NSWorkspaceLaunchWithoutActivation;
  }
  
  if (NSUserDefaults.standardUserDefaults.areRulesEnabled) {
    @try {
      [NSUserDefaults.standardUserDefaults.rules enumerateObjectsUsingBlock:^(Rule * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
        if (rule.isActive && [rule.predicate evaluateWithObject:url]) {
          neededBrowserBundleId = rule.browser.bundleIdentifier;
          if (![NSBundle isBundleWithIdentifierExists:neededBrowserBundleId]) {
            neededBrowserBundleId = Browser.defaultBrowserBundleId;
            [NSUserNotificationCenter.defaultUserNotificationCenter deliverMessage:kMissingBrowserNotification];
          }
          
          if (rule.openInBackground) {
            options |= NSWorkspaceLaunchWithoutActivation;
          }
          else {
            options &= ~(NSWorkspaceLaunchWithoutActivation);
          }
          
          *stop = YES;
        }
      }];
    }
    @catch (NSException *exception) {
      neededBrowserBundleId = Browser.defaultBrowserBundleId;
    }
  }
  
  [NSWorkspace.sharedWorkspace openURLs:@[url] withAppBundleIdentifier:neededBrowserBundleId options:options
         additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
  return YES;
}

@end
