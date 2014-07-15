//
//  HamburgerViewController.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/12/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

enum ViewType { ViewTypeNone, ViewTypeProfile, ViewTypeTimeLine, ViewTypeMentions };

@interface HamburgerViewController ()
@property (strong, nonatomic) LeftMenuViewController *leftMenuVC;
@property (strong, nonatomic) UINavigationController *timelineNavVC;
@property (strong, nonatomic) UINavigationController *profileNavVC;
@property (assign, nonatomic, getter = isOpen) BOOL open;
@property (assign, nonatomic) enum ViewType viewType;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation HamburgerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initTimeLineView];
        [self initProfileView];
        [self initLeftNavView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.timelineNavVC.view];
    [self.view addSubview:self.leftMenuVC.view];
    [self.view addSubview:self.profileNavVC.view];
    [self.leftMenuVC.timelineButton addTarget:self action:@selector(onTimeLineClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftMenuVC.profileButton addTarget:self action:@selector(onProfileClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMenuButton:(UIButton *)menuButton {
    NSLog(@"Setting menu button...");
    if (menuButton) {
        _menuButton = menuButton;
        [menuButton addTarget:self action:@selector(onMenuClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onMenuClick {
    NSLog(@"Handling menu click - current view type is %d", self.viewType);
    switch (self.viewType) {
        case ViewTypeTimeLine:
            [self toggleMenuWithViewController:self.timelineNavVC];
            break;
            
        case ViewTypeProfile:
            [self toggleMenuWithViewController:self.profileNavVC];
            
        default:
            NSLog(@"Still to implement");
            break;
    }
}

- (void)toggleMenuWithViewController:(UIViewController *)viewController {
    int width = self.contentView.frame.size.width;
    int height = self.contentView.frame.size.height;
    
    [self.view addSubview:self.leftMenuVC.view];
    [self.view addSubview:viewController.view];
    
    if (self.isOpen) {
        [UIView animateWithDuration:0.2 animations:^{
            viewController.view.frame = CGRectMake(0, 0, width, height);
        } completion:^(BOOL finished) {
            self.open = NO;
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.leftMenuVC.view.frame = CGRectMake(0, 0, width/2 + 50, height);
            viewController.view.frame = CGRectMake(width/2 + 50, 0, width, height);
        } completion:^(BOOL finished) {
            self.open = YES;
        }];
    }
}

- (void)onTimeLineClick {
    NSLog(@"Clicked on timeline Button");
    [self toggleMenuWithViewController:self.timelineNavVC];
    self.viewType = ViewTypeTimeLine;
}

- (void)onProfileClick {
    NSLog(@"Clicked on profile Button");
    [self toggleMenuWithViewController:self.profileNavVC];
    self.viewType = ViewTypeProfile;
}

- (void)onMentionsClick {
    NSLog(@"Clicked on mentions Button");
}

- (void)onLogoutClick {
    NSLog(@"Clicked on Logout Button");
}

- (void) initLeftNavView {
    self.leftMenuVC = [[LeftMenuViewController alloc] init];
    self.open = NO;
}

- (void)initTimeLineView {
    TweetsViewController *vc = [[TweetsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.hamburgerMenu = self;
    self.timelineNavVC = nc;
    self.viewType = ViewTypeTimeLine;
}

- (void)initProfileView {
    ProfileViewController *pv = [[ProfileViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pv];
    pv.hamburgerMenu = self;
    self.profileNavVC = nc;
    self.viewType = ViewTypeProfile;
}

@end
