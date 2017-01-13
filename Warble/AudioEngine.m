//
//  AudioEngine.m
//  Warble
//
//  Created by Roshan Krishnan on 4/22/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import "AudioEngine.h"

@interface AudioEngine()

-(void)scheduleBuffers;

@end

@implementation AudioEngine

-(id)initWithTweetDictionary:(NSDictionary *)tweetDictionary {
    self = [super init];
    if(self){
        self.tweets = tweetDictionary;
        self.tickCounter = 0.0;
        self.engine = [[AVAudioEngine alloc] init];
        self.mixer = [self.engine mainMixerNode];
        [self.engine connect:self.mixer to:self.engine.outputNode format:[self.mixer outputFormatForBus:0]];
    }
    return self;
}

-(void)scheduleBuffers {
    NSMutableArray *currSamples = self.tweets[[NSString stringWithFormat:@"%.2f", self.tickCounter]];
    NSUInteger len = [currSamples count];
    if(len > 0){
        for(TweetObject *t in currSamples){
            NSError *err;
            AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
            NSURL *path = [[NSBundle mainBundle] URLForResource:t.samplePath withExtension:@"aif"];
            AVAudioFile *f = [[AVAudioFile alloc] initForReading:path error:&err];
            if(err)
                NSLog(@"Error loading audio file %@", t.samplePath);
            double sampleRate = f.fileFormat.sampleRate;
            double sampleTime = sampleRate * t.timeOffset;
            [self.engine attachNode:playerNode];
            [self.engine connect:playerNode to:self.mixer format:f.processingFormat];
            [playerNode scheduleFile:f atTime:[AVAudioTime timeWithSampleTime:sampleTime atRate:sampleRate] completionHandler:nil];
            [playerNode play];
        }
    }
    
    self.tickCounter += 0.1;
    if(self.tickCounter > 60)
        [self.playbackTimer invalidate];
}

-(void)playAudio {
    NSError *err;
    [self.engine prepare];
    [self.engine startAndReturnError:&err];
    if(err){
        NSLog(@"ERROR PLAYING AUDIO: %@", err);
        return;
    }
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(scheduleBuffers)
                                                    userInfo:nil
                                                     repeats:YES];
}

@end
