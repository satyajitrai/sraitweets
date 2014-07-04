//
//  Tweet.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

static NSString *RetweetedValue = @"1";

+ (NSArray *)tweetsFromResponse:(NSArray*)rawArray {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:rawArray.count];
    for (NSDictionary *rawTweet in rawArray) {
        Tweet *tweet = [Tweet tweetFromTweet: rawTweet];
        [array addObject:tweet];
    }
    return array;
}

+ (Tweet *)tweetFromTweet:(NSDictionary*)rawTweet {
    Tweet * tweet = [[Tweet alloc] init];
    int retweetStatus = [rawTweet[@"retweeted"] integerValue];
    if (retweetStatus == 1) {
        tweet.retweeted = YES;
        tweet.name = rawTweet[@"retweeted_status"][@"user"][@"name"];
        tweet.screenName = rawTweet[@"retweeted_status"][@"user"][@"screen_name"];
        tweet.profileImageURL = rawTweet[@"retweeted_status"][@"user"][@"profile_image_url"];
        tweet.retweetedBy = rawTweet[@"user"][@"screen_name"];
        tweet.text = rawTweet[@"retweeted_status"][@"text"];
    }
    else {
        tweet.retweeted = NO;
        tweet.name = rawTweet[@"user"][@"name"];
        tweet.screenName = rawTweet[@"user"][@"screen_name"];
        tweet.profileImageURL = rawTweet[@"user"][@"profile_image_url"];
        tweet.text = rawTweet[@"text"];
    }
    
    id retweets = rawTweet[@"retweet_count"];
    tweet.retweetCount = (retweets == nil) ? 0 : retweets;
    id favs = rawTweet[@"favorite_count"];
    tweet.favoriteCount = (favs == nil) ? 0 : favs;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    tweet.tweetedAt = [fmt dateFromString:rawTweet[@"created_at"]];
    return tweet;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Tweet - name: %@, screenName: %@, isRetweeted: %d text: %@", self.name, self.screenName, self.isRetweeted, self.text];
}
@end
