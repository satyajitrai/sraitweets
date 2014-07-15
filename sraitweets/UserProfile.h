//
//  UserProfile.h
//  sraitweets
//
//  Created by Satyajit Rai on 7/14/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
- (id)initWithResponse:(NSDictionary*)response;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *screenName;
@property (strong, nonatomic, readonly) NSURL *profileURL;
@property (strong, nonatomic) NSNumber *following;
@property (strong, nonatomic) NSNumber *followers;
@property (strong, nonatomic) NSNumber *tweets;
@end
