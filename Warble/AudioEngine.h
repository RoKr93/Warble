//
//  AudioEngine.h
//  Warble
//
//  Created by Roshan Krishnan on 4/22/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import "TweetObject.h"

@interface AudioEngine : NSObject

@property (strong, nonatomic) AVAudioEngine* engine;
@property (strong, nonatomic) AVAudioMixerNode *mixer;
@property (strong, nonatomic) NSDictionary *tweets;
@property (strong, nonatomic) NSTimer *playbackTimer;
@property float tickCounter;

-(id)initWithTweetDictionary:(NSDictionary *)tweetDictionary;
-(void)playAudio;

@end
