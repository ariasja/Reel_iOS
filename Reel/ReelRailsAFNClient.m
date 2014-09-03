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

- (void) createCurrentUserWithParameters:(NSDictionary*)parameters
                         CompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self POST:@"users" parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"User Created Sucessfully");
           [self.requestSerializer setValue:responseObject[@"device_token"] forHTTPHeaderField:@"X-DEVICE-TOKEN"];
           block(nil);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"User Not Created");
           block(error);
       }];
}

- (void) createSessionWithParameters:(NSDictionary*)parameters
                     CompletionBlock:(RailsAFNClientErrorCompletionBlock)block

{
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
           block(nil);
       } failure: ^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Session Not Created");
           NSLog(@"%@", [error localizedDescription]);
           [[UserSession sharedSession] setSessionActive:NO];
           [[UserSession sharedSession] setUserId:nil];
           block(error);
       }];
}

- (void) createPostWithParameters:(NSDictionary*)parameters
                  CompletionBlock:(RailsAFNClientErrorCompletionBlock)block{
    [self POST:@"posts" parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject){
           NSLog(@"Post Created Successfully");
           block(nil);
       }failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Post Not Created");
           block(error);
       }];
}

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

@end
