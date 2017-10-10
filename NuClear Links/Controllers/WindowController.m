//
//  WindowController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "WindowController.h"


@interface WindowController ()

@end


@implementation WindowController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.window.delegate = self;
  
  [self.window setFrameAutosaveName:@"mainWindow"];
  
  [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyRegular];
}

- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyAccessory];
}

@end
