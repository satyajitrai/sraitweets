//
//  SignOutProtocol.h
//  sraitweets
//
//  Created by Satyajit Rai on 6/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignOutProtocolDelegate <NSObject>
@required
- (void) onSignOut;
@end

@interface SignOutProtocol : NSObject
@property (strong, nonatomic) id<SignOutProtocolDelegate> delegate;
- (void)signOut;
@end