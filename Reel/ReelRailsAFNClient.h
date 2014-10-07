//
//  ReelRailsAFNClient.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CurrentUserProfileTableViewController.h"

typedef void(^RailsAFNClientErrorCompletionBlock)(NSError *error);

@interface ReelRailsAFNClient : AFHTTPSessionManager

@property(nonatomic) BOOL userCreateSuccess;
@property(nonatomic) BOOL userUpdateSuccess;
@property(nonatomic) BOOL sessionCreateSuccess;
@property(nonatomic) BOOL sessionDestroySuccess;

@property(strong, nonatomic) NSMutableDictionary* userPosts;

//User
- (void) createCurrentUserWithParameters:(NSDictionary*) parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) updateCurrentUserWithParameters:(NSDictionary*)parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (NSMutableArray*) getUsersWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (NSMutableArray*) getFollowersForUserWithParameters:(NSDictionary*)parameters
                                      CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (NSMutableArray*) getFollowedUsersForUserWithParameters:(NSDictionary*)parameters
                                          CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;


//Session
- (void) createSessionWithParameters: (NSDictionary*) parameters
                     CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) destroySessionWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Post
- (void) createPostWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (NSMutableArray*) getPostsForUserWithId:(NSDictionary*)parameters
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (NSMutableArray*) getPostsForFolderWithId:(NSDictionary*)parameters
                            CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Folder
-(void)createFolderWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
-(NSMutableArray*)getFoldersForUserWithId:(NSDictionary*)parameters
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Relationship
-(void)createRelationshipWhereUserWithId:(NSNumber*)followerId
                       FollowsUserWithId:(NSNumber*)followedId
                     WithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

-(void)destroyRelationshipWhereUserWithId:(NSNumber*)followerId
                      UnfollowsUserWithId:(NSNumber*)followedId
                      WithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

-(BOOL)isUserWithId:(NSNumber*)followerId
FollowingUserWithId:(NSNumber*)followedId
    CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Shared Client
+ (instancetype) sharedClient;


@end