//
//  TweetFetcher.h
//  Warble
//
//  Created by Roshan Krishnan on 4/19/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "TweetObject.h"

@protocol TweetFetcherDelegate <NSObject>
@required

-(void)tweetFetcherSuccessWithDictionary:(NSDictionary *)tweets;
-(void)tweetFetcherFailure;

@end

@interface TweetFetcher : NSObject

@property (strong, nonatomic) TWTRAPIClient *twitterClient;
@property (weak, nonatomic) id <TweetFetcherDelegate> delegate;

+(TweetFetcher *)newTweetFetcher;
-(void)fetchTweetsFromUser:(NSString *)screenName;

@end
