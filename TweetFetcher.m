//
//  TweetFetcher.m
//  Warble
//
//  Created by Roshan Krishnan on 4/19/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import "TweetFetcher.h"

@interface TweetFetcher()

-(double)getMillisFromDate:(NSString *)date;
-(NSDictionary *)createTweetDictionaryFromJSON:(NSDictionary *)json;
-(double)normalizeTweetTime:(double)time toMin:(double)min andMax:(double)max;
-(float)getTweetTimeBinFromTime:(double)time;

@end

@implementation TweetFetcher

+(TweetFetcher *)newTweetFetcher {
    TweetFetcher *tf = [[TweetFetcher alloc] init];
    return tf;
}

- (id) init {
    self = [super init];
    if(self){
        self.twitterClient = [[TWTRAPIClient alloc] init];
    }
    return self;
}

-(void)fetchTweetsFromUser:(NSString *)screenName {
    // format our GET request to the Twitter API
    NSString *reqString = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *params = @{@"screen_name" : screenName, @"count" : @"200"};
    NSError *clientError;
    NSURLRequest *request = [self.twitterClient URLRequestWithMethod:@"GET" URL:reqString parameters:params error:&clientError];

    if(clientError){
        NSLog(@"Client error: %@", clientError);
    }
    
    NSLog(@"URL Request: %@", request);
    
    // fire away
    [self.twitterClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            // handle the response data e.g.
            NSLog(@"Got response!");
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSDictionary *tweetDictionary = [self createTweetDictionaryFromJSON:json];
            /*for(float i = 0; i <= 120; i += 0.1){
                NSMutableArray *arr = tweetDictionary[[NSString stringWithFormat:@"%.2f", i]];
                NSUInteger len = [arr count];
                NSLog(@"ITEM %.2f:", i);
                for(int i = 0; i < len; i++){
                    TweetObject *t = arr[i];
                    NSLog(@"sentiment: %d", t.sentiment);
                }
                NSLog(@" ");
            }*/
            if([(NSObject *)self.delegate respondsToSelector:@selector(tweetFetcherSuccessWithDictionary:)]){
                [self.delegate tweetFetcherSuccessWithDictionary:tweetDictionary];
            }
        }
        else {
            NSLog(@"Error: %@", connectionError);
            if([(NSObject *)self.delegate respondsToSelector:@selector(tweetFetcherFailure)]){
                [self.delegate tweetFetcherFailure];
            }
        }
    }];
}

-(NSMutableDictionary *)createTweetDictionaryFromJSON:(NSDictionary *)json {
    // create an empty NSDictionary that contains empty mutable arrays for each key
    // each key is a second value from 0 to 120
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for(float i = 0; i <= 60; i += 0.1){
        [result setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%.2f", i]];
    }
    
    // find the earliest and latest dates occurring in the JSON object full of tweets
    double latestDate = 0.0;
    double earliestDate = DBL_MAX;
    for(id tweet in json){
        double currDate = [self getMillisFromDate:[tweet objectForKey:@"created_at"]];
        if(currDate < earliestDate)
            earliestDate = currDate;
        if(currDate > latestDate)
            latestDate = currDate;
    }
    
    // add our tweets to the appropriate NSDictionary "bins"
    for(id tweet in json){
        double currDate = [self getMillisFromDate:[tweet objectForKey:@"created_at"]];
        NSString *text = [tweet objectForKey:@"text"];
        double normalizedDate = [self normalizeTweetTime:currDate toMin:earliestDate andMax:latestDate];
        float timeBin = [self getTweetTimeBinFromTime:normalizedDate];
        double offset = normalizedDate - timeBin;
        NSString *timeBinString = [NSString stringWithFormat:@"%.2f", timeBin];
        TweetObject *tweetObj = [[TweetObject alloc] initWithText:text andTimeOffset:offset];
        [result[timeBinString] addObject:tweetObj];
    }
    
    return result;
}

-(float)getTweetTimeBinFromTime:(double)time {
    for(float i = 0; i <= 60; i += 0.1){
        if(time >= i && time < i + 0.1)
            return i;
    }
    return 0;
}

-(double)normalizeTweetTime:(double)time toMin:(double)min andMax:(double)max {
    return (time - min)*(60.0/(max - min));
}

-(double)getMillisFromDate:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
    NSDate *dateObject = [formatter dateFromString:date];
    NSTimeInterval seconds = [dateObject timeIntervalSinceReferenceDate];
    return seconds*1000.0;
}

@end
