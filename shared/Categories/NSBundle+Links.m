//
//  NSBundle+Links.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "NSBundle+Links.h"

@implementation NSBundle (Links)

- (NSString *)displayName {
  NSString *name;
  
  if ((name = [self.localizedInfoDictionary objectForKey:(__bridge NSString *)kCFBundleNameKey])) {
    return name;
  }
  
  if ((name = [self.infoDictionary objectForKey:(__bridge NSString *)kCFBundleNameKey])) {
    return name;
  }
  
  return [self.infoDictionary objectForKey:(__bridge NSString *)kCFBundleExecutableKey];
}

- (NSString *)version {
  return (NSString *)[self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}


- (NSString *)buildNumber {
  return (NSString *)[self objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
}

- (NSString *)versionWithBuild {
  return [NSString stringWithFormat:@"Version %@ Build %@", self.version, self.buildNumber];
}

- (NSString *)copyright {
  return (NSString *)[self objectForInfoDictionaryKey:@"NSHumanReadableCopyright"];
}

@end
