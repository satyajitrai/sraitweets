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
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetContainer;
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
    self.nameLabel.text = tweet.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    self.msgLable.text = tweet.text;
    self.timeLabel.text = tweet.tweetedAt.shortTimeAgoSinceNow;
    [self.userImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.profileImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.userImage.image = image;
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
}

@end
