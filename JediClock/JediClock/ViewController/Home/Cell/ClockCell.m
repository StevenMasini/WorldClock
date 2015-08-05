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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minuteHandWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *redCenterView;

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation ClockCell

- (void)awakeFromNib {

    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.titleLabel.text = [NSTimeZone localTimeZone].name;
    
    [self setupCircle];
    
    [self setupHands];
    
    [self setupRefreshViewLoop];
    
    [self setupClockNumbers];
}

#pragma mark - UITableViewCell inherited methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.clockView.alpha = editing ? 0.0f : 1.0f;
    }];
}

#pragma mark - ClockCell setup methods

- (void)setupCircle {
    self.clockView.layer.cornerRadius = self.clockView.frame.size.width / 2.0f;
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width / 2.0f;
    self.redCenterView.layer.cornerRadius = self.redCenterView.frame.size.width / 2.0f;
}

- (void)setupHands {
    // setup hands view anchor point
    self.secondHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.minuteHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.hourHandView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    
    // setup anti-aliasing for hands
    self.secondHandView.layer.borderColor = [UIColor clearColor].CGColor;
    self.secondHandView.layer.borderWidth = 1.0f;
    self.secondHandView.layer.shouldRasterize = YES;
    
    self.minuteHandView.layer.borderColor = [UIColor clearColor].CGColor;
    self.minuteHandView.layer.borderWidth = 0.5f;
    self.minuteHandView.layer.cornerRadius = 1.0f;
    self.minuteHandView.layer.shouldRasterize = YES;
    
    self.hourHandView.layer.borderColor = [UIColor clearColor].CGColor;
    self.hourHandView.layer.borderWidth = 0.5f;
    self.hourHandView.layer.cornerRadius = 1.0f;
    self.hourHandView.layer.shouldRasterize = YES;
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
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:frame];
        hourLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
        
        NSInteger time = (i + 3) <= 12 ? (i + 3) : i - 9;
        hourLabel.text = @(time).stringValue;
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.clockView addSubview:hourLabel];
    }
}

#pragma mark - ClockCell update methods

- (void)updateHands {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger second    = components.second;
    NSInteger minute    = components.minute;
    NSInteger hour      = components.hour;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"hh:mm:ss";
    self.detailTitleLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [UIView animateWithDuration:0.1f animations:^{
        [self updateClockHandsWithHour:hour minute:minute second:second];
    }];
}

- (void)updateClockHandsWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    self.secondHandView.transform   = CGAffineTransformMakeRotation(((M_PI * 2) / 60) * second);
    self.minuteHandView.transform   = CGAffineTransformMakeRotation(((M_PI * 2) / 60) * minute);
    self.hourHandView.transform     = CGAffineTransformMakeRotation((((M_PI * 2) / 12) * hour) + ((((M_PI * 2) / 60) * minute) / 12));
}

@end
