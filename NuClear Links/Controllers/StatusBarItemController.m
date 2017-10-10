//
//  StatusBarItemController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 10/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "StatusBarItemController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Rule.h"


@interface StatusBarItemController ()

@property NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *enableRulesMenuItem;
@property (weak) IBOutlet NSMenuItem *disableRulesMenuItem;

@end


@implementation StatusBarItemController

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [NSNotificationCenter.defaultCenter addObserverForName:kRulesStateNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self showHideEnableDisableMenuItems:((NSNumber *)[note.userInfo objectForKey:kAreRulesEnabled]).boolValue];
  }];
  
  _statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image  = [NSImage imageNamed:@"statusBarItemImage"];
  
  _statusItem.menu = _menu;
}

#pragma mark - Actions

- (IBAction)enableDisableMenuItemClicked:(NSMenuItem *)sender {
  AppDelegate *appDelegate = (AppDelegate *)[NSApplication.sharedApplication delegate];
  appDelegate.areRulesEnabled = !appDelegate.areRulesEnabled;
  [self showHideEnableDisableMenuItems:appDelegate.areRulesEnabled];
}

- (void)showHideEnableDisableMenuItems:(BOOL)areRulesEnabled {
  if (Rule.all.count == 0) {
    [_enableRulesMenuItem setHidden:YES];
    [_disableRulesMenuItem setHidden:YES];
    return;
  }
  [_enableRulesMenuItem setHidden:areRulesEnabled];
  [_disableRulesMenuItem setHidden:!areRulesEnabled];
}

//- (IBAction)moreNuClearToolsMenuItemClicked:(NSMenuItem *)sender {
//  NSURL *url = [NSURL URLWithString:@"https://nuclear.tools?utm_source=links&utm_medium=menu&utm_campaign=links"];
//  [NSWorkspace.sharedWorkspace openURL:url];
//}

- (IBAction)quitMenuItemClicked:(NSMenuItem *)sender {
  [NSApplication.sharedApplication terminate:self];
}


@end
