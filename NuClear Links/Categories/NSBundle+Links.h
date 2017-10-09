//
//  NSBundle+Links.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 09/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Links)

@property (readonly) NSString *displayName;
@property (readonly) NSString *version;
@property (readonly) NSString *buildNumber;
@property (readonly) NSString *versionWithBuild;
@property (readonly) NSString *copyright;


@end
