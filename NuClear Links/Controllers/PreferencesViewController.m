//
//  PreferencesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 29/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import "PreferencesViewController.h"
#import "Constants.h"
#import "Browser.h"


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
  NSString *systemBrowserBundleId = (__bridge NSString *)LSCopyDefaultHandlerForURLScheme(CFSTR("http"));
  
  if ([systemBrowserBundleId isEqualToString:NSBundle.mainBundle.bundleIdentifier.lowercaseString]) {
    [_isNotDefaultBrowserStackView setHidden:YES];
    [_isDefaultBrowserStackView setHidden:NO];
  }
  else {
    [[NSUserDefaults standardUserDefaults] setObject:systemBrowserBundleId forKey:kSystemBrowserBundleId];
    [_isNotDefaultBrowserStackView setHidden:NO];
    [_isDefaultBrowserStackView setHidden:YES];
  }
}

- (IBAction)setAsTheSystemDefaultBrowserButtonClicked:(NSButton *)sender {
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)NSBundle.mainBundle.bundleIdentifier);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)NSBundle.mainBundle.bundleIdentifier);
}

- (IBAction)restoreSystemBrowserButonClicked:(NSButton *)sender {
  NSString *systemBrowserBundleId = Browser.systemBrowserBundleId;
  
  if (!systemBrowserBundleId) {
    systemBrowserBundleId = @"com.apple.safari";
  }
  
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)systemBrowserBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)systemBrowserBundleId);
}

@end
