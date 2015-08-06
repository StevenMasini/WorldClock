//
//  ClockCell.m
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "ClockCell.h"
#import "TimezoneManager.h"

@interface ClockCell ()
// clock view
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *redCenterView;

// hands views
@property (weak, nonatomic) IBOutlet UIView *secondHandView;
@property (weak, nonatomic) IBOutlet UIView *minuteHandView;
@property (weak, nonatomic) IBOutlet UIView *hourHandView;

// title view
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHorizontalSpacingConstraint;

// property
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation ClockCell

- (void)awakeFromNib {
    // 1) setup the circles rendering
    [self setupCircles];
    
    // 2) setup the hands rendering
    [self setupHands];
    
    // 3) put the numbers on the clock
    [self setupClockNumbers];
}

#pragma mark - UITableViewCell inherited methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    CGFloat constant = editing ? 50.0f : 12.0f;
    self.rightHorizontalSpacingConstraint.constant = constant;
    [UIView animateWithDuration:0.25f animations:^{
        self.clockView.alpha = editing ? 0.0f : 1.0f;
        [self.clockView layoutIfNeeded];
    }];
}

#pragma mark - ClockCell setter methods

- (void)setTimezone:(Timezone *)timezone {
    self.titleLabel.text = timezone.city;
    NSTimeZone *utc = [NSTimeZone timeZoneWithName:timezone.identifier];
    
    NSDate *date = [NSDate date];
    self.timeInterval = [utc secondsFromGMTForDate:date];
    
    [self setupRefreshViewLoop];
}

#pragma mark - ClockCell setup methods

- (void)setupCircles {
    self.clockView.layer.cornerRadius       = self.clockView.frame.size.width / 2.0f;
    self.centerView.layer.cornerRadius      = self.centerView.frame.size.width / 2.0f;
    self.redCenterView.layer.cornerRadius   = self.redCenterView.frame.size.width / 2.0f;
}

- (void)setupHands {
    // setup hands view anchor point
    self.secondHandView.layer.anchorPoint   = CGPointMake(0.5f, 1.0f);
    self.minuteHandView.layer.anchorPoint   = CGPointMake(0.5f, 1.0f);
    self.hourHandView.layer.anchorPoint     = CGPointMake(0.5f, 1.0f);
    
    // setup anti-aliasing for hands
    self.secondHandView.layer.borderColor       = [UIColor clearColor].CGColor;
    self.secondHandView.layer.borderWidth       = 1.0f;
    self.secondHandView.layer.shouldRasterize   = YES;
    
    self.minuteHandView.layer.borderColor       = [UIColor clearColor].CGColor;
    self.minuteHandView.layer.borderWidth       = 0.5f;
    self.minuteHandView.layer.cornerRadius      = 1.0f;
    self.minuteHandView.layer.shouldRasterize   = YES;
    
    self.hourHandView.layer.borderColor         = [UIColor clearColor].CGColor;
    self.hourHandView.layer.borderWidth         = 0.5f;
    self.hourHandView.layer.cornerRadius        = 1.0f;
    self.hourHandView.layer.shouldRasterize     = YES;
}

- (void)setupRefreshViewLoop {
    CABasicAnimation *secondAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                     selector:@selector(updateTime)
                                                    userInfo:nil repeats:YES];
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

- (void)updateTime {
    NSDate *date = [NSDate dateWithTimeInterval:self.timeInterval sinceDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"hh:mm:ss";
    self.detailTitleLabel.text = [dateFormatter stringFromDate:date];
    
    NSDateComponents *dateComponents = [TimezoneManager dateComponentsFromDate:date];
    [UIView animateWithDuration:0.1f animations:^{
        [self updateClockHandsWithDateComponents:dateComponents];
    }];
}

- (void)updateClockHandsWithDateComponents:(NSDateComponents *)dateComponents {
    NSInteger second    = dateComponents.second;
    NSInteger minute    = dateComponents.minute;
    NSInteger hour      = dateComponents.hour;
    
    CGFloat secondAngle = ((M_PI * 2) / 60) * second;
    self.secondHandView.transform   = CGAffineTransformMakeRotation(secondAngle);
    
    CGFloat minuteAngle = ((M_PI * 2) / 60) * minute;
    self.minuteHandView.transform   = CGAffineTransformMakeRotation(minuteAngle);
    
    CGFloat hourAngle = (((M_PI * 2) / 12) * hour) + ((((M_PI * 2) / 60) * minute) / 12);
    self.hourHandView.transform     = CGAffineTransformMakeRotation(hourAngle);
}

@end
