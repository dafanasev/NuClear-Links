//
//  PreferencesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 29/09/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import "PreferencesViewController.h"
#import "Browser.h"
#import "NSUserDefaults+Links.h"
#import "Constants.h"


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
  BOOL beforeState = _isDefaultBrowserStackView.isHidden;
  
  if (Browser.isLinksActive) {
    [_isNotDefaultBrowserStackView setHidden:YES];
    [_isDefaultBrowserStackView setHidden:NO];
  }
  else {
    NSUserDefaults.standardUserDefaults.defaultBrowserBundleId = Browser.systemBrowserBundleId;
    [_isNotDefaultBrowserStackView setHidden:NO];
    [_isDefaultBrowserStackView setHidden:YES];
  }
  
  // if system browser is changed
  if (_isDefaultBrowserStackView.isHidden != beforeState) {
    [NSNotificationCenter.defaultCenter postNotificationName:kSystemBrowserChangedNotification object:NULL userInfo:NULL];
    
    // if it is changed to Links
    SMLoginItemSetEnabled((__bridge CFStringRef)kLauncherBundleId, Browser.isLinksActive);
  }
}

- (IBAction)setAsTheSystemDefaultBrowserButtonClicked:(NSButton *)sender {
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)NSBundle.mainBundle.bundleIdentifier);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)NSBundle.mainBundle.bundleIdentifier);
}

- (IBAction)restoreSystemBrowserButonClicked:(NSButton *)sender {
  NSString *defaultBrowserBundleId = Browser.defaultBrowserBundleId;
  
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)defaultBrowserBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)defaultBrowserBundleId);
}

@end
