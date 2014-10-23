  //
//  ReelRailsAFNClient.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "UserSession.h"

static NSString *const secretKey = @"C0NsdAmohcQBAw3272uSsn3Y2T5JOrVZQhUhguL2sk414KxhTlpHyn8Sb7rQ";

@interface ReelRailsAFNClient()
@end

@implementation ReelRailsAFNClient


////////////////////////////////////
//            USER                //
////////////////////////////////////
- (void) createCurrentUserWithParameters:(NSDictionary*)parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self setUserCreateSuccess:NO];
    [self POST:@"users" parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"User Created Sucessfully");
           [self setUserCreateSuccess:YES];
           [self.requestSerializer setValue:responseObject[@"device_token"] forHTTPHeaderField:@"X-DEVICE-TOKEN"];
           NSLog(@"%@", responseObject[@"id"]);
           NSLog(@"%@", responseObject[@"name"]);
           NSLog(@"%@", responseObject[@"username"]);
           NSLog(@"%@", responseObject[@"email"]);
           NSLog(@"%@", responseObject[@"bio"]);
           [[UserSession sharedSession] updateUserForUserSessionWithParams:@{@"userId":responseObject[@"id"],
                                                                             @"userName":responseObject[@"name"],
                                                                             @"userUsername":responseObject[@"username"],
                                                                             @"userEmail":responseObject[@"email"],
                                                                             @"userBio":@""}];
           block(nil);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"User Not Created");
           [self setUserCreateSuccess:NO];
           block(error);
       }];
}

- (void) updateCurrentUserWithParameters:(NSDictionary*)parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[[[UserSession sharedSession] userId] stringValue]];
    [self setUserUpdateSuccess:NO];
    [self PUT:pathString  parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"User Updated Successfully");
            NSLog(@"%@", responseObject[@"id"]);
            NSLog(@"%@", responseObject[@"name"]);
            NSLog(@"%@", responseObject[@"username"]);
            NSLog(@"%@", responseObject[@"email"]);
            NSLog(@"%@", responseObject[@"bio"]);

            [[UserSession sharedSession] updateUserForUserSessionWithParams:@{@"userId":responseObject[@"id"],
                                                                              @"userName":responseObject[@"name"],
                                                                              @"userUsername":responseObject[@"username"],
                                                                              @"userEmail":responseObject[@"email"],
                                                                              @"userBio":responseObject[@"bio"]}];
            [self setUserUpdateSuccess:YES];
            block(nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"User Not Updated");
            NSLog(@"%@", [error localizedDescription]);
            block(error);
        }];
}

- (NSMutableArray*) getUsersWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    [self GET:@"users" parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET Users Successful");
          NSLog(@"%@", responseObject);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"GET Users Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
    return returnArray;
}

- (NSMutableArray*) getFollowersForUserWithParameters:(NSDictionary*)parameters
                                      CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[parameters[@"userId"] stringValue]];
    [pathString appendString:@"/followers"];

    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"Get Followers Successful");
          NSLog(@"%@", responseObject);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Get Followers Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
    
    return returnArray;
}
- (NSMutableArray*) getFollowedUsersForUserWithParameters:(NSDictionary*)parameters
                                          CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[[[UserSession sharedSession] userId] stringValue]];
    [pathString appendString:@"/following"];
    
    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"Get Followed Users Successful");
          NSLog(@"%@", responseObject);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Get Followed Users Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
    
    return returnArray;
}

////////////////////////////////////
//           SESSION              //
////////////////////////////////////
- (void) createSessionWithParameters:(NSDictionary*)parameters
                     CompletionBlock:(RailsAFNClientErrorCompletionBlock)block

{
    [self setSessionCreateSuccess:NO];
    [self POST:@"sessions" parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"Session Created Successully");
           NSLog(@"responseObject = %@", responseObject);
           [[UserSession sharedSession] setSessionActive:YES];
           [[UserSession sharedSession] updateUserForUserSessionWithParams:@{@"userId":responseObject[@"id"],
                                                                             @"userName":responseObject[@"name"],
                                                                             @"userUsername":responseObject[@"username"],
                                                                             @"userEmail":responseObject[@"email"],
                                                                             @"userBio":responseObject[@"bio"]}];
           [self setSessionCreateSuccess:YES];
           block(nil);
       } failure: ^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Session Not Created");
           NSLog(@"%@", [error localizedDescription]);
           [[UserSession sharedSession] setSessionActive:NO];
           [[UserSession sharedSession] setUserId:@0];
           block(error);
       }];
}

- (void) destroySessionWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"sessions/"];
    [pathString appendString:[[[UserSession sharedSession] userId] stringValue]];
    
    [self setSessionDestroySuccess:NO];
    [self DELETE:pathString parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSLog(@"Session Destroyed Successfully");
             [[UserSession sharedSession] setSessionActive:NO];
             [[UserSession sharedSession] updateUserForUserSessionWithParams:@{@"userId":@0,
                                                                               @"userName": @"",
                                                                               @"userUsername":@"",
                                                                               @"userEmail":@"",
                                                                               @"userBio":@""}];
             [self resetSuccessProperties];
              block(nil);
         }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Session Not Deleted");
         NSLog(@"%@", [error localizedDescription]);
         block(error);
     }];
}

////////////////////////////////////
//            POST                //
////////////////////////////////////
- (void) createPostWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block{
    [self POST:@"posts" parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject){
           NSLog(@"Post Created Successfully");
           NSMutableArray* postsArray = [[UserSession sharedSession] userPosts];
           if([postsArray count] == 0){
               postsArray = [[NSMutableArray alloc] init];
               [postsArray addObject:responseObject];
           }else{
               [postsArray insertObject:responseObject atIndex:0];
           }
           [[UserSession sharedSession] updateUserPostsWithArray:postsArray];
           block(nil);
       }failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Post Not Created");
           block(error);
       }];
}

- (NSMutableArray*) getPostsForUserWithId:(NSDictionary*)parameters
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    //build path string
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[parameters[@"userId"] stringValue]];
    [pathString appendString:@"/posts"];
    //send request to API
    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET Posts Successful");
          NSLog(@"%@", [responseObject class]);
          [returnArray setArray:responseObject];
           block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"GET Posts Unsuccessful");
          block(error);
      }];
    return returnArray;
}

- (NSMutableArray*) getPostsForFolderWithId:(NSDictionary*)parameters
                            CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"folders/"];
    [pathString appendString:[parameters[@"folder_id"] stringValue]];
    [pathString appendString:@"/posts"];
    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET Posts Successful");
          NSLog(@"%@", [responseObject class]);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"GET Posts Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
    return returnArray;

}

- (NSMutableArray*) getFeedItemsForUserWithId:(NSDictionary*)parameters
                              CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[parameters[@"user_id"] stringValue]];
    [pathString appendString:@"/feed_posts"];
    
    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET Feed Posts Successful");
          NSLog(@"%@", [responseObject class]);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"GET Feed Posts Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
    return returnArray;
}

////////////////////////////////////
//            FOLDER              //
////////////////////////////////////
-(void)createFolderWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self POST:@"folders" parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"POST Folders Successful");
            NSLog(@"%@", responseObject);
            NSMutableArray* foldersArray = [[UserSession sharedSession] userFolders];
            if([foldersArray count] == 0){
                foldersArray = [[NSMutableArray alloc] init];
                [foldersArray addObject:responseObject];
            }else{
                [foldersArray insertObject:responseObject atIndex:0];
            }
            [[UserSession sharedSession] updateUserFoldersWithArray:foldersArray];
            block(nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST Folders Unsuccessful");
            NSLog(@"%@", error);
            block(error);
        }];
}

-(NSMutableArray*)getFoldersForUserWithId:(NSDictionary*)parameters
               CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithArray:@[]];
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:@"users/"];
    [pathString appendString:[parameters[@"userId"] stringValue]];
    [pathString appendString:@"/folders"];
    [self GET:pathString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET Folders Successful");
          NSLog(@"%@", responseObject);
          [returnArray setArray:responseObject];
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"GET Folders Unsuccessful");
          block(error);
      }];
    return returnArray;
}

////////////////////////////////////
//        RELATIONSHIP            //
////////////////////////////////////
-(void)createRelationshipWhereUserWithId:(NSNumber*)followerId
                       FollowsUserWithId:(NSNumber*)followedId
                     WithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self POST:@"relationships/" parameters:@{@"follower_id": followerId,
                                             @"followed_id": followedId}
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"Post Relationships Successful");
          block(nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Post Relationships Unsuccessful");
          NSLog(@"%@", [error localizedDescription]);
          block(error);
      }];
}

-(void)destroyRelationshipWhereUserWithId:(NSNumber*)followerId
                      UnfollowsUserWithId:(NSNumber*)followedId
                      WithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self DELETE:@"relationships/" parameters:@{@"follower_id": followerId,
                                              @"followed_id": followedId}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"Destroy Relationships Successful");
           block(nil);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Destroy Relationships Unsuccessful");
           NSLog(@"%@", [error localizedDescription]);
           block(error);
       }];
}

-(BOOL)isUserWithId:(NSNumber*)followerId
FollowingUserWithId:(NSNumber*)followedId
    CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    BOOL isFollowing = NO;

    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    [self GET:@"relationships/is_valid_relationship" parameters:@{
                                      @"follower_id": followedId,
                                      @"followed_id": followedId
                                      }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"Get Relationships Successful");
           NSLog(@"%@", responseObject);
           [tempDictionary setDictionary:responseObject];
           block(nil);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Get Relationships Unsuccessful");
           NSLog(@"%@", [error localizedDescription]);
           block(error);
       }];
    isFollowing = [tempDictionary[@"id"] isEqualToString:@""];
    NSLog(@"%d", isFollowing);
    return isFollowing;
}

////////////////////////////////////
//        SHARED CLIENT           //
////////////////////////////////////
+ (instancetype)sharedClient
{
    static ReelRailsAFNClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create a client
        NSURL *baseURL = [NSURL URLWithString:ROOT_URL];
        _sharedClient = [[ReelRailsAFNClient alloc] initWithBaseURL:baseURL];
        // Set the client header fields
        NSNumber* userId = [[UserSession sharedSession] userId];
        if (!userId){
            [_sharedClient.requestSerializer setValue:[[[UserSession sharedSession] userId] stringValue] forHTTPHeaderField:@"X-DEVICE-TOKEN"];
            NSLog(@"Headers(1): \n%@",[_sharedClient.requestSerializer HTTPRequestHeaders]);
        }
        else{
            [_sharedClient.requestSerializer setValue:secretKey forHTTPHeaderField:@"X-APP-SECRET"];
            NSLog(@"Headers(2): \n%@",[_sharedClient.requestSerializer HTTPRequestHeaders]);
        }
    });
    return _sharedClient;
}

-(void)resetSuccessProperties
{
    [self setUserCreateSuccess:NO];
    [self setUserUpdateSuccess:NO];
    [self setSessionCreateSuccess:NO];
}

@end
