//
//  UIColor+Jedi.h
//  JediClock
//
//  Created by Steven Masini on 8/8/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(_r_, _g_, _b_) [UIColor colorWithRed:(float)_r_/255. green:(float)_g_/255. blue:(float)_b_/255. alpha:1.0]
#define RGBA(_r_, _g_, _b_, _a_) [UIColor colorWithRed:(float)_r_/255. green:(float)_g_/255. blue:(float)_b_/255. alpha:(float)_a_]

@interface UIColor (Jedi)
+ (UIColor *)redOrangeColor;
+ (UIColor *)whiteGrayColor;
@end
