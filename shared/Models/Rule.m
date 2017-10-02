//
//  Rule.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "Rule.h"
#import "NSUserDefaults+Links.h"

@interface Rule ()

@end


@implementation Rule

#pragma mark - Init

-(instancetype)init {
  if (self = [super init]) {
    self.title = @"New rule";
  }
  return self;
}

-(instancetype)initWithTitle:(NSString *)title browserBundleIdentifier:(NSString *)browserBundleIdentifier {
  if (self = [super init]) {
    self.title = title;
    self.browserBundleIdentifier = browserBundleIdentifier;
  }
  return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.title = [decoder decodeObjectForKey:@"title"];
    self.browserBundleIdentifier = [decoder decodeObjectForKey:@"browserBundleIdentifier"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_title forKey:@"title"];
  [encoder encodeObject:_browserBundleIdentifier forKey:@"browserBundleIdentifier"];
}

#pragma mark - Rules

+(NSArray<Rule *> *)all {
  return [NSUserDefaults appGroupUserDefaults].rules;
}

+(void)setAll:(NSArray<Rule *> *)all {
  [NSUserDefaults appGroupUserDefaults].rules = all;
}

@end
