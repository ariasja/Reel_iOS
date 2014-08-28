//
//  ReelRailsClient.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsClient.h"
#import "UserSession.h"

//////Secret Key Shhh//////
static NSString *const secretKey = @"C0NsdAmohcQBAw3272uSsn3Y2T5JOrVZQhUhguL2sk414KxhTlpHyn8Sb7rQ";

//////@interface//////
@interface ReelRailsClient()

@property(strong, nonatomic) NSURLSession *session;

@end

//////@implemetaion//////
@implementation ReelRailsClient

+ (instancetype) sharedClient {
    static ReelRailsClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    // Code to be run only once
    dispatch_once(&onceToken,^{
            _sharedClient = [[ReelRailsClient alloc] init];
        }
    );
    
    return _sharedClient;
}

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    // Create a session configuration
    NSURLSessionConfiguration *sessionConfiguration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = 30.0;
    sessionConfiguration.timeoutIntervalForResource = 30.0;
    //Set the session headers
    NSDictionary *headers = [UserSession userID] ?
  @{
    @"Accept" : @"application/json",
    @"Content-Type" : @"application/json",
    @"X-DEVICE-TOKEN" : [UserSession userID]
    } :
  @{
    @"Accept" : @"application/json",
    @"Content-Type" : @"application/json",
    @"X-APP-SECRET" : secretKey
    };
    [sessionConfiguration setHTTPAdditionalHeaders:headers];
    // Create a session
    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    return self;
}

- (void)createCurrentUserWithCompletionBlock:(ReelRailsClientErrorCompletionBlock)block
{
    // Create a request for the POST to /users
    NSString *urlString = [NSString stringWithFormat:@"%@/users", ROOT_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Create a task to encapsulate the request and a completion block
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request
                                             completionHandler:
    ^void (NSData *data, NSURLResponse *response, NSError *error){
        NSLog(@"Request completed with error: %@", error);
        if (!error) {
            NSLog(@"User Successfully Posted");
            // Set the user session user ID
            NSDictionary *responseDictionary = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:kNilOptions
                                                error:nil];
            [UserSession setUserID:responseDictionary[@"device_token"]];
            // Create a new configuration with the user ID
            NSURLSessionConfiguration *newConfiguration = self.session.configuration;
            [newConfiguration setHTTPAdditionalHeaders:
            @{
              @"Accept" : @"application/json",
              @"Content-Type" : @"application/json",
              @"X-DEVICE-TOKEN" : responseDictionary[@"device_token"]
            }];
            self.session = [NSURLSession sessionWithConfiguration:
                            newConfiguration];
        }
        // Execute the block regardless of the error
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    }];
    
    [task resume];
}


@end
