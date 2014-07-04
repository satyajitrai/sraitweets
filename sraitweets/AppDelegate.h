//
//  AppDelegate.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/28/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignOutProtocol.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SignOutProtocolDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
