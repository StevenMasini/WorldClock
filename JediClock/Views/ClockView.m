//
//  ClockView.m
//  JediClock
//
//  Created by Steven Masini on 29/04/2017.
//  Copyright © 2017 Steven Masini. All rights reserved.
//

#import "ClockView.h"

@interface ClockView ()

@property (strong, nonatomic) CAShapeLayer *clockLayer;
@property (strong, nonatomic) CALayer *hourHandLayer;
@property (strong, nonatomic) CALayer *minuteHandLayer;
@property (strong, nonatomic) CALayer *secondHandLayer;

@end

@implementation ClockView

#pragma mark - UIView inherited methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 1) setup the circles rendering
    [self setupCircles];
    
    // 2) setup the hands rendering
    [self setupHands];
    
    // 3) put the numbers on the clock
    [self setupClockNumbers];
}


#pragma mark - ClockCell setup methods

- (void)setupCircles {
    // initialize the main layer
    self.clockLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.clockLayer.path = path.CGPath;
    self.clockLayer.fillColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:self.clockLayer];
    
//    self.centerView.layer.cornerRadius      = self.centerView.frame.size.width / 2.0f;
//    self.redCenterView.layer.cornerRadius   = self.redCenterView.frame.size.width / 2.0f;
}

- (void)setupHands {
    // setup hands view anchor point
//    self.secondHandView.layer.anchorPoint   = CGPointMake(0.5f, 1.0f);
//    self.minuteHandView.layer.anchorPoint   = CGPointMake(0.5f, 1.0f);
//    self.hourHandView.layer.anchorPoint     = CGPointMake(0.5f, 1.0f);
    
    // setup anti-aliasing for hands
//    self.secondHandView.layer.borderColor       = [UIColor clearColor].CGColor;
//    self.secondHandView.layer.borderWidth       = 1.0f;
//    self.secondHandView.layer.shouldRasterize   = YES;
    
//    self.minuteHandView.layer.borderColor       = [UIColor clearColor].CGColor;
//    self.minuteHandView.layer.borderWidth       = 0.5f;
//    self.minuteHandView.layer.cornerRadius      = 1.0f;
//    self.minuteHandView.layer.shouldRasterize   = YES;
//    
//    self.hourHandView.layer.borderColor         = [UIColor clearColor].CGColor;
//    self.hourHandView.layer.borderWidth         = 0.5f;
//    self.hourHandView.layer.cornerRadius        = 1.0f;
//    self.hourHandView.layer.shouldRasterize     = YES;
}

- (void)setupClockNumbers {
    float PI2 = M_PI * 2.0f;
    CGSize clockSize = self.bounds.size;
    CGPoint c = CGPointMake((clockSize.width) / 2.0f, (clockSize.height) / 2.0f);
    CGFloat r = (self.bounds.size.width) / 2.0f;
    
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
        
        [self addSubview:hourLabel];
    }
}

//- (void)setupRefreshViewLoop {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
//                                                selector:@selector(updateCell)
//                                                userInfo:nil repeats:YES];
//    [self.timer fire];
//}

@end
