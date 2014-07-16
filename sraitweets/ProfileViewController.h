//
//  ProfileViewController.h
//  sraitweets
//
//  Created by Satyajit Rai on 7/13/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HamburgerViewController.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

// If this is set we add hamburger menu - otherwise we will treat the view as a detail view.
@property (weak, nonatomic) HamburgerViewController *hamburgerMenu;

@property (strong, nonatomic) UserProfile *userInfo;
@end