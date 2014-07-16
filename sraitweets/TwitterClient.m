//
//  TwitterClient.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "TwitterClient.h"
#import "UserProfile.h"
#import "Tweet.h"

@interface TwitterClient()
@property (strong, nonatomic) UserProfile *profile;
@end

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
    self.profile = nil;
    [self.requestSerializer removeAccessToken];
}

- (void)homeTimelineWithSuccess:(void (^)(NSArray* tweets))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/statuses/home_timeline.json"
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 success([Tweet tweetsFromResponse:responseObject]);
             } failure:failure];
}

- (void)userTimelineForUser:(NSString*)screenName
                    success:(void (^)(NSArray *tweets))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *params = @{@"screen_name" : screenName };
    [self GET:@"1.1/statuses/user_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          success([Tweet tweetsFromResponse:responseObject]);
      } failure:failure];
}

- (void)getUserInfoWithSuccess:(void (^)(UserProfile* responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (self.profile != nil) {
        NSLog(@"Returning profile from cache");
        success(self.profile);
        return;
    }
    
    // else
    [self GET:@"1.1/account/verify_credentials.json"
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Fetched user info from network");
        self.profile = [[UserProfile alloc]initWithResponse:responseObject];
        success(self.profile);
    } failure:failure];
}

- (void)getProfile:(NSString *)screenName
           success:(void (^)(UserProfile* responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *params = @{@"screen_name" : screenName };
    [self GET:@"1.1/users/show.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Fetched user info from network");
          self.profile = [[UserProfile alloc]initWithResponse:responseObject];
          success(self.profile);
      } failure:failure];
}

- (AFHTTPRequestOperation *)updateStatus:(NSString*)text
                                 withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": text};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}
@end
