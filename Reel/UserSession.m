//
//  UserSession.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "User.h"
#import "UserSession.h"
#import <SSKeychain/SSKeychain.h>

@interface UserSession ()

@end

@implementation UserSession{}

+ (instancetype)sharedSession
{
    static UserSession *_session;
    NSLog(@"[UserSession sharedSession]");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create a session
        _session = [[UserSession alloc] init];
    });
    return _session;
}


@end
