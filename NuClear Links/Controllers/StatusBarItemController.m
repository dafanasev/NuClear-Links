//
//  StatusBarItemController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 10/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "StatusBarItemController.h"


@interface StatusBarItemController ()

@property NSStatusItem *statusItem;
@property NSWindowController *windowController;
@property NSWindow *window;

@end


@implementation StatusBarItemController

- (void)awakeFromNib {
  [super awakeFromNib];
  
  _statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image  = [NSImage imageNamed:@"statusBarItemImage"];
  _statusItem.button.target = self;
  _statusItem.button.action = @selector(statusItemClicked:);
  
  _windowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"mainWindow"];
}

- (void)statusItemClicked:(NSStatusBarButton *)sender {
  [_windowController showWindow:NULL];
}

@end
