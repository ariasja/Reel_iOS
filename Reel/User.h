//
//  User.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userUsername;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userBio;
@property (strong, nonatomic) NSMutableArray *userFolders;
@property (strong, nonatomic) NSMutableArray *userPosts;

//methods
- (id)initWithJSON:(NSDictionary *)JSONDictionary;
-(void)updateUserForUserSessionWithParams:(NSDictionary *)params;
-(void)updateUserFoldersWithArray:(NSMutableArray*)folderArray;
-(void)updateUserPostsWithArray:(NSMutableArray*)postArray;

@end
