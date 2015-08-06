//
//  ClockCell.h
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Timezone;

@interface ClockCell : UITableViewCell
@property (weak, nonatomic) Timezone *timezone;
@end
