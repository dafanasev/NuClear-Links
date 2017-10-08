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
@property NSTimer *rightStackViewTimer;

@end


@implementation PreferencesViewController

- (void)viewWillAppear {
  [super viewWillAppear];
  
  [self showRightStackView];
  
  _rightStackViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showRightStackView) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear {
  [_rightStackViewTimer invalidate];
  _rightStackViewTimer = nil;
  
  [super viewWillDisappear];
}

- (void)showRightStackView {
  NSString *systemBrowserBundleIdentifier = (__bridge NSString *)LSCopyDefaultHandlerForURLScheme(CFSTR("http"));
  
  if ([systemBrowserBundleIdentifier isEqualToString:kDaemonBundleId]) {
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
