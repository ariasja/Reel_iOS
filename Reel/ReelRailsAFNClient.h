//
//  ReelRailsAFNClient.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^RailsAFNClientErrorCompletionBlock)(NSError *error);

@interface ReelRailsAFNClient : AFHTTPSessionManager

@property(nonatomic) BOOL sessionCreateSuccess;
@property(nonatomic) BOOL sessionDestroySuccess;
@property(nonatomic) BOOL userUpdateSuccess;

@property(strong, nonatomic) NSMutableDictionary* userPosts;

//User
- (void) createCurrentUserWithParameters:(NSDictionary*) parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) updateCurrentUserWithParameters:(NSDictionary*)parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Session
- (void) createSessionWithParameters: (NSDictionary*) parameters
                     CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) destroySessionWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Post
- (void) createPostWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) getPostsForUserWithId:(NSNumber*)userId
                     PostArray:(NSMutableArray*)postArray
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Folder
-(void)createFolderWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
-(NSMutableArray*)getFoldersForUserWithId:(NSDictionary*)parameters
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;

//Shared Client
+ (instancetype) sharedClient;


@end