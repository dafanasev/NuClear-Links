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
#import "NSUserDefaults+Links.h"
#import "Browser.h"


@interface StatusBarItemController ()

@property NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *enableRulesMenuItem;
@property (weak) IBOutlet NSMenuItem *disableRulesMenuItem;
@property NSWindowController *windowController;

@end


@implementation StatusBarItemController

- (void)awakeFromNib {
  [super awakeFromNib];
  _menu.autoenablesItems = NO;
  
  [NSNotificationCenter.defaultCenter addObserverForName:kRulesSetupNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self showHideRulesMenuItems];
    [self enableDisableRulesMenuItems];
  }];
  
  [NSNotificationCenter.defaultCenter addObserverForName:kRulesCountDidChangeNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self enableDisableRulesMenuItems];
  }];
  
  _statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image  = [NSImage imageNamed:@"statusBarItemImage"];
  
  _statusItem.menu = _menu;
}

#pragma mark - Actions

- (IBAction)enableDisableMenuItemClicked:(NSMenuItem *)sender {
  NSUserDefaults.standardUserDefaults.areRulesEnabled = !NSUserDefaults.standardUserDefaults.areRulesEnabled;
  [self showHideRulesMenuItems];
}

- (void)showHideRulesMenuItems {
  BOOL rulesCanBeExecuted = NSUserDefaults.standardUserDefaults.areRulesEnabled; //&& Browser.isLinksDefaultBrowser;
  [_enableRulesMenuItem setHidden:rulesCanBeExecuted];
  [_disableRulesMenuItem setHidden:!rulesCanBeExecuted];
}

- (void)enableDisableRulesMenuItems {
  BOOL areThereRules = Rule.all.count > 0;
  [_enableRulesMenuItem setEnabled:areThereRules];
  [_disableRulesMenuItem setEnabled:areThereRules];
}

//- (IBAction)moreNuClearToolsMenuItemClicked:(NSMenuItem *)sender {
//  NSURL *url = [NSURL URLWithString:@"https://nuclear.tools?utm_source=links&utm_medium=menu&utm_campaign=links"];
//  [NSWorkspace.sharedWorkspace openURL:url];
//}

- (IBAction)preferencesMenuItemClicked:(NSMenuItem *)sender {
  [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  _windowController = [[NSStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateControllerWithIdentifier:kMainWindow];
  [_windowController showWindow:NULL];
}

- (IBAction)quitMenuItemClicked:(NSMenuItem *)sender {
  [NSApplication.sharedApplication terminate:self];
}

@end
