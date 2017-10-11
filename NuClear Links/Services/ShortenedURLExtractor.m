//
//  ShortenedURLExtractor.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 11/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "ShortenedURLExtractor.h"
#import "NSUserDefaults+Links.h"


@interface ShortenedURLExtractor ()

@property NSArray<NSString *> *shorteners;
@property NSURLSession *urlSession;
@property NSMutableDictionary<NSURL *, void (^)(NSURL *)> *blocksDictionary;
@property NSMutableDictionary<NSString *, NSString *> *cache;

@end


@implementation ShortenedURLExtractor

+ (instancetype)sharedExtractor {
  static ShortenedURLExtractor *_sharedExtractor = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedExtractor = [[ShortenedURLExtractor alloc] init];
  });
  return _sharedExtractor;
}

- (instancetype)init {
  if (self = [super init]) {
    self.urlSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
    self.blocksDictionary = [NSMutableDictionary dictionary];
    self.cache = [NSUserDefaults.standardUserDefaults.shortenedURLsCache mutableCopy];
    self.shorteners = @[@"bit.do", @"t.co", @"lnkd.in", @"db.tt", @"qr.ae", @"adf.ly", @"goo.gl", @"bitly.com", @"cur.lv", @"tinyurl.com",
                        @"ow.ly", @"bit.ly", @"ity.im", @"q.gs", @"is.gd", @"po.st", @"bc.vc", @"twitthis.com", @"u.to", @"j.mp", @"buzurl.com",
                        @"cutt.us", @"u.bb", @"yourls.org", @"x.co", @"prettylinkpro.com", @"scrnch.me", @"filoops.info", @"vzturl.com",
                        @"qr.net", @"1url.com", @"tweez.me", @"v.gd", @"tr.im", @"link.zip", @"tinyarrows.com", @"adcraft.co", @"adcrun.ch",
                        @"adflav.com", @"aka.gr", @"bee4.biz", @"cektkp.com", @"dft.ba", @"fun.ly", @"fzy.co", @"gog.li", @"golinks.co",
                        @"hit.my", @"id.tl", @"linkto.im", @"lnk.co", @"nov.io", @"p6l.org", @"picz.us", @"shortquik.com", @"su.pr", @"sk.gy",
                        @"tota2.com", @"xlinkz.info", @"xtu.me", @"yu2.it", @"zpag.es"];
  }
  return self;
}

- (void)saveCache {
  NSUserDefaults.standardUserDefaults.shortenedURLsCache = _cache;
}

- (BOOL)isShortenedURL:(NSURL *)url {
  return [_shorteners containsObject:url.host.lowercaseString];
}

- (void)extractURL:(NSURL *)url andExecuteBlock:(void (^)(NSURL *resultUrl))block {
  NSURL *cachedResultUrl = [NSURL URLWithString:[_cache objectForKey:url.absoluteString]];
  
  if (cachedResultUrl) {
    block(cachedResultUrl);
  }
  else {
    [_blocksDictionary setObject:block forKey:url];
    NSURLSessionDataTask *task = [_urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      [self handleResultURL:response.URL forSourceUrl:response.URL];
    }];
    [task resume];
  }
}

- (void)handleResultURL:(NSURL *)resultUrl forSourceUrl:(NSURL *)sourceUrl {
    // save actual url in cache
  [_cache setObject:resultUrl.absoluteString forKey:sourceUrl.absoluteString];
    // and call proxying block which came from app app delegate
  void (^block)(NSURL *) = [_blocksDictionary objectForKey:sourceUrl];
  [_blocksDictionary removeObjectForKey:sourceUrl];
  block(resultUrl);
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {

  if ([self isShortenedURL:request.URL]) {
    completionHandler(request);
  }
  else {
    completionHandler(nil);
    [self handleResultURL:request.URL forSourceUrl:task.originalRequest.URL];
  }
}

@end
