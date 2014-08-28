//
//  ReelRailsClient.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReelRailsClientErrorCompletionBlock)(NSError *error);


@interface ReelRailsClient : NSObject

- (void)createCurrentUserWithCompletionBlock:(ReelRailsClientErrorCompletionBlock)block;
+ (instancetype) sharedClient;

@end
