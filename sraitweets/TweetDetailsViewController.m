//
//  TweetDetailsViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/2/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeight;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)onReply:(UIButton *)sender;
- (IBAction)onRetweet:(UIButton *)sender;
- (IBAction)onFavorite:(UIButton *)sender;
@end

@implementation TweetDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tweets";
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    Tweet * tweet = self.tweet;
    self.nameLabel.text = tweet.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    self.msgLabel.text = tweet.text;
    self.retweetCountLabel.text = [tweet.retweetCount stringValue];
    self.favoriteCountLabel.text = [tweet.favoriteCount stringValue];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterShortStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [ fmt stringFromDate: tweet.tweetedAt];
    [self.userImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.profileImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.navigationItem.prompt = @"Failed ot load profile image";
        NSLog(@"Failed to get profile view");
    }];

    if (tweet.isRetweeted == YES) {
        self.retweetImage.hidden = false;
        self.retweetContainer.hidden = false;
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedBy];
        self.retweetContainerHeight.constant = 21; // as in the xib file
    }
    else {
        self.retweetImage.hidden = true;
        self.retweetContainer.hidden = true;
        self.retweetContainerHeight.constant = 8;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onReply:(UIButton *)sender {
    NSLog(@"Replied to the tweet");
}

- (IBAction)onFavorite:(UIButton *)sender {
    [sender setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    self.tweet.favoriteCount = @([self.tweet.favoriteCount intValue] + 1);
    self.favoriteCountLabel.text = [self.tweet.favoriteCount stringValue];
    sender.enabled = NO;
}

- (IBAction)onRetweet:(UIButton *)sender {
    [sender setBackgroundImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    self.tweet.retweetCount = @([self.tweet.retweetCount intValue] + 1);
    self.retweetCountLabel.text = [self.tweet.retweetCount stringValue];
    sender.enabled = NO;
}
@end
