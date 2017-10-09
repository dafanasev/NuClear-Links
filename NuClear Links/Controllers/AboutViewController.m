//
//  AboutViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "AboutViewController.h"
#import "NSBundle+Links.h"


@interface AboutViewController ()

@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *copyrightLabel;

@end


@implementation AboutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _versionLabel.stringValue   = NSBundle.mainBundle.versionWithBuild;
  _copyrightLabel.stringValue = NSBundle.mainBundle.copyright;
}

@end
