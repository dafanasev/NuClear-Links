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
    self.isActive = YES;
    [self setupPredicate];
  }
  return self;
}

-(instancetype)initWithTitle:(NSString *)title browser:(Browser *)browser isActive:(BOOL)isActive {
  if (self = [super init]) {
    self.title = title;
    self.browser = browser;
    self.isActive = isActive;
    [self setupPredicate];
  }
  return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.title = [decoder decodeObjectForKey:@"title"];
    self.browser = [decoder decodeObjectForKey:@"browser"];
    self.isActive = [decoder decodeBoolForKey:@"isActive"];
    [self setupPredicate];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_title forKey:@"title"];
  [encoder encodeObject:_browser forKey:@"browser"];
  [encoder encodeBool:_isActive forKey:@"isActive"];
}

-(void)setupPredicate {
  // TODO: empty subpredicates
  NSArray<NSPredicate *> *subpredicates = @[[NSPredicate predicateWithFormat:@"url.host = ''"]];
  self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
}

#pragma mark - Rules

+(NSArray<Rule *> *)all {
  return [NSUserDefaults appGroupUserDefaults].rules;
}

+(void)setAll:(NSArray<Rule *> *)all {
  [NSUserDefaults appGroupUserDefaults].rules = all;
}

@end
