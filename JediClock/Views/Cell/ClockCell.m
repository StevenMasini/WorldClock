//
//  ClockCell.m
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "ClockCell.h"
#import "TimezoneManager.h"
#import "UIColor+Jedi.h"
#import "ClockView.h"

@interface ClockCell ()

// clock view
@property (weak, nonatomic) IBOutlet ClockView *clockView;

// title view
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numericClockLabel;

// property
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ClockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clockView.alpha           = self.shouldDisplayNumericClock ? 0.0f : 1.0f;
    self.numericClockLabel.alpha   = self.shouldDisplayNumericClock ? 1.0f : 0.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchClockToNumeric)
                                                 name:kSwitchClockNotification
                                               object:nil];
}

- (void)prepareForReuse {
    self.clockView.alpha           = self.shouldDisplayNumericClock ? 0.0f : 1.0f;
    self.numericClockLabel.alpha   = self.shouldDisplayNumericClock ? 1.0f : 0.0f;
}

- (void)dealloc {
    // even if the dealloc is rarely call because of the reuse cell system,
    // remove the notification once dealloc is called, to be clean
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ClockCell methods

- (void)switchClockToNumeric {
    self.shouldDisplayNumericClock = !self.shouldDisplayNumericClock;
    
//    __weak typeof(self) wself = self;
//    [UIView animateWithDuration:0.25f animations:^{
//        wself.clockView.alpha           = wself.shouldDisplayNumericClock ? 0.0f : 1.0f;
//        wself.numericClockLabel.alpha   = wself.shouldDisplayNumericClock ? 1.0f : 0.0f;
//    }];
}

- (void)invalidateRefreshLoop {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - UITableViewCell inherited methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
//    __weak typeof(self) wself = self;
//    [UIView animateWithDuration:0.25f animations:^{
//        wself.clockView.alpha           = (editing || wself.shouldDisplayNumericClock) ? 0.0f : 1.0f;
//        wself.numericClockLabel.alpha   = (editing || !wself.shouldDisplayNumericClock) ? 0.0f : 1.0f;
//    }];
}

#pragma mark - ClockCell setter methods

- (void)setTimezone:(Timezone *)timezone {
    _timezone = timezone;
    
    self.timeInterval = [timezone timeInterval];
    self.titleLabel.text = timezone.city;
    
//    [self setupRefreshViewLoop];
}



#pragma mark - ClockCell update methods

- (void)updateCell {
    // 1) retrieve the right time
    NSDate *date = self.timezone.date;
    if (!date) {
        return;
    }
    
    // 2) update the time for the numeric clock
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"HH:mm";
    self.numericClockLabel.text = [dateFormatter stringFromDate:date];
    
    // 3) update clock color according to the day/night
//    BOOL isDay = self.timezone.isDay;
//    self.clockView.backgroundColor      = isDay ? [UIColor whiteGrayColor] : [UIColor blackColor];
//    self.minuteHandView.backgroundColor = isDay ? [UIColor blackColor] : [UIColor whiteColor];
//    self.hourHandView.backgroundColor   = isDay ? [UIColor blackColor] : [UIColor whiteColor];
//    self.centerView.backgroundColor     = isDay ? [UIColor blackColor] : [UIColor whiteColor];
//    for (UIView *subview in self.clockView.subviews) {
//        if ([subview isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel *)subview;
//            label.textColor = isDay ? [UIColor blackColor] : [UIColor whiteColor];
//        }
//    }
    
    // 4) update the detail text
    self.detailTitleLabel.attributedText = [self.timezone attributedStringTimelapse];
    
    // 5) update the hands position for the analog clock
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
    [UIView animateWithDuration:0.1f animations:^{
        [self updateClockHandsWithDateComponents:dateComponents];
    }];
}

/**
 *  @author Steven Masini, 08-Aug-2015
 *
 *  @brief  Update the hands postion
 *
 *  @param dateComponents The data components that containt the second, minute and hour
 */
- (void)updateClockHandsWithDateComponents:(NSDateComponents *)dateComponents {
//    NSInteger second    = dateComponents.second;
//    NSInteger minute    = dateComponents.minute;
//    NSInteger hour      = dateComponents.hour;
    
//    CGFloat secondAngle = ((M_PI * 2) / 60) * second;
//    self.secondHandView.transform   = CGAffineTransformMakeRotation(secondAngle);
//    
//    CGFloat minuteAngle = ((M_PI * 2) / 60) * minute;
//    self.minuteHandView.transform   = CGAffineTransformMakeRotation(minuteAngle);
//    
//    CGFloat hourAngle = (((M_PI * 2) / 12) * hour) + ((((M_PI * 2) / 60) * minute) / 12);
//    self.hourHandView.transform     = CGAffineTransformMakeRotation(hourAngle);
}

@end
