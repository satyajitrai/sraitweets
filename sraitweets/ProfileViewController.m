//
//  ProfileViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/13/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContainerHeight;
@property (assign, nonatomic) int originalImageContainerHeight;
@property (assign, nonatomic) CGPoint dragStartPoint;
- (IBAction)onTableDrag:(UIPanGestureRecognizer *)sender;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Initializing profile view");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton * btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 20, 20)];
    self.navigationItem.title = @"Profile";
    [btn setBackgroundImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.hamburgerMenu.menuButton = btn;
    
    self.tweetsLabel.text = @"0";
    self.followersLabel.text = @"0";
    self.followingLabel.text = @"0";
    
    [self setUpView:self.userInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUserInfo:(UserProfile *)userInfo {
    [self setUpView:userInfo];
}

- (void)setUpView:(UserProfile *)userInfo {
    self.name.text = userInfo.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@",userInfo.screenName];
    self.tweetsLabel.text = userInfo.tweets.stringValue;
    self.followersLabel.text = userInfo.followers.stringValue;
    self.followingLabel.text = userInfo.following.stringValue;
    
    [self.profileImage setImageWithURLRequest:[NSURLRequest requestWithURL: userInfo.profileURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.navigationItem.prompt = @"Failed to load profile image";
        NSLog(@"Failed to get profile view");
    }];
    
    [self.profileBackgroundImage setImageWithURLRequest:[NSURLRequest requestWithURL: userInfo.profileBackgroundURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileBackgroundImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.navigationItem.prompt = @"Failed to load profile image";
        NSLog(@"Failed to get profile view");
    }];
}

- (IBAction)onTableDrag:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView * view = panGestureRecognizer.view;
    CGPoint touch = [panGestureRecognizer locationInView:view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.dragStartPoint = touch;
        self.originalImageContainerHeight = self.imageContainerHeight.constant;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        float heightChange = (self.imageContainerHeight.constant - self.originalImageContainerHeight);
        if (heightChange < 100) {
            float yshift = touch.y - self.dragStartPoint.y;
            self.imageContainerHeight.constant = self.imageContainerHeight.constant + yshift;
            self.profileBackgroundImage.alpha = 1 - heightChange/(self.originalImageContainerHeight + 50);
//            NSLog(@"alpha = %f", self.profileBackgroundImage.alpha);
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1.5 animations:^{
            self.profileBackgroundImage.alpha = 1;
            self.imageContainerHeight.constant = self.originalImageContainerHeight;
        }];
    }
}
@end
