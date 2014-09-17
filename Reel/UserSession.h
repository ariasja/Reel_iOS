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

@property (nonatomic) BOOL sessionActive;

+(instancetype)sharedSession;

@end
