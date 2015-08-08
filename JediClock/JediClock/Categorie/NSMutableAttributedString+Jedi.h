//
//  NSMutableAttributedString+Jedi.h
//  JediClock
//
//  Created by Steven Masini on 8/8/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Jedi)
- (void)appendNewAttributedString:(NSString *)string attributes:(NSDictionary *)attributes;
@end
