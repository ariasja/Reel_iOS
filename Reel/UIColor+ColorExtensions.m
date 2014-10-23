//
//  UIColor+ColorExtensions.m
//  Reel
//
//  Created by Jason Arias on 8/4/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "UIColor+ColorExtensions.h"

@implementation UIColor (ColorExtensions)

+ (UIColor *) tealColor
{
    return [UIColor colorWithRed:22.0f/255.0f green:94.0f/255.0f blue:96.0f/255.0f alpha:1.0];
}

+ (UIColor *)appBlueColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:64.0f/255.0f blue:128.0f/255.0f alpha:1.0];
}

+ (UIColor *)appTanColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:253.0f/255.0f blue:241.0f/255.0f alpha:1.0];
}
@end
