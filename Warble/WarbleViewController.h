//
//  WarbleViewController.h
//  Warble
//
//  Created by Roshan Krishnan on 4/19/16.
//  Copyright © 2016 Roshan Krishnan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetFetcher.h"
#import "AudioEngine.h"

@interface WarbleViewController : UIViewController <TweetFetcherDelegate>

@property (strong, nonatomic) IBOutlet UITextField *screenNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *getTweetsButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) TweetFetcher *tweetFetcher;
@property (strong, nonatomic) NSDictionary *tweets;


- (IBAction)getTweetsButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;


@end
