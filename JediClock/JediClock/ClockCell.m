//
//  ClockCell.m
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "ClockCell.h"

@interface ClockCell ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *secondHandView;
@property (weak, nonatomic) IBOutlet UIView *minuteHandView;
@property (weak, nonatomic) IBOutlet UIView *hourHandView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation ClockCell

- (void)awakeFromNib {
    self.clockView.layer.cornerRadius = self.clockView.frame.size.width / 2.0f;
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width / 2.0f;
    
    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.titleLabel.text = [NSTimeZone localTimeZone].name;
    
    [self setupHandsAnchorPoint];
    
    [self setupRefreshViewLoop];
    
    [self setupClockNumbers];
}

- (void)setupHandsAnchorPoint {
    self.secondHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.minuteHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.hourHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
}

- (void)setupRefreshViewLoop {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateHands) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)setupClockNumbers {
    float PI2 = M_PI * 2.0f;
    CGSize clockSize = self.clockView.frame.size;
    CGPoint c = CGPointMake((clockSize.width) / 2.0f, (clockSize.height) / 2.0f);
    CGFloat r = (self.clockView.frame.size.width) / 2.0f;
    
    for (NSInteger i = 0; i < 12; i++) {
        CGFloat x = ((c.x - 6) + (r - 9) * cos((PI2 / 12.0f) * i));
        CGFloat y = ((c.y - 6) + (r - 9) * sin((PI2 / 12.0f) * i));
        CGRect frame = CGRectMake(x, y, 12.0f, 12.0f);
        NSLog(@"COORD: %@", NSStringFromCGRect(frame));
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:frame];
        hourLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
        
        NSInteger time = (i + 3) <= 12 ? (i + 3) : i - 9;
        NSLog(@"T: %@", @(time));
        hourLabel.text = @(time).stringValue;
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.clockView addSubview:hourLabel];
    }
}

- (void)updateHands {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger second    = components.second;
    NSInteger minute    = components.minute;
    NSInteger hour      = components.hour;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"hh:mm:ss";
    self.detailTitleLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.secondHandView.transform   = CGAffineTransformMakeRotation(((M_PI * 2) / 60) * second);
        self.minuteHandView.transform   = CGAffineTransformMakeRotation(((M_PI * 2) / 60) * minute);
        self.hourHandView.transform     = CGAffineTransformMakeRotation((((M_PI * 2) / 12) * hour) + ((((M_PI * 2) / 60) * minute) / 12));
    } completion:NULL];
}

@end
