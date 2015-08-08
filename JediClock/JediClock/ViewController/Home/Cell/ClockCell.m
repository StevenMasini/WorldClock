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
@property (weak, nonatomic) IBOutlet UILabel *numericClockLabel;

// property
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ClockCell

- (void)awakeFromNib {
    // 1) setup the circles rendering
    [self setupCircles];
    
    // 2) setup the hands rendering
    [self setupHands];
    
    // 3) put the numbers on the clock
    [self setupClockNumbers];
    
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
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25f animations:^{
        wself.clockView.alpha           = wself.shouldDisplayNumericClock ? 0.0f : 1.0f;
        wself.numericClockLabel.alpha   = wself.shouldDisplayNumericClock ? 1.0f : 0.0f;
    }];
}

- (void)invalidateRefreshLoop {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - UITableViewCell inherited methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25f animations:^{
        wself.clockView.alpha           = (editing || wself.shouldDisplayNumericClock) ? 0.0f : 1.0f;
        wself.numericClockLabel.alpha   = (editing || !wself.shouldDisplayNumericClock) ? 0.0f : 1.0f;
    }];
}

#pragma mark - ClockCell setter methods

- (void)setTimezone:(Timezone *)timezone {
    _timezone = timezone;
    
    self.timeInterval = [timezone timeInterval];
    self.titleLabel.text = timezone.city;
    
    [self.timezone attributedStringTimelapse];
    
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                     selector:@selector(updateCell)
                                                    userInfo:nil repeats:YES];
    [self.timer fire];
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
        hourLabel.backgroundColor = [UIColor clearColor];
        
        NSInteger time = (i + 3) <= 12 ? (i + 3) : i - 9;
        hourLabel.text = @(time).stringValue;
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.clockView addSubview:hourLabel];
    }
}

#pragma mark - ClockCell update methods


/**
 *  @author Steven Masini, 08-Aug-2015
 *
 *  @brief  Update cell
 */
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
    BOOL isDay = self.timezone.isDay;
    self.clockView.backgroundColor      = isDay ? [UIColor whiteGrayColor] : [UIColor blackColor];
    self.minuteHandView.backgroundColor = isDay ? [UIColor blackColor] : [UIColor whiteColor];
    self.hourHandView.backgroundColor   = isDay ? [UIColor blackColor] : [UIColor whiteColor];
    self.centerView.backgroundColor     = isDay ? [UIColor blackColor] : [UIColor whiteColor];
    for (UIView *subview in self.clockView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = isDay ? [UIColor blackColor] : [UIColor whiteColor];
        }
    }
    
    // 4) update the detail text
    self.detailTitleLabel.attributedText = [self.timezone attributedStringTimelapse];
    
    // 5) update the hands position for the analog clock
    NSDateComponents *dateComponents = [TimezoneManager dateComponentsFromDate:date];
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
