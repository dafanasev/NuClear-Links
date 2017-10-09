//
//  HyperlinkLabel.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "HyperlinkLabel.h"
#import "NSAttributedString+Links.h"


@implementation HyperlinkLabel

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  if ([super initWithCoder:coder]) {
    [self setup];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  
  [coder encodeObject:_url forKey:@"url"];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self setup];
}

- (void)setup {
  NSURL *realUrl = [NSURL URLWithString:_url != nil ? _url : self.stringValue];
  if (!realUrl) {
    return;
  }
  
  self.allowsEditingTextAttributes = YES;
  [self setSelectable:YES];
  
  self.attributedStringValue = [NSAttributedString linkWithLabel:self.stringValue font:self.font url:realUrl];
}

- (void)resetCursorRects {
  [self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end

