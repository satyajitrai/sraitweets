//
//  UserProfile.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/14/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (id)initWithResponse:(NSDictionary*)response {
    if (self =[super init]) {
        _name = response[@"name"];
        _screenName = response[@"screen_name"];
        _profileURL = [NSURL URLWithString:response[@"profile_image_url"]];
//        NSLog(@"%@", response[@"profile_background_image_url"]);
//        NSLog(@"%@", response[@"profile_background_color"]);
//        NSLog(@"%@", response[@"profile_use_background_image"]);
//        NSLog(@"Tweets: %@", response[@"statuses_count"]);
//        NSLog(@"Followers: %@", response[@"followers_count"]);
//        NSLog(@"Following: %@", response[@"friends_count"]);
        _following = response[@"friends_count"];
        _followers = response[@"followers_count"];
        _tweets = response[@"statuses_count"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"UserProfile[name = %@, screenName=%@, tweets: %@, following: %@, followers: %@]", _name, _screenName, _tweets, _following, _followers];
}

@end
