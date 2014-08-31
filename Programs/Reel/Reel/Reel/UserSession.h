//
//  UserSession.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserSession : NSObject

+ (void) setUserID:(NSString *)userID;
+ (NSString *) userID;

+ (BOOL) userMatchesCurrentUserSession:(User *)user;

@end
