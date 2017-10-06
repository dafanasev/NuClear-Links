//
//  BrowserPopUpButton.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "BrowserPopUpButton.h"
#import <shared/shared.h>

@implementation BrowserPopUpButton

- (instancetype)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    [self setupMenu];
  }
  return self;
}

- (void)setupMenu {
  [Browser.browsersDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull bundleIdentifier, Browser * _Nonnull browser, BOOL * _Nonnull stop) {
    NSMenuItem *mi = [[NSMenuItem alloc] init];
    mi.title = browser.title;
    mi.image = browser.image;
    mi.tag   = bundleIdentifier.hash;
    mi.representedObject = bundleIdentifier;
    [self.menu addItem:mi];
  }];
}

@end
