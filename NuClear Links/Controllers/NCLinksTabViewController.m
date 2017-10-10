//
//  NCLinksTabViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NCLinksTabViewController.h"


@interface NCLinksTabViewController ()

@property NSMutableDictionary<NSString *, NSValue *> *tabViewSizes;

@end


@implementation NCLinksTabViewController

-(void)awakeFromNib {
  [super awakeFromNib];
  
  _tabViewSizes = [[NSMutableDictionary<NSString *, NSValue *> alloc] init];
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
  [super tabView:tabView willSelectTabViewItem:tabViewItem];
  
  // Cache the size of the tab view.
  if (tabViewItem && tabViewItem.view) {
    [_tabViewSizes setObject:[NSValue valueWithSize:tabViewItem.view.frame.size] forKey:tabViewItem.identifier];
  }
  
  if (tabViewItem && [tabViewItem.identifier isEqualToString:@"rules"]) {
    self.view.window.styleMask |= NSWindowStyleMaskResizable;
  }
  else {
    self.view.window.styleMask &= ~(NSWindowStyleMaskResizable);
  }
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
  [super tabView:tabView didSelectTabViewItem:tabViewItem];
  
  if (tabViewItem) {
    [self resizeWindowToFitTabViewItem:tabViewItem];
  }
}

- (void)resizeWindowToFitTabViewItem:(NSTabViewItem *)tabViewItem {
  NSValue *value = [_tabViewSizes objectForKey:tabViewItem.identifier];
  NSWindow *window = ((NSView *)[self valueForKey:@"view"]).window;
  if (value && window) {
    NSSize size = value.sizeValue;
    NSRect contentRect = NSMakeRect(0, 0, size.width, size.height);
    NSRect contentFrame = [window frameRectForContentRect:contentRect];
    CGFloat toolbarHeight = window.frame.size.height - contentFrame.size.height;
    NSPoint newOrigin = NSMakePoint(window.frame.origin.x, window.frame.origin.y + toolbarHeight);
    NSRect newFrame = NSMakeRect(newOrigin.x, newOrigin.y, contentFrame.size.width, contentFrame.size.height);
    [window setFrame:newFrame display:NO animate:YES];
  }
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  [super toolbarDefaultItemIdentifiers:toolbar];
  
  return @[@"rules", @"general", NSToolbarFlexibleSpaceItemIdentifier, @"about"];
}

@end
