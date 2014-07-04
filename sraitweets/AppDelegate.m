//
//  AppDelegate.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TwitterClient.h"
#import "NSURL+dictionaryFromQueryString.h"
#include "TweetsViewController.h"

@interface AppDelegate()
@property (assign) BOOL isNavLoaded;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupRootView];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSDictionary *parameters = [url dictionaryFromQueryString];
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        [[TwitterClient instance] fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
            [[TwitterClient instance].requestSerializer saveAccessToken:accessToken];
            NSLog(@"Got the access token!");
            [self setupRootView];
        } failure:^(NSError *error) {
            NSLog(@"Failed to get access token");
        }];
    }
    
    return YES;
}

- (void) setupRootView {
    if ([TwitterClient instance].isAuthorized) {
        TweetsViewController *vc = [[TweetsViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.tintColor = [UIColor whiteColor];
        UIColor *twitterBlue = [UIColor colorWithRed:64/255.0f green:153/255.0f blue:255/255.0f alpha:0.0f];
        nc.navigationBar.barTintColor = twitterBlue;
        nc.navigationBar.translucent = NO;
        self.window.rootViewController = nc;
        vc.signout.delegate = self;
    }
    else {
        self.window.rootViewController = [[MainViewController alloc] init];
        self.window.backgroundColor = [UIColor whiteColor];
        self.isNavLoaded = NO;
    }
}

- (void) onSignOut {
    [[TwitterClient instance] logout];
    NSLog(@"Logged out!");
    [self setupRootView];
}

@end
