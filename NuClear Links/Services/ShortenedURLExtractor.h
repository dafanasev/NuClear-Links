//
//  ShortenedURLExtractor.h
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 11/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShortenedURLExtractor : NSObject <NSURLSessionTaskDelegate>

+ (instancetype)sharedExtractor;

- (BOOL)isShortenedURL:(NSURL *)url;
- (void)extractURL:(NSURL *)url andExecuteBlock:(void (^)(NSURL *resultUrl))block;
- (void)saveCache;

@end
