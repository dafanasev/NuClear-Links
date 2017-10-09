//
//  IsOneObjectValueTransformer.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 10/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "IsOneObjectValueTransformer.h"

@implementation IsOneObjectValueTransformer

+ (Class)transformedValueClass {
  return NSNumber.class;
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  return [NSNumber numberWithBool:((NSArray *)value).count == 1];
}

@end
