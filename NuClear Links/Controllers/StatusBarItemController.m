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
#import "NSAlert+Links.h"


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
  
  [NSNotificationCenter.defaultCenter addObserverForName:kLinksSetupNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self setupRulesMenuItems];
  }];
  
  [NSNotificationCenter.defaultCenter addObserverForName:kRulesCountDidChangeNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self setupRulesMenuItems];
  }];
  
  [NSNotificationCenter.defaultCenter addObserverForName:kSystemBrowserChangedNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    [self setupRulesMenuItems];
  }];
  
  _statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image  = [NSImage imageNamed:@"statusBarItemImage"];
  
  _statusItem.menu = _menu;
}

#pragma mark - Actions

- (IBAction)enableDisableMenuItemClicked:(NSMenuItem *)sender {
  if (Browser.isLinksActive) {
    NSUserDefaults.standardUserDefaults.areRulesEnabled = !NSUserDefaults.standardUserDefaults.areRulesEnabled;
    [self setupRulesMenuItems];
  }
  else {
    [NSAlert alertWithMessage:@"Rules can not be enabled because NuClear Links is not active. You can activate it by going to Preferences > General."];
  }
}

- (void)setupRulesMenuItems {
  // if there are no rules than menu items should not be clickable
  BOOL areThereRules = Rule.all.count > 0;
  [_enableRulesMenuItem setEnabled:areThereRules];
  [_disableRulesMenuItem setEnabled:areThereRules];
  
  BOOL rulesCanBeExecuted = NSUserDefaults.standardUserDefaults.areRulesEnabled && Browser.isLinksActive;
  [_enableRulesMenuItem setHidden:rulesCanBeExecuted];
  [_disableRulesMenuItem setHidden:!rulesCanBeExecuted];
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
