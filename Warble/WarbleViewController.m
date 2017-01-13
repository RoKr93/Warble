//
//  WarbleViewController.m
//  Warble
//
//  Created by Roshan Krishnan on 4/19/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import "WarbleViewController.h"

@interface WarbleViewController ()

@end

@implementation WarbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetFetcher = [TweetFetcher newTweetFetcher];
    self.playButton.hidden = YES;
    self.tweetFetcher.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getTweetsButtonPressed:(id)sender {
    if(self.playButton.hidden == NO)
        self.playButton.hidden = YES;
    NSLog(@"Calling tweetFetcher with screen name: %@", self.screenNameTextField.text);
    [self.tweetFetcher fetchTweetsFromUser:self.screenNameTextField.text];
}

- (IBAction)playButtonPressed:(id)sender {
    AudioEngine *engine = [[AudioEngine alloc] initWithTweetDictionary:self.tweets];
    [engine playAudio];
}

#pragma mark - TwetFetcher Delegate Methods

-(void)tweetFetcherSuccessWithDictionary:(NSDictionary *)tweets {
    self.tweets = tweets;
    if(self.playButton.hidden == YES)
        self.playButton.hidden = NO;
}
-(void)tweetFetcherFailure {
    NSLog(@"TweetFetcher failed!");
    if(self.playButton.hidden == NO)
        self.playButton.hidden = YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
