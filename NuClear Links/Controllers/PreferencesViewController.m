//
//  PreferencesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 29/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import <shared/shared.h>
#import "PreferencesViewController.h"


@interface PreferencesViewController ()

@property (weak) IBOutlet NSStackView *isNotDefaultBrowserStackView;
@property (weak) IBOutlet NSStackView *isDefaultBrowserStackView;
@property (weak) IBOutlet NSButton *restoreDefaultBrowserButton;

@end


@implementation PreferencesViewController

- (void)viewWillAppear {
  [super viewWillAppear];
  
  NSString *systemBrowserBundleIdentifier = (__bridge NSString *)LSCopyDefaultHandlerForURLScheme(CFSTR("http"));
  
  if ([systemBrowserBundleIdentifier isEqualToString:kDaemonBundleId]) {
    NSString *previousSystemBrowserBundleId = [[NSUserDefaults appGroupUserDefaults] objectForKey:kPreviousSystemBrowserBundleId];
    Browser *previousBrowser = [Browser browserWithBundleIdentifier:previousSystemBrowserBundleId];
    _restoreDefaultBrowserButton.title = [NSString stringWithFormat:@"Restore %@...", previousBrowser.title];
    
    [_isNotDefaultBrowserStackView setHidden:YES];
    [_isDefaultBrowserStackView setHidden:NO];
  }
  else {
    [[NSUserDefaults appGroupUserDefaults] setObject:systemBrowserBundleIdentifier forKey:kPreviousSystemBrowserBundleId];
    [_isNotDefaultBrowserStackView setHidden:NO];
    [_isDefaultBrowserStackView setHidden:YES];
  }
}

- (IBAction)setAsTheSystemDefaultBrowserButtonClicked:(NSButton *)sender {
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)kDaemonBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)kDaemonBundleId);
}

- (IBAction)restoreSystemBrowserButonClicked:(NSButton *)sender {
  NSString *previousSystemBrowserBundleId = [[NSUserDefaults appGroupUserDefaults] objectForKey:kPreviousSystemBrowserBundleId];
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)previousSystemBrowserBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)previousSystemBrowserBundleId);
}

@end
