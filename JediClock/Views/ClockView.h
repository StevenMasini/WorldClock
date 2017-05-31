//
//  ClockView.h
//  JediClock
//
//  Created by Steven Masini on 29/04/2017.
//  Copyright © 2017 Steven Masini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockView : UIView
@property (nonatomic, assign) Boolean isDayTheme;

- (void)refreshClockHandsWithDateComponents:(NSDateComponents *)dateComponents;
@end
