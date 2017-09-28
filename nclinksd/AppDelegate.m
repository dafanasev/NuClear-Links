//
//  AppDelegate.m
//  nclinksd
//
//  Created by Dmitry Afanasyev on 28/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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
  
  NSString *bid = [urlStr isEqualToString:@"https://nuclear.tools/"] ? @"com.google.Chrome" : @"com.apple.safari";
  
  [[NSWorkspace sharedWorkspace] openURLs:urlArray withAppBundleIdentifier:bid options:0 additionalEventParamDescriptor:NULL launchIdentifiers:NULL];
  
}


@end
