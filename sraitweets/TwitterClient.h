//
//  TwitterClient.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "UserProfile.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;
- (void)login;
- (void)logout;

- (void)homeTimelineWithSuccess:(void (^)(NSArray *tweets))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)userTimelineForUser:(NSString*)screenName
                    success:(void (^)(NSArray *tweets))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getProfile:(NSString *)screenName
           success:(void (^)(UserProfile* responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getUserInfoWithSuccess:(void (^)(UserProfile* responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)updateStatus:(NSString*)text
                             withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
