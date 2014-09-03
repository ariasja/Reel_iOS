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

@implementation UserSession{
    BOOL _sessionActive;
}


- (id) init {
    self = [super init];
    if (!self)
        return nil;
    return self;
}

-(void)updateUserForUserSessionWithParams:(NSDictionary *)params
{
    [self setUserId:params[@"userId"]];
    [self setUserName:params[@"userName"]];
    [self setUserUsername:params[@"userUsername"]];
    [self setUserEmail:params[@"userEmail"]];
    [self setUserBio:params[@"userBio"]];
}

+ (instancetype)sharedSession
{
    static UserSession *_session = nil;
    NSLog(@"[UserSession sharedSession]");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create a session
        _session = [[UserSession alloc] init];
    });
    return _session;
}

- (BOOL) sessionActive
{
    return _sessionActive;
}

- (void) setSessionActive:(BOOL)sessionActive{
    _sessionActive = sessionActive;
}

////////////Setters and Getters///////////////
//
//
//-(void)setUserID:(NSNumber *)userID{
//    [_user setUserID:userID];
//}
//-(NSNumber *) getUserID
//{
//    return [_user getUserID];
//}
//
//-(void)setUserName:(NSString *)userName{
//    [_user setUserName:userName];
//}
//-(NSString *)getUserName
//{
//    return [_user getUserName];
//}
//
//-(void)setUserUsername:(NSString *)userUsername
//{
//    [_user setUserUsername:userUsername];
//}
//-(NSString *)getUserUsername
//{
//    return [_user getUserUsername];
//}
//
//-(void)setUserEmail:(NSString *)userEmail
//{
//    [_user setUserEmail:userEmail];
//}
//-(NSString *)getUserEmail
//{
//    return [_user getUserEmail];
//}
//
//-(void)setUserBio:(NSString *)userBio
//{
//    [_user setUserBio:userBio];
//}
//-(NSString *)getUserBio
//{
//    return [_user getUserBio];
//}



@end
