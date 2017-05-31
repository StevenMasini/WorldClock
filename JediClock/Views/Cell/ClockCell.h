//
//  ClockCell.h
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Timezone;

typedef enum : NSUInteger {
    AnalogicClock,
    NumericClock
} ClockDisplay;

@interface ClockCell : UITableViewCell

@property (assign, nonatomic) ClockDisplay clockDisplay;

- (void)updateCellWithTimezone: (Timezone *)timezone;

@end
