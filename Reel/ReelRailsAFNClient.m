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

@implementation ReelRailsAFNClient

- (void) createCurrentUserWithCompletionBlock:(RailsAFNClientErrorCompletionBlock)block
{
    [self POST:@"users" parameters:@{@"device_token" : @"435354",
                                     @"name" : @"Poop McPoopers Jr.",
                                     @"email" : @"poop@mcpoopersjr.com",
                                     @"bio" : @"I poop mcpoop more!"}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"Sucessfully");
           [UserSession setUserID:responseObject[@"device_token"]];
           [self.requestSerializer setValue:responseObject[@"device_token"] forHTTPHeaderField:@"X-DEVICE-TOKEN"];
           block(nil);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"Unsucessfullly");
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
        NSString* userId = [UserSession userID];
        if (![userId isEqualToString:@"0"]){
            [_sharedClient.requestSerializer setValue:[UserSession userID] forHTTPHeaderField:@"X-DEVICE-TOKEN"];
        }
        else{
            [_sharedClient.requestSerializer setValue:secretKey forHTTPHeaderField:@"X-APP-SECRET"];

            NSLog(@"%@",[_sharedClient.requestSerializer HTTPRequestHeaders]);
        }
    });
    return _sharedClient;
}

@end
