//
//  NSUserDefaults+AppGroup.m
//  shared
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSUserDefaults+Links.h"
#import "Constants.h"
#import "NSBundle+Links.h"

@implementation NSUserDefaults (Links)

- (void)register {
  [self registerDefaults:@{
    kAreRulesEnabled: [NSNumber numberWithBool:YES],
    kExpandShortenedURLs: [NSNumber numberWithBool:YES],
  }];
}

- (BOOL)areRulesEnabled {
  return [self boolForKey:kAreRulesEnabled];
}

- (void)setAreRulesEnabled:(BOOL)areRulesEnabled {
  [self setBool:areRulesEnabled forKey:kAreRulesEnabled];
}

- (NSString *)defaultBrowserBundleId {
  NSString *bundleId = [self objectForKey:kDefaultBrowserBundleId];
  if (!bundleId || ![NSBundle isBundleWithIdentifierExists:bundleId]) {
    bundleId = @"com.apple.safari";
  }
  return bundleId;
}

- (void)setDefaultBrowserBundleId:(NSString *)defaultBrowserBundleId {
  if (![self.defaultBrowserBundleId isEqualToString:defaultBrowserBundleId]) {
    [self setObject:defaultBrowserBundleId forKey:kDefaultBrowserBundleId];
  }
}

- (BOOL)expandShortenedURLs {
  return [self boolForKey:@"expandShortenedURLs"];
}

- (void)setExpandShortenedURLs:(BOOL)expandShortenedURLs {
  [self setBool:expandShortenedURLs forKey:@"expandShortenedURLs"];
}

- (BOOL)openInBackground {
  return [self boolForKey:@"openInBackground"];
}

- (void)setOpenInBackground:(BOOL)openInBackground {
  [self setBool:openInBackground forKey:@"openInBackground"];
}

- (NSArray<Rule *> *)rules {
  NSData *data = [self objectForKey:@"rules"];
  if (!data) {
    return @[];
  }
  return (NSArray<Rule *> *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setRules:(NSArray<Rule *> *)newRules {
  [self setObject:[NSKeyedArchiver archivedDataWithRootObject:newRules] forKey:@"rules"];
}

- (NSDictionary<NSString *, NSString *> *)expandedURLsCache {
  NSDictionary<NSString *, NSString *> *cache = [self dictionaryForKey:@"expandedURLsCache"];
  if (!cache) {
    return @{};
  }
  return cache;
}

- (void)setExpandedURLsCache:(NSDictionary<NSString *,NSString *> *)expandedURLsCache {
  [self setObject:expandedURLsCache forKey:@"expandedURLsCache"];
}


@end
