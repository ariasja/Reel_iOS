//
//  UserSession.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "User.h"
#import "UserSession.h"
#import <SSKeychain/SSKeychain.h>

@implementation UserSession

+ (NSString *)userID
{
    NSString *userIDString = [SSKeychain passwordForService:@"Reel"
                                                    account:@"currentUserID"];
    NSLog(@"[UserSession userID]");
    return userIDString;
}

+ (void)setUserID:(NSNumber *)userID
{
    NSString *userIDString = [NSString stringWithFormat:@"%@", userID];
    [SSKeychain setPassword:userIDString
                 forService:@"Reel"
                    account:@"currentUserID"];
}


+ (BOOL)userMatchesCurrentUserSession:(User *)user
{
    return [user.userID isEqual:[UserSession userID]];
}
@end
