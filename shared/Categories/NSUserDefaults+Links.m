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

+(NSUserDefaults *)appGroupUserDefaults {
  static NSUserDefaults *_appGroupUserDefaults = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _appGroupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
  });
  return _appGroupUserDefaults;
}

-(NSArray<Rule *> *)rules {
  NSData *data = [self objectForKey:@"rules"];
  if (data == nil) {
    return @[];
  }
  return (NSArray<Rule *> *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(void)setRules:(NSArray<Rule *> *)newRules {
  [self setObject:[NSKeyedArchiver archivedDataWithRootObject:newRules] forKey:@"rules"];
}


@end
