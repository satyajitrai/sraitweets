//
//  TweetCell.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "TweetCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>

@interface TweetCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetContainer;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)onRetweet:(UIButton *)sender;
- (IBAction)onFavorite:(UIButton *)sender;
- (IBAction)onProfileImageClick:(UIButton *)sender;
@end


@implementation TweetCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.nameLabel.text = tweet.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    self.msgLable.text = tweet.text;
    self.timeLabel.text = tweet.tweetedAt.shortTimeAgoSinceNow;
    [self.profileImageButton.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.profileImageURL]] placeholderImage:[UIImage imageNamed:@"default_profile"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.profileImageButton setBackgroundImage:image forState:UIControlStateNormal];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
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
    
    [self layoutIfNeeded]; // see http://stackoverflow.com/questions/19395766/where-to-update-auto-layout-constant
    
    [self updateRetweets];
    [self updateFavourites];
}

- (void) updateRetweets {
    if (self.tweet.retweetCount.intValue > 0) {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        self.retweetCountLabel.text = self.tweet.retweetCount.stringValue;
    }
    else {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        self.retweetCountLabel.text = @"";
    }
}

- (void) updateFavourites {
    if (self.tweet.favoriteCount.intValue > 0) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        self.favoriteCountLabel.text = self.tweet.favoriteCount.stringValue;
    }
    else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        self.favoriteCountLabel.text =  @"";
    }
}

- (IBAction)onRetweet:(UIButton *)sender {
    self.tweet.retweetCount = @(self.tweet.retweetCount.intValue + 1);
    sender.enabled = NO;
    [self updateRetweets];
}

- (IBAction)onFavorite:(UIButton *)sender {
    self.tweet.favoriteCount = @(self.tweet.favoriteCount.intValue + 1);
    sender.enabled = NO;
    [self updateFavourites];
}

- (IBAction)onProfileImageClick:(UIButton *)sender {
    if (self.profileImageClickHandler) {
        self.profileImageClickHandler(self.tweet);
    }
}
@end
