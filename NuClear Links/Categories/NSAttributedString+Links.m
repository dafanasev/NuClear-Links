//
//  NSAttributedString+Links.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSAttributedString+Links.h"

@implementation NSAttributedString (Links)

+ (NSAttributedString *)linkWithLabel:(NSString *)label font:(NSFont *)font url:(NSURL *)url {
  NSURL *linkUrl = url ? url : [NSURL URLWithString:label];
  if (!linkUrl) {
    return NULL;
  }
  
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label];
  
  [attrString addAttributes:@{NSLinkAttributeName: linkUrl.absoluteString, NSFontAttributeName: font ? font : [NSFont systemFontOfSize: [NSFont systemFontSize]]}
                      range:NSMakeRange(0, attrString.length)];
  
  return attrString;
}

@end
