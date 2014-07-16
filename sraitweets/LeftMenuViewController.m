//
//  LeftMenuViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/13/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView:self.userInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUserInfo:(UserProfile *)userInfo {
    [self setUpView: userInfo];
}

- (void)setUpView:(UserProfile *)userInfo {
    self.userNameLabel.text = userInfo.name;
    self.screenNameLabel.text = userInfo.screenName;
    [self.profileImage setImageWithURLRequest:[NSURLRequest requestWithURL: userInfo.profileURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.navigationItem.prompt = @"Failed to load profile image";
        NSLog(@"Failed to get profile view");
    }];
}

@end
