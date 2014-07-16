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

@interface HamburgerViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) LeftMenuViewController *leftMenuVC;
@property (strong, nonatomic) UINavigationController *timelineNavVC;
@property (strong, nonatomic) UINavigationController *profileNavVC;
@property (assign, nonatomic, getter = isOpen) BOOL open;
@property (assign, nonatomic) enum ViewType viewType;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) CGPoint dragStartPoint;
@end

@implementation HamburgerViewController
const int MaxMenuWidth = 210;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initProfileView];
        [self initLeftNavView];
        [self initTimeLineView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.profileNavVC.view];
    [self.view addSubview:self.leftMenuVC.view];
    self.leftMenuVC.view.frame = CGRectMake(0, 0, MaxMenuWidth, self.contentView.frame.size.height);
    [self addChildViewController:self.timelineNavVC];
    [self.view addSubview:self.timelineNavVC.view];
    [self.timelineNavVC didMoveToParentViewController:self];
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
            viewController.view.frame = CGRectMake(MaxMenuWidth, 0, width, height);
        } completion:^(BOOL finished) {
            self.open = YES;
        }];
    }
}

- (void)onTimeLineClick {
    [self toggleMenuWithViewController:self.timelineNavVC];
    self.viewType = ViewTypeTimeLine;
}

- (void)onProfileClick {
    [self toggleMenuWithViewController:self.profileNavVC];
    self.viewType = ViewTypeProfile;
}

- (void)onMentionsClick {
    NSLog(@"Clicked on mentions Button");
}

- (void)onLogoutClick {
    NSLog(@"Clicked on Logout Button");
}

//TODO: Handle view lifecycle events
- (void) initLeftNavView {
    self.leftMenuVC = [[LeftMenuViewController alloc] init];
    self.open = NO;
}

- (void)initTimeLineView {
    TweetsViewController *vc = [[TweetsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [nc.view addGestureRecognizer:[self panGestureRecognizer]];
    vc.hamburgerMenu = self;
    self.timelineNavVC = nc;
    self.viewType = ViewTypeTimeLine;
}

- (void)initProfileView {
    ProfileViewController *pv = [[ProfileViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pv];
    [nc.view addGestureRecognizer:[self panGestureRecognizer]];
    pv.hamburgerMenu = self;
    self.profileNavVC = nc;
    self.viewType = ViewTypeProfile;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(openLeftMenu:)];
    recognizer.maximumNumberOfTouches = 1;
    recognizer.delegate = self;
    return recognizer;
}

- (IBAction)openLeftMenu:(UIPanGestureRecognizer *)panGestureRecongnizer {
    UIView * view = panGestureRecongnizer.view;
    CGPoint touch = [panGestureRecongnizer locationInView:view];
    if (panGestureRecongnizer.state == UIGestureRecognizerStateBegan) {
        self.dragStartPoint = touch;
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateChanged) {
        float xshift = touch.x - self.dragStartPoint.x;
        if ((view.frame.origin.x >= 0) && (view.frame.origin.x <= MaxMenuWidth)) {
            float newOrigin = view.frame.origin.x + xshift;
            if (newOrigin < 0) newOrigin = 0;
            if (newOrigin > MaxMenuWidth) newOrigin = MaxMenuWidth;
            float finalShift = newOrigin - view.frame.origin.x;
            view.center = CGPointMake(view.center.x + finalShift, view.center.y);
        }
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateEnded) {
        // Animate to origin or max-width
        float finalShift;
        if (view.frame.origin.x < MaxMenuWidth/2) {
            finalShift = - view.frame.origin.x;
        } else {
            finalShift = MaxMenuWidth - view.frame.origin.x;
        }
        [UIView animateWithDuration:0.1 animations:^{
            view.center = CGPointMake(view.center.x + finalShift, view.center.y);
        } completion:^(BOOL finished) {
            self.open = (view.frame.origin.x == 0) ? NO: YES;
        }];
    }
}

@end
