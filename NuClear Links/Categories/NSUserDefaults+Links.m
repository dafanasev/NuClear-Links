//
//  NSUserDefaults+AppGroup.m
//  shared
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSUserDefaults+Links.h"
#import "Constants.h"

@implementation NSUserDefaults (Links)

- (void)register {
  [self registerDefaults:@{kAreRulesEnabled: [NSNumber numberWithBool:YES]}];
}

- (BOOL)areRulesEnabled {
  return [self boolForKey:kAreRulesEnabled];
}

- (void)setAreRulesEnabled:(BOOL)areRulesEnabled {
  [self setBool:areRulesEnabled forKey:kAreRulesEnabled];
}

- (NSString *)systemBrowserBundleId {
  return [self objectForKey:kSystemBrowserBundleId];
}

- (void)setSystemBrowserBundleId:(NSString *)systemBrowserBundleId {
  [self setObject:systemBrowserBundleId forKey:kSystemBrowserBundleId];
}

- (NSArray<Rule *> *)rules {
  NSData *data = [self objectForKey:@"rules"];
  if (data == nil) {
    return @[];
  }
  return (NSArray<Rule *> *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setRules:(NSArray<Rule *> *)newRules {
  [self setObject:[NSKeyedArchiver archivedDataWithRootObject:newRules] forKey:@"rules"];
}


@end
