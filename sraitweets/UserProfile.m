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
    }
    return self;
}

@end
