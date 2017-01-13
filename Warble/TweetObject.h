//
//  TweetObject.h
//  Warble
//
//  Created by Roshan Krishnan on 4/21/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetObject : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *samplePath;
@property int sentiment;
@property double timeOffset;

-(id)initWithText:(NSString *)text andTimeOffset:(double)offset;

@end
