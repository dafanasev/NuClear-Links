//
//  NilToRedColorValueTransformer.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 14/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NilToRedColorValueTransformer.h"

@implementation NilToRedColorValueTransformer

+ (Class)transformedValueClass {
  return NSColor.class;
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)transformedValue:(id)value {
  return value ? NSColor.controlTextColor : NSColor.redColor;
}

@end
