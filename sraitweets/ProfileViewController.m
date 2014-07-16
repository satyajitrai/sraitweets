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
#import "TweetCell.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) NSArray *tweets;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContainerHeight;
@property (assign, nonatomic) int originalImageContainerHeight;
@property (assign, nonatomic) CGPoint dragStartPoint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TweetCell *prototypeCell;

- (IBAction)onTableDrag:(UIPanGestureRecognizer *)sender;
@end

@implementation ProfileViewController
static NSString * const TweetCellName = @"HomeTweetCell";

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

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:TweetCellName];
    self.tableView.rowHeight = 140;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Profile";
    
    if (self.hamburgerMenu) {
        UIButton * btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 20, 20)];
        [btn setBackgroundImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: btn];
        self.hamburgerMenu.menuButton = btn;
    }
    
    // default values
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
    _userInfo = userInfo;
    [self setUpView:userInfo];
    [self fetchUserTimeline];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Image view

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
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self fetchUserTimeline];
        [UIView animateWithDuration:1.5 animations:^{
            self.profileBackgroundImage.alpha = 1;
            self.imageContainerHeight.constant = self.originalImageContainerHeight;
        }];
    }
}

#pragma mark - Home Timeline
- (void) fetchUserTimeline {
    [[TwitterClient instance] userTimelineForUser:self.userInfo.screenName success:^(NSArray *tweets) {
        self.tweets = tweets;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.prompt = @"Unable to fetch tweets";
        NSLog(@"Error getting home timeline: %@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TweetCellName forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:TweetCellName];
    }
    
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

@end
