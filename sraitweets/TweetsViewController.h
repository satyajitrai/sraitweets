//
//  TweetsViewController.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HamburgerViewController.h"
#import "UserProfile.h"

@interface TweetsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) HamburgerViewController *hamburgerMenu;
@property (strong, nonatomic) UserProfile *userInfo;
@end