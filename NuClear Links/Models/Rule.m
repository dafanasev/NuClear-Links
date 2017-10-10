//
//  Rule.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "Rule.h"
#import "NSUserDefaults+Links.h"
#import "Constants.h"


@interface Rule ()

@end


@implementation Rule

#pragma mark - Init

- (instancetype)init {
  if (self = [super init]) {
    self.title = @"New rule";
    self.browser = Browser.systemBrowser;
    self.isActive = YES;
    self.openInBackground = NO;
    self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[]];
  }
  return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.title            = [decoder decodeObjectForKey:@"title"];
    self.browser          = [decoder decodeObjectForKey:@"browser"];
    self.isActive         = [decoder decodeBoolForKey:@"isActive"];
    self.openInBackground = [decoder decodeBoolForKey:@"openInBackground"];
    self.predicate        = [decoder decodeObjectForKey:@"predicate"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_title forKey:@"title"];
  [encoder encodeObject:_browser forKey:@"browser"];
  [encoder encodeBool:_isActive forKey:@"isActive"];
  [encoder encodeBool:_openInBackground forKey:@"openInBackground"];
  [encoder encodeObject:_predicate forKey:@"predicate"];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Rules

+ (NSArray<Rule *> *)all {
  return [NSUserDefaults standardUserDefaults].rules;
}

+ (void)setAll:(NSArray<Rule *> *)all {
  [NSUserDefaults standardUserDefaults].rules = all;
}

@end
