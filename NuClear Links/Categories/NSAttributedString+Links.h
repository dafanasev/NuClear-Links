//
//  NSAttributedString+Links.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedString (Links)

+ (NSAttributedString *)linkWithLabel:(NSString *)label font:(NSFont *)font url:(NSURL *)url;

@end
