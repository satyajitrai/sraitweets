//
//  HamburgerViewController.h
//  sraitweets
//
//  Created by Satyajit Rai on 7/12/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

typedef void (^SignOutHandler)();

@interface HamburgerViewController : UIViewController

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) SignOutHandler signOutHandler;

@end
