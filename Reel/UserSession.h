//
//  UserSession.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class User;

@interface UserSession : User

-(BOOL) sessionActive;
-(void) setSessionActive:(BOOL)sessionActive;

-(void)updateUserForUserSessionWithParams:(NSDictionary *)params;

+(instancetype)sharedSession;

//-(NSNumber *)getUserID;
//-(NSString *)getUserName;
//-(NSString *)getUserUsername;
//-(NSString *)getUserEmail;
//-(NSString *)getUserBio;
//-(void)setUserID:(NSNumber *)userID;
//-(void)setUserName:(NSString *)userName;
//-(void)setUserUsername:(NSString *)userUsername;
//-(void)setUserEmail:(NSString *)userEmail;
//-(void)setUserBio:(NSString *)userBio;

@end
