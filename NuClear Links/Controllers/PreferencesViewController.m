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

@property (weak) IBOutlet NSPopUpButton *defaultBrowserPopUpButton;

@property NSUserDefaults *defaults;

@end


@implementation PreferencesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _defaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
  
  NSString *defaultBrowserBundleId = [_defaults objectForKey:kDefaultBrowserBundleId];
  __block NSMenuItem *menuItemToSelect;
  [browsersList() enumerateObjectsUsingBlock:^(NSString * _Nonnull bundleId, NSUInteger idx, BOOL * _Nonnull stop) {
    NSMenuItem *mi = [[NSMenuItem alloc] init];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleId]];
    mi.title = [bundle.infoDictionary objectForKey:(NSString *)kCFBundleNameKey];
    mi.representedObject = bundleId;
    [_defaultBrowserPopUpButton.menu addItem:mi];
    
    if ([(NSString *)mi.representedObject isEqualToString:defaultBrowserBundleId]) {
      menuItemToSelect = mi;
    }
  }];
  
  [_defaultBrowserPopUpButton selectItem:menuItemToSelect];
}

- (IBAction)setAsTheSystemDefaultBrowserButtonClicked:(NSButton *)sender {
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)kDaemonBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)kDaemonBundleId);
}

- (IBAction)setSafariAsTheSystemDefaultBrowserClicked:(id)sender {
  LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)kSafariBundleId);
  LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)kSafariBundleId);
}

- (IBAction)browserListPopUpButtonClicked:(NSPopUpButton *)sender {
  [_defaults setObject:sender.selectedItem.representedObject forKey:kDefaultBrowserBundleId];
}

@end
