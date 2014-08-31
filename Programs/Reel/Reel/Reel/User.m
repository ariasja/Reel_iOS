//
//  User.m
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithJSON:(NSDictionary *)JSONDictionary
{
    self = [super init];
    if (!self)
        return nil;
    
    _userID = JSONDictionary[@"id"];
    _userName = JSONDictionary[@"name"];
    _userEmail = JSONDictionary[@"email"];
    _userBio = JSONDictionary[@"bio"];
    
    return self;
}


@end
