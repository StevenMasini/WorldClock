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

@end

@implementation ClockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clockView.alpha           = self.clockDisplay == NumericClock ? 0.0f : 1.0f;
    self.numericClockLabel.alpha   = self.clockDisplay == NumericClock ? 1.0f : 0.0f;
    self.showsReorderControl        = YES;
}

- (void)prepareForReuse {
    self.clockView.alpha           = self.clockDisplay == NumericClock ? 0.0f : 1.0f;
    self.numericClockLabel.alpha   = self.clockDisplay == NumericClock ? 1.0f : 0.0f;
}

#pragma mark - UITableViewCell inherited methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25f animations:^{
        if (editing) {
            wself.clockView.alpha = 0.0f;
            wself.numericClockLabel.alpha = 0.0f;
        } else {
            switch (wself.clockDisplay) {
                case NumericClock:
                    wself.clockView.alpha = 0.0f;
                    wself.numericClockLabel.alpha = 1.0f;
                    break;
                case AnalogicClock:
                    wself.clockView.alpha = 1.0f;
                    wself.numericClockLabel.alpha = 0.0f;
                    break;
                default:
                    break;
            }
        }
    }];
}

#pragma mark - ClockCell setter methods

- (void)setClockDisplay:(ClockDisplay)clockDisplay {
    [self willChangeValueForKey:@"clockDisplay"];
    _clockDisplay = clockDisplay;
    [self didChangeValueForKey:@"clockDisplay"];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25f animations:^{
        wself.clockView.alpha           = (wself.clockDisplay == NumericClock) ? 0.0f : 1.0f;
        wself.numericClockLabel.alpha   = (wself.clockDisplay == NumericClock) ? 1.0f : 0.0f;
    }];
}

#pragma mark - ClockCell update methods

- (void)updateCellWithTimezone: (Timezone *)timezone {
    // 1) retrieve the right time
    NSDate *date = timezone.date;
    if (!date) {
        return;
    }
    
    self.titleLabel.text = timezone.city;
    
    // 2) update the time for the numeric clock
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"HH:mm";
    self.numericClockLabel.text = [dateFormatter stringFromDate:date];
    
    // 3) update clock color according to the day/night
    self.clockView.isDayTheme = timezone.isDay;
    
    // 4) update the detail text
    self.detailTitleLabel.attributedText = [timezone attributedStringTimelapse];
    
    // 5) update the hands position for the analog clock
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.1f animations:^{
        [wself.clockView refreshClockHandsWithDateComponents:dateComponents];
    }];
}



@end
