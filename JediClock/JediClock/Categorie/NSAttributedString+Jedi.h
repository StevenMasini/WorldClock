//
//  NSAttributedString+Jedi.h
//  JediClock
//
//  Created by Steven Masini on 8/8/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASFONT(__name__, __size__)                NSFontAttributeName: [UIFont fontWithName:__name__ size:__size__]
#define ASCOLOR(__uicolor__)                      NSForegroundColorAttributeName: __uicolor__
#define ASBGCOLOR(__uicolor__)                    NSBackgroundColorAttributeName: __uicolor__
#define ASLINEOFFSET(__points__)                  NSBaselineOffsetAttributeName: @(__points__)
#define ASSHADOW(__color__, __offset__, __blur__) NSShadowAttributeName: [NSShadow shadowWithColor:__color__ offset:__offset__ blur:__blur__]

@interface NSAttributedString (Jedi)

@end
