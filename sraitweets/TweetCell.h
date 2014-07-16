//
//  TweetCell.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

typedef void (^ProfileImageClickHandler)(Tweet *tweet);

@interface TweetCell : UITableViewCell
@property (strong, nonatomic) Tweet * tweet;
@property (strong, nonatomic) ProfileImageClickHandler profileImageClickHandler;
@end
