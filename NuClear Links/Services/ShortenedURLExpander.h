//
//  ShortenedURLExtractor.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 11/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShortenedURLExpander : NSObject <NSURLSessionTaskDelegate>

@property void (^block)(NSURL *);

+ (instancetype)sharedExpander;

- (BOOL)isShortenedURL:(NSURL *)url;
- (void)expandURLAndExecuteBlock:(NSURL *)url;
- (void)saveCache;

@end
