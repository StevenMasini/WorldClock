//
//  NSMutableAttributedString+Jedi.m
//  JediClock
//
//  Created by Steven Masini on 8/8/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "NSMutableAttributedString+Jedi.h"

@implementation NSMutableAttributedString (Jedi)
- (void)appendNewAttributedString:(NSString *)string attributes:(NSDictionary *)attributes {
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attributes]];
}
@end
