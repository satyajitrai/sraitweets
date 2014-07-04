//
//  Tweet.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSDate *tweetedAt;
@property (strong, nonatomic) NSString *retweetedBy;
@property (assign, nonatomic, getter=isRetweeted) BOOL retweeted;
@property (strong, nonatomic) NSNumber *retweetCount;
@property (strong, nonatomic) NSNumber *favoriteCount;

+ (NSArray *) tweetsFromResponse:(NSArray*)rawArray;
+ (Tweet *) tweetFromTweet:(NSDictionary*)singleTweet;
@end