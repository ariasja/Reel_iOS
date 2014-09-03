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

- (void) createCurrentUserWithParameters:(NSDictionary*) parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) createSessionWithParameters: (NSDictionary*) parameters
                     CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
- (void) createPostWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block;
+ (instancetype) sharedClient;


@end