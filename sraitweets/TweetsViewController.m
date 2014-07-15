//
//  TweetsViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSString *myProfileImageUrl;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) NSString *myScreenName;
@property (strong, nonatomic) UserProfile *userInfo;
@property (strong, nonatomic) TweetCell *prototypeCell;
@end

@implementation TweetsViewController
static NSString * const TweetCellName = @"TweetCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fetchTweets];
        [self fetchUserInfo];
        self.signout = [[SignOutProtocol alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:TweetCellName bundle:nil] forCellReuseIdentifier:TweetCellName];
    self.tableView.rowHeight = 140;
    self.navigationItem.title = @"Home";
    
    UIButton * btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 20, 20)];
    //[btn addTarget:self action:@selector(onMenu) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.hamburgerMenu.menuButton = btn;
    
    self.navigationItem.leftBarButtonItem.width = 20;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshTable:(UIRefreshControl*)refresh {
    [self fetchTweets];
    [refresh endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TweetCellName forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsViewController *detailsView = [[TweetDetailsViewController alloc] init];
    detailsView.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:detailsView animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void) fetchTweets {
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [Tweet tweetsFromResponse:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.prompt = @"Unable to fetch tweets";
        NSLog(@"Error getting home timeline: %@", error);
    }];
}

- (void) fetchUserInfo {
    if (self.userInfo == nil) {
        [[TwitterClient instance] getUserInfoWithSuccess:^(AFHTTPRequestOperation *operation, UserProfile* responseObject) {
            self.userInfo = responseObject;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.navigationItem.prompt = @"Unable to fetch user profile";
            NSLog(@"Failed to get user info");
        }];
    }
}

- (void) onSignOut {
    NSLog(@"Calling the signout delegate");
    [self.signout signOut];
    NSLog(@"Signed out!");
}

- (void) onNewButton {
    NSLog(@"Will compose a new tweet");
    ComposeViewController *cv = [[ComposeViewController alloc] init];
    cv.userInfo = self.userInfo;
    cv.newTweetHandler = ^(Tweet *tweet){
        [self onNewTweet:tweet];
    };
    [self.navigationController pushViewController: cv animated:YES];
}

- (void)onNewTweet:(Tweet *)tweet {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity: self.tweets.count + 1];
    [tweets addObject:tweet];
    [tweets addObjectsFromArray: self.tweets];
    [tweets removeObjectAtIndex: self.tweets.count -1];
    self.tweets = tweets;
    [self.tableView reloadData];
}
@end
