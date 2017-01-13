//
//  TweetObject.m
//  Warble
//
//  Created by Roshan Krishnan on 4/21/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import "TweetObject.h"

@interface TweetObject()

@property (strong, nonatomic) NSArray *majorScaleSamples;
@property (strong, nonatomic) NSArray *minorScaleSamples;

-(NSMutableDictionary *)createSentimentDictionary;
-(int)calculateSentiment;

@end

@implementation TweetObject

-(id)initWithText:(NSString *)text andTimeOffset:(double)offset {
    self = [super init];
    if(self){
        self.majorScaleSamples = @[@"root",
                                   @"second",
                                   @"maj3",
                                   @"fourth",
                                   @"fifth",
                                   @"maj6",
                                   @"maj7",
                                   @"octave"
                                   ];
        self.minorScaleSamples = @[@"root",
                                   @"second",
                                   @"min3",
                                   @"fourth",
                                   @"fifth",
                                   @"min6",
                                   @"min7",
                                   @"octave"
                                   ];
        self.text = text;
        self.timeOffset = offset;
        self.sentiment = [self calculateSentiment];
        self.samplePath = [self assignNoteValue];
    }
    return self;
}

-(NSMutableDictionary *)createSentimentDictionary {
    NSError *err;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AFINN-111" ofType:@"txt"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if(err)
        NSLog(@"error getting file contents: %@", err);
    NSMutableCharacterSet *workingSet = [NSMutableCharacterSet whitespaceCharacterSet];
    [workingSet addCharactersInString:@"\n"];
    NSArray *words = [[NSArray alloc] initWithArray:[contents componentsSeparatedByCharactersInSet:workingSet]];
    NSUInteger wordsLength = [words count];
    NSMutableDictionary *sentiments = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < wordsLength - 1; i += 2){
        [sentiments setObject:words[i+1] forKey:words[i]];
    }
    return sentiments;
}

-(int)calculateSentiment {
    int result = 0;
    NSDictionary *sentiments = [self createSentimentDictionary];
    NSMutableCharacterSet *workingSet = [NSMutableCharacterSet whitespaceCharacterSet];
    [workingSet addCharactersInString:@"\n"];
    NSArray *words = [self.text componentsSeparatedByCharactersInSet:workingSet];
    
    for(NSString *s in words){
        NSString *wordScore = sentiments[s];
        if(wordScore)
            result += [wordScore intValue];
    }
    
    return result;
}

-(NSString *)assignNoteValue {
    if(self.sentiment > 0){
        return self.majorScaleSamples[arc4random()%8];
    }else if(self.sentiment < 0){
        return self.minorScaleSamples[arc4random()%8];
    }
    return self.majorScaleSamples[0];
}

@end
