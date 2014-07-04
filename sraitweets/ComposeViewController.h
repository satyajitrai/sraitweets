//
//  ComposeViewController.h
//  sraitweets
//
//  Created by Satyajit Rai on 7/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

typedef void (^onNewTweet)(Tweet * text);

@interface ComposeViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) onNewTweet newTweetHandler;

@end
