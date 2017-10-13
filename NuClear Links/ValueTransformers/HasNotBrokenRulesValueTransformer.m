//
//  HasNotBrokenRulesValueTransformer.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 14/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "HasNotBrokenRulesValueTransformer.h"
#import "Rule.h"

@implementation HasNotBrokenRulesValueTransformer

+ (Class)transformedValueClass {
  return NSNumber.class;
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  NSArray<Rule *> *rules = (NSArray<Rule *> *)value;
  NSArray<Rule *> *brokenRules = [rules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"browser.title = nil"]];
  return [NSNumber numberWithBool:brokenRules.count == 0];
}

@end
