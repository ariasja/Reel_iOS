//
//  User.h
//  Reel
//
//  Created by Jason Arias on 8/20/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//properties
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userBio;

//methods
- (id)initWithJSON:(NSDictionary *)JSONDictionary;

@end
