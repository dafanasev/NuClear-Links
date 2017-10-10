//
//  Browser.m
//  shared
//
//  Created by Dmitry Afanasyev on 06/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "Browser.h"
#import "Constants.h"


@interface Browser ()

@property (readonly) NSBundle *bundle;

@end


@implementation Browser

#pragma mark - Init

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier {
  if (self = [super init]) {
    self.bundleIdentifier = bundleIdentifier.lowercaseString;
  }
  return self;
}

+ (Browser *)browserWithBundleIdentifier:(NSString *)bundleIdentifier {
  return [[Browser alloc] initWithBundleIdentifier:bundleIdentifier];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.bundleIdentifier = [decoder decodeObjectForKey:@"bundleIdentifier"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_bundleIdentifier forKey:@"bundleIdentifier"];
}

#pragma mark - Computed properties

- (NSBundle *)bundle {
  return [NSBundle bundleWithPath:[[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:_bundleIdentifier]];
}

- (NSString *)title {
  return [self.bundle.infoDictionary objectForKey:(NSString *)kCFBundleNameKey];
}

- (NSImage *)image {
  return [[NSWorkspace sharedWorkspace] iconForFile:self.bundle.bundlePath];
}

+ (NSDictionary <NSString *, Browser *> *)browsersDictionary {
  NSMutableDictionary <NSString *, Browser *> *browsersDictionary = [NSMutableDictionary dictionary];

  [(__bridge NSArray *)LSCopyAllHandlersForURLScheme(CFSTR("http")) enumerateObjectsUsingBlock:^(id  _Nonnull bundleIdentifier, NSUInteger idx, BOOL * _Nonnull stop) {
    Browser *browser = [Browser browserWithBundleIdentifier:bundleIdentifier];
    NSString *lowercasedIdentifier = ((NSString *)bundleIdentifier).lowercaseString;
    if (![lowercasedIdentifier isEqualToString:NSBundle.mainBundle.bundleIdentifier.lowercaseString] && browser.bundle.bundlePath && [[NSWorkspace sharedWorkspace] iconForFile:browser.bundle.bundlePath]) {
      [browsersDictionary setObject:browser forKey:lowercasedIdentifier];
    }
  }];

  return browsersDictionary;
}

@end
