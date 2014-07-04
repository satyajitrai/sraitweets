//
//  SignOutProtocol.m
//  sraitweets
//
//  Created by Satyajit Rai on 7/1/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "SignOutProtocol.h"

@implementation SignOutProtocol

- (void) signOut {
    [self.delegate onSignOut];
}

@end