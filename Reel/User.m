//
//  User.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

//  Should only be created and altered from UserSession object

#import "User.h"

@interface User()

@end

@implementation User

- (id)initWithJSON:(NSDictionary *)JSONDictionary
{
    self = [self init];
    if (!self)
        return nil;
    
    _userId = JSONDictionary[@"userID"];
    _userName = JSONDictionary[@"userName"];
    _userUsername = JSONDictionary[@"userUsername"];
    _userEmail = JSONDictionary[@"userEmail"];
    _userBio = JSONDictionary[@"userBio"];
    
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

-(void)updateUserFoldersWithArray:(NSMutableArray*)folderArray
{
    [self setUserFolders:folderArray];
}

-(void)updateUserPostsWithArray:(NSMutableArray*)postArray
{
    [self setUserPosts:postArray];
}

@end
