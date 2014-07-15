//
//  TwitterClient.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient
static NSString *PlistFileName = @"twitter_client";
static NSString *ConsumerKeyName = @"consumer_key";
static NSString *SecretKeyName = @"secret_key";

+ (TwitterClient *)instance {
    static TwitterClient * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:PlistFileName ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *consumerKey = [dict objectForKey:ConsumerKeyName];
        NSString *secretKey = [dict objectForKey:SecretKeyName];
        
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:consumerKey consumerSecret:secretKey];
    });
    
    return instance;
}

- (void)login {
    if (self.isAuthorized) {
        return;
    }
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"sraitweets://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Request token: %@", requestToken);
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error getting requst token: %@", error);
    }];
}

- (void)logout {
    [self.requestSerializer removeAccessToken];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUserInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, UserProfile* responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, [[UserProfile alloc]initWithResponse:responseObject]);
    } failure:failure];
}

- (AFHTTPRequestOperation *)updateStatus:(NSString*)text
                                 withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": text};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}
@end
