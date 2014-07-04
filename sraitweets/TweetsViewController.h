//
//  TweetsViewController.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignOutProtocol.h"

@interface TweetsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) SignOutProtocol *signout;
@end
